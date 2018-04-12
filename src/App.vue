<template>
    <div>
        <v-app>
            <v-snackbar :timeout="20000" :top="true" v-model="updatesAvailable">
                Newer version ({{newVersion}}) of this application is available. 
                <a href="https://github.com/juhaku/loginized/releases" @click.prevent="openLink($event.currentTarget.href)">Releases</a>
                <v-btn flat color="primary" @click.native="updatesAvailable = false">Close</v-btn>
            </v-snackbar>

            <v-dialog v-model="rebootDialog" persistent max-width="40em">
                <v-card>
                    <v-card-title class="headline">Reboot Computer</v-card-title>
                    <v-card-text>Changes will take affect after reboot, Reboot now?</v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn flat @click="rebootDialog = false">No</v-btn>
                        <v-btn color="primary" flat @click="reboot()">Yes</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <v-dialog v-model="updateDialog" persistent max-width="40em">
                <v-card>
                    <v-card-title class="headline">Update Configuration?</v-card-title>
                    <v-card-text>Application version has changed. Update application configuration?</v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn flat @click="updateDialog = false">No</v-btn>
                        <v-btn color="primary" flat @click="setup()">Yes</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <v-dialog v-model="welcomeDialog" persistent max-width="40em">
                <v-card>
                    <v-card-title>
                        <div style="width: 100% !important;" class="headline">Hello! Choose setup you wish to continue with.</div>
                    </v-card-title>
                    <v-card-text>
                        <v-checkbox label="Install .desktop file to /usr/share/applications" v-model="installDesktop" :disabled="desktopDisabled"></v-checkbox>
                        <v-checkbox label="Install cli for loginized to /usr/bin" v-model="installCli"></v-checkbox>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn color="primary" flat @click="setup()">Ok</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <v-dialog v-model="errorDialog" persistent>
                <v-card>
                    <v-card-title color="error" class="headline">
                        <v-icon color="error" size="2em">error</v-icon> Error
                    </v-card-title>
                    <v-card-text>{{error}}</v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn color="error" flat @click="closeError()">Close</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>

            <v-dialog v-model="settingsDialog" fullscreen transition="dialog-bottom-transition" :overlay="false" scrollable>
                <v-card tile>
                    <v-toolbar card dark color="primary">
                        <v-toolbar-title>Settings</v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-toolbar-items>
                        <v-btn dark flat @click.native="saveSettings()">Save</v-btn>
                        </v-toolbar-items>
                    </v-toolbar>
                    <v-card-text style="height: 100% !important;">
                        <div class="flex__box__">
                            <div class="box__100">
                                <h3>Upload default theme .gresource file:</h3>
                                <File :max-files="1" accept=".gresource" v-on:file-upload="defaultTheme = $event[0]" ref="defaultThemeFile" />
                                <h3>Check for updates:</h3>
                                <v-btn @click="checkUpdates()"><v-icon>refresh</v-icon> Check for updates ({{updatesChecked ? updatesChecked.toLocaleString(dateTimeFormat) : '--'}})</v-btn>
                            </div>
                            <div class="box__100">
                                <p style="margin: 0 !important;">&copy; 2018 Juha Kukkonen - 
                                    <a href="https://github.com/juhaku/loginized" @click.prevent="openLink($event.currentTarget.href)">https://github.com/juhaku/loginized</a> - v {{getVersion()}}
                                     <br>Licensed under: <a @click.prevent="openLink($event.currentTarget.href)" href="https://www.gnu.org/licenses/gpl-3.0.txt">GPL-3.0</a> 
                                     This program is provided AS IS and comes with ABSOLUTELY NO WARRANTY</p>
                            </div>
                        </div>
                    </v-card-text>
                    <div style="flex: 1 1 auto;"/>
                </v-card>
            </v-dialog>

            <div class="flex__box__">
                <div class="box__100">
                    <v-container fluid justify-end align-content-end grid-list-md>
                        <v-flex xs12 text-xs-right>
                            <v-tooltip bottom>
                                <v-btn flat icon slot="activator" @click="settingsDialog = true">
                                    <v-icon>settings</v-icon>
                                </v-btn>
                                Settings
                            </v-tooltip>
                        </v-flex>
                    </v-container>
                </div>
                <div class="box__100">
                    <v-container fluid justify-space-between grid-list-md>
                        <v-layout align-baseline row>
                            <v-flex xs6>
                                <h3>Theme:</h3>
                            </v-flex>
                            <v-flex xs6>
                                <v-select autocomplete :items="themes" v-model="selectedTheme" label="Select theme" single-line solo required :rules="[() => select && select.length > 0 || 'You must choose theme first']"></v-select>
                            </v-flex>
                        </v-layout>
                        <v-layout align-baseline row>
                            <v-flex xs6>
                                <h3>User list enabled: <Info text="Enables or disables user selection in login. If user list is disabled then user need to be typed to username field at login." /></h3>
                            </v-flex>
                            <v-flex style="display: flex; justify-content: flex-end;">
                                <div style="width: 3em;">
                                    <v-switch v-model="enableUserList"></v-switch>
                                </div>
                            </v-flex>
                        </v-layout>
                        <v-layout row>
                            <v-flex xs6>
                                <h3>Shield:</h3>
                                <ImageFile name="shield" v-on:img-change="selectedShield=$event" />
                            </v-flex>
                            <v-flex xs6>
                                <h3>Background image:</h3>
                                <ImageFile name="background" v-on:img-change="selectedImage=$event" />
                            </v-flex>
                        </v-layout>
                    </v-container>
                </div>
                <div class="box__100">
                    <v-container fluid grid-list-md justify-end align-content-end>
                        <v-flex xs12 text-xs-right>
                            <v-btn outline color="primary" :disabled="selectedTheme === '' ? true: false" @click="save()"><v-icon>save</v-icon>Save</v-btn>
                        </v-flex>
                    </v-container>
                </div>
            </div>
        </v-app>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import { Mutation, State } from 'vuex-class';
