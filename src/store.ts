import * as Vue from 'vue';
import * as Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    themes: [],
    configLocation: '',
    img: '',
    theme: '',
    welcomeSetup: undefined,
  },
  mutations: {
    updateThemes(state: any, themes: []) {
      state.themes = [...themes];
    },
    setConfigLocation(state: any, location: string) {
      state.configLocation = location;
    },
    setImg(state: any, img: string) {
      state.img = img;
    },
    setTheme(state: any, theme: string) {
      state.theme = theme;
    },
    setWelcomeDialog(state: any, welcome: boolean) {
      state.welcomeSetup = welcome;
    },
  },
  actions: {
    updateThemes(context) {
      context.commit('updateThemes');
    },
  },
});
