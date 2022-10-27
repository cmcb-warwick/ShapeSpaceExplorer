function   Run_GroupAnalysisNEW()

items = GroupMakingNEW();
groups=items;
O=char(groups{1}.path);
save(fullfile(O, 'groups.mat'), 'groups','-v7.3');
clear groups;
grFile =fullfile(O, 'groups.mat');
items=load(grFile);
%%
GM={};
for i=1:length(items.groups)
   GM=[GM; items.groups{i}.path];
    
end
GMm=unique(GM);
GroupUniqueLength=length(GMm);

%%
%----------------------%
display('Files are loading ... ');
    
    inputFolder = char(items.groups{1}.path);%path i

     load(fullfile(inputFolder, '/CellShapeData_slim.mat'));
     load(fullfile(inputFolder, '/Bigcellarrayandindex.mat'));
     load(fullfile(inputFolder, '/BigCellDataStruct.mat'));
%folder=[inputFolder '/totalanalysis'];
%destdirectory = 'C:\Documents and Settings\Pradeep\Processed';
%mkdir(folder);   %create the directory
%     
%     
 LengthEachGroup=length(BigCellDataStruct);
 %LengthEachSCORE=length(CellShapeData.set.SCORE);
 %LengthEachLONGD=length(CellShapeData.set.Long_D);
 maxStackNumber=max([BigCellDataStruct(:).Stack_number]);

 % %LONG D
%  dBAM=load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/Analysis OoSE/Dist_mat.mat');
%  [r c]=size(dBAM.D)
%  k=1;
%  for i=1:r
%      for j=1:c
%          d(k)=dBAM.D(i,j);
%          k=k+1;
%      end
%  end
%  
%             nodes=512;
%              d=d./(sqrt(nodes));
%              sig_sq=median(d);
%  
%                  for kk=1:length(d)
%                      CellShapeData.set.Long_D(end+1)=d(kk);
%                  end

if (GroupUniqueLength>1)
 for i=2:GroupUniqueLength%length(items.groups)
     inputFolder = char(items.groups{i}.path);%path i

     
      D = load(fullfile(inputFolder, '/CellShapeData_slim.mat'));
      for j=1:length(D.CellShapeData.point)
          CellShapeData.point(end+1)=D.CellShapeData.point(j);
         
      end
      for j=1:length(D.CellShapeData.set.SCORE)
          CellShapeData.set.SCORE(end+1,:)=D.CellShapeData.set.SCORE(j,:);
      end
        
% %     for k=1:length(D.CellShapeData.set.Long_D)
% %         CellShapeData.set.Long_D(end+1)=D.CellShapeData.set.Long_D(k);
% %     end
% %        
      E = load(fullfile(inputFolder, '/Bigcellarrayandindex.mat'));
      
      BigCellArray=[BigCellArray; E.BigCellArray];
      cell_indices=[cell_indices; E.cell_indices+max(cell_indices)];

        
     F = load(fullfile(inputFolder, '/BigCellDataStruct.mat'));%length(BigCellDataStruct)
    LengthEachGroup=[LengthEachGroup length(F.BigCellDataStruct)];
    BigCellDataStruct=[BigCellDataStruct, F.BigCellDataStruct];%BigCellDataStruct(2).Stack_number
%    LengthEachSCORE=[LengthEachSCORE length(D.CellShapeData.set.SCORE)];
%    LengthEachLONGD=[LengthEachLONGD length(D.CellShapeData.set.Long_D)];

      maxStackNumber=[maxStackNumber max([F.BigCellDataStruct(:).Stack_number])];
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UPDATE STACK NUMBER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  maxStackNumber(1);
  for i=2:GroupUniqueLength%length(items.groups)
      for j=LengthEachGroup(i-1)+1:LengthEachGroup(i-1)+LengthEachGroup(i)
         BigCellDataStruct(j).Stack_number=BigCellDataStruct(j).Stack_number+maxStackNumber(i-1);
      end
     
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxxx=maxStackNumber(1);
%%Create items correctly
for i=2:length(items.groups)
   
    items.groups{i}.tracks=items.groups{i}.tracks+maxxx;
  
end

end

   groups=items.groups;
  save(fullfile(O, 'groups.mat'), 'groups','-v7.3');
  
%   save(['/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/Bigcellarrayandindex.mat'],'BigCellArray', 'cell_indices', '-v7.3')   
%   save(['/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/BigCellDataStruct.mat'],'BigCellDataStruct','-v7.3')
%   save(['/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/CellShapeData.mat'],'CellShapeData','-v7.3')

 %save([folder '/BigCellDataStruct.mat'],'BigCellDataStruct','-v7.3')
 %save([folder '/CellShapeData.mat'],'CellShapeData','-v7.3')
  
%   load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/Bigcellarrayandindex.mat');
%   load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/CellShapeData.mat');
%   load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/BigCellDataStruct.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %load([folder '/CellShapeData.mat']);
    %load([folder '/BigCellDataStruct.mat']);
    %load([folder '/Bigcellarrayandindex.mat']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



display('Files loaded ');



config1 = ConstrainedClusteringNEW();

number1=config1.classes1;
number2=config1.classes2;
number = number1 * number2;
fname = ['Region_' num2str(number) '_Groups_' num2str(length(items.groups)) ];
groupPath=fullfile(inputFolder, 'Figures', 'GroupAnalysis', fname);
if ~exist(groupPath,'dir'),mkdir(groupPath);end


%load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/CellShapeData.mat');

N=length(CellShapeData.point);
% N=length(CellShapeData.set.SCORE);
% 
% if isfield(CellShapeData.set,'SCORE')
%     SCORE=CellShapeData.set.SCORE;%[CellShapeData.set.SCORE; EXT.OoSE_emb];
% else
%     for i=1:N%
%        SCORE(i,:)= CellShapeData.set(i).SCORE;
%     end
% 
% end



































%   
%  DD=CellShapeData.set.Long_D;
%  NN=length(DD)
%  nobs=uint8(0.5*(1+sqrt(1+8*NN)))
%  
%  W=ones(nobs,nobs);
%  sig_sq=(mean(DD))^2;
%  k=1;
%  p = ProgressBar(nobs);
%  for j=2:nobs
%      p.progress;
%      for i=1:(j-1)
%          W(i,j)=exp(-(DD(k).^2)./(2*sig_sq));
%          W(j,i)=W(i,j);
%          k=k+1;
%          
%      end
%  end
%  p.stop;
%  DD=[];
% %W=SCORE;
% p=median(W(:));
% 
%      w=single(W);
%      %save([folder '/double_sim_matrix.mat'],'W','-v7.3')
% %     clear('W');
%     
%      %save([folder '/single_sim_matrix.mat'],'w','-v7.3')
%      %save([folder '/pref.mat'],'p','-v7.3')
%      idx=apcluster_edit(w,0.001*p,folder);
%     
%      save([folder '/APclusterOutput.mat'],'idx','-v7.3')
% %     clear('w');
%      %load([folder '/double_sim_matrix.mat'])
% 
%  XCM=corrcoef(W);
%  V=squareform(1-XCM,'tovector');
%  linkagemat=linkage(V,'ward');
%  save([folder '/linkagemat.mat'], 'linkagemat','-v7.3')
%   load([folder '/linkagemat.mat'])
% 
% figure('visible','off')
% [~,T]=dendrogram(linkagemat,number);
% if max(T(:))<number
%     mode = struct('WindowStyle','non-modal','Interpreter','tex');
%     msg = DialogMessages(2);
%     errordlg(msg, 'Error', mode);
%     return
% end
% 
% 
% %%%%%%
% %%%%%%
% % update wish_list
% % p.stop;
%  %D=[];
% %  p=median(W(:));
% %      w=single(W);
% % 
% %     idx=apcluster_edit(W,0.001*p);
% % size(idx)
%  exems=unique(idx);
% % size(exems)
% %  size(idx);
% % size(W);
% % size(linkagemat);
% exem_idx=Corr_wish_mat( W , folder, exems );
% %T=exem_idx;
% wish_list=exems(exem_idx);
% save([folder '/wish_list.mat'], 'wish_list','-v7.3')
% %%%%%%
% 
% %load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/wish_list.mat')
% %load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/linkagemat.mat')
% % [~,T]=dendrogram(linkagemat,number);
% % if max(T(:))<number
% %     mode = struct('WindowStyle','non-modal','Interpreter','tex');
% %     msg = DialogMessages(2);
% %     errordlg(msg, 'Error', mode);
% %     return
% % end







%load('/media/mohammed/Data 2/Mohammed/CorrectedThesisData_Sam/Experiment3_MATLAB2012_eigs/wish_list.mat')
%load('/media/mohammed/Data 2/Mohammed/CorrectedThesisData_Sam/Experiment3_MATLAB2012_eigs/linkagemat.mat')


% load('/media/mohammed/Data 2/Mohammed/CorrectedThesisData_Sam/Experiment3_MATLAB2012_eigs/APclusterOutput.mat')
% A=load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/Analysis OoSE/APclusterOutput.mat');
% idx=[idx; A.idx+max(idx)];

%%%%%%%%
colourW=jet(number);
colourW=flipud(colourW);
colourW=colourW.*repmat((1-0.25*colourW(:,2)),1,3);


% %%clustering SOM
% %% clustering for each group independently
% T=ones(N,1);
%  for i=1:length(items.groups)
%      items.groups{i}.tracks;%stack numbers for group i%=items.groups{i}.tracks+maxStackNumber(i-1);
%      gIds =getAllIndicesFor(stack_indices, items.groups{i}.tracks);
%      [ii, v]=find(gIds);% v is a vector contains the indecis of elements of group i
%      A=zeros(N,1);
%      A(ii)=T(ii);
%      
%  end
 
%%


    xdata=CellShapeData.set.SCORE';
    net = selforgmap([number1 number2]);
    net = train(net,xdata);
    view(net)
    ydata = net(xdata);
    classes = vec2ind(ydata)';
    T=classes;
size(T);



%%


%dendrogram(Z)
     n = int8(100);
     figure(double(n)), scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,T)
      colormap(colourW(:,:))
      fPath=fullfile(groupPath, 'ShapeSpace_mono');
      %saveas(n, fPath, 'fig');
       h=figure(double(n));
      saveas(h, fPath, 'epsc');
      close(h)
      
     n = int8(101);
     figure(double(n)), scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,[0.5 0.5 0.5])
      h=figure(double(n));
    
     %% create contour images
      fPath=fullfile(groupPath, '_ShapeSpace_grey');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc');
      close(h)
    % CreateContourImages(T,number)
     %%
