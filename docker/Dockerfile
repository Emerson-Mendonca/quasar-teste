# Dockerfile

FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Gera arquivos de produção em /app/dist/spa
RUN npm run build     # ou quasar build


FROM nginx:stable-alpine
# Copia build SPA para a pasta servida pelo nginx
COPY --from=builder /app/dist/spa /usr/share/nginx/html
# Remover configuração default se quiser customizar
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
