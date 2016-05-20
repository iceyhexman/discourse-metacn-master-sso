import { withPluginApi } from 'discourse/lib/plugin-api';

function initializeWithApi(api) {
  const notMobile = !api.container.lookup('site:main').get('mobileView');
  
  api.decorateWidget('header-buttons:before', helper => {
    const notInTopic = !helper.attrs.topic;

    if (notInTopic) {
      return helper.attach('link', {
        rawLabel: notMobile ? "测试站1" : "测试站",
        className: 'btn btn-default btn-small stage-site-link',
        href: "https://master1.discoursecn.org/" });
    }
  });
  api.decorateWidget('header-buttons:before', helper => {
    const notInTopic = !helper.attrs.topic;

    if (notMobile && notInTopic) {
      return helper.attach('link', {
        rawLabel: "2",
        className: 'btn btn-default btn-small stage-site-link',
        href: "https://master2.discoursecn.org/" });
    }
  });
}

export default {
  name: 'master_hub',
  initialize() {
    withPluginApi('0.4', initializeWithApi);

  }
};

