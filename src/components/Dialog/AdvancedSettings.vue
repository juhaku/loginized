<template>
    <Dialog title="Advanced Settings"
        :width="30"
        :active="true"
        :onCloseClick="onCloseDialog">
        <div class="advanced-dialog">
            <FluidGrid class="theme-selection" justify="end">
                <FluidGridColumn width="100">
                    <FluidGrid>
                        <FluidGridColumn width="50">
                                <h3>User list enabled
                                    <Info text="Enables or disables user selection in login. If user list is disabled then user need to be typed to username field at login." />
                                </h3>
                        </FluidGridColumn>
                        <FluidGridColumn width="50">
                            <FluidGrid justify="end">
                                <h3><Toggle v-model="data.userListEnabled" @input="(selected) => data.changeUserListEnabled(selected)" /></h3>
                            </FluidGrid>
                        </FluidGridColumn>
                    </FluidGrid>
                </FluidGridColumn>
                <FluidGridColumn width="100">
                    <FluidGrid>
                        <FluidGridColumn width="50">
                                <h3>Rounded login icon</h3>
                        </FluidGridColumn>
                        <FluidGridColumn width="50">
                            <FluidGrid justify="end">
                                <h3><Toggle :disabled="!data.userListEnabled" v-model="data.forceRoundedLoginIcon" @input="(selected) => data.changeForceLoginIcon(selected)" /></h3>
                            </FluidGrid>
                        </FluidGridColumn>
                    </FluidGrid>
                </FluidGridColumn>
            </FluidGrid>
        </div>
    </Dialog>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import Dialog from './Dialog.vue';
import FluidGrid from '../Grid/FluidGrid.vue';
import FluidGridColumn from '../Grid/FluidGridColumn.vue';
import Toggle from '../Toggle/Toggle.vue';
import Info from '../Info.vue';

@Component({
    components: {
        Dialog,
        FluidGrid,
        FluidGridColumn,
        Toggle,
        Info,
    },
})
export default class AdvancedSettings extends Vue {
    @Prop() private data!: any | undefined;
    @Prop() private onCloseDialog!: () => void;
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.advanced-dialog
    align-content space-between
    height 100%
    .select-padding
        padding-top 1rem

    .image-left-padding
        margin-left 0.4rem

    .image-right-padding
        margin-right 0.4rem
    
    .hint-text
        padding 0
        margin 0
        color smoke
        font-weight 400
        font-size 11pt
</style>
