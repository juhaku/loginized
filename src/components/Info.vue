<template>
    <Tooltip
        class="info"
        maxWidth="20"
        :text="text">
        <div slot="opener">
            <Icon size="small" icon="help" />
        </div>
    </Tooltip>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';
import Tooltip from '@/components/Tooltip/Tooltip.vue';
import Icon from '@/components/Icon/Icon.vue';

@Component({
    components: {
        Tooltip,
        Icon,
    },
})
export default class Info extends Vue {
    @Prop() private text!: string;
}
</script>

<style lang="stylus" scoped>
@import '../stylus/variables.styl'

.info
    display inline-block
    position absolute
    margin-top -6px
    margin-left 6px
</style>
