import { VueConstructor } from 'vue';
import { exec } from 'child_process';
import Constants from './constants';
import store from './store/store';
import { ActionKeys } from './store/action-keys';

const XML_LINT_WARNING = 'XMLLINT not set and xmllint not found in path; skipping xml preprocessing.';

const cli = {
    install(Vue: VueConstructor, options: {}) {
        Vue.prototype.$exec = (cmd: string): Promise<string> => {
            return new Promise((resolve, reject) => {
                exec(cmd, (error, stdout: string, stderr: any) => {
                    if (error || stderr) {
                        if ((error || stderr)
                            && !stderr.includes(XML_LINT_WARNING)
                            && !stderr.includes('Command failed: pkexec')
                            && !stderr.includes('Operation was cancelled')
                            && !stderr.includes('Request dismissed')
                            && !stderr.includes('firefox')) {
                                store.commit(ActionKeys.SET_ERROR, error || stderr);
                        }
                        reject(error || stderr);
                    }
                    resolve(stdout);
                });
            });
        };

        Vue.prototype.$cliExec = (cmd: string) => {
            return Vue.prototype.$exec(`${Constants.BASE_PATH}/loginized-cli.sh ${cmd}`);
        };
    },
};

export default cli;
