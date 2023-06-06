# Model_CNS_Isabel



## Introduction

This repository was created to upload all the files programmed during the realization of project. It contains the files programmed to obtain a list of proteins expressed in the CNS and run their dynamics. 


## Description of the files 
The repository contains two folder with the following files in each one of them: 

·1. Obtain_CNSList_PrepareSimulations:

- `LISTS_ALLJUPYTERS_PD.ipynb`: To make a list of proteins expressed in CNS, among other filters and download the files needed for running their dynamics. 
- `Prep__dinam.ipynb` and `Create_analysis_inputsjson.ipynb`: To create the folders where the simulations will be run and import there the files needed to run these simulations. 
- `Check_dynamics.ipynb`: Check the progress of the dynamics. 

·2. StarLife_Files:

- `mailterator.sh`: To run the dynamics of each PDB structure. 
- `analyzer.py`: To do the imaging and basic analyses of the trajectories with the MoDEL Workflow by Daniel Beltrán.
- `img_run.sh`: To do the fitting of the trajectories. 
- `workflow_runner.py`: Do the advanced analyses of the trajectories with the MoDEL Workflow by Daniel Beltrán.


## How to run them

Some files are written in Python language (.ipynb) and other in Bash (.sh). For running them, the appropiate environment has to be installed. This project has used a Conda environment with all the needed packages downloaded to run the Python files. Moreover, the environment corresponding to the MoDEL Workflow by Daniel Beltrán was installed to run the bash files. 

It is recommended to have a high storage space in the computer if you intend to run these scripts. 

## License


