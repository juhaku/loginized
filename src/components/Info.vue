<template>
  <v-menu open-on-hover right offset-x>
      <v-icon slot="activator">info_outline</v-icon>
      <v-card width="300">
          <v-card-text>
            {{text}}
          </v-card-text>
      </v-card>
    </v-menu>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator';

@Component
export default class Info extends Vue {
    @Prop() private text!: string;
}
</script>
