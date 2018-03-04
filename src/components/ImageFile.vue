<template>
    <div class="pointer">
        <input type="file" style="display: none;" @change="update($event)" ref="imageFile" />
        <v-card @click.native="browseImage($event)">
            <v-card-media :src="img" height="200px">
            </v-card-media>
        </v-card>
    </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';

@Component
export default class ImageFile extends Vue {

    @Prop() private image: string;

    private img: string = '';

    private created() {
        this.img = this.image;
    }

    private browseImage($event: any) {
        this.$refs.imageFile.click();
    }

    private update(event: any) {
        if (event.target.files.length > 0) {
            this.img = URL.createObjectURL(event.target.files[0]);
        } else {
            this.img = '';
        }

        this.$emit('img-change', this.img);
    }

}
</script>

<style lang="stylus" scoped>
.pointer
 cursor pointer
</style>