%%%%%%%%


%T=[T,cell_indices];% first column is the cluster indices, second is the cell indices

stack_indices=getStackIndices(BigCellDataStruct);

%     items.groups{1}.tracks;%stack numbers for group i%=items.groups{i}.tracks+maxStackNumber(i-1);
%     gIds1 =getAllIndicesFor(stack_indices, items.groups{1}.tracks);
%     [i, v1]=find(gIds1);% v is a vector contains the indecis of elements of group i
%     scatter(CellShapeData.set.SCORE(v1,1),CellShapeData.set.SCORE(v1,2),3,T(v1))
%     
%     items.groups{2}.tracks;%stack numbers for group i%=items.groups{i}.tracks+maxStackNumber(i-1);
%     gIds2 =getAllIndicesFor(stack_indices, items.groups{2}.tracks);
%     [i, v2]=find(gIds2);% v is a vector contains the indecis of elements of group i
%     scatter(CellShapeData.set.SCORE(v2,1),CellShapeData.set.SCORE(v2,2),3,T(v2))
%     
%         items.groups{3}.tracks;%stack numbers for group i%=items.groups{i}.tracks+maxStackNumber(i-1);
%     gIds3 =getAllIndicesFor(stack_indices, items.groups{3}.tracks);
%     [i, v3]=find(gIds3);% v is a vector contains the indecis of elements of group i
% 
%     plot(CellShapeData.set.SCORE(v3,1),CellShapeData.set.SCORE(v3,2),'group',T(v3))
    %gscatter(CellShapeData.set.SCORE(v3,1),CellShapeData.set.SCORE(v3,2),T(v3));
labels={};
groupNames={};
groupStacks={}; 
clusters= zeros(number,2);
groupPlots=zeros(number,length(items.groups));
%%

%colourW(i,:)
%%
 for i=1:length(items.groups)
     items.groups{i}.tracks;%stack numbers for group i%=items.groups{i}.tracks+maxStackNumber(i-1);
     gIds =getAllIndicesFor(stack_indices, items.groups{i}.tracks);
     [ii, v]=find(gIds);% v is a vector contains the indecis of elements of group i
     A=zeros(length(T),1);
     A(ii)=T(ii);
     search = unique(T(ii),'stable');
     size(A)
     n = i*5005;
     figure(double(n)),
     scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,[0.5 0.5 0.5])
     hold on,
   % plotdata(CellShapeData.set.SCORE(v,1),CellShapeData.set.SCORE(v,2),T(v),folder);
     %unique(T(:),'stable')
     
     
    scatter(double(CellShapeData.set.SCORE(ii,1)),double(CellShapeData.set.SCORE(ii,2)),1,T(ii));
    %set(h, 'MarkerFaceColor', colourW(search,:));
     colormap(colourW(:,:))
     %set(h,'FaceColor',colourW(search,:))  
     h=figure(double(n));
     
     fPath=fullfile(groupPath, [char(items.groups{i}.name) '_ShapeSpace_group']);
    % saveas(h, fPath, 'fig');
     saveas(h, fPath, 'epsc');
    close(h)
      hold off,
     %length(T(ii));% max number to normalize plots
    for k=1:number
       [indexv valuev]=find(T(ii)==search(k));
       
        %clusters(k,2)=sum(indexv)/length(T(ii));
        clusters(k,2)=sum(valuev);
        clusters(k,1)= search(k);
        %groupPlots(k,i)=clusters(k,2);
        groupPlots(clusters(k,1),i)=clusters(k,2);
        
        
    end
 end
 %groupPlots1=groupPlots;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %groupPlots = normc(groupPlots1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      for k=1:number
%         clusters(k,1)=k;
%         
%         
%     end
%groupPlots = groupPlots';
  for i=1:length(items.groups)
%     %%
      labels{end+1}=char(items.groups{i}.name);
%      s=size(clusters);
%     for j =1:s(1)
%         ix =clusters(j,1);
%         groupPlots(ix,i)=clusters(j,2);
%     end
     groupNames{end+1}=char(items.groups{i}.name);
     groupStacks{end+1}=getCharOf(items.groups{i}.tracks);
%     %%
% 
% 
  end
    plotClusterBars(groupPlots,labels, groupPath)
    tableFilename=fullfile(groupPath, 'GroupMapping.csv');
    writeGroups2Table(tableFilename, groupNames, groupStacks);
   hold off,
% s = size(groupPlots);
% colour=jet(s(1));...
% colour=flipud(colour);
% colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
%    
%   for i=1:length(items.groups)
%     figure,
%     %h=bar(sum(groupPlots,2));
%     h=bar(groupPlots(:,i));
%     set(h,'FaceColor',colour(i,:))
% 
%      fPath=fullfile(groupPath, [char(items.groups{i}.name) 'allClusters_barplot']);
%     % saveas(h, fPath, 'fig');
%      saveas(h, fPath, 'epsc');
%   end



%colour=jet(number);
%colour=flipud(colour);
%colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
   
%%
%         search = unique(T(i),'stable');
%        
%         
%         [indexv valuev]=find(T(i)==search(j));
%        %clusters(k,2)=sum(valuev);
%         clusters(j,1)= search(j);
%         groupPlots(clusters(j,1),i)=clusters(k,2);
%%


  for i=1:length(items.groups)
    items.groups{i}.tracks;%stack numbers for group i%=items.groups{i}.tracks+maxStackNumber(i-1);
     gIds =getAllIndicesFor(stack_indices, items.groups{i}.tracks);
     [ii, v]=find(gIds);% v is a vector contains the indecis of elements of group i
     %A=zeros(length(T),1);
     %A(ii)=T(ii);
     search = unique(T(ii),'stable');  
    figure,
    for j=1:number
%        [indexv valuev]=find(T(i)==search(j));
        clusters(j,1)= search(j);
        jj=clusters(j,1)
        h=bar(jj,groupPlots(jj,i));
        set(h,'FaceColor',colourW(jj,:))
        hold on
    end
    hold off
     fPath=fullfile(groupPath, [char(items.groups{i}.name) 'allRegions_barplot']);
     saveas(h, fPath, 'epsc');
  end  
    
    
%     h=bar(groupPlots(:,i));
%     set(h,'FaceColor',colour(i,:))
% 
%      fPath=fullfile(groupPath, [char(items.groups{i}.name) 'allClusters_barplot']);
%     % saveas(h, fPath, 'fig');
%      saveas(h, fPath, 'epsc');
%   end
% 
% 
%   %%
% 
% mMax = max(clusters(:,2));
% if isempty(mMax)||mMax<=0, mMax=1;end
% ylim([0, mMax * 1.2]);  %# The 1.2 factor is just an example
% array =[];
% for i=1:number
%     barNum=1/mClusters(i,2)*clusters(i,2);
%     h=bar(i,barNum);
%     array(end+1)=barNum;
%     %array=[array; barNum];
%     set(h,'FaceColor',colour(clusters(i,1),:))
%     hold on
% end

  
  %%
  
  
  
%item=items.groups;
% write avg speed per cluster to file.
writeAverageSpeed2File(items.groups,BigCellDataStruct,cell_indices,CellShapeData.set.SCORE,groupPath);
writePersitanceEucledianPerGroup(items.groups,BigCellDataStruct,cell_indices,CellShapeData.set.SCORE,groupPath);

%%
     h=figure(51), 
     scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,T)
     colormap(colourW(:,:))
      button = 1;
    x=[];
    y=[];
