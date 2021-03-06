FROM node:10.3 as node
WORKDIR /app
COPY package.json /app/
COPY package-lock.json /app/
RUN npm ci --quiet
COPY ./ /app/

RUN npm run build -- --progress=false

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.13
COPY --from=node /app/dist/random-app/ /usr/share/nginx/html
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf
