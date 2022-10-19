---
layout: default
title: Out of Sample Extension
permalink: /out_of_sample_extension/
nav_order: 9
---

# Out of Sample Extension

First step: create a folder called OOSE (possibly inside Analysis folder), then perform the following two preparatory steps:
- Run <code>1-ImageSegmentationFull > Run_CellSegmentation.m</code> and select OOSE as your Analysis folder
- Either correct data manually, using <code>Inspect Data</code> for all <code>ImageStacksXXX.mat</code> and run 
<code>1-ImageSegmentationFull > MakeBigStructs.m</code> or continue without inspection running
<code>1-ImageSegmentationFull > MakeBigStructsWithoutManual.m</code>.

Now, run <code>6_OoSE > run_OoSE_training</code> and configure the next step \
<img align="center" width=500px src="./img/oose_config.png">

Once completed successfully, the OOSE folder contains the new file:
- LP_trained.mat; its structure has  Nx5 matrix, where N is the number of frames analysed. 

Now, run <code>6_OoSE > generate_OoSe_distMatrix_new</code> (Choose analysis and OoSE folders as above and click <code>Start OOSE</code> in similar way to the previous step).
After correctly finishing, there will be one new file in the OOSE folder:
- Dist_mat.mat
- OoSE_embedding.mat

As a validation step, run <code>3-ShapeFeatures > Run_PlotBAMvsSCORES</code> and select the analysis and OsSE folders, then the program will produce the following figures: \
<img align="center" width=500px src="./img/bam_plot.png">

First and second rows (from left to right) show a comparison between 'Score' and 'Solidity and DistRatio' distributions, respectively, while third row shows regression lines on top of the shape distributions.

To compare the OOSE sample within the shape parameters and cluster parameters of say the control sample, run <code>6_OoSE > createBargraphs.m</code> \
<img align="center" width=500px src="./img/oose_config3.png">

For clusters, select the best numbers from the reference (Analysis) sample. The new subset will be plotted in shape space using the two most distinctive features for x- and y-axis from the larger sample in Analysis. Also, for the clustering, the sample in Analysis is used as ‘reference’ clusters, and this permits to see how this sample extension compares to a larger sample or a control sample. \
<img align="center" width=500px src="./img/abs_clusters.png">
Bar graphs for clusters with absolute numbers \
<img align="center" width=500px src="./img/shape_space_ref_grey.png">
Shape space with reference dots in grey and sample extension in colour \
<img align="center" width=500px src="./img/shape_space_ref_empty.png">
Extension shapes in full circles and reference shapes in empty circles.

Note: All Figures are plotted in OOSE/Figures, with numbers of bar graphs written in CVS files.
