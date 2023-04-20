
# FROM public.ecr.aws/amazonlinux/amazonlinux:2 AS core

# # Install Git
# RUN set -ex \
#    && GIT_VERSION=2.27.0 \
#    && GIT_TAR_FILE=git-$GIT_VERSION.tar.gz \
#    && GIT_SRC=https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz  \
#    && curl -L -o $GIT_TAR_FILE $GIT_SRC \
#    && tar zxf $GIT_TAR_FILE \
#    && cd git-$GIT_VERSION \
#    && make -j4 prefix=/usr \
#    && make install prefix=/usr \
#    && cd .. && rm -rf git-$GIT_VERSION \
#    && rm -rf $GIT_TAR_FILE /tmp/*

# FROM core AS tools
# ##nodejs
# ENV N_SRC_DIR="$SRC_DIR/n"
# RUN git clone https://github.com/tj/n $N_SRC_DIR \
#      && cd $N_SRC_DIR && make install

# FROM tools AS runtimes_1

# #****************      NODEJS     ****************************************************

# ENV NODE_10_VERSION="10.24.1"

# RUN  n $NODE_10_VERSION && npm install --save-dev -g -f grunt && npm install --save-dev -g -f grunt-cli && npm install --save-dev -g -f webpack \
#      && curl -sSL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo \
#      && rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg \
#      && yum install -y https://download-ib01.fedoraproject.org/pub/epel/8/Modular/x86_64/Packages/l/libuv-1.43.0-2.module_el8+13804+34326f90.x86_64.rpm \
#      && yum install -y -q yarn \
#      && yarn --version \
#      && cd / && rm -rf $N_SRC_DIR && rm -rf /tmp/*

# #****************      END NODEJS     ****************************************************
#FROM public.ecr.aws/lambda/nodejs:18
#Build Step 
FROM public.ecr.aws/docker/library/node:18 AS build
WORKDIR /Users/hongwsun/code/github/eb-node-express-sample
COPY package*.json ./
RUN npm install

FROM public.ecr.aws/docker/library/node:18-slim
RUN apt-get update && apt-get install -y \
  curl \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=build /Users/hongwsun/code/github/eb-node-express-sample .
COPY . .
EXPOSE 8080
ENV PORT=8080
CMD ["node", "app.js"]
  
