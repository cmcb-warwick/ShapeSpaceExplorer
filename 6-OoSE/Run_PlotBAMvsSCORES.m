function   Run_PlotBAMvsSCORES()

path=OoseConfig();
try if isempty(path.anaFolder) || isempty(path.OosFolder)||...
    strcmp(path.anaFolder,path.OosFolder)==1 ||...
    ~exist(path.anaFolder, 'dir') || ~exist(path.OosFolder, 'dir')
    return;
    end
catch
    return;
end

BPath=fullfile(path.anaFolder, 'Figures','Validation');
if ~exist(BPath,'dir'),mkdir(BPath);end
%----------------------%
display('Files are loading ... ');
load(fullfile(path.anaFolder, '/CellShapeData.mat'));
load(fullfile(path.anaFolder, '/Morphframe.mat'));
load(fullfile(path.OosFolder, '/Dist_mat.mat'));
display('Files loaded ');

%%

colourW=jet(6);
colourW=flipud(colourW);
colourW=colourW.*repmat((1-0.25*colourW(:,2)),1,3);
YY=[];
ZZ=[];
for i=1:length(morphframe)
    YY=[YY; morphframe(i).Solidity morphframe(i).Dist_ratio ];
    ZZ=[ZZ; CellShapeData.set.SCORE(i,1) CellShapeData.set.SCORE(i,2)];
end
% xdata=YY';
%     net = selforgmap([3 2]);
%     net = train(net,xdata);
%     view(net)
%     ydata = net(xdata);
%     classes = vec2ind(ydata)';
%     T=classes;
   
%% clustering using AP
%[ wish_list, idx ] = AP_Seriation_analysis_finaledit(CellShapeData.set.Long_D, 1, BPath);
%%
    
xdata=ZZ';
    net = selforgmap([3 2]);
    net = train(net,xdata);
    view(net)
    ydata = net(xdata);
    classes = vec2ind(ydata)';
    T=classes;
h=figure(22222);
scatter(ZZ(:,1) ,ZZ(:,2),1,T)
colormap(colourW(:,:))
      fPath=fullfile(BPath, 'plot_Scores');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc');
h=figure(11111);
scatter(YY(:,2) ,YY(:,1),1,T)
colormap(colourW(:,:))
      fPath=fullfile(BPath, 'plot_solidyratio');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')
% %%
% X=triu(D);
% %X=nonzeros(triu(X));
% X=X(:);
%%
YY=[];
ZZ=[];
for i=1:length(morphframe)
    YY=[YY; morphframe(i).Solidity morphframe(i).Dist_ratio ];%morphframe(i).Area   morphframe(i).MajorAxisLength  morphframe(i).MinorAxisLength    morphframe(i).Eccentricity   morphframe(i).Orientation  morphframe(i).ConvexArea   morphframe(i).FilledArea  morphframe(i).EquivDiameter   morphframe(i).Extent  morphframe(i).Perimeter   morphframe(i).Circularity   morphframe(i).Dist_max   morphframe(i).Dist_min   morphframe(i).Dist_ratio   morphframe(i).Irregularity  morphframe(i).Irregularity2   morphframe(i).Symmetry        ];
    ZZ=[ZZ; CellShapeData.set.SCORE(i,1) CellShapeData.set.SCORE(i,2)];
end

%%
train_nobs=length(morphframe);
DD=zeros(train_nobs,train_nobs);
DDZ=zeros(train_nobs,train_nobs);
for i=1:train_nobs
    for j=1:train_nobs
        DD(i,j)=sqrt((YY(i,1)-YY(j,1))^2 + (YY(i,2)-YY(j,2))^2);
        DDZ(i,j)=sqrt((ZZ(i,1)-ZZ(j,1))^2 + (ZZ(i,2)-ZZ(j,2))^2);
    end
    
    
end
%Y=triu(DD);
mask=tril(ones(train_nobs,train_nobs),-1);
%mask=triu(ones(train_nobs,train_nobs),-1);
%mask = tril(true(size(mask)),-1);
Y=DD(logical(mask));
Z=DDZ(logical(mask));
%Y=nonzeros(triu(Y));
%Y=Y(:);
X=D(logical(mask));
 p = polyfit(X,Y,1); 
 f = polyval(p,X);
