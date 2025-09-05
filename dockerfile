FROM node:18
WORKDIR /app

# Copier uniquement les fichiers nécessaires à l'installation
COPY package*.json ./
RUN npm install

# Copier le reste du code après
COPY . .

EXPOSE 3000
ENV NODE_ENV=development
RUN npm run build
CMD ["node", "server.js"]