disp('Please select two regions and then right-click to find speed of cells between the regions...')
 while sum(button) <=1   % read ginputs until a mouse right-button occurs
   [a1,a2,button] = ginput(1);
   x=[x;a1];
   y=[y;a2];
 end
 
CPs=[x y];
ClickedPoints=CPs(1:2,:);
%%
IDX = knnsearch([CellShapeData.set.SCORE(:,1) CellShapeData.set.SCORE(:,2)],ClickedPoints);
T(IDX);%list of clusters to find trans. speed from/to
%%
txt1=['Region_' num2str(T(IDX(1)))];
txt2=['Region_' num2str(T(IDX(2)))];
text(ClickedPoints(1,1),ClickedPoints(1,2),txt1)
text(ClickedPoints(2,1),ClickedPoints(2,2),txt2)

     fPath=fullfile(groupPath, 'ShapespaceWithClickedClusters');
    % saveas(h, fPath, 'fig');
     saveas(h, fPath, 'epsc');
     
S=['Calculating speed from Region ' num2str(T(IDX(1))) ' to Region' num2str(T(IDX(2))) ' and vise versa ....'];
 disp(S)

[fId1, v]=find(A == T(IDX(1)));
[fId2, v]=find(A == T(IDX(2)));
CIs1=cell_indices(fId1);  % cell indices (from cell_indices) of all shapes in cluster T(IDX(1))
CIs2=cell_indices(fId2);  % cell indices (from cell_indices) of all shapes in cluster T(IDX(2))
min(CIs1);
max(CIs1);
min(CIs2);
max(CIs2);

uCIs1=sort(unique(CIs1));
uCIs2=sort(unique(CIs2));
%uCIs1=unique(CIs1);
%uCIs2=unique(CIs2);
%uCIs1=CIs1;
%uCIs2=CIs2;
% trans speed from T(1) to T(2)
d1=[];
d2=[];
k1=1;%% plot the path of the cells from one cluster to another
k2=1;%% plot the path of the cells from one cluster to another
 %n1 = int8(1011);
     figure(1), scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,[0.5 0.5 0.5])
     hold on
     h1=figure(1);
     %close(h1)
  % n2 = int8(1022);
     figure(2), scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,[0.5 0.5 0.5])
     hold on
     h2=figure(2);  
     %close(h2)
%%
%%
[fId, v]=find(A);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CIs=cell_indices(fId);%%%%%
%[fIdungrouped, v]=find(T(ii) == 0);
%CIsungrouped=cell_indices(fIdungrouped);
%uCIs=sort(unique(CIs));
for j=1:length(uCIs1)%65:65%1:length(uCIs1)%647:647%
    iD=[];
    IDD=[];
    IDDD=[];
    iD11=[];
   %     [idxes1 v]=find(CIs1==uCIs1(j));
   % iD1=fId1(idxes1(length(v)));% the index of last uCIS1(j)
   %  [idxes v]=find(CIs2==uCIs1(j));
    
     
    [idxes1, v1]=find(CIs1==uCIs1(j));
    iD1=fId1(idxes1(1));% the index of last uCIS1(j)
     [idxx, vx]=find(CIs==uCIs1(j));%%%%%%
      iD=fId(idxx);%%%%%
   %%
    stack_indices=getStackIndices(BigCellDataStruct);
    stack_indices(iD1);
    
   %%
    
    [idxes, v]=find(CIs2==uCIs1(j));
    

       if (~isempty(idxes))
           % j
       % iD2=idxes(1);% the index of last uCIS1(j)
         iD2=fId2(idxes(1));% the index of first uCIS1(j)
         stack_indices(iD2);
       % d(k)=pdist2([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]);
       
     %  if(max(fId1(idxes1)) < max(fId2(idxes)))

           if (iD1<iD2 & max(fId1(idxes1)) > max(fId2(idxes))) | (iD1>iD2 & max(fId1(idxes1)) < max(fId2(idxes)))
            else
                      if(max(fId1(idxes1)) < max(fId2(idxes)))
                                iD1=fId1(idxes1(end));
                                iD2=fId2(idxes(1));
                                iD11=[ fId1(idxes1(1:end-1)) ; fId2(idxes(2:end))];% should be changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% remove iD1 from iD
                                iD=iD(~ismember(iD,iD11));
                                IDD=iD(iD>=min(iD1,iD2) & iD<=max(iD1,iD2));
                                  if ~isempty(IDD)
                                     d1(k1)=length(IDD)-1;
                                     k1=k1+1;
                                     r=[rand rand rand];
                                     for i=1:d1(k1-1)%mm=IDD(1):IDD(end-1)
                                         mm=IDD(i);
                                         mmm=IDD(i+1);
                                        hold on,
                                         % plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]) 
                                         figure(1), plot([CellShapeData.set.SCORE(mm,1) CellShapeData.set.SCORE(mmm,1)], [CellShapeData.set.SCORE(mm,2) CellShapeData.set.SCORE(mmm,2)],'Color',r)     
                                        % hold on,
                                     end
                                  end
%                                               iD1;
%                                               iD2;
%                                               min(fId1(idxes1));
%                                               max(fId1(idxes1));
%                                               min(fId2(idxes));
%                                               max(fId2(idxes));
%                                               iD;
%                                               IDD;
%                                               BigCellDataStruct(cell_indices(iD1)).Cell_number;
%                                               stack_indices(iD1);
%                                               stack_indices(iD2);
%                                               stack_indices(iD);

                       else
                               %hold off,
                                iD1=fId1(idxes1(1));
                                iD2=fId2(idxes(end));
                                iD11=[ fId1(idxes1(2:end)) ; fId2(idxes(1:end-1))];% should be changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% remove iD1 from iD
                                iD=iD(~ismember(iD,iD11));
                                IDDD=iD(iD>=min(iD1,iD2) & iD<=max(iD1,iD2));
                                  if ~isempty(IDDD)
                                     d2(k2)=length(IDDD)-1;
                                     k2=k2+1;
                                    r=[rand rand rand];
                                     for i=1:d2(k2-1)%mm=IDD(1):IDD(end-1)
                                         mm=IDDD(i);
                                         mmm=IDDD(i+1);
                                         hold on,
                                         % plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]) 
                                        figure(2), plot([CellShapeData.set.SCORE(mm,1) CellShapeData.set.SCORE(mmm,1)], [CellShapeData.set.SCORE(mm,2) CellShapeData.set.SCORE(mmm,2)],'Color',r) 
                                       % hold on,
                                     end
                                  end  
%                                               iD1;
%                                               iD2;
%                                               min(fId1(idxes1));
%                                               max(fId1(idxes1));
%                                               min(fId2(idxes));
%                                               max(fId2(idxes));
%                                               iD;
%                                               IDDD;
%                                               BigCellDataStruct(cell_indices(iD1)).Cell_number;
%                                               stack_indices(iD1);
%                                               stack_indices(iD2);
%                                               stack_indices(iD);

                       end
           end
           hold off,
      %%%   iD11=[ fId1(idxes1(1:end-1)) ; fId2(idxes(2:end))];% should be changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% remove iD1 from iD
      %%%   iD=iD(~ismember(iD,iD11));

