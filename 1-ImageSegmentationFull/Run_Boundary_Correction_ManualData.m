function Run_Boundary_Correction_ManualData()

% a script to correct for faulty manual data.
% program prompts you for the 'Bigcellarrayandindex'
% result original result will be left in Bigcellarrayandindex_org.
% corrected data will be written into Bigcellarrayandindex.mat

[filename, pathname] = uigetfile({'*.mat';},'File Selector');

path = fullfile(pathname, filename);
    if exist(path, 'file')
        display('File is loading ... ');
        try data = load(path);
            BigCellArray=data.BigCellArray;
        catch
            fileHasWrongStructure(path);
            return;
        end
    else
        filleDoesNotexist(path);
        return;
    end

%save original data.
oFile = fullfile(pathname, 'Bigcellarrayandindex_orig.mat');
save( oFile, 'BigCellArray', '-v7.3');
BigCellArray_old=BigCellArray;
BigCellArray={};

s=length(BigCellArray_old);
for i=1:s % check each entry
    border =BigCellArray_old{i};
    cBorder =cleanBorder(border);
    BigCellArray{i} =cBorder;
    close all
end

nFile = fullfile(pathname, 'Bigcellarrayandindex.mat');
save( nFile, 'BigCellArray', '-v7.3');
display('Program corrected all manual entered shapes');


end

function cleanBorder= cleanBorder(border)
   %remove outliers entries.
   x=border(:,1);
   y=border(:,2);
   muX=mean(x); muY=mean(y);
   sigmaX=std(x); sigmaY=std(y);
   
   outlierX=abs(x-muX)>3*sigmaX;
   outlierY=abs(y-muY)>3*sigmaY;
   idx1 =find(outlierX==1);
   idx2 =find(outlierY==1);
   idx =union(idx1,idx2);
   x(idx)=[];
   y(idx)=[];

    maxY=max(border(:,2));
    maxX=max(border(:,1));
    mask = poly2mask(x, y,maxY, maxX);
    nuregionmask=imdilate(mask, [0 1 0; 1 1 1; 0 1 0]);
    bound = bwboundaries(nuregionmask,8,'noholes');
    l = 0;
    cleanBorder=[];
    for i=1:length(bound)
        if length(bound{i})>l
            cleanBorder=bound{i};
            l=length(cleanBorder);
        end
    end
    if isempty(cleanBorder)
        display('empty');
    end
    tmp =cleanBorder;
    cleanBorder=[];
    cleanBorder(:,1)=tmp(:,2);
    cleanBorder(:,2)=tmp(:,1);
    figure %@ Anne, here you can see the shape we are taking.
    plot(x,y, 'b'); hold on
    plot(cleanBorder(:,1), cleanBorder(:,2), 'r');
    close all
end






function filleDoesNotexist(filename)
    display('-------');
    display(['The file "' filename '" does not exist in your Analysis folder.']);
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
end

function fileHasWrongStructure(filename)
    display('-------');
    display(['The file "' filename '" does not have the expected structure in your Analysis folder.']);
    display('Please check whether previous steps have been succesfully completed.');
    display('-------');
end

