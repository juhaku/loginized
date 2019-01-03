import Vue from 'vue';
import Vuex from 'vuex';
import { DateTime } from 'luxon';
import Constants from './constants';
import fs from 'fs';
import { ThemeConfig } from './ThemeConfig';

Vue.use(Vuex);

export enum ActionKeys {
    CHECK_FOR_UPDATES = 'CHECK_FOR_UPDATES',
    SET_LAST_CHECKED = 'SET_LAST_CHECKED',
    SET_ERROR = 'SHOW_ERROR',
    SET_NEW_VERSION = 'SET_NEW_VERSION',
    WRITE_CONFIG = 'WRITE_CONFIG',
    SET_CONFIG_LOCATION = 'SET_CONFIG_LOCATION',
    OPEN_DIALOG = 'OPEN_DIALOG',
    SET_CLI_INSTALLED_VERSION = 'SET_CLI_INSTALLED_VERSION',
    SET_THEME_CONFIG = 'SET_THEME_CONFIG',
}

export interface AppState {
    lastChecked: string;
    error: any | undefined;
    newVersion: string;
    configLocation: string;
    theme: string;
    userlistEnabled: boolean;
    shield: string;
    background: string;
    dialog: string;
    cliInstalledOnVersion: string;
}

const appState: AppState = {
    lastChecked: '',
    newVersion: '',
    configLocation: '',
    error: undefined,
    dialog: '',
    theme: '',
    shield: '',
    background: '',
    userlistEnabled: true,
    cliInstalledOnVersion: '',
};

export default new Vuex.Store({
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

        [ActionKeys.SET_LAST_CHECKED]: (state: AppState, lastChecked) => {
            state.lastChecked = lastChecked;
        },

        [ActionKeys.OPEN_DIALOG]: (state: AppState, dialog: string) => {
            state.dialog = dialog;
        },

        [ActionKeys.SET_CLI_INSTALLED_VERSION]: (state: AppState, cliInstalledVersion: string) => {
            state.cliInstalledOnVersion = cliInstalledVersion;
        },

        [ActionKeys.SET_THEME_CONFIG]: (state: AppState, config: ThemeConfig) => {
            state.background = config.background;
            state.theme = config.theme;
            state.shield = config.shield;
            state.userlistEnabled = config.userlistEnabled;
        },
    },
    actions: {
        [ActionKeys.CHECK_FOR_UPDATES]: ({ state, commit, dispatch }, force?: boolean) => {
            if (force === true
                || state.lastChecked === ''
                || DateTime.local().diff(DateTime.fromISO(state.lastChecked)).toObject().hours! > 24) {
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
                dispatch(ActionKeys.WRITE_CONFIG);
            }
        },

        [ActionKeys.WRITE_CONFIG]: async ({ state, commit }) => {
            return new Promise((resolve, reject) => {
                fs.writeFile(`${state.configLocation}/config.json`,
                    JSON.stringify(state, (key, value) => {
                        if (key === 'dialog' || key === 'error') {
                            return '';
                        }
                        return value;
                    }), (nerr: NodeJS.ErrnoException) => {
                        if (nerr) {
                            reject(nerr);
                        }
                        resolve('OK');
                    });
            }).catch((error) => (commit(ActionKeys.SET_ERROR, error)));
        },
    },
});
