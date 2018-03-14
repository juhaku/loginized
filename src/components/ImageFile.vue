<template>
    <div>
        <input type="file" accept="image/*" style="display: none;" @change="update($event)" ref="imageFile" />
        <v-card>
            <div @click="browseImage($event)" class="pointer" @dragenter.prevent @dragover.prevent @dragleave.prevent @drop.prevent="dropFiles($event)">
                <v-card-media :src="imgBlob" height="200px" v-if="imgBlob != ''">
                </v-card-media>
                <v-card-title style="height: 250px !important;" v-else>
                    <div class="grey-label">Drag and drop or click to select image</div>
                </v-card-title>
            </div>
            <v-card-actions v-show="imgBlob != ''" >
                <div class="content-right">
                    <v-btn flat @click="clear()">Clear</v-btn>
                </div>
            </v-card-actions>
        </v-card>
    </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';
import { mixins } from 'vue-class-component';
import * as fs from 'fs';
import FileEntry from '../model/FileEntry.ts';
import * as AbstractFile from './AbstractFile';
import { State, Mutation } from 'vuex-class';

@Component
export default class ImageFile extends mixins(AbstractFile) {

    @State('configLocation') private configLocation: string;
    @State('img') private img: string;

    @Mutation private setImg: ({ }) => {};

    private imgBlob: string = '';

    @Watch('img') private updateBlob(newImg: string, oldImg: string) {
        if (newImg !== '') {
            const img = fs.readFileSync(newImg);
            const blob = new Blob([img], {type: 'application/octet-binary'});
            this.imgBlob = URL.createObjectURL(blob);
        } else {
            this.imgBlob = '';
        }
    }

    private browseImage($event: any) {
        return this.$refs.imageFile.click();
    }

    private dropFiles(event: any) {
        if (event.dataTransfer.files.length === 1) {
            this.updateFile(event.dataTransfer.files[0]);
        }
    }

    private update(event: any) {
        if (event.target.files.length === 1) {
            this.updateFile(event.target.files[0]);
        }
    }

    private updateFile(file: any) {
        this.imgBlob = URL.createObjectURL(file);

        const entry = new FileEntry();
        entry.url = this.imgBlob;
        entry.file = file;
        entry.name = file.name;

        const path = `${this.configLocation}/${entry.getFileName()}`;
        entry.path = path;

        this.setImg(path);

        this.writeUploadFile(path, entry).then((retVal: any) => this.$emit('img-change', entry));
    }

    private clear() {
        this.setImg('');
        this.$emit('img-change', new FileEntry());
    }

}
</script>

<style lang="stylus" scoped>
.pointer
    cursor pointer

.content-right
    float right 
    width 100%
    text-align right 

.grey-label
    font-size 16px
    color rgba(0,0,0,0.54)
</style>
