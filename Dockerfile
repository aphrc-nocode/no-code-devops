# ---- Base image ----
FROM rocker/shiny:latest

# ---- System dependencies ----
RUN apt-get update && apt-get install build-essential -y
RUN apt-get update && apt-get install -y \
    cmake \
    libudunits2-dev \
    libgdal-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    openjdk-11-jdk \
    libmagick++-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxslt1-dev \
    libpoppler-cpp-dev \
    tk \
    libgit2-dev \
    libsodium-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# ---- Java configuration ----
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN R CMD javareconf

# ---- Copy and install R packages ----
COPY packages.R /tmp/packages.R
RUN Rscript /tmp/packages.R

# ---- Install Rautoml from GitHub ----
RUN R -e "remotes::install_github('aphrc-nocode/Rautoml')"

# ---- Clone your Shiny app ----
RUN rm -rf /usr/no-code-app/*

RUN git clone https://github.com/aphrc-nocode/no-code-app.git /usr/no-code-app

COPY .env /usr/no-code-app/

RUN chmod -R 777 /usr/local/lib/R/site-library

# ---- Create writable directories ----
RUN mkdir -p /usr/no-code-app/datasets \
    /usr/no-code-app/.log_files \
    /usr/no-code-app/models \
    /usr/no-code-app/recipes \
    /usr/no-code-app/outputs \
    /usr/no-code-app/output \
    /usr/no-code-app/logs \
    /usr/no-code-app/users_db \
 && chown -R shiny:shiny /usr/no-code-app

# ---- Copy local users.sqlite template ----
COPY users.sqlite /usr/no-code-app/users_db/users_template.sqlite

# ---- Define volumes ----
VOLUME ["/usr/no-code-app/datasets", \
        "/usr/no-code-app/.log_files", \
        "/usr/no-code-app/models", \
        "/usr/no-code-app/recipes", \
        "/usr/no-code-app/outputs", \
        "/usr/no-code-app/output", \
        "/usr/no-code-app/users_db", \
        "/usr/no-code-app/logs"]

# ---- Working directory ----
WORKDIR /usr/no-code-app

# ---- Expose Shiny Server port ----
EXPOSE 3838

# ---- Copy entrypoint script ----
COPY entrypoint.sh /usr/no-code-app/entrypoint.sh
RUN chmod +x /usr/no-code-app/entrypoint.sh

# ---- Run as non-root user ----
USER shiny

# ---- Use entrypoint to initialize users.sqlite if first install ----
ENTRYPOINT ["/usr/no-code-app/entrypoint.sh"]
