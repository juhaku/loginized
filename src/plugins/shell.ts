import * as Promise from 'promise';
import * as Vue from 'vue';
import { exec } from 'child_process';

export default class Shell {

    public exec = (cmd: string): Promise<any> => {
        return new Promise((resolve, reject) => {
            exec(cmd, (error: Error, stdout: any, stderr: any) => {
                if (error || stderr) {
                    throw error || stderr;
                }
                resolve(stdout);
            });
        });
    }

}

Vue.prototype.$shell = new Shell();
