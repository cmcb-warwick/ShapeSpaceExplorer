function   Run_PlotBAMvsSCORES()

config1=DataSelection();
global PATH;
PATH=config1.fpath;
if strcmp(config1.fpath, '...')==1, return; end
inputFolder =  config1.fpath;
BPath=fullfile(inputFolder, 'Figures','Validation');
if ~exist(BPath,'dir'),mkdir(BPath);end
%----------------------%
display('Files are loading ... ');
load(fullfile(inputFolder, '/CellShapeData_slim.mat'));
load(fullfile(inputFolder, '/Morphframe.mat'));
display('Files loaded ');

%%

YY=[];
ZZ=[];
train_nobs=length(morphframe);
for i=1:train_nobs
    YY=[YY; morphframe(i).Solidity morphframe(i).Dist_ratio ];
    ZZ=[ZZ; CellShapeData.set.SCORE(i,1) CellShapeData.set.SCORE(i,2)];
end
D=CellShapeData.set.Long_D;
clear('CellShapeData');
clear('morphframe');
    

DD=zeros(train_nobs,train_nobs);
DDZ=zeros(train_nobs,train_nobs);
for i=1:train_nobs
    for j=1:train_nobs
        DD(i,j)=sqrt((YY(i,1)-YY(j,1))^2 + (YY(i,2)-YY(j,2))^2);
        DDZ(i,j)=sqrt((ZZ(i,1)-ZZ(j,1))^2 + (ZZ(i,2)-ZZ(j,2))^2);
    end
end
mask=tril(ones(train_nobs,train_nobs),-1);
Y=DD(logical(mask));
clear('DD');
clear('YY');

D2=zeros(train_nobs,train_nobs);
k=1;
for j=2:train_nobs
    for i=1:(j-1)
        D2(i,j)=D(k);
        D2(j,i)=D2(i,j);
        k=k+1;
    end
end
clear('D');
X=D2(logical(mask));
clear('D2');

 p = polyfit(X,Y,1); 
 f = polyval(p,X);
h=figure(1);
reduce_plot(X,Y,'.',X,f,'-');
xlabel('BAM Diclose(h);stance')
ylabel('Solidity and DistRatio Distance')
mn=mean(Y);
dot(Y-mn,Y-mn); 
SST=var(Y)*(length(Y)-1);
SSE=dot(Y-f,Y-f);
Rsq=1-SSE/SST;
title(['Coefficient of determination (Rsq) value is  ' num2str(Rsq) ])
      fPath=fullfile(BPath, 'plot_regression_solidyratio');
      saveas(h, fPath, 'pdf');
      saveas(h, fPath, 'epsc')
close(h);


h=figure(111);
[N,xedges,yedges] = histcounts2(X,Y,[100,100]);
imagesc(xedges,yedges, N');
xlabel('BAM'); ylabel('Solidity and DistRatio Distance');
axis xy;
colormap('hot')
colorbar
      fPath=fullfile(BPath, 'plot_density_solidyratio');
      saveas(h, fPath, 'pdf');
      saveas(h, fPath, 'epsc')
hold on,
reduce_plot(X,f,'b-');
      fPath=fullfile(BPath, 'plot_density_solidyratioReg');
      saveas(h, fPath, 'pdf');
      saveas(h, fPath, 'epsc')
hold off
close(h);
clear('Y');

Z=DDZ(logical(mask));
clear('DDZ');
clear('ZZ');
clear('f');

 p = polyfit(X,Z,1); 
 ff = polyval(p,X);
h=figure(2);
reduce_plot(X,Z,'.',X,ff,'-');
mn=mean(Z);
dot(Z-mn,Z-mn); 
SST=var(Z)*(length(Z)-1);
SSE=dot(Z-ff,Z-ff);
Rsq=1-SSE/SST;
xlabel('BAM')
ylabel('SCORE Distance')
title(['Coefficient of determination (Rsq) value is  ' num2str(Rsq) ])
      fPath=fullfile(BPath, 'plot_regression_Scores');
      saveas(h, fPath, 'pdf');
      saveas(h, fPath, 'epsc');
close(h);

h=figure(222);
[N,xedges,yedges] = histcounts2(X,Z,[100,100]);
imagesc(xedges,yedges, N');
xlabel('BAM'); ylabel('SCORE Distance');
axis xy;
colormap('hot')
colorbar
fPath=fullfile(BPath, 'plot_density_Scores');
      saveas(h, fPath, 'pdf');
      saveas(h, fPath, 'epsc')
hold on,
reduce_plot(X,ff,'b-');
      fPath=fullfile(BPath, 'plot_density_ScoresReg');
      saveas(h, fPath, 'pdf');
      saveas(h, fPath, 'epsc')
close(h);

end