<template>
    <div>
        <input type="file" accept="image/*" style="display: none;" @change="update($event)" ref="imageFile" />
        <v-card>
            <div @click="browseImage($event)" class="pointer">
                <v-card-media :src="imgBlob" height="200px" v-if="imgBlob != ''">
                </v-card-media>
                <v-card-title v-else>
                    <div class="grey-label">No picture selected</div>
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
import * as fs from 'fs';
import FileEntry from '../model/FileEntry.ts';
import { State, Mutation } from 'vuex-class';

@Component
export default class ImageFile extends Vue {

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

    private update(event: any) {
        let name = '';
        let file: File = {} as File;
        if (event.target.files.length > 0) {
            file = event.target.files[0];
            name = file.name;
            this.imgBlob = URL.createObjectURL(file);

            const entry = new FileEntry();
            entry.url = this.imgBlob;
            entry.file = file;
            entry.name = name;

            const path = `${this.configLocation}/${entry.getFileName()}`;
            entry.path = path;

            this.setImg(path);
            this.$emit('img-change', entry);

            this.writeUploadFile(path, entry);
        }
    }

    private clear() {
        this.setImg('');
        this.$emit('img-change', new FileEntry());
    }

    private writeUploadFile(name: string, entry: FileEntry) {
        const reader = new FileReader();
        reader.onload = (event: any) => {
            fs.writeFile(name, Buffer.from(event.target.result), (error: NodeJS.ErrnoException) => {
                if (error) {
                    throw error;
                }
            });
        };
        reader.readAsArrayBuffer(entry.file);
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
