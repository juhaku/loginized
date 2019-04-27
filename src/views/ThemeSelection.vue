<template>
    <FluidGrid class="theme-selection" justify="end">
        <FluidGridColumn width="100">
            <FluidGrid>
                <FluidGridColumn width="50">
                    <h3>Theme</h3>
                </FluidGridColumn>
                <FluidGridColumn width="50">
                    <Select
                        class="select-padding" 
                        id="select-theme"
                        v-model="selectedTheme"
                        :selections="themes" />
                </FluidGridColumn>
            </FluidGrid>
            <FluidGrid>
                <FluidGridColumn width="50">
                    <h3>Shield</h3>
                    <ImageFile class="image-right-padding"
                        v-model="selectedShield" :configLocation="configLocation && configLocation" />
                </FluidGridColumn>
                <FluidGridColumn width="50">
                    <h3>Background image</h3>
                    <ImageFile class="image-left-padding"
                        v-model="selectedBackground" :configLocation="configLocation && configLocation" />
                </FluidGridColumn>
            </FluidGrid>
            <FluidGrid>
                <FluidGridColumn width="50">
                    <h3>
                        Advanced<br>
                        <span class="hint-text">Change advanced settings for login screen</span>
                    </h3>
                </FluidGridColumn>
                <FluidGridColumn width="50">
                     <FluidGrid justify="end">
                        <h3>
                            <Button
                                @click.native="openDialog({
                                    dialog: 'advanced_settings',
                                    data: {
                                        userListEnabled,
                                        changeUserListEnabled,
                                        forceRoundedLoginIcon,
                                        changeForceLoginIcon,
                                    }
                                })"
                                text="Advanced"
                                :neutral="true"
                                size="normal" />
                        </h3>
                     </FluidGrid>
                </FluidGridColumn>
            </FluidGrid>
        </FluidGridColumn>
        <FluidGridColumn width="100">
            <FluidGrid justify="end">
                <FluidGridColumn>
                    <Button
                        :disabled="!selectedTheme || selectedTheme === ''"
                        @click.native="save"
                        text="Save"
                        size="large" />
                </FluidGridColumn>
            </FluidGrid>
        </FluidGridColumn>
    </FluidGrid>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import FluidGrid from '@/components/Grid/FluidGrid.vue';
import FluidGridColumn from '@/components/Grid/FluidGridColumn.vue';
import Button from '@/components/Button/Button.vue';
import Info from '@/components/Info.vue';
import Toggle from '@/components/Toggle/Toggle.vue';
import Select from '@/components/Select/Select.vue';
import ImageFile from '@/components/ImageFile.vue';
import Icon from '@/components/Icon/Icon.vue';
import { State, Action, Mutation } from 'vuex-class';
import { FileEntry } from '@/FileEntry';
import { AppState } from '@/store/store';
import { ThemeConfig } from '@/ThemeConfig';
import { ActionKeys } from '@/store/action-keys';

@Component({
  components: {
    FluidGrid,
    FluidGridColumn,
    Button,
    Info,
    Toggle,
    Select,
    ImageFile,
    Icon,
  },
})
export default class ThemeSelection extends Vue {

    @State((state: AppState) => state.persisted.theme)
    private theme!: string;

    @State((state: AppState) => state.persisted.userlistEnabled)
    private userlistEnabled!: boolean;

    @State((state: AppState) => state.persisted.shield)
    private shield!: string;

    @State((state: AppState) => state.persisted.background)
    private background!: string;

    @State((state: AppState) => state.persisted.forceRoundedLoginIcon)
    private forceRoundedLogin!: boolean;

    @State('configLocation') private configLocation!: string;
    @State('themes') private themes!: string[];

    @Mutation(ActionKeys.OPEN_DIALOG)
    private openDialog!: (dialog: string | { dialog: string, data: any }) => void;

    @Mutation(ActionKeys.SET_THEME_CONFIG)
    private setThemeConfig!: (config: ThemeConfig) => void;

    private selectedTheme = '';
    private userListEnabled = false;
    private selectedShield = '';
    private selectedBackground = '';
    private forceRoundedLoginIcon = false;

    private created() {
        this.$watch('userlistEnabled',
            (newValue, oldValue) => (this.userListEnabled = newValue), { immediate: true });
        this.$watch('shield',
            (newValue, oldValue) => (this.selectedShield = newValue), { immediate: true });
        this.$watch('background',
            (newValue, oldValue) => (this.selectedBackground = newValue), { immediate: true });
        this.$watch('forceRoundedLogin',
            (newValue, oldValue) => (this.forceRoundedLoginIcon = newValue), { immediate: true });
        this.$watch('theme',
            (newValue, oldValue) => {
            this.selectedTheme = newValue;
            // If by default there is no theme selected select system default initially
            if (this.selectedTheme === '' || this.selectedTheme === undefined) {
                this.selectedTheme = 'Default';
            }
        }, { immediate: true });
    }

    private getFileName(file: string): string {
        return file.substring(file.lastIndexOf('/') + 1);
    }

    private changeUserListEnabled(selected: boolean) {
        this.userListEnabled = selected;
    }

    private changeForceLoginIcon(loginIconSelected: boolean) {
        this.forceRoundedLoginIcon = loginIconSelected;
    }

    private save() {
        const themeArgs = `${this.selectedTheme},${this.getFileName(this.selectedBackground)}`;
        const shieldImage = this.selectedShield !== '' ?
            `${this.configLocation}/${this.getFileName(this.selectedShield)}` : '';

        this.$cliExec(`--gui save ${themeArgs},${shieldImage},${this.userListEnabled},${this.forceRoundedLoginIcon}`)
            .then((stdout: any) => {
            this.setThemeConfig({
                theme: this.selectedTheme,
                background: this.selectedBackground,
                shield: this.selectedShield,
                userlistEnabled: this.userlistEnabled,
                forceRoundedLoginIcon: this.forceRoundedLoginIcon,
            });

            this.openDialog('reboot');
        });
    }
}
</script>

<style lang="stylus" scoped>
@import '../stylus/variables.styl'

.theme-selection
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
