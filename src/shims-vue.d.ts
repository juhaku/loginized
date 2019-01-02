import Vue from 'vue';

declare module 'vue/types/vue' {
  interface Vue {
    $exec: (cmd: string) => Promise<string>;
    $cliExec: (cmd: string) => Promise<string>;
  }
}

declare module '*.vue' {
  import Vue from 'vue';
  export default Vue;
}
