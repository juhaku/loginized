<template>
    <Dialog title="Reboot Computer"
        :active="true"
        :onCloseClick="onCloseDialog">
        <div class="reboot-dialog">
            <div class="text">
                Changes will take affect after reboot, Reboot now?
            </div>
            <Button
                size="normal"
                text="Yes"
                @click.native="onReboot"/>
            <Button
                class="button"
                size="normal"
                text="No" 
                :neutral="true"
                @click.native="onCloseDialog" />
        </div>
    </Dialog>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import Dialog from '@/components/Dialog/Dialog.vue';
import Button from '@/components/Button/Button.vue';

@Component({
    components: {
        Dialog,
        Button,
    },
})
export default class RebootDialog extends Vue {
    @Prop() private onCloseDialog!: () => void;
    @Prop() private onReboot!: () => void;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.reboot-dialog
    .text
        margin-bottom 1rem
    
    .button
        margin 0.5rem
</style>
