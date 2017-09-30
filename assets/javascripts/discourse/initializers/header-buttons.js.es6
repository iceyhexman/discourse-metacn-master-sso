import { withPluginApi } from 'discourse/lib/plugin-api';

function initializeWithApi(api) {
  const notMobile = !api.container.lookup('site:main').get('mobileView');
  
  api.decorateWidget('header-buttons:before', helper => {
    const notInTopic = !helper.attrs.topic;

    if (notInTopic) {
      return helper.attach('link', {
        rawLabel: notMobile ? "捐赠" : "捐赠",
        className: 'btn btn-default btn-small stage-site-link',
        //href: "javascript:$('.stage-site-link').click();"  如果有问题就换为注释里的
        href: "javascript:;"
      });
    }
  });
}

export default {
  name: 'master_hub',
  initialize() {
    withPluginApi('0.4', initializeWithApi);

  }
};

