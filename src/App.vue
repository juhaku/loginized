<template>
    <div class="app">
        <Snackbar :active="newVersion !== ''" :timeout="10000" :onClose="() => hideUpdatesSnackbar('')">
            <h3 class="snackbar-message">Updates available {{newVersion}} 
                <Button class="button" text="Show" :filled="true" :inverted="true" />
            </h3>
        </Snackbar>
        <ErrorDialog :error="error"
            :onCloseDialog="onCloseErrorDialog" v-if="error"/>
        <RebootDialog  v-else-if="dialog === 'reboot'"
            :onCloseDialog="() => openDialog('')" :onReboot="reboot"/>
        <AboutDialog
            v-else-if="dialog === 'about'"
            :onCloseDialog="() => openDialog('')" />
        <AdvancedSettings
            v-else-if="dialog === 'advanced_settings'"
            :data="dialogData"
            :onCloseDialog="() => openDialog('')" />
        <FluidGrid class="app-grid" direction="row" noWrap="noWrap" ref="grid">
            <FluidGridColumn class="app-grid__menu_view">
                <div class="menu">
                    <Tooltip :left="true" text="Login theme">
                        <Icon :class="[
                            'menu__item',
                            isActive('/') && 'menu__item--active',
                            ]"
                            :main="true"
                            icon="paint" 
                            size="huge"
                            @click.native="navigate('/')"
                            slot="opener" />
                    </Tooltip>
                    <Tooltip :left="true" text="Settings">
                        <Icon :class="[
                            'menu__item',
                            isActive('/settings') && 'menu__item--active',
                            ]"
                            :main="true"
                            icon="settings"
                            size="huge"
                            @click.native="navigate('/settings')"
                            slot="opener" />
                    </Tooltip>
                    <Tooltip :left="true" text="About">
                        <Icon :class="[
                            'menu__item',
                            ]"
                            :main="true"
                            icon="info"
                            size="huge"
                            @click.native="openDialog('about')"
                            slot="opener" />
                    </Tooltip>
                </div>
            </FluidGridColumn>
            <FluidGridColumn class="app-grid__view" column="12">
                <router-view/>
            </FluidGridColumn>
        </FluidGrid>
    </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import FluidGrid from '@/components/Grid/FluidGrid.vue';
import FluidGridColumn from '@/components/Grid/FluidGridColumn.vue';
import Tooltip from '@/components/Tooltip/Tooltip.vue';
import Icon from '@/components/Icon/Icon.vue';
import { AppState } from '@/store/store';
import fs from 'fs';
import Constants from '@/constants';
import { State, Mutation, Action } from 'vuex-class';
import ErrorDialog from '@/components/Dialog/ErrorDialog.vue';
import RebootDialog from '@/components/Dialog/RebootDialog.vue';
import AboutDialog from '@/components/Dialog/AboutDialog.vue';
import AdvancedSettings from './components/Dialog/AdvancedSettings.vue';
import Snackbar from '@/components/Snackbar/Snackbar.vue';
import Button from '@/components/Button/Button.vue';
import { ActionKeys } from '@/store/action-keys';


@Component({
  components: {
    FluidGrid,
    FluidGridColumn,
    Tooltip,
    Icon,
    ErrorDialog,
    RebootDialog,
    AboutDialog,
    AdvancedSettings,
    Snackbar,
    Button,
  },
})
export default class App extends Vue {

    @State('configLocation') private configLocation!: string;
    @State('dialog') private dialog!: string;
    @State('dialogData') private dialogData!: string;
    @State('error') private error!: any;
    @State('newVersion') private newVersion!: string;

    @Mutation(ActionKeys.SET_ERROR)
    private onCloseErrorDialog!: () => void;

    @Mutation(ActionKeys.OPEN_DIALOG)
    private openDialog!: (dialog: string) => void;

    @Mutation(ActionKeys.SET_NEW_VERSION)
    private hideUpdatesSnackbar!: (v: string) => void;

    @Mutation(ActionKeys.SET_THEMES)
    private setThemes!: (themes: string[]) => void;

    @Mutation(ActionKeys.RESTORE_PERSISTED_STATE)
    private restorePersistedState!: () => void;

    @Mutation(ActionKeys.SET_CONFIG_LOCATION)
    private setConfigLocation!: (configLocation: string) => void;

    @Action(ActionKeys.CHECK_FOR_UPDATES)
    private checkForUpdates!: () => void;

    private created() {
        window.addEventListener('resize', (ev) => (this.setGridHeight()));
        this.restorePersistedState();

        this.$watch('newVersion', (newValue, oldValue) => {
            if (newValue !== '') {
                // this show notification of new version
                const titleAndMessage = `"New version available ${newValue}" "See https://github.com/juhaku/loginized/releases/latest"`;
                this.$exec(`${Constants.BASE_PATH}/utils.sh notify ${titleAndMessage}`);
            }
        }, { immediate: true });

        this.$cliExec('--gui start').then((configLocation) => {
            this.setConfigLocation(Constants.IS_DEBUG
                ? `${configLocation.replace('\n', '')}/_test` : configLocation.replace('\n', ''));
            const config = `${this.configLocation}/config.json`;

            this.$cliExec('list').then((themes) =>
                (this.setThemes([...themes.split(/\s/).filter((item: string) => item !== '')])));

            this.checkForUpdates();
        });
    }

    private mounted() {
        this.setGridHeight();
    }

    private setGridHeight() {
        this.$nextTick(() => {
            const grid = ((this.$refs.grid as FluidGrid).$el as HTMLDivElement);

            if (grid) {
                grid.style.height = `${window.innerHeight}px`; // minus the margin
            }
        });
    }

    private isActive(route: string): boolean {
        return this.$route.path === route;
    }

    private navigate(path: string) {
        this.$router.push({ path });
    }

    private reboot() {
        this.openDialog('');
        this.$exec('gnome-session-quit --reboot');
    }
}
</script>
<style lang="stylus">
@import './stylus/*'

.app
    .snackbar-message
        margin-left 1rem
        color cool-white

        .button
            margin-left 1rem

    .app-grid
        display flex
        background-color darker-white

        &__view
            padding 0.5rem

        &__menu_view
            width 70px
        
        .menu
            background-color dark-grey
            display flex
            flex-direction column
            height 100%
            width 70px

            &__item
                width 45px
                height 45px
                border 0em solid grey
                transition fill 150ms ease-in, border 150ms ease-in
                padding 0.3rem

                &:hover, &--active
                    fill secondary
                    border-left 0.2rem solid secondary
                    cursor pointer

</style>
