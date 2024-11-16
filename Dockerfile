# Use the official R Shiny server image as the base image
FROM rocker/shiny:latest

# Install system dependencies required for the Shiny app
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libudunits2-dev \
    libgdal-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
	 libmagick++-dev \
	 tk \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install R packages from CRAN
RUN R -e "install.packages(c( \
    'shiny', 'shinyjs', 'shinyvalidate', 'shinyalert', 'shinyWidgets', \
    'sjlabelled', 'dplyr', 'stringr', 'stringi', 'remotes', \
    'readr', 'readxl', 'openxlsx', 'haven', 'forcats', \
    'skimr', 'countries', 'summarytools', \
    'plotly', 'ggplot2', 'DT' \
  ), repos='https://cloud.r-project.org')"


# Install Rautoml package from GitHub
RUN R -e "remotes::install_github('aphrc-nocode/Rautoml')"

# Clone the Shiny app repository
RUN git clone https://github.com/aphrc-nocode/no-code-app.git /srv/shiny-server/no-code-app

# Ensure proper permissions for the Shiny app directory
RUN chown -R shiny:shiny /srv/shiny-server

# Set the working directory to the app's location
WORKDIR /srv/shiny-server/no-code-app

# Expose the default Shiny server port
## EXPOSE 3838

# Run the Shiny server
# CMD ["/usr/bin/shiny-server"]
CMD ["R", "-q", "-e", "shiny::runApp('.', host='0.0.0.0', port=3838)"]

