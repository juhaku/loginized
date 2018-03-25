<template>
    <div>
        <v-app>
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
                        <v-layout row>
                            <v-flex xs6>
                                <h3>Theme:</h3>
                                <v-select autocomplete :items="themes" v-model="selectedTheme" label="Select theme" single-line solo required :rules="[() => select && select.length > 0 || 'You must choose theme first']"></v-select>
                            </v-flex>
                            <v-flex xs6>
                                <h3>Background image:</h3>
                                <ImageFile v-on:img-change="selectedImage=$event" />
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

@Component({
    components: {
        File,
        ImageFile,
    },
})
export default class App extends Vue {
    private static BASE_PATH = `${__dirname}/..`;
    private static readonly VERSION = '0.1.3-SNAPSHOT';

    private selectedTheme: string = '';
    private selectedImage: FileEntry = new FileEntry();
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

    @State('themes') private themes: string[];
    @State('configLocation') private configLocation: string;
    @State('theme') private theme: string;
    @State('defaultDesktop') private defaultDesktop: boolean;

    @Mutation private updateThemes: ({ }) => {};
    @Mutation private setConfigLocation: ({ }) => {};
    @Mutation private setImg: ({ }) => {};
    @Mutation private setTheme: ({ }) => {};
    @Mutation private setRelease: ({ }) => {};
    @Mutation private setDefaultDesktop: ({ }) => {};

    private getVersion() {
        return App.VERSION;
    }

    private created() {
        this.cliExec('start', false).then((stdout: any) => {
            const configPath = `${stdout.trim()}/config.json`;

            if (fs.existsSync(configPath)) {
                const state = fs.readFileSync(configPath, 'utf8');
                const stateJson = JSON.parse(state);
                this.release = stateJson.release;
                this.$store.replaceState(stateJson);
                this.selectedTheme = this.theme;
            }

            this.setConfigLocation(stdout.trim());
        }, (error: any) => this.showError(error));

        this.cliExec('list', false).then((stdout: string) =>
            this.updateThemes([...stdout.split(/\s/).filter((item: string) => item !== '')]),
                (error: any) => this.showError(error));

        this.$store.subscribe((mutation, state) => {
            if (mutation.type === 'setConfigLocation' && state.release === null) {
                this.openWelcomeOrUpdateSetup(state.release);
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
            this.installDesktop = this.defaultDesktop;
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
        if (this.selectedTheme === '') {
            return;
        }

        this.cliExec(`install gui ${this.configLocation} ${this.selectedTheme} ${this.selectedImage.getFileName()}`,
            true).then((stdout: any) => {
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

    private cliExec(command: string, sudo: boolean): Promise<any> {
        return this.exec(`${sudo ? 'pkexec ' : ''}${App.BASE_PATH}/loginized-cli.sh ${command}`);
    }

    private exec(command: string): Promise<any> {
        return this.$shell.exec(command);
    }

    private saveSettings() {
        this.settingsDialog = false;
        if (this.defaultTheme !== null || this.defaultTheme !== undefined) {
            this.updateDefaultTheme(this.defaultTheme);
        }
    }

    private updateDefaultTheme(file: FileEntry) {
        // We want to explicitly name the default theme to gnome-shell-theme.gresource
        const nameWithPath = `${this.configLocation}/default/gnome-shell-theme.gresource`;
        this.$refs.defaultThemeFile.writeUploadFile(nameWithPath, file).then((retVal: any) =>
            this.cliExec('updateDefault', false)
            .then((stdout: any) => this.$refs.defaultThemeFile.clear(), (error: any) => this.showError(error)));
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

        this.cliExec(`setupApp ${command}`, true)
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
