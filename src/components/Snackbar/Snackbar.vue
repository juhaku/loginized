<template>
    <transition name="snackbar">
        <div :class="[
            'snackbar',
        ]" v-if="active">
            <slot></slot>
        </div>
    </transition>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from 'vue-property-decorator';

@Component
export default class Snackbar extends Vue {
    @Prop() private timeout!: number;
    @Prop() private active!: boolean;
    @Prop() private onClose!: () => void;

    private visible = false;

    @Watch('active', { immediate: true })
    private closeAfterTimeout() {
        this.visible = this.active;
        if (this.visible === true) {
            const timeOut = window.setTimeout(() => {
                this.visible = false;
                if (this.onClose) {
                    this.onClose();
                }
                window.clearTimeout(timeOut);
            }, this.timeout);
        }
    }
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.snackbar
    position absolute 
    width 20em
    height 4rem
    background-color dark-grey
    display flex
    bottom 30px
    left 100px
    border-radius radius-mini radius-mini
    transition opacity 150ms ease-in
    transform translate3d(0em, 0em, 0em)

.snackbar-enter, .snackbar-leave-to
    opacity 0
    transform translate3d(-1em, 0em, 0em)

.snackbar-leave, .snackbar-enter-to
    opacity 1
    transform translate3d(0em, 0em, 0em)

.snackbar-enter-active, .snackbar-leave-active
    transition opacity 150ms ease-in, transform 150ms ease-in

</style>
