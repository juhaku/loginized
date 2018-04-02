<template>
    <div :class="['uploader', {'dragging': over}]" @mouseover="over = true" @mouseout="over = false" 
        @dragenter.prevent="over = false" @dragover.prevent="over = true" @dragleave.prevent="over = false" @drop.prevent="dropFiles($event)">
        <input type="file" :accept="accept" style="display: none;" @change="update($event)" ref="file" />
        <div @click="browseFiles($event)" class="pointer content">
            <div v-if="!hasFiles()">
                <v-icon :color="over ? 'primary': ''" size="2.5em">file_upload</v-icon>
            </div>
            <div class="grey-label" v-if="!hasFiles()">Drag and drop file, or click to browse files.</div>

            <template v-for="(file, index) in files">
                <div :key="file.name" v-if="hasFiles()">
                    <v-icon size="2.5em">insert_drive_file</v-icon>
                </div>
                <div class="grey-label" :key="file.name + '_label'" v-if="hasFiles()">{{file.name}}</div>
                <v-btn class="rm_file" flat icon :key="file.name + '_rm'" @click="removeFileAndUpdate(index)">
                    <v-icon color="primary">remove</v-icon>
                </v-btn>
            </template>
        </div>
    </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';
import { mixins } from 'vue-class-component';
import * as AbstractFile from './AbstractFile';
import FileEntry from '../model/FileEntry';

@Component
export default class File extends mixins(AbstractFile) {

    private over: boolean = false;
    private files: [] = [];

    @Prop() private accept: string;
    @Prop({default: 0}) private maxFiles: number;

    public clear() {
        this.files.splice(0, this.files.length);
        this.$refs.file.value = '';
    }

    private browseFiles($event) {
        if (!$event.target.parentNode.className.includes('rm_file') && this.maxFiles > this.files.length) {
            this.openUploader(this.$refs.file);
        }
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
        this.$refs.file.value = this.files.join(', ');
        this.updateFiles(this.files);
    }

    private updateFiles(files: File[]) {
        this.files = files;
        if (files.length > 0) {
            this.$emit('file-upload', this.files
                .map((file: any) => {
                    const entry = new FileEntry();
                    entry.name = file.name;
                    entry.file = file;
                    entry.url = URL.createObjectURL(file);

                    return entry;
            }));
        }
    }
}
</script>

<style lang="stylus" scoped>
.pointer
  cursor pointer

.uploader
  border-radius 0.25em !important
  border 0.1em dotted #dbdbdb
  transition 200ms border ease-in, 200ms color ease-in

  &:hover, &.dragging
    border 0.1em dotted rgb(245, 118, 79)

  div.content
    display flex
    justify-content center
    align-items center
    flex-wrap nowrap
    height 5em

    .grey-label
      color rgba(0,0,0,0.54)
</style>
