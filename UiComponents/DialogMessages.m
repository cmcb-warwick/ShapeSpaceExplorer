% this is a method to keep all dialog messages in one place
% it has the advantage of correcting messages in one place
% and if error messages are re-used, they will all be corrected
% in a single point... 
% 1 - Error Msg for not choosing CellShapeData.mat

function msg = DialogMessages( number )
msgs=setUpMsgs();
try
msg = msgs{number};
catch
    msg ='Message Not found.';
end
end



function msgs=setUpMsgs()
msgs={};
msgs{1} =['Selected File did not contain  the structure CellShapeData.' char(10) ...
            'Please select the file "CellShapeData.mat" from previous step.'];
msgs{2} =['Selected Number was greater than maximal clusters found in Dendogram.' char(10) ...
            'Please select a more sensible number.'];
msgs{3}=['You did not select a movie.' char(10) ...
       'Please select at least one movie to continue pre-processing.'];
msgs{4}=['Your first frame is greater than your selected last frame.' char(10) ...
       'Please select an appropriate range of frames.'];
   
msgs{5}=['The path in the text fild is not a valid folder directory.' char(10) ...
       'Please select an appropriate folder.'];
   
msgs{6}=['The file you choose does not contained the expected content.' char(10) ...
         'Please load a file with the name "ImageStack0XX.mat. char(10)' ...
         ' or repeat Cell Segmentation step.'];
     
msgs{7}=['In your analysis folder there is a "ImageStack0XX.mat but not a "ImageStack0XXCurveData.mat.' char(10) ...
         'Please repeat Cell segmentation step, to produces missing files.'];
     
msgs{8}=['You have not loaded any image stacks.' char(10) ...
         'Nothing can be  saved.'];
  
msgs{9}=['Your modifications have been sucesfully saved.' char(10)];


msgs{10}=['You did not enter corretly a number.' char(10) ...
         'Please enter a positive integer number.'];
     
msgs{11}=['There are no segemenated cells in stack.' char(10) ...
         'Nothing was saved to file.'];
     
     
 msgs{12}=['You must select two valid folder paths.' char(10) ...
         'Please select Analysis folder and Oose Folder.'];
     
 msgs{13}=['Your path of the Analysis and Oose Folder are the same.' char(10) ...
         'You must select two differetn folders.'];
     
 msgs{14} =['To merge 2 objects do following steps:' char(10) ...
            '1) Click on the 1. object,' char(10) ...
            '2) Drag mouse to 2. object, ' char(10) ...
            '3) Release and Double Click on Line.'];
        
msgs{15} = ['You entered an empty group name.' char(10) ... 
            'Please enter a meaningful name' ];

end