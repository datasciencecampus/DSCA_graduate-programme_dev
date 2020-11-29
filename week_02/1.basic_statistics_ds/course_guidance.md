# Basic Statistics for Data Science

## Course Guidance

This course has been written in R markdown, using the anaconda library. The idea being to be able to allow the learner to execute both pyhton and R code fom within the same rmarkdown scripts. 

This can be a little tricky to set up. Therefore I have included some guidance to assist and also some alternatives, incase the environmental issues cannot be resolved prior to the course.

### Pre Course

Access the pre_course folder and attempt to run the dependencies.Rmd file. You may need to adjust some of the filepaths in the code chunks there in order to configure reticulate correctly. A successful outcome here looks like:

* Able to run python code chunks within the .rmd files.
* Able to knit the .rmd files to html.
* Able to include python charts in the .html output.

### Alternatives

If you are unable to configure reticulate correctly, there are 2 options available:

* Follow along the 2.basic_stats_R_only.html file. You can run your code chunks in child_notebooks/basic_stats_ds-1_R_only.Rmd and child_notebooks/basic_stats_ds-2_R_only.Rmd

* Using Spyder or Jupyter Notebook, you can use `pandas.read_pickle()` to read the dependencies from child_notebooks\cache. The .pkl are python-native binary files that should preserve the data structure of the objects cached from the .Rmd scripts. Using these should allow you to follow along the course from an alternative IDE.



