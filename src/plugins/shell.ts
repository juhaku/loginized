import * as Promise from 'promise';
import * as Vue from 'vue';
import { exec, execFile } from 'child_process';

export default class Shell {

    private xmlLintError = 'XMLLINT not set and xmllint not found in path; skipping xml preprocessing.';

    public exec = (cmd: string): Promise<any> => {
        return new Promise((resolve, reject) => {
            exec(cmd, (error: Error, stdout: any, stderr: any) => {
                if ((error || stderr) && !stderr.includes(this.xmlLintError)) {
                    reject(error || stderr);
                }
                resolve(stdout);
            });
        });
    }
}

Vue.prototype.$shell = new Shell();
