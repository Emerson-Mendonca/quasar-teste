#!/usr/bin/env bash

# dev.sh - Script para inicializar o ambiente de desenvolvimento Quasar via Docker
# Agora considerando que todos os arquivos Docker estão em './docker/'

set -e  # Interrompe o script em caso de erro

# Cores ANSI
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"  # Sem cor

# Diretório que contém os arquivos Docker
docker_dir="./docker"
# Variáveis de configuração
dev_image_name="quasar-dev:latest"
compose_file="${docker_dir}/docker-compose.yml"
dockerfile_dev="${docker_dir}/Dockerfile.dev"

# Função para exibir erro e encerrar
function error_exit() {
  echo -e "${RED}✖ $1${NC}"
  exit 1
}

# 1) Verifica pré-requisitos de binários
echo -e "${BLUE}🔍 Verificando instalação de Docker e Docker Compose...${NC}"
command -v docker >/dev/null 2>&1 || error_exit "Docker não encontrado. Instale o Docker antes de prosseguir."
command -v docker-compose >/dev/null 2>&1 || error_exit "Docker Compose não encontrado. Instale o Docker Compose antes de prosseguir."
echo -e "${GREEN}✔ Docker e Docker Compose estão instalados!${NC}"

# 2) Verifica status do Docker daemon
echo -e "\n${BLUE}⏳ Verificando se o Docker daemon está ativo...${NC}"
if ! docker info >/dev/null 2>&1; then
  error_exit "Não foi possível conectar ao Docker daemon. Certifique-se de que o serviço Docker esteja em execução."
fi
echo -e "${GREEN}✔ Docker daemon ativo e respondendo!${NC}"

# 3) Verifica existência dos arquivos Docker
echo -e "\n${BLUE}🔧 Verificando presença de arquivos em '${docker_dir}'...${NC}"
[[ -f "${dockerfile_dev}" ]] || error_exit "Dockerfile de desenvolvimento não encontrado em '${dockerfile_dev}'"
[[ -f "${compose_file}" ]]  || error_exit "docker-compose.yml não encontrado em '${compose_file}'"
echo -e "${GREEN}✔ Arquivos Docker encontrados!${NC}"

# 4) Construção da imagem de desenvolvimento
echo -e "\n${BLUE}[1/3]${NC} ${YELLOW}Construindo imagem de desenvolvimento${NC} ${GREEN}(${dev_image_name})...${NC}"
docker build \
  --file "${dockerfile_dev}" \
  --tag "${dev_image_name}" \
  .
echo -e "${GREEN}✔ Imagem ${dev_image_name} construída com sucesso!${NC}"

# 5) Inicialização dos containers em modo dev
echo -e "\n${BLUE}[2/3]${NC} ${YELLOW}Subindo containers (hot-reload)...${NC}"
docker-compose -f "${compose_file}" up --build
echo -e "${GREEN}✔ Containers iniciados com sucesso!${NC}"

# 6) Mensagem final
echo -e "\n${BLUE}[3/3]${NC} ${YELLOW}Ambiente de desenvolvimento pronto!${NC}"
echo -e "${YELLOW}🚀 Acesse o Quasar Dev Server em:${NC} ${BLUE}http://localhost:8080${NC}\n"
# Para interromper o serviço: Ctrl+C e, se necessário, 'docker-compose down -f ${compose_file}'
