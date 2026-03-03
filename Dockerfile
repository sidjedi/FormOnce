# ---------- BUILDER ----------
FROM node:20-alpine AS builder

WORKDIR /app

RUN npm install -g pnpm

# Copia tudo primeiro (IMPORTANTE)
COPY . .

# Instala dependências
RUN pnpm install --frozen-lockfile

# Gera Prisma client explicitamente
RUN npx prisma generate

# Build Next
RUN pnpm build


# ---------- RUNNER ----------
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

RUN npm install -g pnpm

COPY --from=builder /app ./

EXPOSE 3000

CMD ["pnpm", "start"]
