<template>
    <div :class="['grid-column', 
        grow ? `grid-column--grow-${grow}`: '', 
        width ? `grid-column--${width}`: '',
        max ? `grid-column--max-${max}`: '',
        min ? `grid-column--min-${min}`: '',
        basis ? `grid-column--basis-${basis}`: '',
        gutter ? `grid-column--gutter-${gutter}`: '',
        stackable ? `grid-column--stackable`: '',
        end ? `grid-column--end`: '',
        centered ? `grid-column--centered`: '',
        columns ? `grid-column--columns-${columns}`: '',
        (width && responsive) ? `grid-column--${width}--responsive`: '']">
        <slot></slot>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class GridColumn extends Vue {
    @Prop() private grow!: string;
    @Prop() private width!: string;
    @Prop() private max!: string;
    @Prop() private min!: string;
    @Prop() private basis!: string;
    @Prop() private gutter!: string;
    @Prop({default: false}) private stackable!: boolean;
    @Prop({default: false}) private centered!: boolean;
    @Prop({default: false}) private end!: boolean;
    @Prop() private columns!: string;
    @Prop({default: false}) private responsive!: boolean;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl';

.grid-column
    // border 1px solid #000000
    // width 100%

    for i in 0..9
        &--grow-{i}
            flex-grow i
    
    for i in 1..100
        &--{i}
            width (i)%

            &--responsive
                @media screen and (min-width 50px)
                    width 95%

                @media screen and (min-width 500px)
                    width 90%

                @media screen and (min-width 768px)
                    width 80%

                @media screen and (min-width 1000px)
                    width 70%

                @media screen and (min-width 1300px)
                    width (i)%

    for i in 1..100
        &--min-{i}
            min-width (i)%

    for i in 1..100
        &--max-{i}
            max-width (i)%
    
    for i in 1..10
        &--basis-{i}
            flex-basis (i*10)%

    for i in 1 2 3
        &--gutter-{i}
            margin (i*gutter)em
            @media screen and (min-width 50px)
                margin 0.5em

            @media screen and (min-width 500px)
                margin 1em

            @media screen and (min-width 768px)
                margin (i*gutter)em

    &--columns-3
        @media screen and (min-width 200px)
            width 100%

        @media screen and (min-width 500px)
            width 47%
        
        @media screen and (min-width 1100px)
            width 31%

    &--columns-4
        @media screen and (min-width 200px)
            width 100%

        @media screen and (min-width 500px)
            width 47%
        
        @media screen and (min-width 1100px)
            width 31%

        @media screen and (min-width 1790px)
            width 22%

    &--columns-5
        @media screen and (min-width 200px)
            width 100%

        @media screen and (min-width 500px)
            width 47%

        @media screen and (min-width 800px)
            width 31%

        @media screen and (min-width 1200px)
            width 22%

        @media screen and (min-width 1790px)
            width 17%

    &--columns-2
        @media screen and (max-width 1100px)
            width 100%

    &--stackable
        @media screen and (max-width 768px)
            width 100%

    &--centered
        align-self center

    &--end
        align-self flex-end

</style>


