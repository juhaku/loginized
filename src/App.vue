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
            <v-dialog v-model="settingsDialog" fullscreen transition="dialog-bottom-transition" :overlay="false" scrollable>
                <v-card tile>
                    <v-toolbar card dark color="primary">
                        <v-toolbar-title>Settings</v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-toolbar-items>
                        <v-btn dark flat @click.native="settingsDialog = false">Save</v-btn>
                        </v-toolbar-items>
                    </v-toolbar>
                    <v-card-text>
                        <v-divider></v-divider>
                        <v-list three-line subheader>
                            <v-subheader>General</v-subheader>
                            <v-list-tile avatar>
                                <v-list-tile-action>
                                    <v-checkbox v-model="notifications"></v-checkbox>
                                </v-list-tile-action>
                                <v-list-tile-content>
                                    <v-list-tile-title>Notifications</v-list-tile-title>
                                    <v-list-tile-sub-title>Notify me about updates to apps or games that I downloaded</v-list-tile-sub-title>
                                </v-list-tile-content>
                            </v-list-tile>
                        </v-list>
                    </v-card-text>
                    <div style="flex: 1 1 auto;"/>
                </v-card>
            </v-dialog>
            <v-container grid-list-md>
                <v-layout justify-space-around row style="height: 500px;">
                    <v-flex xs6>
                        <h3>Select theme:</h3>
                        <v-select autocomplete :items="themes" v-model="selectedTheme" label="Select theme" single-line solo required :rules="[() => select && select.length > 0 || 'You must choose theme first']"></v-select>
                    </v-flex>
                    <v-flex xs6>
                        <h3>Select background image:</h3>
                        <ImageFile v-on:img-change="selectedImage=$event" />
                    </v-flex>
                </v-layout>

                <v-layout row justify-end align-content-end>
                    <v-flex xs6 text-xs-right>
                        <v-btn outline color="primary" :disabled="selectedTheme === '' ? true: false" @click="save()"><v-icon>save</v-icon>Save</v-btn>
                    </v-flex>
                </v-layout>
            </v-container>
        </v-app>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import { Mutation, State } from 'vuex-class';
import * as ImageFile from './components/ImageFile.vue';
import FileEntry from './model/FileEntry.ts';
import * as fs from 'fs';
import { throws } from 'assert';
import * as _ from 'lodash';
import { exists } from 'fs';
import * as PerfectScrollbar from 'perfect-scrollbar';

@Component({
    components: {
        ImageFile,
    },
})
export default class App extends Vue {
    private static BASE_PATH = `${__dirname}/../`;

    private selectedTheme: string = '';
    private selectedImage: FileEntry = new FileEntry();
    private rebootDialog: boolean = false;
    private settingsDialog: boolean = false;

    @State('themes') private themes: string[];
    @State('configLocation') private configLocation: string;
    @State('theme') private theme: string;

    @Mutation private updateThemes: ({ }) => {};
    @Mutation private setConfigLocation: ({ }) => {};
    @Mutation private setImg: ({ }) => {};
    @Mutation private setTheme: ({ }) => {};

    private created() {
        this.cliExec('start', false, (error: Error, stdout: any, stderr: any) => {
            const path = `${stdout.trim()}/config.json`;
            console.log(`status: ${stdout}`);
            console.log(`statuseerr: ${stderr}`);

            if (fs.existsSync(path)) {
                const state = fs.readFileSync(path, 'utf8');
                this.$store.replaceState(JSON.parse(state));
                this.selectedTheme = this.theme;
            }

            this.setConfigLocation(stdout.trim());
            this.exec(`cp ${App.BASE_PATH}gnome-shell-theme.gresource.xml ${stdout.trim()}/.`);
        });
        this.cliExec('list', false, (error: Error, sdtout: string, stderr: string) =>
            this.updateThemes([...sdtout.split(/\s/).filter((item: string) => item !== '')]));
    }

    private mounted() {
        // menu__content menu__content--select  menu__content--dropdown menu__content--autocomplete
        const contentMenu = this.$el.querySelector('.menu__content');
        contentMenu.style.overflow = 'hidden';
        const ps = new PerfectScrollbar('.menu__content');
    }

    private save() {
        if (this.selectedTheme === '') {
            return;
        }

        this.cliExec(`install gui ${this.configLocation} ${this.selectedTheme} ${this.selectedImage.getFileName()}`,
            true, (error: Error, stdout: any, stderr: any) => {
                console.log(stdout);
                console.log(stderr);
                if (!error) {
                    const state = _.cloneDeep(this.$store.state);
                    fs.writeFile(`${this.configLocation}/config.json`,
                        JSON.stringify(state), (nerr: NodeJS.ErrnoException) => {
                            if (nerr) {
                                throw nerr;
                            }
                            this.rebootDialog = true;
                        });
                }
            });
    }

    private reboot() {
        this.rebootDialog = false;
        this.exec('gnome-session-quit --reboot');
    }

    @Watch('selectedTheme') private updateThemeChanges(theme: string, oldTheme: string) {
        this.setTheme(theme);
    }

    private cliExec(command: string, sudo: boolean, callback?: (error: Error, stdout: string, stderr: string) => void) {
        this.exec(`${sudo ? 'pkexec ' : ''}${App.BASE_PATH}loginized-cli.sh ${command}`, callback);
    }

    private exec(command: string, callback?: (error: Error, stdout: string, stderr: string) => void) {
        this.$shell.exec(command, callback);
    }

    // private writeUploadFile(name: string, file: any) {
    //     const reader = new FileReader();
    //     reader.onload = (event: any) => {
    //         fs.writeFile(name, Buffer.from(event.target.result), (error: NodeJS.ErrnoException) => {
    //             if (error) {
    //                 throw error;
    //             }
    //             // Saved file
    //         });
    //     };
    //     reader.readAsArrayBuffer(file);
    // }

}
</script>

<style lang="stylus">
@import './stylus/custom.styl';
</style>
