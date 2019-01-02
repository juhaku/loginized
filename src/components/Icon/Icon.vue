<template>
    <svg :class="['icon',
        hoverable && !inverted && !main ? 'icon--hoverable': '',
        inverted ? 'icon--inverted': '',
        inverted && hoverable ? 'icon--inverted--hoverable': '',
        main ? 'icon--main': '',
        main && hoverable ? 'icon--main--hoverable': '',
        size ? `icon--${size}`: '',]">
        <use :xlink:href="`#${icon}`" :href="`#${icon}`"></use>
    </svg>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class Icon extends Vue {
    @Prop() private icon!: string;
    @Prop({default: false}) private inverted!: boolean;
    @Prop({default: 'small'}) private size!: string;
    @Prop({default: false}) private main!: boolean;
    @Prop({default: false}) private hoverable!: boolean;

    private widthHeight = '';
    private iconFile = '';

    private created() {
        ['small', 'normal', 'large', 'huge'].forEach((size, index) => {
            if (size === this.size) {
                this.widthHeight = `${24 + (index * 3)}`;
            }
        });
    }
}
</script>

<style lang="stylus">
@import '../../stylus/variables.styl'

defSize=24

.icon
    fill midnight-black
    transition fill 150ms ease-in
    margin 0.2em 0em 0em 0em

    &--hoverable
        &:hover
            fill early-black

    &--main
        fill main-color

        &--hoverable
            &:hover
                fill secondary

    &--inverted
        fill darker-white

        &--hoverable
            &:hover
                fill cool-white
    
    for w, i in small normal large huge
        &--{w}
            width defSize+(i*3)px
            height defSize+(i*3)px

</style>
