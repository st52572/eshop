FROM node:10 as builder
RUN npx browserslist@latest --update-db
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG APP_MOUNT_URI
ARG API_URI
ARG STATIC_URL
ENV API_URI ${API_URI:-http://46.101.214.33:8000/graphql/}
ENV APP_MOUNT_URI ${APP_MOUNT_URI:-/dashboard/}
ENV STATIC_URL ${STATIC_URL:-http://46.101.214.33:9000/}
RUN STATIC_URL=${STATIC_URL} API_URI=${API_URI} APP_MOUNT_URI=${APP_MOUNT_URI} npm run build

FROM nginx:stable
WORKDIR /app
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build/ /app
