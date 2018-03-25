import * as Vue from 'vue';
import * as App from './App.vue';
import store from './store';
import './plugins/shell.ts';

import * as Vuetify from 'vuetify';

Vue.use(Vuetify, {
  theme: {
    primary: "#F4511E",
    secondary: "#FF7043",
    accent: "#E65100",
    error: "#f44336",
    warning: "#ffeb3b",
    info: "#2196f3",
    success: "#4caf50"
  }
});

// Vue.config.productionTip = process.env.NODE_ENV === 'production';
Vue.config.productionTip = !process.execPath.match(/[\\/]electron/);

new Vue({
  store,
  render: (h) => h(App),
}).$mount('#app');
