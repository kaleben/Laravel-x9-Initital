FROM php:8.1.0-fpm

# Instalação das dependências
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libmcrypt-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    curl \
    libcurl3-dev \
    libcurl4-openssl-dev \
    libsodium-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxpm-dev \
    libfreetype6-dev \
    zlib1g-dev \
    tzdata \
    autoconf \
    git \
    wget \
    software-properties-common \
    gnupg2 \
    cron \
    vim

RUN apt install -yq xfonts-utils
RUN apt install -yq xfonts-base
RUN apt install -yq xfonts-75dpi

RUN apt-get install -y libmagickwand-dev --no-install-recommends

# Limpeza do cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalação das extenções
RUN docker-php-ext-install pdo_mysql \
    #&& pecl install mcrypt-1.0.4 \
    #&& docker-php-ext-enable mcrypt \
    && docker-php-ext-install exif \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install zip \
    && docker-php-ext-install soap \
    && docker-php-ext-install intl \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    #&& pecl install propro \
    #&& docker-php-ext-enable propro \
    && pecl install raphf \
    && docker-php-ext-enable raphf \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && docker-php-source delete

#multiarch-support
RUN cd ~/ & wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1_amd64.deb
RUN cd ~/ chomd +x multiarch-support_2.27-3ubuntu1_amd64.deb
RUN apt-get install ./multiarch-support_2.27-3ubuntu1_amd64.deb

RUN apt-get update
RUN curl -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN apt-get install unixodbc-dev

RUN apt update

RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

RUN printf "; priority=20\nextension=sqlsrv.so\n" > /usr/local/etc/php/conf.d/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /usr/local/etc/php/conf.d/pdo_sqlsrv.ini

RUN command -v php


#Configura o Composer
# TODO: Verificar se ao carregar o composer do container externo, ele utiliza uma versão do PHP própria ou
# deste container do qual esta sendo chamado
#COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalação do NodeJS e suas depêndencias necessárias para geração de PDF com o package spatie/browsershot no Laravel
# TODO: Mudar esta configuração para um container
# Configuração para instalação do Node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Instalação de dependências para funcionamento do Chrome/Chromium
RUN apt-get install -y \
    nodejs \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    ca-certificates \
    fonts-liberation \
    #libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    libgbm-dev



# Instalação do package puppeteer, necessário para funcionamento do PDF
RUN ln -s /usr/bin/npm /usr/local/bin/npm
RUN npm config set "@fortawesome:registry" https://npm.fontawesome.com/
RUN npm config set "//npm.fontawesome.com/:_authToken" 4B3DD3C5-954F-4CAF-BFBE-7323CDD91A8C
RUN npm install --global --unsafe-perm puppeteer@4.0.1
RUN command -v node
RUN command -v npm

# Instalação do wkhtml
#RUN apt-get update
#RUN apt -y install xvfb libfontconfig wkhtmltopdf
#RUN ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
RUN dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb
RUN rm wkhtmltox_0.12.6-1.buster_amd64.deb

# Configuração necessária para o Chrome/Chromium rodar em segundo plano sem ter problemas com a Sandbox do navegador
RUN echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/userns.conf

# Configuração para conseguir utilizar HTTPS no ambiente local
#COPY BussolaSocialRootCA.crt /usr/local/share/ca-certificates/BussolaSocialRootCA.crt
#COPY BussolaSocialRootCA.pem /usr/local/share/ca-certificates/BussolaSocialRootCA.pem
#RUN update-ca-certificates --fresh

# Configuração fuso horario
RUN TZ='America/Argentina/Buenos_Aires'; export TZ

# Instalacao supervisor
#RUN apt-get update
#RUN apt install -y supervisor
#RUN service supervisor start

#CMD ["supervisorctl reread && supervisorctl update && supervisorctl start laravel-worker:*"]

CMD [ "php-fpm" ]

# Set working directory
WORKDIR /var/www
