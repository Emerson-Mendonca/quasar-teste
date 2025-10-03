<template>
  <q-page class="q-pa-md">
    <div class="row q-gutter-md justify-center">
      <!-- Container Q-Select com emails pré-preenchidos -->
      <div class="col-12 col-md-5">
        <q-card class="q-pa-md">
          <q-card-section>
            <div class="text-h6 q-mb-sm">Envio de Emails de relatórios</div>
            <div class="text-subtitle2 text-grey-7 q-mb-md">
              Você pode adicionar novos emails ou
              remover os existentes. O botão "Salvar" só é habilitado quando há alterações.
            </div>

            <!-- Skeleton durante carregamento -->
            <div v-if="isLoading" class="q-mb-md">
              <q-skeleton type="rect" height="56px" class="q-mb-sm" />
              <div class="row q-gutter-sm">
                <q-skeleton type="rect" width="120px" height="32px" />
                <q-skeleton type="rect" width="140px" height="32px" />
                <q-skeleton type="rect" width="100px" height="32px" />
              </div>
            </div>

            <!-- Q-Select após carregamento -->
            <q-select v-else v-model="emails" use-input multiple hide-dropdown-icon input-debounce="0"
              new-value-mode="add-unique" label="Emails - Digite e pressione Enter" filled dense :options="[]"
              @new-value="validateAndAddEmail">
              <template v-slot:selected-item="scope">
                <q-chip removable dense color="primary" text-color="white" @remove="removeEmail(scope.opt)">
                  {{ scope.opt }}
                </q-chip>
              </template>
            </q-select>
          </q-card-section>
          <q-card-actions align="right">
            <q-btn color="primary" label="Salvar" @click="saveEmails" :loading="isLoading"
              :disable="isLoading || !hasEmailChanges" unelevated />
          </q-card-actions>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onMounted } from 'vue'
import { Notify } from 'quasar'

// Q-Select com emails pré-preenchidos
const emails = ref<string[]>([])
const originalEmails = ref<string[]>([])
const isLoading = ref(true)
const isNewRecord = ref(false) // Para saber se deve criar (POST) ou atualizar (PUT)

// Computed para verificar se houve alterações
const hasEmailChanges = computed(() => {
  if (isLoading.value) return false

  // Verifica se os arrays têm o mesmo tamanho e conteúdo
  if (emails.value.length !== originalEmails.value.length) return true

  // Ordena ambos os arrays para comparação
  const sortedEmails = [...emails.value].sort()
  const sortedOriginal = [...originalEmails.value].sort()

  return !sortedEmails.every((email, index) => email === sortedOriginal[index])
})

onMounted(async () => {
  try {
    // Tentativa de buscar dados da API
    const response = await fetch('http://143.244.174.27:2023/sendEmail/emailRecordById/d03')
    const data = await response.json()

    // Verifica se retornou NOT_FOUND
    if (data && data.code === 'NOT_FOUND') {
      isNewRecord.value = true
      // Não carrega emails, mantém vazio para novo registro
      emails.value = []
      originalEmails.value = []
    } else if (data && data.email) {
      isNewRecord.value = false
      const emailData = Array.isArray(data.email) ? data.email : [data.email]
      emails.value = [...emailData]
      originalEmails.value = [...emailData]
    }
  } catch (e) {
    console.warn('API não disponível, usando dados mockados:', e)
  } finally {
    // Simular um pequeno delay para mostrar o skeleton
    setTimeout(() => {
      isLoading.value = false
    }, 1000)
  }
})

function removeEmail(val: string) {
  emails.value = emails.value.filter(email => email !== val)
}

// Função para validar e adicionar email
function validateAndAddEmail(val: string, done: (val?: string, behavior?: 'add' | 'add-unique' | 'toggle') => void) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  const trimmedEmail = val.trim().toLowerCase()

  // Verifica se é um email válido
  if (!emailRegex.test(trimmedEmail)) {
    Notify.create({
      type: 'negative',
      message: 'Email inválido! Use o formato: exemplo@email.com',
      position: 'top'
    })
    done()
    return
  }

  // Verifica se o email já existe (ignorando case)
  const emailExists = emails.value.some(email => email.toLowerCase() === trimmedEmail)

  if (emailExists) {
    Notify.create({
      type: 'warning',
      message: 'Este email já foi adicionado!',
      position: 'top'
    })
    done()
    return
  }

  // Adiciona o email válido e único
  done(trimmedEmail, 'add')
  console.log('Email adicionado:', trimmedEmail)
}

async function saveEmails() {
  try {
    if (isNewRecord.value) {
      const response = await fetch('http://143.244.174.27:2023/sendEmail/createSentEmails', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: emails.value,
          idInstalacao: 'd03',
          submissionPeriod: 1
        })
      })

      const result = await response.json()
      console.log('Novo registro criado:', result)

      // Após criar com sucesso, passa a ser um registro existente
      isNewRecord.value = false

    } else {
      // PUT - Atualizar registro existente
      const response = await fetch('http://143.244.174.27:2023/sendEmail/updateEmailRecordById/d03', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: emails.value,
          submissionPeriod: 1
        })
      })

      const result = await response.json()
      console.log('Registro atualizado:', result)

      Notify.create({
        type: 'positive',
        message: 'Emails atualizados com sucesso!',
        position: 'top'
      })
    }

    // Atualiza os emails originais após salvar com sucesso
    originalEmails.value = [...emails.value]
    console.log('Emails salvos com sucesso!')

  } catch (error) {
    console.error('Erro ao salvar emails:', error)

    Notify.create({
      type: 'negative',
      message: 'Erro ao salvar emails. Tente novamente.',
      position: 'top'
    })
  }
}
</script>
