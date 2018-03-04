import * as Vue from 'vue';
import { exec } from 'child_process';

export default class Shell {

    public exec = (cmd: string, callback: (error: any, stdout: any, stderr: any) => {}) => {
        exec(cmd, callback);
    }

}

Vue.prototype.$shell = new Shell();
