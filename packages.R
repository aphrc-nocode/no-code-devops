libraries <- c(
   "remotes",
   "leaflet",
	"sortable",
   "sdcMicro",
	"plyr",
	"e1071",
	"nnet",
	"pls",
	"mgcv",
   "gsheet",
   "dygraphs",
   "jsonlite",
   "httr2",
   "shiny",
   "shinyjs",
   "shinyvalidate",
   "shinyalert",
   "shinyWidgets",
   "shinydashboard",
   "shinydashboardPlus",
   "shinycssloaders",
   "sjlabelled",
   "tidyr",
   "dplyr",
   "stringr",
   "stringi",
   "officer",
   "readr",
   "readxl",
   "openxlsx",
   "haven",
   "forcats",
   "skimr",
   "summarytools",
   "countries",
   "plotly",
   "RPostgreSQL",
   "DT",
   "bslib",
   "gt",
   "lubridate",
   "gtsummary",
   "webshot",
   "webshot2",
   "ggplot2",
   "shinyFiles",
   "flextable",
   "RSQLite",
   "sjmisc",
   "DBI",
   "RMySQL",
   "Achilles",
   "DatabaseConnector",
   "doParallel",
   "GGally",
   "DataExplorer",
   "htmltools",
   "promises",
   "future",
   "CodelistGenerator",
   "CDMConnector",
   "CohortConstructor",
   "RColorBrewer",
   "caret",
   "cli",
   "gemini.R",
   "naniar",
   "recipes",
   "rlang",
   "rsample",
   "shapviz",
   "callr",
   "caretEnsemble",
   "cvms",
   "digest",
   "foreach",
   "ggthemes",
   "grid",
   "httpuv",
   "httr",
   "patchwork",
   "pins",
   "plumber",
   "scales",
   "themis",
   "vetiver",
   "waiter",
   "glue",
   "zip",
   "htmlwidgets",
	"duckdb",
	"gbm",
	"MLmetrics",
	"fs",
	"rpart",
	"RSNNS",
	"naivebayes"
)

# Install missing CRAN packages
missing <- setdiff(libraries, rownames(installed.packages()))
if (length(missing) > 0) install.packages(missing, repos='https://cloud.r-project.org', dependencies = TRUE)

remotes::install_github("OHDSI/DataQualityDashboard", upgrade="never")
remotes::install_github("jbryer/login", upgrade="never")

remotes::install_github("OHDSI/Andromeda", upgrade="never")
remotes::install_github("OHDSI/FeatureExtraction", upgrade="never")

if (!requireNamespace("fastshap", quietly = TRUE)) {
  install.packages(
    "https://cran.r-project.org/src/contrib/Archive/fastshap/fastshap_0.1.1.tar.gz",
    repos = NULL, type = "source"
  )
}


## Install specific version
install_package_version <- function(package, version) {
  install_pkg <- TRUE
  if (requireNamespace(package, quietly = TRUE)) {
    installed_version <- as.character(packageVersion(package))
    if (installed_version == version) {
      install_pkg <- FALSE
      message(package, " ", version, " is already installed.")
    } else {
      message(
        "Found ", package, " ", installed_version,
        ", but version ", version, " is required."
      )
      remove.packages(package)
    }
  }
  if (install_pkg) {
    if (!requireNamespace("remotes", quietly = TRUE)) {
      install.packages("remotes")
    }
    remotes::install_version(
      package = package,
      version = version,
      repos = "https://cloud.r-project.org"
    )
  }
}
install_package_version("xgboost", version="1.7.11.1")
