function [ BigCellArray, cell_indices ] = Import_Manual_Segs_plus_Struct
%LOAD_MANUAL_SEGS Summary
%
% OUTPUT: Will generate BigCellArray.mat and BigCellDtaStruct.mat for further analysis in ShapeSpaceExplorer from
% manually segmented data.

% INPUT: These data should be in numbered folders for each stack, stack001, stack002 etc. each containing 
% folders with contours from different cells in folders i.e. Cell_001,
% Cell_002 etc.
% with numbered text files containing the x and y coordinates as integer numbers for each contour in different image frames.
% Contour files should have the structure pointid /T x /T y as output by
% ImageJ getSelectionCoordinates(x, y); and saved as individual textfiles
%
%

Experiment_folder = uigetdir(pwd,'Select Data Folder');

D=dir(Experiment_folder);
D(~[D.isdir])= []; %Remove all non directories.
stack_folder_names = setdiff({D.name},{'.','..'}); %Remove '.' and '..' anomalies

num_stacks=length(stack_folder_names);
stack_folder_names=sort_nat(stack_folder_names);

cell_indices=[];
BigCellArray={};
cell_num=1;
BigCellDataStruct=struct;
for i=1:num_stacks
    stackD=dir([Experiment_folder '/' stack_folder_names{i}]);
    stackD(~[stackD.isdir])= []; %Remove all non directories.
    cell_folder_names = setdiff({stackD.name},{'.','..'}); %Remove '.' and '..' anomalies
    num_cells=length(cell_folder_names);  
    cell_folder_names=sort_nat(cell_folder_names);
    
    for j=1:num_cells
        fdr_name=[Experiment_folder '/' stack_folder_names{i} '/' cell_folder_names{j} '/'];
        fdr_D=dir(fdr_name);
        frame_names = setdiff({fdr_D.name},{'.','..','.DS_Store'}); % remove folder anomalies and hidden files
        frame_names = sort_nat(frame_names);
        num_frames=length(frame_names);
        BigCellDataStruct(cell_num).Stack_number=i;
        BigCellDataStruct(cell_num).Cell_number=j;
        BigCellDataStruct(cell_num).Contours={};
        for k=1:num_frames
            filename = [fdr_name frame_names{k}];
    
            fid  = fopen(filename);
            xh=fgets(fid);
            datacell = textscan(fid,'%f\t%f\t%f');
            fclose(fid) ;

            data = [datacell{2},datacell{3}];

            if size(data,1) >= 3;

                        BigCellArray{end+1,1}=data(:,:);
						cbw = cleanCellBorder(BigCellArray{end,1});         %please make this step optional!!!
            			BigCellArray{end,1}=cbw;                            %please make this step optional!!!
                        BigCellDataStruct(cell_num).Contours{end+1}=BigCellArray{end,1};
            end
            
        end
        cell_indices=[cell_indices; cell_num*ones(num_frames,1)];
        cell_num=cell_num+1;
        
    end
    
end

save([Experiment_folder '/Bigcellarrayandindex.mat'], 'BigCellArray', 'cell_indices', '-v7.3')
save([Experiment_folder '/BigCellDataStruct.mat'], 'BigCellDataStruct', '-v7.3')

end

function [cs,index] = sort_nat(c,mode)
%sort_nat: Natural order sort of cell array of strings.
% usage:  [S,INDEX] = sort_nat(C)
%
% where,
%    C is a cell array (vector) of strings to be sorted.
%    S is C, sorted in natural order.
%    INDEX is the sort order such that S = C(INDEX);
%
% Natural order sorting sorts strings containing digits in a way such that
% the numerical value of the digits is taken into account.  It is
% especially useful for sorting file names containing index numbers with
% different numbers of digits.  Often, people will use leading zeros to get
% the right sort order, but with this function you don't have to do that.
% For example, if C = {'file1.txt','file2.txt','file10.txt'}, a normal sort
% will give you
%
%       {'file1.txt'  'file10.txt'  'file2.txt'}
%
% whereas, sort_nat will give you
%
%       {'file1.txt'  'file2.txt'  'file10.txt'}
%
% See also: sort

