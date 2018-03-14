<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';
import * as fs from 'fs';
import FileEntry from '../model/FileEntry.ts';
import * as Promise from 'promise';

@Component
export default class AbstractFile extends Vue {

    public writeUploadFile(name: string, entry: FileEntry): Promise<any> {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = (event: any) => {
                fs.writeFile(name, Buffer.from(event.target.result), (error: NodeJS.ErrnoException) => {
                    if (error) {
                        reject(error);
                        throw error;
                    }
                    resolve(name);
                });
            };
            reader.readAsArrayBuffer(entry.file);
        });
    }

    protected openUploader(uploader: any) {
        return uploader.click();
    }

    protected fileListToArray(fileList: FileList): any[] {
        return Array(fileList.length).fill(0).map((value: number, index: number) => fileList[index]);
    }

}
</script>
