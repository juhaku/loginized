import * as Vue from 'vue';
import * as Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    themes: [],
  },
  mutations: {
    updateThemes(state: any, themes: []) {
      console.log(`got herer`);
      state.themes = [...themes];
    },
  },
  actions: {
    updateThemes(context) {
      context.commit('updateThemes');
    },
  },
});
