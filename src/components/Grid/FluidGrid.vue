<template>
    <div :class="[
        'fluid-grid',
        justify && `fluid-grid--justify-${justify}`,
        direction && `fluid-grid--direction-${direction}`,
        noWrap && 'fluid-grid--no-wrap',
        ]">
        <slot></slot>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class FluidGrid extends Vue {
    @Prop() private justify!: string;
    @Prop() private direction!: string;
    @Prop() private noWrap!: string;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

cols=12
colWidth=100/12

.fluid-grid
    display flex
    flex-wrap wrap
    width 100%

    &--no-wrap
        flex-wrap nowrap

    &--justify-end
        justify-content flex-end

    &--justify-center
        justify-content center

    &--justify-start
        justify-content flex-start

    &--justify-between
        justify-content space-between

    &--justify-around
        justify-content space-around

    &--direction-column
        flex-direction column
    
    &--direction-row
        flex-direction row

</style>