% Version: 1.4, 22 January 2011
% Author:  Douglas M. Schwarz
% Email:   dmschwarz=ieee*org, dmschwarz=urgrad*rochester*edu
% Real_email = regexprep(Email,{'=','*'},{'@','.'})


% Set default value for mode if necessary.
if nargin < 2
	mode = 'ascend';
end

% Make sure mode is either 'ascend' or 'descend'.
modes = strcmpi(mode,{'ascend','descend'});
is_descend = modes(2);
if ~any(modes)
	error('sort_nat:sortDirection',...
		'sorting direction must be ''ascend'' or ''descend''.')
end

% Replace runs of digits with '0'.
c2 = regexprep(c,'\d+','0');

% Compute char version of c2 and locations of zeros.
s1 = char(c2);
z = s1 == '0';

% Extract the runs of digits and their start and end indices.
[digruns,first,last] = regexp(c,'\d+','match','start','end');

% Create matrix of numerical values of runs of digits and a matrix of the
% number of digits in each run.
num_str = length(c);
max_len = size(s1,2);
num_val = NaN(num_str,max_len);
num_dig = NaN(num_str,max_len);
for i = 1:num_str
	num_val(i,z(i,:)) = sscanf(sprintf('%s ',digruns{i}{:}),'%f');
	num_dig(i,z(i,:)) = last{i} - first{i} + 1;
end

% Find columns that have at least one non-NaN.  Make sure activecols is a
% 1-by-n vector even if n = 0.
activecols = reshape(find(~all(isnan(num_val))),1,[]);
n = length(activecols);

% Compute which columns in the composite matrix get the numbers.
numcols = activecols + (1:2:2*n);

% Compute which columns in the composite matrix get the number of digits.
ndigcols = numcols + 1;

% Compute which columns in the composite matrix get chars.
charcols = true(1,max_len + 2*n);
charcols(numcols) = false;
charcols(ndigcols) = false;

% Create and fill composite matrix, comp.
comp = zeros(num_str,max_len + 2*n);
comp(:,charcols) = double(s1);
comp(:,numcols) = num_val(:,activecols);
comp(:,ndigcols) = num_dig(:,activecols);

% Sort rows of composite matrix and use index to sort c in ascending or
% descending order, depending on mode.
[unused,index] = sortrows(comp);
if is_descend
	index = index(end:-1:1);
end
index = reshape(index,size(c));
cs = c(index);
end



function cleanBorder= cleanCellBorder(border)

%check whether open curve without overlaps
if border(1,:) ~= border(end,:);    %check whether open curve
   C = unique(border,'rows');
   if size(C,1) == size(border,1)
       cleanBorder = [border; border(1,:)];   % close curve if not closed yet and not overlapping
   end
end   
       [C,IA,IC] = unique(border,'rows', 'first');
       pos = setdiff([1:1:size(border,1)],IA);   
       endpos = min(pos);                        % find first position of final intersection
       [C,IA,IC] = unique(border,'rows', 'last');
       pos = setdiff([1:1:size(border,1)],IA);   
       startpos = max(pos);                     % find last position of intersection
       cleanBorder = border(startpos:endpos,:); % trim curve to remove all overlaps

% check whether there is a problem with clockcheck
a=border(1,1)+1i*border(1,2);
b=border(2,1)+1i*border(2,2);
x=0.5*(a*(1-0.5*1i)+b*(1+0.5*1i));

anticlockwise=inpolygon(real(x),imag(x),border(:,1),border(:,2));

if anticlockwise

a=border(2,1)+1i*border(2,2);
b=border(1,1)+1i*border(1,2);
x=0.5*(a*(1-0.5*1i)+b*(1+0.5*1i));

anticlockwise=inpolygon(real(x),imag(x),border(:,1),border(:,2));

if anticlockwise   % only if answer is contradicting, i.e. anticlockwise in both directions, further modify the curve

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
border(idx)=[]; % filter out points that lie somewhere random in image.

maxY=max(border(:,2));
maxX=max(border(:,1));
mask = poly2mask(border(:,1), border(:,2),maxY, maxX);
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
tmp =cleanBorder;
cleanBorder=[];
cleanBorder(:,1)=tmp(:,2);
cleanBorder(:,2)=tmp(:,1);
end
end
end