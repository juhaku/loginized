import * as Vue from 'vue';
import { exec } from 'child_process';

export default class Shell {
    private static DEFAULT_CALLBACK = (error: Error, stdout: any, stderr: any) => {};

    public exec = (cmd: string, callback?: (error: Error, stdout: any, stderr: any) => {}) => {
        let fn = Shell.DEFAULT_CALLBACK;
        if (callback) {
            fn = callback;
        }

        exec(cmd, fn);
    }

}

Vue.prototype.$shell = new Shell();
