import Vue from 'vue';
import Vuex, { MutationPayload } from 'vuex';
import { DateTime } from 'luxon';
import Constants from '../constants';
import fs from 'fs';
import persisted, { PersistedState } from './persisted';
import { ActionKeys } from './action-keys';

Vue.use(Vuex);

export interface AppState {
    error: any | undefined;
    newVersion: string;
    configLocation: string;
    dialog: string;
    themes: string[];
    persisted: PersistedState;
}

const appState: AppState = {
    newVersion: '',
    configLocation: '',
    error: undefined,
    dialog: '',
    themes: [],
    persisted: {} as PersistedState,
};

const store = new Vuex.Store({
    modules: {
        persisted,
    },
    state: appState,
    mutations: {
        [ActionKeys.SET_ERROR]: (state: AppState, error: any) => {
            state.error = error;
        },

        [ActionKeys.SET_NEW_VERSION]: (state: AppState, version: string) => {
            state.newVersion = version;
        },

        [ActionKeys.SET_CONFIG_LOCATION]: (state: AppState, configLocation: string) => {
            state.configLocation = configLocation;
        },

        [ActionKeys.OPEN_DIALOG]: (state: AppState, dialog: string) => {
            state.dialog = dialog;
        },

        [ActionKeys.SET_THEMES]: (state: AppState, themes: string[]) => {
            state.themes = [...themes];
        },

        [ActionKeys.RESTORE_PERSISTED_STATE]: (state: AppState) => {
            // nada
        },
    },
    actions: {
        [ActionKeys.CHECK_FOR_UPDATES]: ({ state, commit, dispatch }, force?: boolean) => {
            if (force === true
                || state.persisted.lastChecked === ''
                || DateTime.local().diff(DateTime.fromISO(state.persisted.lastChecked), 'hour').hours! > 24) {
                commit(ActionKeys.SET_NEW_VERSION, '');
                fetch(Constants.LATEST_RELEASE_URL).then((response) => response.json())
                    .then((release: any) => {
                        const latest = release.tag_name.replace('v', '').split('.');
                        const current = Constants.VERSION.replace('-SNAPSHOT', '').split('.');

                        if (Number(latest.join('')) > Number(current.join(''))) {
                            commit(ActionKeys.SET_NEW_VERSION, latest.join('.'));
                        }
                    }).catch((error) => (commit(ActionKeys.SET_ERROR, error)));
                commit(ActionKeys.SET_LAST_CHECKED, DateTime.local().toISO());
            }
        },
    },
});

store.subscribe((mutation: MutationPayload) => {
    switch (mutation.type) {
        case ActionKeys.SET_THEME_CONFIG:
        case ActionKeys.SET_LAST_CHECKED:
        window.localStorage.setItem('persistedState', JSON.stringify(store.state.persisted));
        break;
        case ActionKeys.RESTORE_PERSISTED_STATE:
        const persistedStateJson = window.localStorage.getItem('persistedState');
        if (persistedStateJson !== null) {
            store.state.persisted = {
                ...store.state.persisted,
                ...JSON.parse(persistedStateJson),
            };
        }
        break;
    }
});

export default store;
