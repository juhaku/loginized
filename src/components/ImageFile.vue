<template>
    <div :class="[
        'image-file',
        dragover && 'image-file--dragover'
        ]">
        <input type="file"
            accept="image/*"
            style="display: none;"
            @change="update($event)"
            ref="imageFile" />
        <div @click="browseImage()" 
            class="content" 
            @dragenter.prevent
            @dragover.prevent="dragover = true"
            @dragleave.prevent="dragover = false"
            @drop.prevent="dropFiles($event)">
            <div
                class="image-file__image" 
                v-if="imgBlob !== ''"
                ref="img" />
            <div class="image-file__placeholder" v-else>
                <div v-if="!dragover">Drag and drop or click to select image</div>
                <div v-else>Drop here</div>
            </div>
        </div>
        <div class="buttons" v-show="imgBlob !== ''" >
            <div>
                <Button @click.native="clear()" text="Clear" />
            </div>
        </div>
    </div>
</template>

<script lang="ts">
import { Component, Prop } from 'vue-property-decorator';
import fs from 'fs';
import AbstractFile from '@/components/AbstractFile.vue';
import Button from '@/components/Button/Button.vue';
import { State } from 'vuex-class';
import { FileEntry } from '@/FileEntry';

@Component({
    extends: AbstractFile,
    components: { Button },
})
export default class ImageFile extends AbstractFile {

    @Prop() private value!: string;
    @Prop() private configLocation!: string;

    private dragover = false;
    private imgBlob: string = '';

    private created() {
        this.$watch('value', (newPath, oldPath) => {
            if (newPath && newPath !== '') {
                const img = fs.readFileSync(newPath);
                const blob = new Blob([img], {type: 'application/octet-binary'});
                this.imgBlob = URL.createObjectURL(blob);
                this.showImage();
            } else {
                this.imgBlob = '';
            }
        }, { immediate: true });
    }

    private browseImage() {
        return (this.$refs.imageFile as HTMLInputElement).click();
    }

    private dropFiles(event: any) {
        const accept = 'image/';
        const files = super.acceptFilter(event.dataTransfer.files, (file: any) => file.type.includes(accept));
        if (files.length === 1) {
            this.updateFile(files[0]);
        }
    }

    private update(event: any) {
        if (event.target.files.length === 1) {
            this.updateFile(event.target.files[0]);
        }
    }

    private updateFile(file: File) {
        this.imgBlob = URL.createObjectURL(file);
        this.showImage();
        const entry = {
            url: this.imgBlob,
            name: file.name,
            file,
            path: `${this.configLocation}/${file.name.substring(file.name.lastIndexOf('/') + 1)}`,
        } as FileEntry;

        super.writeUploadFile(entry.path, entry).then((retVal: any) => {
            this.$emit('input', entry.path);
        });
    }

    private clear() {
        this.imgBlob = '';
        (this.$refs.img as HTMLDivElement).style.backgroundImage = 'none';
        this.$emit('input', '');
    }

    private showImage() {
        this.$nextTick(() => {
            (this.$refs.img as HTMLDivElement).style.backgroundImage = `url(${this.imgBlob})`;
        });
    }

}
</script>

<style lang="stylus" scoped>
@import '../stylus/variables.styl'

.image-file
    display flex
    align-items center
    background-color cool-white
    border-radius radius-mini radius-mini
    border default-border-width solid smoke
    transition border-color 150ms ease-in, background-color 150ms ease-in
    flex-wrap wrap

    &--dragover
        border-color main-color

    .content
        cursor pointer
        width 100%
    
    &__image, &__placeholder
        display flex
        justify-content center
        align-items center
        color smoke
        height 10rem
        width 100%
    
    &__image
        background-position center center
        background-repeat no-repeat
        background-size cover

    &__placeholder
        height 12rem
    
    .buttons
        width 100%
        margin 0.2rem
        display flex
        justify-content flex-end

</style>
