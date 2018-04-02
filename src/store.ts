import * as Vue from 'vue';
import * as Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    themes: [],
    configLocation: '',
    shield: '',
    background: '',
    theme: 'Default',
    release: null,
    defaultDesktop: false,
    userList: true,
    checked: '',
  },
  mutations: {
    updateThemes(state: any, themes: []) {
      state.themes = [...themes];
    },
    setConfigLocation(state: any, location: string) {
      state.configLocation = location;
    },
    background(state: any, background: string) {
      state.background = background;
    },
    shield(state: any, shield: string) {
      state.shield = shield;
    },
    setTheme(state: any, theme: string) {
      state.theme = theme;
    },
    setRelease(state: any, release: string) {
      state.release = release;
    },
    setDefaultDesktop(state: any, defaultDesktop: boolean) {
      state.defaultDesktop = defaultDesktop;
    },
    setUserList(state: any, userList: boolean) {
      state.userList = userList;
    },
    setChecked(state: any, checked: string) {
      state.checked = checked;
    },
  },
  actions: {
    updateThemes(context) {
      context.commit('updateThemes');
    },
  },
});
