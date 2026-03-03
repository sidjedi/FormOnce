# ---------- BUILDER ----------
FROM node:20-bullseye AS builder

WORKDIR /app

RUN npm install -g pnpm

# SOMENTE variáveis necessárias para o build
ARG GITHUB_CLIENT_ID
ARG GITHUB_CLIENT_SECRET
ARG NEXTAUTH_URL
ARG DATABASE_URL
ARG NODE_ENV

ENV GITHUB_CLIENT_ID=$GITHUB_CLIENT_ID
ENV GITHUB_CLIENT_SECRET=$GITHUB_CLIENT_SECRET
ENV NEXTAUTH_URL=$NEXTAUTH_URL
ENV DATABASE_URL=$DATABASE_URL
ENV NODE_ENV=$NODE_ENV

COPY . .

RUN pnpm install --frozen-lockfile
RUN npx prisma generate
RUN pnpm build


# ---------- RUNNER ----------
FROM node:20-bullseye AS runner

WORKDIR /app
ENV NODE_ENV=production

RUN npm install -g pnpm

COPY --from=builder /app ./

EXPOSE 3000

CMD ["pnpm", "start"]
