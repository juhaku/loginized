<template>
    <div>
        <ErrorDialog :error="error"
            :onCloseDialog="onCloseErrorDialog" v-if="error"/>
        <RebootDialog  v-else-if="dialog === 'reboot'"
            :onCloseDialog="onCloseDialog" :onReboot="reboot"/>
        <AboutDialog
            v-else-if="dialog === 'about'"
            :onCloseDialog="onCloseDialog" />
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
import { ActionKeys } from '@/store';
import fs from 'fs';
import Constants from '@/constants';
import { State, Mutation, Action } from 'vuex-class';
import ErrorDialog from '@/components/Dialog/ErrorDialog.vue';
import RebootDialog from '@/components/Dialog/RebootDialog.vue';
import AboutDialog from '@/components/Dialog/AboutDialog.vue';


@Component({
  components: {
    FluidGrid,
    FluidGridColumn,
    Tooltip,
    Icon,
    ErrorDialog,
    RebootDialog,
    AboutDialog,
  },
})
export default class App extends Vue {

    @State('configLocation') private configLocation!: string;
    @State('dialog') private dialog!: string;
    @State('error') private error!: any;

    @Mutation(ActionKeys.SET_ERROR)
    private onCloseErrorDialog!: () => void;

    @Mutation(ActionKeys.OPEN_DIALOG)
    private onCloseDialog!: () => void;

    @Mutation(ActionKeys.OPEN_DIALOG)
    private openDialog!: (dialog: string) => void;

    @Action(ActionKeys.CHECK_FOR_UPDATES)
    private checkForUpdates!: () => void;

    @Action(ActionKeys.WRITE_CONFIG)
    private writeConfig!: () => Promise<string>;

    private created() {
        window.addEventListener('resize', (ev) => (this.setGridHeight()));

        this.$cliExec('--gui start').then((result) => {
            this.$store.commit(ActionKeys.SET_CONFIG_LOCATION,
                Constants.IS_DEBUG ? `${result.replace('\n', '')}/_test` : result);
            const config = `${this.configLocation}/config.json`;

            if (fs.existsSync(config)) {
                const state = fs.readFileSync(config, 'utf8');
                this.$store.replaceState(JSON.parse(state));
            }
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
        this.onCloseDialog();
        this.$exec('gnome-session-quit --reboot');
    }
}
</script>
<style lang="stylus">
@import './stylus/*'

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
