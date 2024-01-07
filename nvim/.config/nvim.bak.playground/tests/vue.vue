<script setup lang="ts">
const Button = defineComponent({
  name: "Button",
  setup() {
    return () => <button class="button"></button>;
  },
});
</script>

<template>
  <div>
    <Button
      id="button"
      class="button"
      @click="(e) => void"
      toto="tata"
      tata="tutu"
      riri="raa"
      rtou="asdf"
      asdfasd="asdfasdfasdfsa"
    >
    </Button>
  </div>
</template>