%%%      BigCellDataStruct(cell_indices(iD1)).Cell_number;
 %%%      length(BigCellDataStruct(cell_indices(iD1)).Contours);
  %%%      stack_indices(iD1);
   %%%        stack_indices(iD2);
    %%%        stack_indices(iD);
            %%
        %%
       %%% IDD=iD;
         %IDD=iD(iD>=min(iD1,iD2) & iD<=max(iD1,iD2));
          
       %  IDD=sort(IDD);
% % %           if ~isempty(IDD)
% % %              d(k)=length(IDD)-1;
% % %              k=k+1;
% % %              r=[rand rand rand];
% % %              for i=1:d(k-1)%mm=IDD(1):IDD(end-1)
% % %                  mm=IDD(i);
% % %                  mmm=IDD(i+1);
% % %                  hold on,
% % %                  % plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]) 
% % %                  plot([CellShapeData.set.SCORE(mm,1) CellShapeData.set.SCORE(mmm,1)], [CellShapeData.set.SCORE(mm,2) CellShapeData.set.SCORE(mmm,2)],'Color',r)     
% % %              end
% % %           end
        %%
        
%              d(k)=abs(idxes1(1)-idxes(length(v)));
%              k=k+1;
% %         for mm=min(iD1,iD2):max(iD1,iD2)
%              hold on,
%              plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]) 
% %            plot([CellShapeData.set.SCORE(mm,1) CellShapeData.set.SCORE(mm+1,1)], [CellShapeData.set.SCORE(mm,2) CellShapeData.set.SCORE(mm+1,2)],'r')     
          %end
        % hold on,
        %scatter(CellShapeData.set.SCORE(iD1,1) , CellShapeData.set.SCORE(iD1,2)) 
        % hold on,
        %scatter(CellShapeData.set.SCORE(iD2,1) , CellShapeData.set.SCORE(iD2,2)) 
     
     end
  
       
end 




fPath = fullfile(groupPath, ['Paths_from_Region_' num2str(T(IDX(1))) '_to_Region_' num2str(T(IDX(2)))]);
     saveas(h1, fPath, 'fig');
     saveas(h1, fPath, 'epsc');
    %close(h1)
hold off,

fPath = fullfile(groupPath, ['Paths_from_Region_' num2str(T(IDX(2))) '_to_Region_' num2str(T(IDX(1)))]);
     saveas(h2, fPath, 'fig');
     saveas(h2, fPath, 'epsc');
    %close(h2)
hold off,
if (~isempty(d1))
fPath = fullfile(groupPath, ['Speed_from_Region_' num2str(T(IDX(1))) '_to_Region_' num2str(T(IDX(2)))]);
figure(601), bar(d1)
     h=figure(601);
     %fPath=fullfile(groupPath, 'speed_from_to');
  %   fPath=fullfile(groupPath, [char(items.groups{i}.name) '_ShapeSpace_group']);
     saveas(h, fPath, 'fig');
     saveas(h, fPath, 'epsc');
     close(h)
end
hold off,
if (~isempty(d2))

fPath = fullfile(groupPath, ['Speed_from_Region_' num2str(T(IDX(2))) '_to_Region_' num2str(T(IDX(1)))]);
figure(602), bar(d2)
     h=figure(602);
     %fPath=fullfile(groupPath, 'speed_from_to');
  %   fPath=fullfile(groupPath, [char(items.groups{i}.name) '_ShapeSpace_group']);
     saveas(h, fPath, 'fig');
     saveas(h, fPath, 'epsc');
     close(h)
end
     
% % trans speed from T(2) to T(1)
% d
% d=[];
% k=1;
% 
%      n = int8(1013);
%      figure(double(n)), scatter(CellShapeData.set.SCORE(:,1),CellShapeData.set.SCORE(:,2),1,[0.5 0.5 0.5])
%       h=figure(double(n));
% for j=1:length(uCIs2)%321:321%
%     iD=[];
%     IDD=[];
%     iD11=[];
%     [idxes1, v1]=find(CIs2==uCIs2(j));
%     iD1=fId2(idxes1(1));% the index of last uCIS1(j)
%     
%     [idxes, v]=find(CIs1==uCIs2(j));
%     [idxx, vx]=find(CIs==uCIs2(j));%%%%%%
%       iD=fId(idxx);%%%%%
%    %%
%        if (~isempty(idxes) )
%     
%        % iD2=idxes(1);% the index of last uCIS1(j)
%          iD2=fId1(idxes(end));% the index of first uCIS1(j)
%        % d(k)=pdist2([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]);
%           
% %           if(iD1 < iD2)
% %                 iD1=fId2(idxes1(end));
% %                 iD2=fId1(idxes(1));
% %            else
% %                 iD1=fId2(idxes1(1));
% %                 iD2=fId1(idxes(end));
% %            end
%        
%        
%          iD11=[ fId2(idxes1(2:end)); fId1(idxes(1:end-1))];
%         %%
%         %  IDD=iD(iD>=min(iD1,iD2) & iD<=max(iD1,iD2));
%           %IDD=iD(idxes1(length(v1)))
%          % IDD=sort(IDD);
%           
%           
%         % iD11=[ fId1(idxes1) ; fId2(idxes)];% should be changes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% remove iD1 from iD
%          iD=iD(~ismember(iD,iD11));
%        %  iD=iD(~ismember(iD,CIsungrouped)); 
%        %  iD=[iD2 ; iD;iD1];
%     
%         %%
%            IDD=iD;%iD(iD>=min(iD1,iD2) & iD<=max(iD1,iD2));
%          %IDD=iD(iD>=min(iD1,iD2) & iD<=max(iD1,iD2));
%         % IDD=sort(IDD);
%           
%           
%           if ~isempty(IDD)
%               iD1
%               iD2
%               iD
%              d(k)=length(IDD)-1;
%              k=k+1;
%              r=[rand rand rand];
%              for i=1:d(k-1)%mm=IDD(1):IDD(end-1)
%                  mm=IDD(i);
%                  mmm=IDD(i+1);
%                  hold on,
%                  % plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]) 
%                  plot([CellShapeData.set.SCORE(mm,1) CellShapeData.set.SCORE(mmm,1)], [CellShapeData.set.SCORE(mm,2) CellShapeData.set.SCORE(mmm,2)],'Color',r) 
%                  
%              end
%           end
% 
%       end
%    
%    %%
%     
% %     if ~isempty(idxes)
% %         % iD2=idxes(1);% the index of last uCIS1(j)
% %          iD2=fId1(idxes(1));% the index of first uCIS1(j)
% %         %d(j)=pdist2([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]);
% %         d(k)= abs(idxes1(length(v1))-idxes(1));
% %         k=k+1;        
% %         for mm=min(iD1,iD2):max(iD1,iD2)
% %             hold on,
% %            % plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)]) 
% %            plot([CellShapeData.set.SCORE(mm,1) CellShapeData.set.SCORE(mm+1,1)], [CellShapeData.set.SCORE(mm,2) CellShapeData.set.SCORE(mm+1,2)],'b')     
% %         end
% %         
% %         %hold on,
% %         %plot([CellShapeData.set.SCORE(iD1,1) CellShapeData.set.SCORE(iD2,1)], [CellShapeData.set.SCORE(iD1,2) CellShapeData.set.SCORE(iD2,2)],'b')      
% %     end
% end  
% d
% fPath = fullfile(groupPath, ['Paths_from_Cluster_' num2str(T(IDX(2))) '_to_Cluster_' num2str(T(IDX(1)))]);
%      saveas(h, fPath, 'fig');
%      saveas(h, fPath, 'epsc');
% hold off,
% figure(602), bar(d)
% h=figure(602);
% fPath = fullfile(groupPath, ['Speed_from_Cluster_' num2str(T(IDX(2))) '_to_Cluster_' num2str(T(IDX(1)))]);
% %    fPath=fullfile(groupPath, 'speed_viseversa');
%   %   fPath=fullfile(groupPath, [char(items.groups{i}.name) '_ShapeSpace_group']);
%      saveas(h, fPath, 'fig');
%      saveas(h, fPath, 'epsc');
















