# Dockerfile (produção)
FROM node:18-alpine AS builder

# Ambiente de Produção

ENV NODE_ENV=prod
WORKDIR /app

# Instala Quasar CLI globalmente com permissões adequadas
RUN npm install -g @quasar/cli --unsafe-perm=true

# Copia todo o código-fonte para dentro do container
COPY . .

# Instala dependências (incluindo scripts do Quasar Prepare)
RUN npm install

RUN quasar build

# Fase final: container leve com Nginx
FROM nginx:stable-alpine

# Copia os arquivos de produção para o Nginx
COPY --from=builder /app/dist/spa /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
