# name: Master SSO
# About: Internal for bootstraping master nodes for DiscourseCN
# author: Erick
# version: 0.99

PLUGIN_NAME = "master_hub".freeze

enabled_site_setting :master_hub_enabled

register_asset 'stylesheets/hub.scss'

after_initialize do

  require_dependency 'session_controller'
  require_dependency 'single_sign_on'
  ::SessionController.class_eval do
    def sso_provider(payload=nil)
      payload ||= request.query_string
      if SiteSetting.enable_sso_provider
        sso = SingleSignOn.parse(payload, SiteSetting.sso_secret)
        if current_user
          sso.name = current_user.name
          sso.username = current_user.username
          sso.email = "#{SecureRandom.hex}@sso.#{Discourse.current_hostname}"
          sso.external_id = current_user.username.to_s
          sso.admin = grant_admin?
          sso.moderator = grant_moderator?
          sso.suppress_welcome_message = true

          if sso.return_sso_url.blank?
            render plain: "return_sso_url is blank, it must be provided", status: 400
            return
          end

          if request.xhr?
            cookies[:sso_destination_url] = sso.to_url(sso.return_sso_url)
          else
            redirect_to sso.to_url(sso.return_sso_url)
          end
        else
          session[:sso_payload] = request.query_string
          redirect_to path('/login')
        end
      else
        render nothing: true, status: 404
      end
    end

    private

    def grant_admin?
      return true if SiteSetting.master_hub_admin_whitelist.split(',').include?(current_user.username)
      if SiteSetting.master_hub_admin_admin_required?
        current_user.admin?
      else
        current_user.trust_level >= SiteSetting.master_hub_admin_tl_required
      end
    end

    def grant_moderator?
      current_user.trust_level >= SiteSetting.master_hub_moderator_tl_required
    end
  end
end
