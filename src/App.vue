<template>
  <div>
    <v-app>
      <v-container grid-list-md>
        <v-layout justify-space-around row style="height: 700px;">
            <v-flex xs6>
                <h1>Select theme:</h1>
                <v-select autocomplete :items="items" v-model="selectedTheme" label="Select theme" single-line solo></v-select>
            </v-flex>
            <v-flex xs6>
                <h1>Select background image:</h1>
                <ImageFile image="" v-on:img-change="selectedImage=$event" />
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
import { Component, Vue } from 'vue-property-decorator';
import * as HelloWorld from './components/HelloWorld.vue';
import * as ImageFile from './components/ImageFile.vue';

@Component({
    components: {
        HelloWorld,
        ImageFile,
    },
})
export default class App extends Vue {
    private static BASE_PATH = `${__dirname}/../`;

    private items: string[] = [];
    private selectedTheme: string = '';
    private selectedImage: string = '';

    created() {
        this.$shell.exec(`${App.BASE_PATH}loginized-cli.sh list`, (error: Error, sdtout: string, stderr: string) => {
            this.items = [...sdtout.split(/\s/).filter((item: string) => item !== '')];
        });
    }

}
</script>

<style lang="stylus">
@import './stylus/custom.styl';
</style>
