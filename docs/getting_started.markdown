---
layout: default
title: Getting Started
permalink: /getting_started/
nav_order: 2
---

# Installation

Click here to download ShapeSpaceExplorer: \
[<button type="button" name="button" class="btn">Download</button>](https://github.com/rosegostner/shape/archive/refs/heads/master.zip)

Unzip the downloaded folder and add it to your MATLAB path. 

For more detailed instructions see [New to MATLAB](#new-to-matlab).

# Terminology

To make the documentation easy to read, some terms are introduced:
- Movie folder: the folder containing your microscopy data
- Analysis folder: your folder containing the complete set of analysis files generated using the ShapeSpaceExplorer package described in this tutorial. For this tutorial it is important to save all outputs in this folder unless stated otherwise.
- Run a "specificMatlabFile.m": navigate to the specified file, select and run it to execute the script. Should these instructions feel unfamiliar, read the next Section [New to MATLAB](#new-to-matlab) 
- MATLAB: The program has been tested on Matlab R2017b on Ubuntu 16.04 LTS and Matlab R2022b on Windows 10. The ShapeSpaceExplorer package requires the following toolboxes:
	- Image Processing
	- MATLAB Coder
	- MATLAB Compiler
	- Deep Learning (optional, only required for group analysis of regions)
	- Statistics and Machine Learning

All figures produced by the scripts are automatically saved in the folder Analysis > Figures unless otherwise stated.

# New to MATLAB

If you have never used MATLAB before, you should install the program and obtain a license first. Most universities offer free licenses for staff and students. A comprehensive guide can be found at [Mathworks](http://uk.mathworks.com/help/install/installation-and-licensing-fundamentals.html). During the installation process you will be asked to choose which toolboxes to install, make sure you select the four mentioned in the [Terminology](#terminology) section With a valid MATLAB license, previous releases can also be downloaded from the [Mathworks Download Page](https://uk.mathworks.com/downloads/).

To run the program, you need the folder ShapeSpaceExplorer containing all files. Within the Matlab program go to the folder <code>ShapeSpaceExplorer</code>.\
<img align="center" width=500px src="./img/add_folder_to_path1.png">

Then, right click on <code>ShapeSpaceExplorer</code> folder, and select <code>Add to Path > Selected Folders and Subfolders</code> \
<img align="center" width=500px src="./img/add_folder_to_path2.png">

This adds the ShapeSpaceExplorer to the MATLAB path, so the scripts are easy to execute. The <code>ShapeSpaceExplorer</code> folder should appear as active \
<img align="center" width=500px src="./img/add_folder_to_path3.png">

To run a script, open <code>ShapeSpaceExplorer > 1-ImageSegmentationFull</code> and select the File <code>Run_CellSegmentation.m</code> with a double click. Then click on the <code>Run</code> button in the Toolbar.  The first line in the MATLAB command window should then contain the line 
```matlab
>> Run_CellSegmentation
```
<img align="center" width=500px src="./img/run_script.png">

Once a script has finished properly, the Command Line shows a new line:
```matlab
>> 
```

