<template>
    <Dialog title="About"
        :active="true"
        :onCloseClick="onCloseDialog">
        <div class="about-dialog">
            <div class="icon-holder">
                <img class="icon" src="../../assets/logo_ld_4.png"/>
                <h2>Loginized</h2>
            </div>
            <p>
                &copy; 2019 Juha Kukkonen
            </p>
            <p>
                v {{version}}
            </p>
            <p>
                <a href="https://github.com/juhaku/loginized"
                    @click.prevent="openLink($event.currentTarget.href)">
                        https://github.com/juhaku/loginized</a>
            </p>
            <p>
                Licensed under: <a @click.prevent="openLink($event.currentTarget.href)"
                        href="https://www.gnu.org/licenses/gpl-3.0.txt">GPL-3.0</a> 
            </p>
            <p>
                This program is provided AS IS and comes with<br> ABSOLUTELY NO WARRANTY
            </p>
        </div>
    </Dialog>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import Dialog from '@/components/Dialog/Dialog.vue';
import Constants from '@/constants';
import opn from 'opn';

@Component({
    components: {
        Dialog,
    },
})
export default class AboutDialog extends Vue {

    @Prop() private onCloseDialog!: () => void;

    private readonly version = Constants.VERSION;

    private openLink(link: string) {
        opn(link);
    }
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.about-dialog
    display flex
    align-items center
    flex-direction column
    text-align center

    .icon-holder
        display flex

        .icon
            display flex
            width 40px
            height 40px
            margin 0.5rem

</style>