h=figure(1);
reduce_plot(X,Y,'.',X,f,'-');
%figure(1), plot(X,Y,'.',X,f,'-') 
%figure(1),reduce_plot(X,Y,'.');
xlabel('BAM Distance')
ylabel('Solidity and DistRatio Distance')
mn=mean(Y);
dot(Y-mn,Y-mn); 
SST=var(Y)*(length(Y)-1);
SSE=dot(Y-f,Y-f);
Rsq=1-SSE/SST;
title(['Coefficient of determination (Rsq) value is  ' num2str(Rsq) ])
      fPath=fullfile(BPath, 'plot_regression_solidyratio');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')
 p = polyfit(X,Z,1); 
 ff = polyval(p,X);
h=figure(2);
reduce_plot(X,Z,'.',X,ff,'-');
mn=mean(Z);
dot(Z-mn,Z-mn); 
SST=var(Z)*(length(Z)-1);
SSE=dot(Z-ff,Z-ff);
Rsq=1-SSE/SST;
%figure(2), reduce_plot(X,Z,'.',X,f,'-') 
%figure(2),reduce_plot(X,Z,'.');
xlabel('BAM Distance')
ylabel('SCORE Distance')
title(['  Coefficient of determination (Rsq) value is  ' num2str(Rsq) ])
      fPath=fullfile(BPath, 'plot_regression_Scores');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')

%X=X(:);
h=figure(11);
hist3([X Y],[100 100])
xlabel('BAM Distance'); ylabel('Solidity and DistRatio Distance');
s = findobj(gca,'Type','Surface');
s.FaceAlpha = 0.75;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto','EdgeColor','none');
colormap('hot')
colorbar
view(2)
      fPath=fullfile(BPath, 'plot_density_solidyratio');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')
      
h=figure(22);
hist3([X Z],[100 100])

xlabel('BAM Distance'); ylabel('SCORE Distance');
s = findobj(gca,'Type','Surface');
s.FaceAlpha = 0.75;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto','EdgeColor','none');
colormap('hot')
colorbar
view(2)
      fPath=fullfile(BPath, 'plot_density_Scores');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')
      
%%
h=figure(111);
hist3([X Y],[100 100])
xlabel('BAM Distance'); ylabel('Solidity and DistRatio Distance');
s = findobj(gca,'Type','Surface');
s.FaceAlpha = 0.75;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto','EdgeColor','interp');
colormap('hot')
colorbar
caxis([0 2000000])
view(2)

hold on,
reduce_plot(X,f,'b-');
      fPath=fullfile(BPath, 'plot_density_solidyratioReg');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')
hold off,      
h=figure(222);
hist3([X Z],[100 100])

xlabel('BAM Distance'); ylabel('SCORE Distance');
s = findobj(gca,'Type','Surface');
s.FaceAlpha = 0.75;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto','EdgeColor','interp');
colormap('hot')
colorbar
caxis([0 2000000])
view(2)
hold on,
reduce_plot(X,ff,'b-');
      fPath=fullfile(BPath, 'plot_density_ScoresReg');
      %saveas(n, fPath, 'fig');
      saveas(h, fPath, 'epsc')
%%
% %%
% %%
% %Y=vecnorm(Y,2,2);
% X=vecnorm(CellShapeData.set.SCORE,2,2);
% n = int8(1);
% figure(double(n)), scatter(X,Y,'.')
% h=figure(double(n));
% xlabel('Shape Features SCORES (euclidean norm)')
% ylabel('solidity')
%       %% plot normalized data
% %       X1 = (D-min(D(:))) ./ (max(D(:)-min(D(:))));
% %       X=mean(X1,2);
% %       Y1 = (CellShapeData.set.SCORE-min(CellShapeData.set.SCORE(:))) ./ (max(CellShapeData.set.SCORE(:)-min(CellShapeData.set.SCORE(:))));
% %       Y=mean(Y1,2);
% %       figure, scatter(X,Y,'.')
%       %%vecnorm(a,2,2)


% %%
% load('/media/mohammed/Data 2/Mohammed/straubelabshapeproject/plot BAM vs SCORES/Morphframe.mat')
% YY=[];
% ZZ=[];
% for i=1:length(morphframe)
%     YY=[YY; morphframe(i).Solidity morphframe(i).Dist_ratio ];
% end
% xdata=YY';
%     net = selforgmap([3 2]);
%     net = train(net,xdata);
%     view(net)
%     ydata = net(xdata);
%     classes = vec2ind(ydata)';
%     T=classes;
% figure(1), scatter(YY(:,2) ,YY(:,1),1,T)
% %%

end