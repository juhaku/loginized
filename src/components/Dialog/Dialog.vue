<template>
    <transition name="dialog">
        <div :class="['dialog',
            active ? 'dialog--active': '']">
            <div :class="['dialog__overlay',
                active ? 'dialog__overlay--active': '']"
                @click="outsideClickHide">
                <div :class="['dialog__overlay__content',
                    width ? `dialog__overlay__content--width-${width}`: '',
                    height ? `dialog__overlay__content--height-${height}`: '',]">
                    <div class="dialog__overlay__title">
                        <h2 class="dialog__overlay__title__text">{{title}}</h2>
                        <h2 class="dialog__overlay__title__close" @click="onCloseClick()">&times;</h2>
                    </div>
                    <div class="dialog__overlay__content__body">
                        <slot></slot>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import { findParent } from '@/components/utils';

@Component
export default class Dialog extends Vue {
    @Prop() private title!: string;
    @Prop() private active!: boolean;
    @Prop() private onCloseClick!: () => void;
    @Prop({default: '40'}) private width!: string;
    @Prop({default: '5'}) private height!: string;

    private outsideClickHide(e: Event) {
        // When dialog content is not found from click content, close dialog
        if (!findParent('dialog__overlay__content', e.target as HTMLElement)) {
            this.onCloseClick();
        }
    }
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.dialog
    display none
    position fixed
    z-index 7
    width 100%
    height 100%

    &--active
        display block

    &__overlay
        background-color transparent
        transition background 150ms ease-in
        display flex
        justify-content center
        align-items center
        width 100%
        height 100%
    
        &--active
            background-color rgba(50, 50, 50, 0.5)
            animation fadeoverlay 150ms

        &__title
            display flex
            justify-content space-between

            &__text
                margin-left 1em

            &__close
                margin-right 1em
                cursor pointer

        &__content
            border-radius 0.2em 0.2em
            background-color cool-white
            width 40%

            &__body
                margin 0.5em 1.5em 1.5em 1.5em

            for i in 1..100
                &--width-{i}
                    width (i)em

            for i in 1..100
                &--height-{i}
                    min-height (i)em

            @media screen and (max-width 700px)
                width 100%
                height 100%
                overflow auto

.dialog-enter-active
        animation fadeoverlay 150ms
    
.dialog-leave-active
    animation fadeoverlay 150ms reverse

@keyframes fadeoverlay 
    0%
        transform translate3d()
        opacity 0
    
    100%
        transform translate3d()
        opacity 1

</style>