import * as ImageFile from './components/ImageFile.vue';
import * as File from './components/File.vue';
import FileEntry from './model/FileEntry.ts';
import * as fs from 'fs';
import { throws } from 'assert';
import * as _ from 'lodash';
import { exists } from 'fs';
import * as PerfectScrollbar from 'perfect-scrollbar';
import * as Promise from 'promise';
import * as opn from 'opn';
import * as path from 'path';
import FileEntry from '@/model/FileEntry';
import * as Info from './components/Info.vue';
import 'whatwg-fetch';
import { DateTime } from 'luxon';

@Component({
    components: {
        File,
        ImageFile,
        Info,
    },
})
export default class App extends Vue {
    private static readonly BASE_PATH = `${__dirname}/..`;
    private static readonly VERSION = '0.2.4-SNAPSHOT';
    private static readonly LATEST_RELEASE_URL = 'http://api.github.com/repos/juhaku/loginized/releases/latest';

    private selectedTheme: string = '';
    private selectedImage: FileEntry = new FileEntry();
    private selectedShield: FileEntry = new FileEntry();
    private rebootDialog: boolean = false;
    private settingsDialog: boolean = false;
    private defaultTheme: FileEntry | null = null;
    private errorDialog: boolean = false;
    private error: string | null = null;
    private installDesktop = true;
    private installCli = false;
    private desktopDisabled = false;
    private updateDialog = false;
    private welcomeDialog = false;
    private release: string | undefined;
    private setupClicked: boolean = false;
    private enableUserList: boolean = true;
    private updatesAvailable: boolean = false;
    private newVersion: string;
    private dateTimeFormat: string = DateTime.DATETIME_SHORT;

    @State('themes') private themes: string[];
    @State('configLocation') private configLocation: string;
    @State('theme') private theme: string;
    @State('defaultDesktop') private defaultDesktop: boolean;
    @State((state) => state.checked && DateTime.fromISO(state.checked)) private updatesChecked: DateTime;

