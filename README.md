# Quasar App (quasar-teste)

A Quasar Project

## Install the dependencies

```bash
yarn
# or
npm install
```

### Start the app in development mode (hot-code reloading, error reporting, etc.)

```bash
quasar dev
```

### Lint the files

```bash
yarn lint
# or
npm run lint
```


### Format the files

```bash
yarn format
# or
npm run format
```

### Build the app for production

```bash
quasar build
```

### Docker buildx

```bash
docker buildx build \
  --builder quasar-builder \
  --platform linux/amd64,linux/arm64 \
  -f docker/Dockerfile \
  -t ghcr.io/emerson-mendonca/quasar-teste:0.0.1 \
  --push \
  .
```

### Customize the configuration

See [Configuring quasar.config.js](https://v2.quasar.dev/quasar-cli-vite/quasar-config-js).
