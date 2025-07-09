FROM node:22-alpine AS builder
WORKDIR /app
COPY ./package.json ./
RUN npm install

FROM node:22-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM nginx:alpine
EXPOSE 80
COPY --from=production /app/build /usr/share/nginx/html

