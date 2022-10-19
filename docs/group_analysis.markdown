---
layout: default
title: Group Analysis
permalink: /group_analysis/
nav_order: 8
---

# Group Analysis

A classical example for group analysis might be that your data is divided into three samples: control, treatment1 and treatment2. This group analysis permits to analyse cluster membership for each group and the speed and directionality of shape changes for each group.

Run <code>5-Extended_Affinity_Propagation > Run_GroupAnalysis.m</code> 
Please select the Analysis folder and the ideal number of clusters as determined in Step 3a. \
<img align="center" width=500px src="./img/constrained_cluster_interface.png">

Define the Groups by entering a group name and the stack number. A mapping between stack number and original file is in <code>FileMapping.csv</code>, generated in the cell segmentation step. 
Note: Avoid special characters and white space for group names as they are used later directly in figure paths, and may cause issues on some operating systems. \
<img align="center" width=500px src="./img/group_making.png">

Note: stack numbers from one to five can be entered in several ways, such as
- 1-5
- 1,2,3,4,5
To delete a group, hold CTRL and click on the group, which produces a context menu with a delete option. 

For each group analysis, the program creates a subfolder within a folder called <code>GroupAnalysis</code> in the Figures folder. The subfolder is named <code>Cluster_a_Groups_b</code> where <code>a</code> is the number of clusters selected and <code>b</code> is the number of groups defined. The folder contains the following results for each group: \
<img align="center" width=500px src="./img/shape_space_grey.png"> \
shows shape space in gray, with group elements in cluster colour
<img align="center" width=500px src="./img/group_elements.png"> \
shows group elements as full circles and non-group elements as empty circles in shape space. \
<img align="center" width=500px src="./img/relative_amount_shapes.png"> \
shows the relative amount of shapes in the clusters \
<img align="center" width=500px src="./img/euclidean_ratio.png"> \
shows Eucledian ratio persistency of the group,  a ratio between accumulated distance and shortest possible distance over different time lags. \
<img align="center" width=500px src="./img/relative_count_resp1.png"> \
shows relative count of all groups with respect to cluster 1 (red) \
<img align="center" width=500px src="./img/abs_count.png"> \
shows bar plots with absolute counts. For all bar plots, the numbers are written in text format in the Group Analysis folder.

Finally, the averages speed in shape space is written in <code>AvgSpeedPerGroup.csv</code>. The unit of the speed is [unit in shape space/ time point difference]. If your movies took a frame every 5 minutes, than the respective unit would be 
[1 unit in shape space/ 5 minutes].
<img align="center" width=500px src="./img/speed_per_group.png">

## Shape Slicer

To run the shape slicer, run <code>4-Shape_Averaging > Run_SpaceSlicer.m</code>, which opens a configuration window. \
<img align="center" width=500px src="./img/gui_shape_slicer.png">

Select the Analysis folder and the number of slices the x and y axis should be divided into. The program produces the figure below. \
<img align="center" width=500px src="./img/shape_space_red.png">

Each dot corresponds to a shape in shape space.  Here, the x-axis is sliced into 15 sections. For each section, the program produces an average shape (see blue shapes). Similarly, the y-axis is sliced into 9 sections, and the respective average shape is plotted in green. 

To make the results graphically more appealing, the program writes the single items, such as contents and average shapes of x- and y-axis into single figures, permitting to edit the elements in graphic programs able to deal with EPS file format. 


## Shape Slicer with Group Analysis
<img align="center" width=500px src="./img/gui_shape_slicer_with_group.png">

To see the group distribution in space slicer, tick the last choice box (load group analysis). Below is the shape space sliced, with the coloring of the group analysis and the associated histograms for the defined groups. \
<img align="center" width=500px src="./img/shape_space_groups.png">
<img align="center" width=500px src="./img/group_histograms.png">
