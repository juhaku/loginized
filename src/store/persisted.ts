import { Module, MutationTree } from 'vuex';
import { AppState } from '@/store/store';
import { ThemeConfig } from '@/ThemeConfig';
import { ActionKeys } from './action-keys';

export interface PersistedState {
    lastChecked: string;
    theme: string;
    userlistEnabled: boolean;
    shield: string;
    background: string;
}

const persistedState: PersistedState = {
    lastChecked: '',
    theme: '',
    userlistEnabled: true,
    shield: '',
    background: '',
};

const mutations: MutationTree<PersistedState> = {
    [ActionKeys.SET_LAST_CHECKED]: (state: PersistedState, lastChecked) => {
        state.lastChecked = lastChecked;
    },

    [ActionKeys.SET_THEME_CONFIG]: (state: PersistedState, config: ThemeConfig) => {
        state.background = config.background;
        state.theme = config.theme;
        state.shield = config.shield;
        state.userlistEnabled = config.userlistEnabled;
    },
};

const persisted: Module<PersistedState, AppState> = {
    state: persistedState,
    mutations,
};

export default persisted;