%%

%c1 c2


% did not work as expected.
%writeSpatialAutorrelationPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath);
    






% 
% labels={};
% groupNames={};
% groupStacks={};
% %   g1 g2
% % c1
% % c2
% 
% groupPlots=zeros(number,length(items));
% for i =1: length(items)
%     item = items{i};
%     [h, h2, clusters, mClusters] = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx, T, item.tracks, N); 
% 
%     fPath=fullfile(groupPath, [char(item.name) '_ShapeSpace']);
%     saveas(h, fPath, 'fig');
%     saveas(h, fPath, 'epsc');
%     fPath=fullfile(groupPath, [char(item.name) '_ShapeSpace_mono']);
%     saveas(h2, fPath, 'fig');
%     saveas(h2, fPath, 'epsc');
%     [h, array] = plotBars(clusters,number, mClusters);
%     fPath=fullfile(groupPath, [char(item.name) '_barplot']);
%     tPath = fullfile(groupPath, [char(item.name) '_barplot.txt']);
%     saveas(h, fPath, 'fig');
%     saveas(h, fPath, 'epsc'); 
%     dlmwrite(tPath ,array, '\t');
%     labels{end+1}=char(item.name);
%     s=size(clusters);
%     
%     for j =1:s(1)
%         ix =clusters(j,1);
%         groupPlots(ix,i)=clusters(j,2);
%     end
%     groupNames{end+1}=char(item.name);
%     groupStacks{end+1}=getCharOf(item.tracks);
% end
% 
% plotClusterBars(groupPlots,labels, groupPath)
% tableFilename=fullfile(groupPath, 'GroupMapping.csv');
% writeGroups2Table(tableFilename, groupNames, groupStacks);
% 
% close all

end

function plotdata(X,Y,T,folder)

h=scatter(X,Y,3,T);
 saveas(h, folder, 'epsc');
end

%hack for dml so that it works for Matlab2012.
function writeGroups2Table(path,groupnames,groupstacks)
header='GroupNames,MovieStacks'; 
dlmwrite(path,header,'delimiter','');
s=size(groupnames);
for i=1:s(2)
    txt = [groupnames{i} ',' groupstacks(i)];
    dlmwrite(path,txt,'delimiter','', '-append');
end

end


%hack for dml so that it works for Matlab2012.
function writeGroupswithClusters2Table(path,labels, table)
header ='';
for k=1:length(labels)
    header = strcat([ header ' ,'], labels{k});
end
dlmwrite(path,header,'delimiter','');

s=size(table);
for k=1:s(1)
    line = ['Region_' num2str(k) ','];
    for j=1:s(2)
        line =strcat(line, [num2str(table(k,j)) ', ']);
    end
    dlmwrite(path,line,'delimiter','','-append');
end

end




function plotClusterBars(classess,labels, groupPath)

s = size(classess);
colour=jet(s(1));
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);

percTable=zeros(size(classess));
NORMrows=classess./sum(classess);

for i =1:s(1)
    f=figure(12);
    clf;
    fPath = fullfile(groupPath, ['Region_' num2str(i) '_barplot_count']);
    tPath = fullfile(groupPath, ['Region_' num2str(i) '_barplot_count.txt']);
    array=[];
    array = classess(i,:);
    h=bar(array);
    dlmwrite(tPath ,array, '\t');
    set(h,'FaceColor',colour(i,:))
    hold on
    set(gca, 'XTick', 1:length(array), 'XTickLabel', labels);
    saveas(h, fPath, 'fig');
    saveas(h, fPath, 'epsc');
    close(f)
    % percentual
    
    clf;
    
    fPath = fullfile(groupPath, ['Region_' num2str(i) '_barplot_fraction']);
    tPath = fullfile(groupPath, ['Region_' num2str(i) '_barplot_fraction.txt']);
    %array=classess(i,:)/sum(classess(i,:));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %array=normc(classess(i,:));
   array=NORMrows(i,:);
    percTable(i,:)=array;
    h=bar(array);
    dlmwrite(tPath ,array, '\t');
    set(h,'FaceColor',colour(i,:))
    hold on
    set(gca, 'XTick', 1:length(array), 'XTickLabel', labels);
    ylim([0 1.0]);
    saveas(h, fPath, 'fig');
    saveas(h, fPath, 'epsc'); 
    
end

tPath = fullfile(groupPath, 'Region_all_barplot_count.csv');
writeGroupswithClusters2Table(tPath, labels, classess);
tPath = fullfile(groupPath, 'Region_all_barplot_fraction.csv');
writeGroupswithClusters2Table(tPath,labels, percTable)

end


function [f,array] = plotBars(clusters,number, mClusters)
f=figure(11);
clf;

colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
mMax = max(clusters(:,2));
if isempty(mMax)||mMax<=0, mMax=1;end
ylim([0, mMax * 1.2]);  %# The 1.2 factor is just an example
array =[];
for i=1:number
    barNum=1/mClusters(i,2)*clusters(i,2);
    h=bar(i,barNum);
    array(end+1)=barNum;
    %array=[array; barNum];
    set(h,'FaceColor',colour(clusters(i,1),:))
    hold on
end

set(gca, 'XTick', 1:number, 'XTickLabel', clusters(:,1));
ylim([0 1.0]);
end



function [h, h2,clusters, mClusters] = plotGroup(BigCellDataStruct, number, wish_list, SCORE, idx,T, stacks, N)
colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
clusters= zeros(number,2);
mClusters= zeros(number,2);
% prepare T2;
n_exems=length(wish_list);
exem_list=sort(wish_list);  
for i=1:n_exems
T2(i)=T(exem_list==wish_list(i));
end
d=diff([0 T2]);
clust_order=T2(logical(d));


h=figure(10);
clf;
mk = getMarkerSize(N);
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
%    colour(clust_idx,:)
    %plot(SCORE(points,1),SCORE(points,2),'o','Color',colour(clust_idx,:), 'MarkerSize', 5)
    plot(SCORE(points,1),SCORE(points,2),'o', 'MarkerSize', 5)
    hold on
    mClusters(i,1)=clust_idx;
    mClusters(i,2)=sum(points);
end
axis tight
axis equal
grid on

%now plot the group
    stack_indices=getStackIndices(BigCellDataStruct);
    gIds =getAllIndicesFor(stack_indices, stacks);
    for i=1:number
        clust_idx=clust_order(i);
        exems=wish_list(T2==clust_idx);
        points=ismember(idx.*gIds,exems);
        clusters(i,1)=clust_idx;
        clusters(i,2)=sum(points);
        %plot(SCORE(points,1),SCORE(points,2),'.','Color',colour(clust_idx,:), 'MarkerSize', 14)
        plot(SCORE(points,1),SCORE(points,2),'.','MarkerSize', 14)
    end
    
    
    
% image in grey
h2=figure(11);
clf;
mk = getMarkerSize(N);
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    plot(SCORE(points,1),SCORE(points,2),'.','Color',[0.5,.5,.5], 'MarkerSize', mk)
    hold on
    mClusters(i,1)=clust_idx;
    mClusters(i,2)=sum(points);
end
axis tight
axis equal
grid on
%now plot the group
    stack_indices=getStackIndices(BigCellDataStruct);
    gIds =getAllIndicesFor(stack_indices, stacks);
    for i=1:number
        clust_idx=clust_order(i);
        exems=wish_list(T2==clust_idx);
        points=ismember(idx.*gIds,exems);
        clusters(i,1)=clust_idx;
        clusters(i,2)=sum(points);
       % plot(SCORE(points,1),SCORE(points,2),'.','Color',colour(clust_idx,:), 'MarkerSize', mk)
         plot(SCORE(points,1),SCORE(points,2),'.', 'MarkerSize', mk)
    end




end


function indices =getAllIndicesFor(stack_indices, stacks)
indices =zeros(size(stack_indices));
    for i=1:length(stacks)
        idx=find(stack_indices==stacks(i));
        indices(idx)=1;
    end
end




function stack_indices=getStackIndices(BigCellDataStruct)
idx=1;
stack_indices=[];
s=size(BigCellDataStruct);
for i =1:s(2)
    item = BigCellDataStruct(i);
    shapes = size(item.Contours);
    stack_indices(idx:idx+shapes(2)-1)=item.Stack_number;
    idx=idx+shapes(2);
