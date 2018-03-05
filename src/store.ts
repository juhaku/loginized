import * as Vue from 'vue';
import * as Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    themes: [],
    configLocation: '',
    img: '',
    theme: '',
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
  },
  actions: {
    updateThemes(context) {
      context.commit('updateThemes');
    },
  },
});
