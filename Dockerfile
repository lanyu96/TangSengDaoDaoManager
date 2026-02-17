FROM node:16.20.1 as builder
WORKDIR /app

# 使用 npm 官方注册表并安装与 Node.js v16 兼容的 pnpm 8 版本
RUN npm config set registry https://registry.npmjs.org && npm install pnpm@8 -g

COPY . .

# 使用 pnpm 官方注册表
RUN pnpm config set registry https://registry.npmjs.org && pnpm install && pnpm build


FROM nginx:latest
COPY --from=builder /app/docker-entrypoint.sh /docker-entrypoint2.sh 
COPY --from=builder /app/nginx.conf.template /
COPY --from=builder /app/dist /usr/share/nginx/html
ENTRYPOINT ["sh", "/docker-entrypoint2.sh"]
CMD ["nginx","-g","daemon off;"]
