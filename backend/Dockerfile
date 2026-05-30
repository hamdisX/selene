FROM node:24-alpine AS base
WORKDIR /app
RUN apk add --no-cache python3 make g++ openssl

# ─── Développement (hot-reload) ───────────────────────────────────────────
FROM base AS development
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 3000 9229
CMD ["npm", "run", "start:dev"]

# ─── Build de production ──────────────────────────────────────────────────
FROM base AS build
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --production

# ─── Production (image légère, utilisateur non-root) ─────────────────────
FROM node:24-alpine AS production
WORKDIR /app
ENV NODE_ENV=production
RUN apk add --no-cache openssl \
  && addgroup -S nodejs \
  && adduser -S nestjs -G nodejs
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json
RUN chown -R nestjs:nodejs /app
USER nestjs
EXPOSE 3000
CMD ["node", "dist/main.js"]
