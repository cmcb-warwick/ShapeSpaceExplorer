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
end