end
stack_indices=stack_indices';
end

function counter = getMaxStackNumber(folder)
counter=-1;
file = fullfile(folder,'BigCellDataStruct.mat');
if ~exist(file, 'file')
    display(['The file "BigCellDataStruct" is not present in your Analysis folder\n' ...
             'Please check whether you followed all steps as described in the tutorial.'] );
    return
end
data = load(file);
s = size(data.BigCellDataStruct);
for i = 1:s(2)
    tmp = data.BigCellDataStruct(i);
    if tmp.Stack_number>counter
        counter=tmp.Stack_number;
    end
end
end



function d = getDistancesForId(fId, cell_indices, SCORE)
idxes=find(cell_indices==fId);
d=[];
%size(SCORE)
%max(cell_indices)
x=SCORE(idxes,1);
y=SCORE(idxes,2);
if length(x)<2, return; end
d = ones(length(x)-1, 1);
for i=2:length(x)
    d(i-1)=pdist2([x(i-1) x(i)], [y(i-1), y(i)]);
end
end


function d = getAllDistancesForId(fId, cell_indices, SCORE)
distances= getDistancesForId(fId, cell_indices, SCORE);
idxes=find(cell_indices==fId);
x=SCORE(idxes,1);
y=SCORE(idxes,2);
d ={};
if length(x)<2, return; end
d {length(distances)}=[];
for i=1:length(x)-1
    for j=i+1:length(x)
        d1=pdist2([x(i) x(j)], [y(i), y(j)]);  %direct distance
        ac=distances(i:j-1); % accumulated as cell walked in space.
        d{j-i}(end+1)=d1/sum(ac); % ratio
    end
end
end


 function allDist=getDistancesForGroup(stacks, BigCellDataStruct, cell_indices, SCORE)


allDist=[];
gIds=getIndicesForGroup(BigCellDataStruct, stacks);
cIds = sort(unique(cell_indices.*gIds));
cIds = cIds(2:end);
for i=1:length(cIds)
    fId = cIds(i);
    d = getDistancesForId(fId, cell_indices, SCORE);
allDist(end+1:end+length(d))=d;
end

end


function c =getCharOf(items)
c='';
for i=1:length(items)
    if i==1, c = [num2str(items(i))]; 
    else 
    c = [c ';' num2str(items(i))];
    end
end
end


function writeAverageSpeed2File(items,BigCellDataStruct,cell_indices,SCORE,groupPath)
s=size(items);
groups={};
avgSpeed=[];
speedStd=[];
speedStE=[];
allSpeed=[];
for i=1:s(2)
    item =items{i};
    d=getDistancesForGroup(item.tracks, BigCellDataStruct, cell_indices, SCORE);
    groups{end+1}=char(item.name);
    avgSpeed(end+1)=sum(d)/length(d);
    allSpeed(end+1:end+length(d))=d;
    speedStd(end+1)=std(d);
    speedStE(end+1)=std(d)/sqrt(length(d));
end
groups{end+1}='All';
avgSpeed(end+1)=sum(allSpeed)/length(allSpeed);
speedStd(end+1)=std(allSpeed);
speedStE(end+1)=std(allSpeed)/sqrt(length(allSpeed));
tableFilename=fullfile(groupPath, 'AvgSpeedPerGroup.csv');
%T = table(groups', avgSpeed', speedStd', speedStE');

s=size(avgSpeed);
header ={'Groups, AvgSpeed, Std, StandErr'};
dlmwrite(tableFilename,header,'delimiter','');
for i=1:s(2)
    txt = [groups{i} ', ' num2str(avgSpeed(i),'%10.15e') ', ' num2str(speedStd(i), '%10.15e') ...
            ', ' num2str(speedStE(i), '%10.15e')];
    dlmwrite(tableFilename,txt,'delimiter','', '-append');
end
end


function writePersitanceEucledianPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath)
s=size(items);
for i=1:s(2)
    item =items{i}
    pers=getDistancesEucRatioForGroup(item.tracks, BigCellDataStruct, cell_indices, SCORE);
    s=size(pers);
    pM=ones(s(2),1);
    pSt=ones(s(2),1);
    for j=1:s(2)
        tmp = pers{j};
        pM(j)=mean(tmp);
        pSt(j)=std(tmp);
    end
    h=figure(21);
    clf;
    x = 1:s(2);
    
    errorbar(x,pM,pSt, 'Color', [156/255,187/255,229/255]);
    hold on
    plot(x,pM, 'Color', [237/255 94/255 48/255], 'LineWidth', 1.5);
    fPath = fullfile(groupPath, [char(item.name) '_Directionality']);
    saveas(gcf, fPath, 'fig');
    saveas(gcf, fPath, 'epsc');
    close(h)
end 


end


function allDist=getDistancesEucRatioForGroup(stacks, BigCellDataStruct, cell_indices, SCORE)


allDist={};
gIds=getIndicesForGroup(BigCellDataStruct, stacks);
%stack_indices=getStackIndices(BigCellDataStruct);
%gIds =getAllIndicesFor(stack_indices, stacks);
cIds = sort(unique(cell_indices.*gIds));
cIds = cIds(2:end);
for i=1:length(cIds)
    fId = cIds(i);
    d=getAllDistancesForId(fId, cell_indices, SCORE);
    s1=size(d);
    s2=size(allDist);
    if s2(2)<s1(2), 
        allDist=resize(allDist, s1(2)); end
    for j=1:s1(2)
        tmp=d{j};
        allDist{j}(end+1:end+length(tmp))=tmp;
    end
end

end





function r = resize(d, num)
r={};
r{num}=[];
s=size(d);
for i=1:s(2)
    r{i}=d{i};
end
end





% function d = getAnglesForId(fId, cell_indices, SCORE)
% idxes=find(cell_indices==fId);
% d=[];
% x=SCORE(idxes,1);
% y=SCORE(idxes,2);
% if length(x)<2, return; end
% d = ones(length(x)-1, 1);
% for i=2:length(x)
%     p= polyfit([x(i-1) x(i)], [y(i-1), y(i)],1);
%     d(i-1)=atan(p(1));
% end
% end


% function d = getAllAnglesForId(fId, cell_indices, SCORE)
% angles= getAnglesForId(fId, cell_indices, SCORE);
% d ={};
% if length(angles)<2, return; end
% d {length(angles)}=[];
% for i=1:length(angles)-1
%     for j=i:length(angles)
%         y= angles(j);
%         x= angles(i);
%         a=atan2(sin(x-y), cos(x-y));
%         d{j-i+1}(end+1) = abs(cos(a));
%     end
% end
% end

% 
% function allAngles=getSpatialAutocorrelationForGroup(stacks, BigCellDataStruct, cell_indices, SCORE)
% allAngles={};
% stack_indices=getStackIndices(BigCellDataStruct);
% gIds =getAllIndicesFor(stack_indices, stacks);
% cIds = sort(unique(cell_indices.*gIds));
% cIds = cIds(2:end);
% for i=1:length(cIds)
%     fId = cIds(i);
%     d=getAllAnglesForId(fId, cell_indices, SCORE);
%     s1=size(d);
%     s2=size(allAngles);
%     if s2(2)<s1(2), 
%         allAngles=resize(allAngles, s1(2)); end
%     for j=1:s1(2)
%         tmp=d{j};
%         allAngles{j}(end+1:end+length(tmp))=tmp;
%     end
% end
% 
% end



