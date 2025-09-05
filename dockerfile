FROM node:18
WORKDIR /app
COPY . /app
RUN npm install
EXPOSE 3000
ENV NODE_ENV=development
RUN npm run build
CMD ["node", "server.js"]
