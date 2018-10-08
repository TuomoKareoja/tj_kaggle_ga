Getting started
===============

Command in this envinronment assume that you have Anaconda installed

1.
run make create_environment to create a conda virtual environment with necessary packages. 
The environment name will be tj_kaggle_ga (if you want to change this you have to change the
makefile or get by without it)

2.
Install the official Kaggle API from https://github.com/Kaggle/kaggle-api. Don't install this 
package to a conda virtual env. If you are on Windows you need to restart before the kaggle-congif
is applied to local system account.

3.
run make fetch_data in console download the files to data/raw