% function writeSpatialAutorrelationPerGroup(items,BigCellDataStruct,cell_indices,SCORE,groupPath)
% s=size(items);
% for i=1:s(2)
%     item =items{i};
%     pers=getSpatialAutocorrelationForGroup(item.tracks, BigCellDataStruct, cell_indices, SCORE);
%     s=size(pers);
%     pM=ones(s(2),1);
%     pSt=ones(s(2),1);
%     for j=1:s(2)
%         tmp = pers{j};
%         pM(j)=mean(tmp);
%         pSt(j)=std(tmp);
%     end
%     figure(25);
%     clf;
%     x = 1:s(2);
%     errorbar(x,pM,pSt, 'Color', [156/255,187/255,229/255]);
%     hold on
%     plot(x,pM, 'Color', [237/255 94/255 48/255], 'LineWidth', 1.5);
%     
%     ePath = fullfile(groupPath, [char(item.name) '_Persitence_SpatialAutocorrelation.eps']);
%     fPath = fullfile(groupPath, [char(item.name) '_Persitence_SpatialAutocorrelation.fig']);
%     savefig(gcf,fPath);
%     saveas(gcf, ePath, 'epsc'); 
% end 
% 
% 
% end
function [idx,netsim,dpsim,expref]=apcluster_edit(s,p,savedestination,varargin)
if nargin==0, % display demo
	fprintf('Affinity Propagation (APCLUSTER) sample/demo code\n\n');
	fprintf('N=100; x=rand(N,2); % Create N, 2-D data points\n');
	fprintf('M=N*N-N; s=zeros(M,3); % Make ALL N^2-N similarities\n');
	fprintf('j=1;\n');
	fprintf('for i=1:N\n');
	fprintf('  for k=[1:i-1,i+1:N]\n');
	fprintf('    s(j,1)=i; s(j,2)=k; s(j,3)=-sum((x(i,:)-x(k,:)).^2);\n');
	fprintf('    j=j+1;\n');
	fprintf('  end;\n');
	fprintf('end;\n');
	fprintf('p=median(s(:,3)); % Set preference to median similarity\n');
	fprintf('[idx,netsim,dpsim,expref]=apcluster(s,p,''plot'');\n');
	fprintf('fprintf(''Number of clusters: %%d\\n'',length(unique(idx)));\n');
	fprintf('fprintf(''Fitness (net similarity): %%g\\n'',netsim);\n');
	fprintf('figure; % Make a figures showing the data and the clusters\n');
	fprintf('for i=unique(idx)''\n');
	fprintf('  ii=find(idx==i); h=plot(x(ii,1),x(ii,2),''o''); hold on;\n');
	fprintf('  col=rand(1,3); set(h,''Color'',col,''MarkerFaceColor'',col);\n');
	fprintf('  xi1=x(i,1)*ones(size(ii)); xi2=x(i,2)*ones(size(ii)); \n');
	fprintf('  line([x(ii,1),xi1]'',[x(ii,2),xi2]'',''Color'',col);\n');
	fprintf('end;\n');
	fprintf('axis equal tight;\n\n');
	return;
end;
start = clock;
% Handle arguments to function
if nargin<2 error('Too few input arguments');
else
    maxits=1000; convits=100; lam=0.9; plt=0; details=0; nonoise=0;
    i=1;
    while i<=length(varargin)
        if strcmp(varargin{i},'plot')
            plt=1; i=i+1;
        elseif strcmp(varargin{i},'details')
            details=1; i=i+1;
		elseif strcmp(varargin{i},'sparse')
