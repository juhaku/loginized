<template>
    <button :class="['button',
        `button--${size}`,
        (filled && !danger && !neutral) ? 'button--filled': '',
        inverted ? 'button--inverted': '',
        neutral ? 'button--neutral': '',
        (neutral && filled) ? 'button--neutral--filled': '',
        (inverted && link) ? 'button--link--inverted': '',
        (black && link) ? 'button--link--black': '',
        link ? 'button--link': '',
        loading ? 'button--loading': '',
        fluid ? 'button--fluid': '',
        colored ? 'button--colored': '',
        danger ? 'button--danger': '',
        (danger && filled) ? 'button--danger--filled': '',]"
        :disabled="loading || disabled" :type="type ? type : 'button'">
        <template v-if="loading">
            {{$i18n('loading.placeholder')}}
        </template>
        <template v-else>
            <template v-if="icon">
                <Icon :class="['button__icon',
                    colored ? 'button__icon--colored': '',
                    (loading || disabled) ? 'button__icon--disabled': '',]" 
                    :icon="icon" 
                    :inverted="inverted" 
                    :size="size" />
            </template>
            <slot>{{text}}</slot>
        </template>
    </button>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import Icon from '@/components/Icon/Icon.vue';

@Component({
    components: { Icon },
})
export default class Button extends Vue {
    @Prop() private loading!: boolean;
    @Prop() private text!: string;
    @Prop({default: false}) private filled!: boolean;
    @Prop({default: false}) private neutral!: boolean;
    @Prop({default: false}) private inverted!: boolean;
    @Prop({default: false}) private link!: boolean;
    @Prop({default: false}) private black!: boolean;
    @Prop({default: 'small'}) private size!: string;
    @Prop() private icon!: string;
    @Prop({default: false}) private colored!: boolean;
    @Prop() private type!: string;
    @Prop({default: false}) private fluid!: boolean;
    @Prop({default: false}) private danger!: boolean;
    @Prop() private disabled!: boolean;
}
</script>

<style lang="stylus">
@import '../../stylus/variables.styl'

.button
    padding 0.5em 1em 0.5em 1em
    background transparent
    font-size 8pt
    border default-border-width solid main-color
    border-radius 50px 50px
    font-weight 400
    transition border-color 150ms ease-in, background-color 150ms ease-in, color 150ms ease-in, fill 150ms ease-in
    cursor pointer

    &:not(.button--inverted):not(.button--colored):not(.button--filled--inverted):hover > svg
        fill early-black

    &--fluid
        width 100%

    &--loading, &:disabled
        cursor auto
        border-color smoke
        color smoke
        background-color darker-white
        > svg
            fill smoke

    &--colored
        background @background

    &__icon
        margin 0em;
        margin-bottom: -0.2em;
        padding 0em;

        &:not(.button--inverted)&--colored
            fill main-color
        
        &--disabled
            pointer-events none

    for w, i in small normal large huge
        &--{w}
            font-size (i*2)+8pt

    &:not(&--loading):not(:disabled):hover
        border-color secondary
    
    &:not(&--loading):not(:disabled):active
        border-color tertiary

    &--inverted
        color darker-white

        &:not(.button--loading):not(:disabled):hover
            color cool-white

            > svg
                fill cool-white

    &:not(&--neutral):not(&--danger)&--filled
        background-color main-color
        
        &:not(.button--loading):not(:disabled):hover
            background-color secondary

        &:not(.button--loading):not(:disabled):active
            background-color tertiary

    &--link
        border-width 0px
        color main-color

        &:hover
            color secondary

        &--black
            color midnight-black

            &:hover
                color early-black

        &--inverted
            color darker-white

            &:hover
                color cool-white
    
    &--neutral
        border default-border-width solid mid-grey

        &:not(.button--loading):not(:disabled):hover
            border-color smoke
        
        &:not(.button--loading):not(:disabled):active
            border-color dark-white

        &--filled
            background-color mid-grey
        
            &:not(.button--loading):not(:disabled):hover
                background-color smoke

            &:not(.button--loading):not(:disabled):active
                background-color dark-white

    &--danger
        border default-border-width solid error

        &:not(.button--loading):not(:disabled):hover
            border-color lighten(error, 20%)
        
        &:not(.button--loading):not(:disabled):active
            border-color lighten(error, 40%)

        &--filled
            background-color error
            // color cool-white
        
            &:not(.button--loading):not(:disabled):hover
                background-color lighten(error, 20%)

            &:not(.button--loading):not(:disabled):active
                background-color lighten(error, 40%)

</style>

