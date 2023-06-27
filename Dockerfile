FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:18 AS build
WORKDIR /Users/hongwsun/code/github/eb-node-express-sample
COPY package*.json ./
RUN npm install

FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:18-slim
RUN apt-get update && apt-get install -y \
  curl \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=build /Users/hongwsun/code/github/eb-node-express-sample .
COPY . .
EXPOSE 8080
ENV PORT=8080
CMD ["node", "app.js"]
  
