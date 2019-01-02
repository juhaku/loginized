<template>
    <div :class="[
        'fluid-grid-column',
        column && `fluid-grid-column--${column}`,
        width && `fluid-grid-column--w-${width}`]">
        <slot></slot>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class FluidGridColumn extends Vue {
    @Prop() private column!: string;
    @Prop() private width!: string;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

cols=12
colWidth=100 / cols
widths=100 / 5

.fluid-grid-column
    for i in (1..cols)
        &--{i}
            width (i * colWidth)%

            // @media screen and (max-width 768px)
            //     width 100%
            
            // @media screen and (min-width 750px)
            //     width 50%
            
            // @media screen and (min-width 1300px)
            //     width (i * colWidth)%
    
    for i in (1..widths)
        &--w-{(i * 5)}
            width (i * 5)%
</style>
