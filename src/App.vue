<template>
  <div>
    <v-app>
      <v-container grid-list-md>
        <v-layout justify-space-around row style="height: 500px;">
            <v-flex xs6>
                <h1>Select theme:</h1>
                <v-select autocomplete :items="themes" v-model="selectedTheme" label="Select theme" single-line solo></v-select>
            </v-flex>
            <v-flex xs6>
                <h1>Select background image:</h1>
                <ImageFile image="img" v-on:img-change="setSelectedImage($event)" />
            </v-flex>
        </v-layout>

        <v-layout row justify-end align-content-end>
            <v-flex xs6 text-xs-right>
                <v-btn outline color="primary"><v-icon>save</v-icon>Save</v-btn>
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

@Component({
    components: {
        ImageFile,
    },
})
export default class App extends Vue {
    private static BASE_PATH = `${__dirname}/../`;

    private selectedTheme: string = '';
    private selectedImage: FileEntry = new FileEntry();

    @State('themes') private themes: string[];
    @State('configLocation') private configLocation: string;
    @State('img') private img: string;
    @State('theme') private theme: string;

    @Mutation private updateThemes: ({ }) => {};
    @Mutation private setConfigLocation: ({ }) => {};
    @Mutation private setImg: ({}) => {};
    @Mutation private setTheme: ({}) => {};

    private created() {
        this.cliExec('start', false, (error: Error, stdout: any, stderr: any) => {
            const path = `${stdout.trim()}/config.json`;

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

    private save() {
        this.cliExec(`install gui ${this.selectedTheme} ${this.selectedImage.getFileName()}`, true,
            (error: Error, stdout: any, stderr: any) => {
                if (!error) {
                    const state = _.cloneDeep(this.$store.state);
                    fs.writeFile(`${this.configLocation}/config.json`,
                        JSON.stringify(state), (nerr: NodeJS.ErrnoException) => {
                        if (nerr) {
                            throw nerr;
                        }
                        console.log(`saved config file`);
                    });
                    // TODO ask question whether to reboot or not
                    // this.cliExec('reboot');
                }
            });
    }

    private setSelectedImage(file: FileEntry) {
        this.selectedImage = file;
        if (file.url !== '') {
            const path = `${this.configLocation}/${file.getFileName()}`;
            this.setImg(path);
            this.writeFile(path, file.file);
        } else {
            this.setImg('');
        }
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

    private writeFile(name: string, file: any) {
        const reader = new FileReader();
        reader.onload = (event: any) => {
            fs.writeFile(name, Buffer.from(event.target.result), (error: NodeJS.ErrnoException) => {
                if (error) {
                    throw error;
                }
                // Saved file
            });
        };
        reader.readAsArrayBuffer(file);
    }

}
</script>

<style lang="stylus">
@import './stylus/custom.styl';
</style>
