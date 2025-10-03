<template>
  <q-item clickable :tag="isExternalLink ? 'a' : 'router-link'" :target="isExternalLink ? '_blank' : undefined"
    :href="isExternalLink ? link : undefined" :to="isExternalLink ? undefined : link">
    <q-item-section v-if="icon" avatar>
      <q-icon :name="icon" />
    </q-item-section>

    <q-item-section>
      <q-item-label>{{ title }}</q-item-label>
      <q-item-label caption>{{ caption }}</q-item-label>
    </q-item-section>
  </q-item>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue';

export interface EssentialLinkProps {
  title: string;
  caption?: string;
  link?: string;
  icon?: string;
}

export default defineComponent({
  name: 'EssentialLink',
  props: {
    title: {
      type: String,
      required: true,
    },
    caption: {
      type: String,
      default: '',
    },
    link: {
      type: String,
      default: '#',
    },
    icon: {
      type: String,
      default: '',
    },
  },
  setup(props) {
    const isExternalLink = computed(() => {
      return props.link?.startsWith('http') || props.link?.startsWith('//') || props.link === '#';
    });

    return {
      isExternalLink,
    };
  },
});
</script>
