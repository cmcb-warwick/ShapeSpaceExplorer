---
layout: default
title: Cell Segmentation
nav_order: 3
---

# Cell Segmentation

Cell Segmentation starts with the microscopy data in your Movie folder. ShapeSpaceExplorer uses [Bioformats](https://www.openmicroscopy.org/bio-formats/downloads/) to read in the data. Check the [list of supported formats](https://docs.openmicroscopy.org/bio-formats/6.10.1/supported-formats.html) to see if your data are supported.

To run cell segmentation, run <code>ShapeSpaceExplorer > 1-ImageSegmentationFull > Run_CellSegmentation.m</code> which should show the interface below: \
<img align="center" width=500px src="./cell_segmentation/img/select_data_folder.png">

Select your Movie folder containing your microscopy data, which should show all files in a selectable list. \
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/select_data_files.png">

Select all movies that should be analysed. Note that at least one file must be selected to continue. The loading of the next interface can be slow, because it calculates the number of frames of your shortest movie from all movies files. 

The interface offers two choices: 
- Analyse all movies from start to end (default choice) 
- Select a substack of your frames, which might be helpful if your data went out of focus. If you select a substack from frame A to frame B, this selection will automatically be applied to all movies in your analysis.

<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/substack_choice.png">

The final interface asks you for the Analysis folder to save the output of the cell segmentation.  Clicking on <code>Start Pre-processing</code> begins the automatic cell segmentation. This is a time intensive task and can take hours to days depending on your data size and available computing power. The segmentation parameters should optimised on a typical movie before running a large dataset. See [Troubleshooting](#troubleshooting) for more information. \
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/select_analysis_folder.png">

Two progress bars indicate the movie and frame that are currently processed. At the end, the command line prints a note when the program finishes successfully. \
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/progress_bar1.png"> \
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/progress_bar2.png"> \
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/segmentation_finished.png">

After cell segmentation, the Analysis folder should have the following new files:
- ImageStackXXX.mat for each analysed movie
- ImageStackXXXCurveData.mat for each analysed movie
- FileMapping.csv: contains the mapping between the new movie names and the original movie names from the Movie folder. Excel can import CSV files.

## Troubleshooting

The cell segmentation in ShapeSpaceExplorer uses an EDISON (Edge Detection and Image SegmentatiON) implementation of the Mean Shift Algorithm within a MATLAB wrapper. Please see the [About](about.markdown) page for links to original code and references. 

If the segmentation produces strange outputs, then there are two parameters to adjust the algorithm: Spatial Bandwidth and Range Bandwidth. These parameters are ideally optimised on a typical example image before attempting segmentation of a large dataset.

Generally speaking, the range bandwidth influences how much noise the cell segmentation picks up. Should there be too many smalls blobs recognized as cells, this parameter should be increased. 

The spatial bandwidth, influences on how large the  radius of a detected shape can be as smallest possible radius. Depending on your imaging conditions and average size of your cell, the interface permits to fine tune the cell segmentation step. Though, the proposed default values worked for a widee range of cases.

An excellent detailed explanation on how the parameters influence cell segmentation can be found on [Wikipedia](http://en.wikipedia.org/wiki/Mean_shift)

If when running <code>ShapeSpaceExplorer > 1-ImageSegmentationFull > Run_CellSegmentation.m</code> you get an error starting 
```
'edison_wrapper_mex' is not found in the current folder or on the MATLAB path, but exists in:
```
In Matlab navigate to <code>1-ImageSegmentationFull > New_Download > edison_matlab_interface</code> and run <code>compile_edison_wrapper</code>. You may then need to restart Matlab.

## Manual Correction of Cell Segmentation

To inspect the cell segmentation results, run the file <code>1-ImageSegmentationFull > Inspect_Shapes.m </code> in the ShapeSpaceExplorer folder, which will open the Inspect_Shapes interface \
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/open_manual_inspect.png">

Click on the folder icon in the toolbar and select one of the files with the name format <code>ImageStackXXX.mat</code>, for example <code>ImageStack001.mat</code>. The program highlights the contours of the detected cells. The toolbar offers zoom in, zoom out and pan operations. The 8th icon from the left is the legend icons and permits you to see the id assigned to detected shapes. 
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/contour_highlights.png">

There are a variety of operations that permit to correct the automatic cell segmentation manually. Each of the operations is explained in the following sections. 

### Delete a Single Shape
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/delete_single1.png">

Selecting the Cursor and clicking on a shape removes the shape from the detected cells, indicated by a grey outline. To remove a shape from a frame plus all future frame you need to hold down the key CTRL and click on the shape. To add the shape back to detected shapes, simply click with the Cursor selected inside the shape, which should re-colour the shape in a bright colour.

### Filter Out Shapes With Small Area Size
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/filter_small.png">

### Filter Out Shapes With Small Life Span
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/filter_short.png">

### Merge
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/merge.png">

### Manual Drawing
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/manual_drawing.png">

You have the full functionality of the [MATLAB ROI tool](https://uk.mathworks.com/help/images/ref/roipoly.html). Here is a basic guide:
- Delete: Backspace
- Adding a new vertex: Key A
- Delete vertex: right click, and select delete
- Closing Polygon: Move to an existing point and click on it. 

### Continues Tracks
Continuous tracks are cell tracks that stretch from a start frame to an end frame, without any interruption. The cell with ID 1, appearing from frame 1 to 5, i.e. [1, 2, 3, 4, 5], would be an example. However, if the track would have a missing frame, say at frame 3, so that the sequence is [1, 2, 4, 5], then when the program saves your modification, it will assign a new ID to the second part, i.e. [4, 5], of the track. 

When you save 3 new files should be produced:
- CellArayXXX.mat
- CellFrameDataXXX.mat
- ManCorrtdCurvesXXX.mat

## After Manual Correction

The program expects you to open each stack with the <code>Inspect_Shape.m</code> program and save it from there. For each stack ImageStackXXX.mat, the program creates two files, namely CellArayXXX.mat, and CellFrameDataXXX.mat. The analysis integrates only stacks that have those two files generated. To proceed run <code>1-ImageSegmentationFull > MakeBigStructs.m</code>.
<img align="center" width=500px src="{{ site.baseurl }}/cell_segmentation/img/run_MakeBigStructs.png">

After selecting the Analysis folder, the program generates two files:
- Bigcellarrayandindex.mat
- BigCellDataStruct.mat

---
**NOTE**

You can construct the <code>Bigcellarrayandindex.m</code> and <code>BigCellDataStruct.mat</code> without manual correction; to do so, run <code>1-ImageSegmentationFull > MakeBigStructsWithoutManual.m</code>

Running the program <code>MakeBigStructsWithoutManual.m</code> will not include any existing manual corrections!

---

## Manual Segmentation

Manually segmented shapes (for example by drawing outlines using the freehand tool in ImageJ and exporting the xy coordinates into individual textfiles) can be imported into ShapeSpaceExplorer.
Please note that files should be tab-separated file with 3 columns. Following the header line these should contain only numbers: Point ID in the first column, x coordinates in the second column and y coordinates in the third column. These should be arranged in a folder structure like this:

```
.
+-- Stack_001
|	+-- Cell_001
	|	+-- Results_1.txt
	|	+-- Results_2.txt
	|	+-- Results_3.txt
|	+-- Cell_002
	|	+-- Results_1.txt
	|	+-- Results_2.txt
	|	+-- Results_3.txt
|	+-- Cell_003
	|	+-- Results_1.txt
	|	+-- Results_2.txt
	|	+-- Results_3.txt
+-- Stack_002
|	+-- Cell_001
	|	+-- Results_1.txt
	|	+-- Results_2.txt
	|	+-- Results_3.txt
|	+-- Cell_002
	|	+-- Results_1.txt
	|	+-- Results_2.txt
	|	+-- Results_3.txt
|	+-- Cell_003
	|	+-- Results_1.txt
	|	+-- Results_2.txt
	|	+-- Results_3.txt
```

Use the following Macro in ImageJ

```javascript
//Macro allows manual extraction of cell shape and saves these as textfiles in the image folder.

macro "Get cell shape [1]" {

	run("Clear Results");
		getSelectionCoordinates(x, y);

for (i=0; i<x.length-1; i++){
setResult("y", i, y[i]);
setResult("x", i, x[i]);}

updateResults();

dir=getDirectory("image");

roiManager("Add");
nROI = roiManager("count");

selectWindow("Results");

   name = dir + "Results_" + nROI + ".txt";
   saveAs("Results", name);

setForegroundColor(255, 0, 0);
run("Draw", "slice");

}
```

Now, run <code>1-ImageSegmentationFull > ImportManual_Segs_plus_Struct.m</code>, which asks for the Experiment folder and then the Analysis folder as input. If successful, it will generate these two files:
- Bigcellarrayandindex.mat
- BigCellDataStruct.mat
