FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

EXPOSE 3000
ENV NODE_ENV=production
RUN npm run build
USER node
CMD ["node", "server.js"]
