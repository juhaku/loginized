<template>
    <div :class="[
        'toggle',
        checked && 'toggle--checked',
        disabled && 'toggle--disabled'
        ]" @click="onToggleChange">
        <div :class="[
            'toggle-indicator',
            checked && 'toggle-indicator--checked',
            disabled && 'toggle-indicator--disabled'
            ]"></div>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';

@Component
export default class Toggle extends Vue {
    @Prop() private value!: boolean;
    @Prop() private disabled!: boolean;

    private checked = false;

    private created() {
        this.$watch('value', (newValue, oldValue) => {
            this.checked = this.value || false;
        }, { immediate: true });
    }

    private onToggleChange() {
        if (!this.disabled) {
            this.checked = !this.checked;
            this.$emit('input', this.checked);
        }
    }
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.toggle
    position relative
    display flex
    width 2.5rem
    height 1rem
    background-color cool-white
    border-radius radius-mini radius-mini
    border default-border-width solid smoke
    transition border-color 150ms ease-in, background-color 150ms ease-in
    align-items center
    
    &:not(&--disabled):hover
        cursor pointer

    &--disabled
        border default-border-width solid smoke
        background-color darker-white

    &--checked:not(&--disabled)
        border-color main-color
        background-color tertiary

    .toggle-indicator
        width 1rem
        height 1rem
        background-color cool-white
        border-radius radius-mini radius-mini
        border default-border-width solid smoke
        transition border-color 150ms ease-in, background-color 150ms ease-in, transform 150ms ease-in
        transform scale(1.2)

        &--disabled
            border default-border-width solid smoke
            background-color darker-white

        &--checked:not(.toggle-indicator--disabled)
            border-color main-color
            background-color main-color
        
        &--checked
            transform translate3d(110%, 0em, 0rem) scale(1.2)
</style>