    @Mutation private updateThemes: ({ }) => {};
    @Mutation private setConfigLocation: ({ }) => {};
    @Mutation private setImg: ({ }) => {};
    @Mutation private setTheme: ({ }) => {};
    @Mutation private setRelease: ({ }) => {};
    @Mutation private setDefaultDesktop: ({ }) => {};
    @Mutation private setUserList: ({ }) => {};
    @Mutation private setChecked: ({ }) => {};

    private getVersion() {
        return App.VERSION;
    }

    private created() {
        this.cliExec('--gui start').then((stdout: any) => {
            const configPath = `${stdout.trim()}/config.json`;

            if (fs.existsSync(configPath)) {
                const state = fs.readFileSync(configPath, 'utf8');
                const stateJson = JSON.parse(state);
                this.release = stateJson.release;
                this.$store.replaceState(stateJson);
                this.selectedTheme = this.theme;
            }

            this.setConfigLocation(stdout.trim());

            if (this.$store.state.checked === undefined || this.$store.state.checked === '') {
                this.checkUpdates();
            }

            this.cliExec('list').then((stdout: string) =>
                this.updateThemes([...stdout.split(/\s/).filter((item: string) => item !== '')]),
                    (error: any) => this.showError(error));
        }, (error: any) => this.showError(error));

        this.$store.subscribe((mutation, state) => {
            // Set the selected theme always point to theme from vuex
            this.selectedTheme = state.theme;

            if (mutation.type === 'setConfigLocation') {
                this.openWelcomeOrUpdateSetup(state.release);
            }
        });

        this.$store.watch(() => this.$store.state.checked, (checked: string, oldChecked: string) => {
            if (checked !== undefined) {
                const lastChecked = DateTime.fromISO(checked);
                // When there is more than 24 hours since last check then check updates.
                if (DateTime.local().diff(this.updatesChecked, 'hours').toObject().hours > 24) {
                    this.checkUpdates();
                }
            }
        });

        this.$store.watch(() => this.$store.state.userList, (userList: boolean, oldUserList: boolean) => {
            if (userList !== undefined) {
                this.enableUserList = userList;
            }
        });
    }

    private openWelcomeOrUpdateSetup(release: string | null) {
        if (this.setupClicked) {
            return;
        }

        // When application is new installation
        if (release === null) {
            // If desktop file is already installed in new installation do not allow installation of it
            if (this.isLoginizedDesktopInstalled()) {
                this.installDesktop = false;
                this.desktopDisabled = true;
                this.setDefaultDesktop(true);
            }
            this.welcomeDialog = true;

        // When different release than before offer update
        } else if (App.VERSION !== this.release) {
            this.updateDialog = true;
            this.installCli = this.isCliInstalled();
            // Only allow update desktop file if it was not default desktop
            this.installDesktop = !this.defaultDesktop;
        }
    }

    private mounted() {
        const contentMenu = this.$el.querySelector('.menu__content');
        contentMenu.style.overflow = 'hidden';
        const ps = new PerfectScrollbar('.menu__content');
    }

    private isCliInstalled(): boolean {
        return fs.existsSync('/usr/bin/loginized-cli');
    }

    private isLoginizedDesktopInstalled(): boolean {
        return fs.existsSync('/usr/share/applications/Loginized.desktop');
    }

    private save() {
        const themeArgs = `${this.selectedTheme},${this.selectedImage.getFileName()}`;
        const shieldImage = this.selectedShield && this.selectedShield.name !== undefined ?
            `${this.configLocation}/${this.selectedShield.getFileName()}` : '';

        this.cliExec(`--gui save ${themeArgs},${shieldImage},${this.enableUserList}`).then((stdout: any) => {
            this.writeConfig().then((status: any) => {
                this.rebootDialog = true;
            }, (error: any) => this.showError(error));
        }, (error: any) => {
            if (!error.includes('Command failed: pkexec')) {
                this.showError(error);
            }
        });
    }

