<template>
    <div class="pointer">
        <input type="file" style="display: none;" @change="update($event)" ref="imageFile" />
        <v-card @click.native="browseImage($event)">
            <v-card-media :src="img" height="200px">
            </v-card-media>
        </v-card>
    </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';
import FileEntry from '../model/FileEntry.ts';

@Component
export default class ImageFile extends Vue {

    @Prop() private image: string;

    private img: string = '';

    private created() {
        this.img = this.image;
    }

    private browseImage($event: any) {
        this.$refs.imageFile.click();
    }

    private update(event: any) {
        let name = '';
        let file: File = {} as File;
        if (event.target.files.length > 0) {
            file = event.target.files[0];
            name = file.name;
            this.img = URL.createObjectURL(file);
        } else {
            this.img = '';
        }

        const entry = new FileEntry();
        entry.url = this.img;
        entry.file = file;
        entry.name = name;
        this.$emit('img-change', entry);
    }

}
</script>

<style lang="stylus" scoped>
.pointer
 cursor pointer
</style>
