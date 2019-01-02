import Vue from 'vue';
import VueRouter from 'vue-router';
import App from './App.vue';
import store from './store';
import router from './router';
import cli from './cli';

Vue.config.productionTip = false;

Vue.use(VueRouter);
Vue.use(cli);

new Vue({
  store,
  router,
  render: (h) => h(App),
}).$mount('#app');
