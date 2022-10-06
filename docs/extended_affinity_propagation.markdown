---
layout: default
title: Extended Affinity Propagation
permalink: /extended_affinity_propagation/
nav_order: 7
---

# Extended Affinity Propagation

This step is optional.

This step determines similarities between shapes. 
In this step, similarities between shapes are determined. For pre-processing run 
5-Extended_Affinity_Propagation > Run_Affinity_Propagation.m

Note: this step needs first to load CellShapeData.mat; when this file is large, say about 20 GB, loading the file may take half an hour where the computer gives no feedback. Once loaded, the program prints progress on the console. \
<img align="center" width=500px src="./img/progress.png">

After successful completion, the following nine files should have been generated in the Analysis folder:
- avail_list.mat
- APclusterOutput.mat
- double_sim_matrix.mat
- linkagemat.mat
- pref.mat
- resp_mat.mat
- single_sim_matrix.mat
- unconv.mat
- wish_list.mat

## Inspecting Automatic Classification of Shapes

To inspect the automatic classification, run 5-Extended_Affinity_Propagation > Inspect_ShapeAffinity.m , select the Analysis folder, and then the program produces two figures (see below) \
<img align="center" width=10px src="./img/column_shapes.png">
<img align="center" width=500px src="./img/matrix_shapes.png">

The left figure shows the unordered exemplars with one example highlighted for each of 10 clusters, while the right figure shows ten example shapes from each cluster. 

## Dendrogram of Shapes

Often, the program produces to many clusters and it is desirable to constraint the number of clusters. To make an informed choice, the cluster dendrogram should be consulted. 
Run 5-Extended_Affinity_Propagation > Run_Dendogram_of_Shapes.m, select Analysis folder, and then the program produces the cluster dendrogram (see below). Use this to decide how many clusters are appropriate for the dataset. \
<img align="center" width=500px src="./img/dendrogram.png">

## Constrained Clustering

Then run
5-Extended_Affinity_Propagation > Run_constrained_Clustering.m, 
select the Analysis folder and configure the number of clusters based on your choice made above (see figure below). \
<img align="center" width=500px src="./img/contrained_clustering_interface.png">

Note: The number you enter for constraint clusters must be smaller than the number of exemplars from the affinity propagation; otherwise the program terminates without results. \
<img align="center" width=300px src="./img/cluster_colours.png">
<img align="center" width=300px src="./img/coloured_exemplars.png">

Left figure shows all shapes in shape space coloured in the cluster colours. Each dot in the figure corresponds to a cell shape. The x and y axes are the first two Diffusion Coordinates. The right figure the ordered list of exemplars coloured in the cluster colours. 