    private reboot() {
        this.rebootDialog = false;
        this.exec('gnome-session-quit --reboot').catch((error: any) => {
            if (!error.includes('Operation was cancelled')) {
                this.showError(error);
            }
        });
    }

    @Watch('selectedTheme') private updateThemeChanges(theme: string, oldTheme: string) {
        this.setTheme(theme);
    }

    @Watch('enableUserList') private updateUserListChanges(userlist: boolean, oldUserList: boolean) {
        this.setUserList(userlist);
    }

    private cliExec(command: string): Promise<any> {
        return this.exec(`${App.BASE_PATH}/loginized-cli.sh ${command}`);
    }

    private exec(command: string): Promise<any> {
        return this.$shell.exec(command);
    }

    private saveSettings() {
        this.$refs.defaultThemeFile.clear();
        this.settingsDialog = false;
        if (this.defaultTheme !== null || this.defaultTheme !== undefined) {
            this.updateDefaultTheme(this.defaultTheme);
        }
    }

    private updateDefaultTheme(file: FileEntry) {
        // We want to explicitly name the default theme to gnome-shell-theme.gresource
        const nameWithPath = `${this.configLocation}/default/gnome-shell-theme.gresource`;
        this.$refs.defaultThemeFile.writeUploadFile(nameWithPath, file).then((retVal: any) =>
            this.cliExec(`--gui updateDefault`)
            .then((stdout: any) => { }, (error: any) => this.showError(error)));
    }

    private openLink(link: string) {
        opn(link);
    }

    private showError(error: any) {
        this.errorDialog = true;
        this.error = error.stack || error.message || error;
    }

    private closeError(error: any) {
        this.errorDialog = false;
        this.error = null;
    }

    private setup() {
        this.setupClicked = true; // Just to prevent opening setup again
        this.welcomeDialog = false;
        this.updateDialog = false;
        this.setRelease(App.VERSION); // Set new release version at setup

        let command = ``;
        if (this.installCli) {
            command += `${App.BASE_PATH}/loginized-cli.sh,${App.BASE_PATH}/loginized-cli-prompt`;
        }
        command += ',';
        if (this.installDesktop) {
            command += `${App.BASE_PATH}/Loginized.desktop`;
        }
        command += `,${path.resolve(App.BASE_PATH, '../../')},${path.resolve(__dirname, 'assets/icon_3@3x.png')}`;

        this.cliExec(`--gui setupApp ${command}`)
            .then((stdout: any) => this.writeConfig().catch((error: any) => this.showError(error)))
            .catch((error) => {
                if (!error.includes('Command failed: pkexec')) {
                    this.showError(error);
                }
            });
    }

    private writeConfig(): Promise<any> {
        return new Promise((resolve, reject) => {
            const state = _.cloneDeep(this.$store.state);

            fs.writeFile(`${this.configLocation}/config.json`,
                JSON.stringify(state), (nerr: NodeJS.ErrnoException) => {
                    if (nerr) {
                        reject(nerr);
                    }
                    resolve('OK');
                });
        });
    }

    private checkUpdates() {
        this.setChecked(DateTime.local().toISO());
        fetch(App.LATEST_RELEASE_URL).then((response) => response.json()).then((release: any) => {
            const latest = release.tag_name.replace('v', '').split('.');
            const current = App.VERSION.replace('-SNAPSHOT', '').split('.');

            latest.forEach((version: string, index: number) => {
                if (Number(version) > Number(current[index])) {
                    this.newVersion = latest.join('.');
                    this.updatesAvailable = true;
                    return;
                }
            });
        }).catch((error) => this.showError(error));
        this.writeConfig().catch((error) => this.showError(error));
    }

}
</script>

<style lang="stylus">
@import './stylus/custom.styl';

.flex__box__ 
  display: flex;
  flex-wrap: wrap;
  align-content: space-between;
  height: 100%;
  
  .box__50 
     width: 50%;
  
  .box__100 
     width: 100%;
</style>
