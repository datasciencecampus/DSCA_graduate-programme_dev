# Week 2

## 1.basic_statistics_ds

## 2.research_practice_ds
### 2.2. [prezi presentation part 1- research and practice in data science](https://prezi.com/view/Eb9pWY1Bq2QHtUmSekGe/)
### 2.3. [prezi presentation part 2- research and practice in data science](https://prezi.com/view/P6CQDjw73VJfcVw9vyJX/)

## 3.[intro to python](https://github.com/datasciencecampus/DSCA_intropython)

## 4.[intro to R](https://github.com/datasciencecampus/DSCA_Intro-R)

***

# Actions for 2021:
* 1.basic_statistics_ds feedback from AL colleagues to be included shortly.
* Reticulate troubleshooting guidance from Hannah in AL:
Hi @channel, casting our minds back to before Christmas and our issues running reticulate on ONS machines. Hannah from Analytical Learning has spent some time resolving issues she was encountering on her side. Hopefully this may resolve some of your issues and I will look at incorporating her advice into our troubleshooting guidance going forward. Here's Hannah's message:

I followed these instructions (https://support.rstudio.com/hc/en-us/articles/360023654474-Installing-and-Configuring-Python-with-RStudio) and found this helpful too (https://community.rstudio.com/t/configuring-python-for-rstudio-in-windows-10-reticulate/52798)

I used Anaconda Prompt:
Create a Python environment in your project
Followed the guidance to use one virtual environment per project. I’m not sure how much that actually should apply – may be better to create a generic one if you’re not too to worried about versioning.
Navigate into your your RStudio project directory by using the following command:
cd <project-dir>
Create a new virtual environment in a folder called python within your project directory using the following command:
virtualenv name_of_virtual_env

N.B – I needed to pip install virtualenv before I could do this.
 
Step 3) Activate your Python environment
You can activate the virtualenv in your project using the following command in a terminal:
source name_of_virtual_env/bin/activate

That didn’t work for me - I had to do name_of_virtual_env\Scripts\activate
You can verify that you have activated the correct version of Python using the following command in a terminal:
which python

That didn’t work for me - I used python and then quit() to exit

Step 4) Install Python packages in your environment
You can install Python packages such as numpy, pandas, matplotlib, and other packages in your Python virtualenv by using pip install using the following command in a terminal:
pip install numpy pandas matplotlib

Installed one by one using pip install package_name==package_version as I wanted base ONS versions.
I installed:
 Numpy 1.18.1
Pandas 0.20.1
Matplotlib 2.0.2
Seaborn 0.7.1
 
Step 5) Install and configure reticulate to use your Python version
Install the reticulate package using the following command in your R console:
install.packages("reticulate")
To configure reticulate to point to the Python executable in your virtualenv, create a file in your project directory called .Rprofile with the following contents:
Sys.setenv(RETICULATE_PYTHON = "name_of_virtual_env/bin/python")
You'll need to restart your R session for the setting to take effect. You can verify that reticulate is configured for the correct version of Python using the following command in your R console:
reticulate::py_config()

I also needed to make sure the setup chunk in RStudio had these lines in it to work. The name of my virtual environment is .venv
library(reticulate)
Sys.setenv(RETICULATE_PYTHON = "C:/Users/hodgeh/html_itp/.venv/Scripts/python.exe")

