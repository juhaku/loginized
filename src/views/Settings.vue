<template>
    <FluidGrid class="settings" justify="end">
        <FluidGridColumn width="100">
            <FluidGrid>
                <FluidGridColumn>
                    <h2>Addons</h2>
                </FluidGridColumn>
            </FluidGrid>
            <FluidGrid>
                <FluidGridColumn width="50">
                    <h3>loginized-cli
                        <Info text="Command line interface for Loginized. Install needs sudo access which will be asked upon install." />
                    </h3>
                </FluidGridColumn>
                <FluidGridColumn width="50">
                    <FluidGrid justify="end">
                        <FluidGridColumn>
                            <h3>
                                <Button
                                    :disabled="isCliInstalled() && appVersion === cliInstalledOnVersion"
                                    size="normal"
                                    :text="!isCliInstalled() ? 'Install' : 'Update'"
                                    @click.native="installOrUpdateCli()"/>
                            </h3>
                        </FluidGridColumn>
                    </FluidGrid>
                </FluidGridColumn>
            </FluidGrid>
            <FluidGrid class="divider">
            </FluidGrid>
            <FluidGrid>
                <FluidGridColumn>
                    <h2>Settings</h2>
                </FluidGridColumn>
            </FluidGrid>
            <FluidGrid>
                <FluidGridColumn width="100">
                        <h3>Upload default theme .gresource file:
                            <Info text="Update cached Default theme .gresource file. Useful when system will will override the theme file via system update." />
                        </h3>
                        <File
                            :writeLocation="`${configLocation}/default/gnome-shell-theme.gresource`"
                            :max-files="1"
                            accept=".gresource" />
                </FluidGridColumn>
            </FluidGrid>
            <FluidGrid>
                <FluidGridColumn>
                    <h3>Check for updates:</h3>
                    <Button
                        size="normal"
                        :text="`Check for updates (${lastChecked || '--'})`"
                        @click.native="checkForUpdates(true)" />
                </FluidGridColumn>
            </FluidGrid>
        </FluidGridColumn>
    </FluidGrid>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import FluidGrid from '@/components/Grid/FluidGrid.vue';
import FluidGridColumn from '@/components/Grid/FluidGridColumn.vue';
import { State, Action, Mutation } from 'vuex-class';
import { AppState, ActionKeys } from '@/store';
import { DateTime } from 'luxon';
import fs from 'fs';
import Constants from '@/constants';
import Info from '@/components/Info.vue';
import Button from '@/components/Button/Button.vue';
import File from '@/components/File.vue';
import { FileEntry } from '@/FileEntry';

@Component({
    components: {
        FluidGrid,
        FluidGridColumn,
        Info,
        Button,
        File,
    },
})
export default class Settings extends Vue {

    @State((state: AppState) => (state.lastChecked !== ''
        && DateTime.fromISO(state.lastChecked)
            .toLocaleString(DateTime.DATETIME_SHORT)))
    private lastChecked!: string;

    @State('cliInstalledOnVersion')
    private cliInstalledOnVersion!: string;

    @State('configLocation')
    private configLocation!: string;

    @Mutation(ActionKeys.SET_CLI_INSTALLED_VERSION)
    private setCliInstalledOnVersion!: (version: string) => void;

    @Action(ActionKeys.CHECK_FOR_UPDATES)
    private checkForUpdates!: (force?: boolean) => void;

    @Action(ActionKeys.WRITE_CONFIG)
    private writeConfig!: () => Promise<string>;

    private readonly appVersion = Constants.VERSION;

    private isCliInstalled(): boolean {
        return fs.existsSync('/usr/bin/loginized-cli');
    }

    private installOrUpdateCli() {
        let command = ``;
        command += `${Constants.BASE_PATH}/loginized-cli.sh,${Constants.BASE_PATH}/loginized-cli-prompt,`;
        // command += `${App.BASE_PATH}/Loginized.desktop,`;
        // command += `${path.resolve(App.BASE_PATH, '../../')},${path.resolve(__dirname, 'assets/icon_3@3x.png')}`;

        this.$cliExec(`--gui setupApp ${command}`).then((stdout: any) => {
            this.setCliInstalledOnVersion(Constants.VERSION);
            this.writeConfig();
        });
    }
}
</script>

<style lang="stylus" scoped>
@import '../stylus/variables.styl'

.settings
    align-content space-between
    height 100%

    .divider
        height default-border-width
        background-color smoke
    
</style>
