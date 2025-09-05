# Étape 1 : Build (si jamais tu as besoin de devDependencies ou de transpilation)
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

# Étape 2 : Run (image finale optimisée)
FROM node:18-alpine
WORKDIR /app

# Copier uniquement package.json et installer dépendances prod
COPY package*.json ./
RUN npm ci --omit=dev

# Copier le code source depuis le build
COPY --from=build /app ./

EXPOSE 3000
ENV NODE_ENV=production
USER node
CMD ["node", "server.js"]
