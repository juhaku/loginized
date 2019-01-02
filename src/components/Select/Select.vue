<template>
    <div :id="id" class="select">
        <div
            @click="toggleOpenClose"
            :class="[
            'input',
            opened && 'input--opened'
            ]">
            <div :class="['suggestion', 
                selected !== '' && 'suggestion--selected']" v-if="selected === ''">
                {{selected !== '' ? selected : 'Select value'}}
            </div>
            <input 
                type="text" 
                size="2"
                class="text-input"
                ref="textInput" 
                @keyup="onKeyUp"
                @keydown="onKeyDown"
                v-model="selected" />
            <Icon :class="[
                'icon',
                opened && 'icon--opened'
            ]"
            icon="arrow-dropdown-up"
            :hoverable="true" />
        </div>
        <div class="select-list" tabindex="-1">
            <transition name="select-selections">
                <div 
                    :class="[
                        'select-selections',
                        opened && 'select-selections--opened'
                    ]" v-if="opened" ref="selectionsList">
                    <div v-for="(selection, index) in filteredItems" :key="selection"
                        @click="selectItem(index)"
                        @mouseenter="hoverItem(index)"
                        :class="[
                            'select-selections__selection',
                            cursor === index && 'select-selections__selection--hovered']">
                        {{selection}}
                    </div>
                    <div class="select-selections__selection" v-if="filteredItems.length === 0">
                        No Results
                    </div>
                </div>
            </transition>
        </div>
    </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator';
import { findParent } from '@/components/utils';
import Icon from '@/components/Icon/Icon.vue';

@Component({
    components: { Icon },
})
export default class Select extends Vue {
    @Prop() private id!: string;
    @Prop() private value!: string;
    @Prop() private selections!: string[];

    private selected = '';
    private opened = false;
    private cursor = -1;
    private filteredItems: string[] = [];

    private created() {
        this.filteredItems = [...this.selections];
        this.$watch('value', (next, old) => {
            if (next) {
                this.selected = next;
            }
        }, { immediate: true });

        this.$watch('selected', (next, old) => {
            if (next !== '') {
                this.filteredItems = [...this.selections
                    .filter((value: string) => value.toLocaleLowerCase().includes(next.toLocaleLowerCase()))];
            } else {
                this.filteredItems = [...this.selections];
            }
        });

        window.addEventListener('click', (e) => {
            if (this.opened === true && !findParent(this.id, e.target as HTMLElement)) {
                this.close();
            }
        });
    }

    private open() {
        this.opened = true;
        this.focusInputContent();
    }

    private close() {
        this.opened = false;
        const input = (this.$refs.textInput as HTMLInputElement);
        if (input) {
            input.blur();
        }
    }

    private toggleOpenClose() {
        this.opened = !this.opened;
        if (this.opened) {
            this.focusInputContent();
        }
    }

    private focusInputContent() {
        const input = (this.$refs.textInput as HTMLInputElement);
        input.focus();
        input.setSelectionRange(0, this.selected.length);
        this.filteredItems = [...this.selections];
    }

    private selectItem(index: number) {
        this.selected = this.filteredItems
            .find((value, selectionIndex) => selectionIndex === index) || '';
        this.close();
        this.cursor = -1;
    }

    private onKeyUp(event: KeyboardEvent) {
        switch (event.which) {
            case 27: // Escape
                this.close();
                break;
            case 13: // Enter
                this.selectItem(this.cursor);
                break;
            case 38: // Up
                if (this.cursor > -1) {
                    this.cursor--;
                } else {
                    // Set cursor to last element
                    this.cursor = this.selections.length - 1;
                }
                this.scrollToCursor();
                break;
            case 40: // Down
                if (this.cursor < this.selections.length - 1) {
                    this.cursor++;
                } else {
                    // Reset cursor
                    this.cursor = -1;
                }
                this.scrollToCursor();
                break;
            default:
                break;
        }
    }

    private onKeyDown(event: KeyboardEvent) {
        switch (event.which) {
            case 38: // Up
            case 40: // Down
                event.preventDefault();
                break;
            default:
                break;
        }
    }

    private scrollToCursor() {
        const list = (this.$refs.selectionsList as HTMLDivElement);
        const item = list.children[this.cursor] as HTMLElement;

        if (this.cursor > -1 && this.opened && item) {
            list.scrollTo(0, item.offsetTop);
        } else {
            list.scrollTo(0, 0);
        }
    }

    private hoverItem(index: number) {
        this.cursor = index;
    }
}
</script>

<style lang="stylus" scoped>
@import '../../stylus/variables.styl'

.select
    z-index 3
    position relative
    width 100%

    .input
        display flex
        width 99.5%
        // height 1rem
        background-color cool-white
        border-radius radius-mini radius-mini
        border default-border-width solid smoke
        transition border-color 150ms ease-in, background-color 150ms ease-in
        align-items center

        &:hover
            cursor pointer

        &--opened
            border-color main-color
        
        .icon
            transform rotate(180deg)
            transition transform 150ms ease-in
            &--opened
                transform rotate(0deg)
    
    .text-input
        width 100%
        padding 0.5rem 0.5rem 0.5rem 0.5rem
        background-color transparent
        border 0em solid #000
        font-size 12pt

    .suggestion
        position absolute
        color smoke
        padding 0.5rem 0.5rem 0.5rem 0.5rem

        &:hover
            cursor text

        &--selected
            color #000

    .select-list
        position relative
    
    .select-selections
        z-index 5
        max-height 10rem
        overflow-y auto
        overflow-x hidden
        background-color cool-white
        // border-radius radius-mini radius-mini
        border default-border-width solid smoke
        margin-top default-border-width
        display none
        position absolute
        width 99.5%

        &--opened
            display block
            z-index 5
            border-color main-color

        &__selection
            padding 0.5rem 0.5rem 0.5rem 0.5rem
            
            &:hover, &--hovered
                cursor pointer
                background-color darker-white

.select-selections-enter, .select-selections-leave-to
    opacity 0
    max-height 0em
    transform translate3d(0em, -1em, 0em)

.select-selections-leave, .select-selections-enter-to
    opacity 1
    transform translate3d(0em, 0em, 0em)
    // max-height 8em

.select-selections-enter-active, .select-selections-leave-active
    transition opacity 150ms ease-in, transform 150ms ease-in, max-height 150ms ease-in

</style>

