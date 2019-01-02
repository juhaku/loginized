<template>
    <Dialog title="Error"
        :active="true"
        :onCloseClick="onCloseDialog">
        <div>
            {{error}}
        </div>
    </Dialog>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import Dialog from '@/components/Dialog/Dialog.vue';

@Component({
    components: {
        Dialog,
    },
})
export default class ErrorDialog extends Vue {
    @Prop() private onCloseDialog!: () => void;
    @Prop() private error!: any;
}
</script>
