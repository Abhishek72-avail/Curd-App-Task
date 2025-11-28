# backend/Dockerfile
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy source
COPY . .

# Build step if needed (e.g. TypeScript)
# RUN npm run build

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]
# or ["node", "app.js"] depending on your entry file
