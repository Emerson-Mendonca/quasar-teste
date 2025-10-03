<template>
  <q-page class="q-pa-md">
    <div class="row q-gutter-md justify-center">
      <!-- Container Q-Select com emails pré-preenchidos -->
      <div class="col-12 col-md-5">
        <EmailManager 
          title="Envio de Emails de relatórios"
          description="Você pode adicionar novos emails ou remover os existentes. O botão 'Salvar' só é habilitado quando há alterações."
          input-label="Emails - Digite e pressione Enter"
          api-endpoint="http://143.244.174.27:2023/sendEmail"
          id-instalacao="d03"
        />
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import EmailManager from 'components/EmailManager.vue'
</script>
