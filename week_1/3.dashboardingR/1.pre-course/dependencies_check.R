"script purpose: Test dependencies prior to course delivery.
instructions: Please unhash line 6 and run to install pacman. Then comment out
and run the entire script. Please copy and paste the output of the if statement
to the Slack channel."

#install.packages("pacman", dependencies = TRUE, type = "win.binary")
library(pacman)

#vector of required packages for course:
packages <- c("flexdashboard", "dplyr", "ggplot2", "plotly", "DT", "shiny")
#load the packages and install if required:
pacman::p_load(packages, character.only = TRUE)
# check whats installed:
p_loaded()
# which packages failed to load?
fails <- setdiff(packages, loadedNamespaces())


if (length(fails) == 0) {
  print("Everything installed and loaded")
} else {
  warning(paste(fails, collapse = ", "), " not loaded.")
}
