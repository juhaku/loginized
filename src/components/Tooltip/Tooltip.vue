<template>
    <div class="tooltip" @mouseover="visible = true" @mouseout="visible = false">
        <div>
            <slot name="opener"></slot>
        </div>
        <div :class="[
            'tooltip__content',
            left && 'tooltip__content--left',
            ]">
            <transition name="tooltip">
                <div :class="[
                    'tooltip', 
                    'content', 
                    maxWidth && `content--mw-${maxWidth}`
                    ]" v-if="visible">
                    <div>{{text}}</div>
                </div>
            </transition>
        </div>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class Tooltip extends Vue {
    @Prop() private text!: string;
    @Prop() private maxWidth!: string;
    @Prop() private left!: boolean;

    private visible = false;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

widths=100 / 5

.tooltip
    position relative
    display inline-block

    &__content
        position absolute
        z-index 5
        transform translateX(-50%)
        left 50%

        &--left
            left 100%
            transform translateY(-66%)
            top 50%

        @media screen and (max-width 768px)
            transform translateX(0%)
            left unset

    &.content
        position relative
        padding 0.2em 0.6em 0.2em 0.6em
        border-radius radius-mini radius-mini
        background-color transparentify(dark-grey, 0.9)
        margin-top 1rem
        display block
        color cool-white
        font-size 12pt
        font-weight 400
        white-space nowrap

        for i in (1..widths)
            &--mw-{(i * 5)}
                width (i * 5)em
                white-space pre-wrap

.tooltip-enter, .tooltip-leave-to
    opacity 0
    transform translate3d(0rem, -1rem, 0rem)

.tooltip-enter-to, .tooltip-leave
    opacity 1
    transform translate3d(0rem, 0rem, 0rem)

.tooltip-enter-active, .tooltip-leave-active
    transition transform 150ms ease-in, opacity 150ms ease-in
    transition-delay 100ms

</style>
