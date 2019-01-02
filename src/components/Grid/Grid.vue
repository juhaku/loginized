<template>
    <div :class="['grid',
        `grid--${justify}`,
        width ? `grid--${width}`: '',
        stackable ? 'grid--stackable': '',
        wrap ? 'grid--wrap': '',
        raised ? `grid--raised--${raised}` : '',
        segment ? `grid--segment-${segment}` : '',]">
        <slot></slot>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class Grid extends Vue {
    @Prop() private width!: string;
    @Prop({default: 'start'}) private justify!: string;
    @Prop({default: false}) private stackable!: boolean;
    @Prop() private wrap!: boolean;
    @Prop() private raised!: string;
    @Prop() private segment!: string;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.grid
    display flex
    flex-wrap nowrap
    align-items stretch

    &--center
        justify-content center

    &--start
        justify-content flex-start

    &--end
        justify-content flex-end

    &--between
        justify-content space-between

    &--around
        justify-content space-around

    &--reverse
        flex-wrap wrap-reverse

    &--wrap
        flex-wrap wrap

    &--100
        width 100%
    
    &--90
        width 90%
    
    &--80
        width 80%
    
    &--stackable
        @media screen and (max-width: 768px)
            flex-wrap wrap

    for w, i in light dark
        &--raised--{w}
            if w == light
                background linear-gradient(darker-white, dark-white)
            else 
                background linear-gradient(mid-grey, dark-grey)
            border-top default-border-width solid smoke
            border-bottom default-border-width solid smoke
    
    for segment in neutral danger 
        &--segment-{segment}
            if segment == neutral
                background-color darker-white
                border default-border-width smoke solid
            else
                background-color lighten(error, 70%)
                border default-border-width lighten(error, 50%) solid
            border-radius radius-mini radius-mini
</style>