% 			[idx,netsim,dpsim,expref]=apcluster_sparse(s,p,varargin{:});
			fprintf('''sparse'' argument no longer supported; see website for additional software\n\n');
			return;
        elseif strcmp(varargin{i},'nonoise')
            nonoise=1; i=i+1;
        elseif strcmp(varargin{i},'maxits')
            maxits=varargin{i+1};
            i=i+2;
            if maxits<=0 error('maxits must be a positive integer'); end;
        elseif strcmp(varargin{i},'convits')
            convits=varargin{i+1};
            i=i+2;
            if convits<=0 error('convits must be a positive integer'); end;
        elseif strcmp(varargin{i},'dampfact')
            lam=varargin{i+1};
            i=i+2;
            if (lam<0.5)||(lam>=1)
                error('dampfact must be >= 0.5 and < 1');
            end;
        else i=i+1;
        end;
    end;
end;
if lam>0.9
    fprintf('\n*** Warning: Large damping factor in use. Turn on plotting\n');
    fprintf('    to monitor the net similarity. The algorithm will\n');
    fprintf('    change decisions slowly, so consider using a larger value\n');
    fprintf('    of convits.\n\n');
end;

% Check that standard arguments are consistent in size
if length(size(s))~=2 error('s should be a 2D matrix');
elseif length(size(p))>2 error('p should be a vector or a scalar');
elseif size(s,2)==3
    tmp=max(max(s(:,1)),max(s(:,2)));
    if length(p)==1 N=tmp; else N=length(p); end;
    if tmp>N
        error('data point index exceeds number of data points');
    elseif min(min(s(:,1)),min(s(:,2)))<=0
        error('data point indices must be >= 1');
    end;
elseif size(s,1)==size(s,2)
    N=size(s,1);
    if (length(p)~=N)&&(length(p)~=1)
        error('p should be scalar or a vector of size N');
    end;
else error('s must have 3 columns or be square'); end;

% Construct similarity matrix
if N>3000
    fprintf('\n*** Warning: Large memory request. Consider activating\n');
    fprintf('    the sparse version of APCLUSTER.\n\n');
end;
if size(s,2)==3 && size(s,1)~=3,
    S=-Inf*ones(N,N,class(s)); 
    for j=1:size(s,1), S(s(j,1),s(j,2))=s(j,3); end;
else S=s; s=s(1,2);
end;

if S==S', symmetric=true; else symmetric=false; end;
realmin_=realmin(class(s)); realmax_=realmax(class(s));

% In case user did not remove degeneracies from the input similarities,
% avoid degenerate solutions by adding a small amount of noise to the
% input similarities
if ~nonoise
    rns=randn('state'); randn('state',0);
    S=S+(eps*S+realmin_*100).*rand(N,N);
    randn('state',rns);
end;

% Place preferences on the diagonal of S
if length(p)==1 for i=1:N S(i,i)=p; end;
else for i=1:N S(i,i)=p(i); end;
end;

% Numerical stability -- replace -INF with -realmax
n=find(S<-realmax_); if ~isempty(n), warning('-INF similarities detected; changing to -REALMAX to ensure numerical stability'); S(n)=-realmax_; end; clear('n');
if ~isempty(find(S>realmax_,1)), error('+INF similarities detected; change to a large positive value (but smaller than +REALMAX)'); end;


% Allocate space for messages, etc
%dS=diag(S);
A=zeros(N,N,class(s));
R=zeros(N,N,class(s)); t=1;
% if plt, netsim=zeros(1,maxits+1); end;
% if details
%     idx=zeros(N,maxits+1);
%     netsim=zeros(1,maxits+1); 
%     dpsim=zeros(1,maxits+1); 
%     expref=zeros(1,maxits+1); 
% end;

% Execute parallel affinity propagation updates
e=zeros(N,convits); dn=0; i=0;
if symmetric, ST=S; else 
    ST=S';
    S=[];
end; % saves memory if it's symmetric
NN = 10000; % this is an arbitrary number
p = ProgressBar(NN);
while ~dn
    i=i+1; 
    % Compute responsibilities
	A=A';
    R=R';
    p.progress; 
	for ii=1:N,
		old = R(:,ii);
		AS = A(:,ii) + ST(:,ii);
        [Y,I]=max(AS);
        AS(I)=-Inf;
		Y2=max(AS);
        RS=ST(:,ii)-Y;
        STS=ST(:,ii);
        RS(I)=STS(I)-Y2;
        RS=(1-lam)*RS+lam*old;% Damping
        RS(RS>realmax_)=realmax_;
        R(:,ii)=RS;
	end;
	A=A'; R=R';

    % Compute availabilities
	for jj=1:N,
		old = A(:,jj);
		Rp = max(R(:,jj),0); Rp(jj)=R(jj,jj);
		A(:,jj) = sum(Rp)-Rp;
		dA = A(jj,jj); A(:,jj) = min(A(:,jj),0); A(jj,jj) = dA;
		A(:,jj) = (1-lam)*A(:,jj) + lam*old; % Damping
	end;
	
    % Check for convergence
    E=((diag(A)+diag(R))>0); e(:,mod(i-1,convits)+1)=E; K=sum(E);
    if i>=convits || i>=maxits,
        se=sum(e,2);
        unconverged=(sum((se==convits)+(se==0))~=N);
        if (~unconverged&&(K>0))||(i==maxits) dn=1; end;
    end;

    
    if details
        netsim(i)=tmpnetsim; dpsim(i)=tmpdpsim; expref(i)=tmpexpref;
        idx(:,i)=tmpidx;
    end;
    if plt,
        netsim(i)=tmpnetsim;
		figure(234);
        plot(((netsim(1:i)/10)*100)/10,'r-'); xlim([0 i]); % plot barely-finite stuff as infinite
        xlabel('# Iterations');
        ylabel('Fitness (net similarity) of quantized intermediate solution');
%         drawnow; 
    end;
    
    
end; % iterations
p.stop;
save([savedestination '/avail_mat.mat'],'A','-v7.3')
save([savedestination '/resp_mat.mat'],'R','-v7.3')
save([savedestination '/unconv'],'unconverged','-v7.3')

I=find((diag(A)+diag(R))>0); K=length(I); % Identify exemplars
A=[];
R=[];
S=ST'; ST=[];
dS=diag(S);

if K>0
    [tmp c]=max(S(:,I),[],2); c(I)=1:K; % Identify clusters
    % Refine the final set of exemplars and clusters and return results
    for k=1:K ii=find(c==k); [y j]=max(sum(S(ii,ii),1)); I(k)=ii(j(1)); end; notI=reshape(setdiff(1:N,I),[],1);
    [tmp c]=max(S(:,I),[],2); c(I)=1:K; tmpidx=I(c);
	tmpdpsim=sum(S(sub2ind([N N],notI,tmpidx(notI))));
	tmpexpref=sum(dS(I));
	tmpnetsim=tmpdpsim+tmpexpref;
else
    tmpidx=nan*ones(N,1); tmpnetsim=nan; tmpexpref=nan;
end;
if details
    netsim(i+1)=tmpnetsim; netsim=netsim(1:i+1);
    dpsim(i+1)=tmpdpsim; dpsim=dpsim(1:i+1);
    expref(i+1)=tmpexpref; expref=expref(1:i+1);
    idx(:,i+1)=tmpidx; idx=idx(:,1:i+1);
else
    netsim=tmpnetsim; dpsim=tmpdpsim; expref=tmpexpref; idx=tmpidx;
end;

if plt||details
    fprintf('\nNumber of exemplars identified: %d  (for %d data points)\n',K,N);
    fprintf('Net similarity: %g\n',tmpnetsim);
    fprintf('  Similarities of data points to exemplars: %g\n',dpsim(end));
    fprintf('  Preferences of selected exemplars: %g\n',tmpexpref);
    fprintf('Number of iterations: %d\n\n',i);
	fprintf('Elapsed time: %g sec\n',etime(clock,start));
end;
if unconverged
	fprintf('\n*** Warning: Algorithm did not converge. Activate plotting\n');
	fprintf('    so that you can monitor the net similarity. Consider\n');
	fprintf('    increasing maxits and convits, and, if oscillations occur\n');
	fprintf('    also increasing dampfact.\n\n');
end;
end

function [ p ] = Corr_wish_mat( W, savedestination, varargin )
%CORR_WISH_MAT Summary of this function goes here
%   Detailed explanation goes here
if length(varargin)>0
    W=W(:,varargin{1});
end
    

XCM=corrcoef(W);
imshow(XCM,[])
[~,p]=wishart_seriation(1-XCM, savedestination );
imshow(XCM(p,p),[])

end

function [ CM,p ] = wishart_seriation( dCorrMat, savedestination )
%WISHART_SERIATION Summary of this function goes here
%   Detailed explanation goes here
%V=squareform(dCorrMat,'tovector');
%linkagemat=linkage(V,'ward');
%save([savedestination '/linkagemat.mat'], 'linkagemat','-v7.3')
L=size(dCorrMat,1);
t=diag(ones(1,L));
P=bwdist(t,'cityblock');
 load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/totalanalysis/linkagemat.mat')
%c = cluster(linkagemat,'maxclust',2:L);
[~,~,p]=dendrogram(linkagemat,0);
close

%CM=CorrMat(p,p);
A=zeros(L,L);
for i=p
    [~,I]=sort(dCorrMat(i,p),'ascend');
    A(i,:)=I-1;
end
F=A.*P;
f=sum(F(:));
count=0;
improved=true;
while improved
    improved=false;
    for i=1:(L-1)
        T=linkagemat(i,[1 2]);
        a=T(1);
        b=T(2);
        while sum(a>L)>0
            ind=a>L;
            ind_plus=cumsum(ind);
            a2=[];
            for j=1:length(a)
                a2(j+ind_plus(j))=a(j);
                if ind(j)
                    a2(j+ind_plus(j)-1)=linkagemat(a(j)-L,1);
                    a2(j+ind_plus(j))=linkagemat(a(j)-L,2);
                end
            end
            a=a2;
        end

        while sum(b>L)>0
           ind=b>L;
            ind_plus=cumsum(ind);
            b2=[];
            for j=1:length(b)
                b2(j+ind_plus(j))=b(j);
                if ind(j)
                    b2(j+ind_plus(j)-1)=linkagemat(b(j)-L,1);
                    b2(j+ind_plus(j))=linkagemat(b(j)-L,2);
                end
            end
            b=b2;
        end

        p_ab=ismember(p,union(a,b));
        p_star=p;
        if max(bwlabel(p_ab))>1
           what 
        end

        p_star(p_ab)=fliplr(p(p_ab));
        
        A_star=zeros(L,L);
        for j=p_star
            [~,I]=sort(dCorrMat(j,p_star),'ascend');
            A_star(j,:)=I-1;
        end
        F_star=A_star.*P;
        f_star=sum(F_star(:));
        
        if f_star<f
            p=p_star;
            f=f_star;
            improved=true;
        end
    end
    count=count+1;
end
CM=dCorrMat(p,p);


end



















% 
% function [ p ] = Corr_wish_mat( W, linkagemat, varargin )
% %CORR_WISH_MAT Summary of this function goes here
% %   Detailed explanation goes here
% % if length(varargin)>0
% %     W=W(:,varargin{1});
% % end
%     
% 
% XCM=corrcoef(W);
% imshow(XCM,[])
% [~,p]=wishart_seriation(1-XCM , linkagemat);
% imshow(XCM(p,p),[])
% 
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% function [ CM,p ] = wishart_seriation( dCorrMat,linkagemat  )
% %WISHART_SERIATION Summary of this function goes here
% %   Detailed explanation goes here
% 
% L=size(dCorrMat,1);
% t=diag(ones(1,L));
% P=bwdist(t,'cityblock');
% 
% %c = cluster(linkagemat,'maxclust',2:L);
% [~,~,p]=dendrogram(linkagemat,0);
% close
% 
% %CM=CorrMat(p,p);
% A=zeros(L,L);
% for i=p
%     [~,I]=sort(dCorrMat(i,p),'ascend');
%     A(i,:)=I-1;
% end
% F=A.*P;
% f=sum(F(:));
% count=0;
% improved=true;
% while improved
%     improved=false;
%     for i=1:(L-1)
%         T=linkagemat(i,[1 2]);
%         a=T(1);
%         b=T(2);
%         while sum(a>L)>0
%             ind=a>L;
%             ind_plus=cumsum(ind);
%             a2=[];
%             for j=1:length(a)
%                 a2(j+ind_plus(j))=a(j);
%                 if ind(j)
%                     a2(j+ind_plus(j)-1)=linkagemat(a(j)-L,1);
%                     a2(j+ind_plus(j))=linkagemat(a(j)-L,2);
%                 end
%             end
%             a=a2;
%         end
% 
%         while sum(b>L)>0
%            ind=b>L;
%             ind_plus=cumsum(ind);
%             b2=[];
%             for j=1:length(b)
%                 b2(j+ind_plus(j))=b(j);
%                 if ind(j)
%                     b2(j+ind_plus(j)-1)=linkagemat(b(j)-L,1);
%                     b2(j+ind_plus(j))=linkagemat(b(j)-L,2);
%                 end
%             end
%             b=b2;
%         end
% 
%         p_ab=ismember(p,union(a,b));
%         p_star=p;
%         if max(bwlabel(p_ab))>1
%            what 
%         end
% 
%         p_star(p_ab)=fliplr(p(p_ab));
%         
%         A_star=zeros(L,L);
%         for j=p_star
%             [~,I]=sort(dCorrMat(j,p_star),'ascend');
%             A_star(j,:)=I-1;
%         end
%         F_star=A_star.*P;
%         f_star=sum(F_star(:));
%         
%         if f_star<f
%             p=p_star;
%             f=f_star;
%             improved=true;
%         end
%     end
%     count=count+1;
% end
% CM=dCorrMat(p,p);
% 
% 
% end
