<template>
    <div :class="[
        'uploader',
        {'uploader--dragging': over},
        ]"
        @dragenter.prevent
        @dragover.prevent="over = true"
        @dragleave.prevent="over = false"
        @drop.prevent="dropFiles($event)">
        <input type="file" :accept="accept" style="display: none;" @change="update($event)" ref="file" />
        <div @click="browseFiles($event)" class="content">
            <div v-if="!hasFiles() && !over">Drag and drop file, or click to browse files.</div>
            <div v-else-if="over">Drop here</div>

            <template v-for="(file) in files">
                <div :key="file.name + '_label'" v-if="hasFiles()">{{file.name}} updated!</div>
            </template>
        </div>
    </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';
import AbstractFile from '@/components/AbstractFile.vue';
import { FileEntry } from '@/FileEntry.ts';

@Component({
    extends: AbstractFile,
})
export default class File extends AbstractFile {

    private over = false;
    private files: File[] = [];

    @Prop() private accept!: string;
    @Prop({default: 0}) private maxFiles!: number;
    @Prop() private writeLocation!: string;

    public clear() {
        this.files.splice(0, this.files.length);
        (this.$refs.file as HTMLInputElement).value = '';
    }

    private browseFiles($event: MouseEvent) {
        this.openUploader(this.$refs.file);
    }

    private dropFiles($event: any) {
        // Remove start (*) from this accept as it would lead wrong information when filtered files
        const acceptTrimmed = this.accept.replace('*', '');
        this.updateFiles(this.fileListToArray($event.dataTransfer.files)
            .filter((file: any) => file.type.includes(acceptTrimmed) || file.name.includes(acceptTrimmed)));
    }

    private update($event: any) {
        this.updateFiles(this.fileListToArray($event.target.files));
    }

    private hasFiles(): boolean {
        return this.files !== null && this.files.length > 0;
    }

    private removeFileAndUpdate(index: number) {
        this.files.splice(index, 1);
        (this.$refs.file as HTMLInputElement).value = this.files.join(', ');
        this.updateFiles(this.files);
    }

    private updateFiles(files: File[]) {
        this.files = files;
        if (files.length > 0) {
            this.$emit('file-uploaded', this.files
                .map((file: any) => {
                    const entry = {
                        name: file.name,
                        file,
                        url: URL.createObjectURL(file),
                    } as FileEntry;
                    this.writeUploadFile(this.writeLocation, entry);
                    return entry;
            }));
        }
    }
}
</script>

<style lang="stylus" scoped>
@import '../stylus/variables.styl'

.uploader
    background-color cool-white
    border-radius radius-mini radius-mini
    border default-border-width solid smoke
    transition border-color 150ms ease-in, background-color 150ms ease-in

    &--dragging
        border-color main-color

    .content
        display flex
        justify-content center
        align-items center
        flex-wrap nowrap
        height 5em
        color smoke
        
        &:hover
            cursor pointer
</style>
