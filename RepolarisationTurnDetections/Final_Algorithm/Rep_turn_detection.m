function [ performance_out,perf_mat ] = Rep_turn_detection( varargin)
%CELLTRACKVIEWER Summary of this function goes here
%   Detailed explanation goes here

%model needs to be an hmm model

%ploton is about plotting, set to 0 for no plots, 1 for CoM plots, 2 for CoM and DM plots

%optional input for plotting only, not analysis. This selects only
%certain cells to be plotted, if it's numeric it should be a list of cell
%numbers, if it's a string it should correspond to one of the follow:
%-'perfect': cells with perfect turn score and straight score
%-'vac_perf': vacuously perfect cell tracks: no turns identified & straight.
%-'wobbly': straight score <1
%-'big_green_blob': a long (>8) section of green (and connected yellow and blue)
%-'wrong_turns': turns identified, angle too low.

load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/NecessaryData/cellarrayandindex.mat')
load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/NecessaryData/refinedSCORE.mat')
load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/NecessaryData/corrected_CoM.mat')
load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/NecessaryData/corners_attempt1.mat')
%load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/first_working_hmm_model')
%load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/pmtk_SJanalysis/model_g10.mat')

L=length(NewCellArray);
%model2=model_g;

test_set=1:440;

warning off
ploton=2;
model=gen_hmm_model4_design2(0);

L2=length(test_set);
perfect=zeros(L2,1);
wobbly=zeros(L2,1);
vac_perf=zeros(L2,1);
%big_green_blob=false(440,1);
wrong_turn=zeros(L2,1);
for i=1:L2
    DM_path=(10^7)*SCORE(cell_idx==test_set(i),1:2)';
    logp(i)=hmmLogprob(model,DM_path);
    path{i}=hmmMap(model,DM_path);
    looong(i)=length(path{i});
    [class(i),perf_score(i),turn_score(i),straight_score(i),first_point{i},before_point{i},last_point{i},after_point{i},first_point_glob{i},before_point_glob{i},last_point_glob{i},after_point_glob{i},Output_classes{i}] = model_perf(com(cell_idx==test_set(i),:)', path{i});
    perfect(i)=class(i).perfect;
    vac_perf(i)=class(i).vac_perfect;
    wobbly(i)=class(i).wobbly;
    %big_green_blob(i)=class(i).big_green_blob;
    wrong_turn(i)=class(i).wrong_turns;
end
c=[-2.439757234828432  -4.708850661445092];
p_score=logp-(c(1)*looong+c(2));
%[slogp,high_idx]=sort(p_score,'descend');
[~,high_idx]=sort(perf_score,'descend');

performance_out.perfect=sum(perfect);
performance_out.vac_perf=sum(vac_perf);
performance_out.wobbly=sum(wobbly);
% performance_out.big_green_blob=sum(big_green_blob);
performance_out.wrong_turn=sum(wrong_turn);
perf_mat=[perfect vac_perf wobbly wrong_turn];


% for i=1:size(SCORE,2)
%     M(i)=max(SCORE(:,i));
%     m(i)=min(SCORE(:,i));
% end
% if ~isempty(varargin)
%         view_list=find(ismember(cell_idx,varargin{1}));
%         view_list=view_list(:)';
% else
%     view_list=find(ismember(cell_idx,1:440));
%     view_list=view_list(:)';
% end
% view_list=[];
% cell_idx2=cell_idx;
% if ~isempty(varargin)
%     if isnumeric(varargin{1})
%         cell_idx2(~ismember(cell_idx,varargin{1}))=0;
%     else
%         switch varargin{1}
%             case 'perfect'
%                 cell_idx2(~ismember(cell_idx,test_set(logical(perfect))))=0;
%             case 'vac_perf'
%                 cell_idx2(~ismember(cell_idx,test_set(logical(vac_perf))))=0;
%             case 'wobbly'
%                 cell_idx2(~ismember(cell_idx,test_set(logical(wobbly))))=0;
%                 %                 case 'big_green_blob'
%                 %                     cell_idx2(~ismember(cell_idx,find(logical(big_green_blob))))=0;
%             case 'wrong_turn'
%                 cell_idx2(~ismember(cell_idx,test_set(logical(wrong_turn))))=0;
%             otherwise
%                 error('Not accepted input')
%         end
%     end
% end
% for i=1:L2
%     view_list=[view_list find(cell_idx2==test_set(i))'];
% end
% 
% cell_idx(end+1)=0;
hax=figure('units','normalized','outerposition',[0 0 1 1]);
if ~isempty(varargin)
    cellnum=varargin{1};
else
    cellnum=test_set(1);
end


plotstuff_init(cellnum,cell_idx,test_set,Output_classes,NewCellArray,class,hax)

end

function [class,perf_score,turn_score,straight_score,first_point,before_point,last_point,after_point,first_point_glob,before_point_glob,last_point_glob,after_point_glob,Output_classes] = model_perf(com_path, hmm_path )

path=hmm_path;


%Turn Score
blue_bits=path==4;
blue_bits=bwlabel(blue_bits);
num_blue=max(blue_bits);
for i=1:num_blue
    first=find(blue_bits==i,1,'first');
    last=find(blue_bits==i,1,'last');
    if first==1
        blue_bits(blue_bits==i)=0;
        continue
    elseif path(first-1)~=2
        blue_bits(blue_bits==i)=0;
        continue
    end
    
    if last==length(path)
        blue_bits(blue_bits==i)=0;
        continue
    elseif path(last+1)~=1
        blue_bits(blue_bits==i)=0;
        continue
    end
end

blue_bits=bwlabel(logical(blue_bits));
num_blue=max(blue_bits);
first_point=zeros(2,num_blue);
before_point=zeros(2,num_blue);
last_point=zeros(2,num_blue);
after_point=zeros(2,num_blue);
first_point_glob=zeros(2,num_blue);
before_point_glob=zeros(2,num_blue);
last_point_glob=zeros(2,num_blue);
after_point_glob=zeros(2,num_blue);

% %average +/- 7
% 
% for i=1:num_blue
%     first=find(blue_bits==i, 1,'first');
%     last=find(blue_bits==i,1,'last');
%     before_chunk=(max(1,first-7)):(first-1);
%     after_chunk=(last+1):min(length(path),last+7);
%     first_point(:,i)=com_path(:,first);
%     before_point(:,i)=mean(com_path(:,before_chunk),2);
%     last_point(:,i)=com_path(:,last);
%     after_point(:,i)=mean(com_path(:,after_chunk),2);
%     angles(i)=abs(anglefinder(first_point(1,i),first_point(2,i),before_point(1,i),before_point(2,i),last_point(1,i),last_point(2,i),after_point(1,i),after_point(2,i)));
% end

%LOCAL
last_prev=1;

for i=1:num_blue
    
    first=find(blue_bits==i, 1,'first');
    last=find(blue_bits==i,1,'last');
    
    if i==num_blue
        first_next=length(path);
    else
        first_next=find(blue_bits==i+1,1,'first');
    end
    
    before_chunk=(max(last_prev,first-10)):(max(last_prev,first-6));
    after_chunk=min(first_next,last+6):min(first_next,last+10);
    
    first_point(:,i)=com_path(:,first);
    before_point(:,i)=mean(com_path(:,before_chunk),2);
    last_point(:,i)=com_path(:,last);
    after_point(:,i)=mean(com_path(:,after_chunk),2);
    
    angles(i)=abs(anglefinder(first_point(1,i),first_point(2,i),before_point(1,i),before_point(2,i),last_point(1,i),last_point(2,i),after_point(1,i),after_point(2,i)));
    
    last_prev=last;
end

%GLOBAL
blue_bits(logical(blue_bits))=blue_bits(logical(blue_bits))+1;
blue_bits([1 end])=[1 max(blue_bits)+1];
for i=1:num_blue
    first=find(blue_bits==i+1, 1,'first');
    last=find(blue_bits==i+1,1,'last');
    before=find(blue_bits==i,1,'last');
    after=find(blue_bits==i+2, 1,'first');
    first_point_glob(:,i)=com_path(:,first);
    before_point_glob(:,i)=com_path(:,before);
    last_point_glob(:,i)=com_path(:,last);
    after_point_glob(:,i)=com_path(:,after);
    angles_glob(i)=abs(anglefinder(first_point_glob(1,i),first_point_glob(2,i),before_point_glob(1,i),before_point_glob(2,i),last_point_glob(1,i),last_point_glob(2,i),after_point_glob(1,i),after_point_glob(2,i)));
end


if num_blue==0
    turn_score=0.5;
    class.no_turns=true;
    perfect_score=0;
    wrong_turn_score=0;
else
    class.no_turns=false;
    ang=angles>=40|angles_glob>=25;
    turn_score=mean(ang);
    perfect_score=sum(ang);
    wrong_turn_score=sum(~ang);
end



% %Straight Score
% red_bits=path==1;
% red_bits=bwlabel(red_bits);
% green_bits=path==2;
% green_bits=bwlabel(green_bits);
% [str_labs,~,straight_bits]=unique(red_bits+1000*green_bits);

straight_bits=logical(blue_bits);
straight_bits([1 end])=[false false];
straight_bits=~straight_bits;
straight_bits=bwlabel(straight_bits);
[str_labs,~,straight_bits]=unique(straight_bits);
if str_labs(1)==0
    straight_bits=straight_bits-1;
end
num_straight=max(straight_bits);
for i=1:num_straight
    stretch=com_path(:,straight_bits==i);
    p=polyfit(stretch(1,:),stretch(2,:),1);
    gr=atan(p(1));
    int=p(2);
    R=[cos(-gr) -sin(-gr); sin(-gr) cos(-gr)];
    
    
    stretch(2,:)=stretch(2,:)-int;
    stretch=R*stretch;
    
    m_R(i)=sqrt(sum(stretch(2,:).^2))/(max(stretch(1,:))-min(stretch(1,:)));
end
if num_straight==0
    straight_score=0.5;
    vac_perf_score=0;
    wobbly_score=0;
else
    straight_score=mean(m_R<0.175);
    vac_perf_score=sum(m_R<0.175);
    wobbly_score=sum(m_R>=0.175);
end
perf_score=mean([turn_score straight_score]);

% class.perfect=perf_score==1&&~class.no_turns;
% class.vac_perfect=straight_score==1&&class.no_turns;
% class.wobbly=straight_score<1;%&&turn_score==1&&~class.no_turns;
% class.wrong_turns=straight_score==1&&turn_score<1&&~class.no_turns;
% class.big_green_blob=logical(sum(bwareaopen( hmm_path==2|hmm_path==3|hmm_path==4,8)));

class.perfect=perfect_score;
class.vac_perfect=vac_perf_score;
class.wobbly=wobbly_score;
class.wrong_turns=wrong_turn_score;

Output_classes=straight_bits;
for i=1:num_straight
    Output_classes(straight_bits==i)=~double(m_R(i)<0.175)+1;
end
for i=1:num_blue
    Output_classes(blue_bits==i+1)=~double(ang(i))+3;
end

end

function theta=anglefinder(a1x,a1y,a2x,a2y,b1x,b1y,b2x,b2y)
the1=atan2(a2y-a1y,a2x-a1x);
b=-exp(-1i*the1)*(b2x-b1x+1i*(b2y-b1y));
theta=atan2(imag(b),real(b));
theta=theta*180/pi;
end

function levelslider(hObj,event,lineseries_handles)

val = round(get(hObj,'Value'));
L=length(lineseries_handles);
for i=1:L
   if i==val
%       set(lineseries_handles(i).com,'MarkerSize',10)
       set(lineseries_handles(i).cell_outline,'LineWidth',3)
%       set(lineseries_handles(i).DM_path,'MarkerSize',10)
   else
%       set(lineseries_handles(i).DM_path,'MarkerSize',6)
%       set(lineseries_handles(i).com,'MarkerSize',4)
       set(lineseries_handles(i).cell_outline,'LineWidth',1)
   end
end

end

function plotstuff_init(cellnum,cell_idx,test_set,Output_classes,NewCellArray,class,hax)
clf
set(hax,'toolbar','figure');
%  fullpos=fullpos+1;
%cellnum=cell_idx(i);
celltestsetidx=find(test_set==cellnum);
L3=sum(cell_idx==cellnum);


colourscheme=zeros(L3,3);
colourscheme(Output_classes{celltestsetidx}==1,1)=1;
colourscheme(Output_classes{celltestsetidx}==2,1)=1;
colourscheme(Output_classes{celltestsetidx}==2,3)=1;
colourscheme(Output_classes{celltestsetidx}==3,3)=1;
colourscheme(Output_classes{celltestsetidx}==4,2)=1;

temp=cell2mat(NewCellArray(cell_idx==cellnum));
Cells_cell=NewCellArray(cell_idx==cellnum);
xmin=min(temp(:,1));
xmax=max(temp(:,1));
ymin=min(temp(:,2));
ymax=max(temp(:,2));
%         turn_locs=corners_idx{cellnum};
%subpos=mod(fullpos-1,sub_a*sub_b)+1;
hold off
hold on
for j=1:L3
    plandles(j).cell_outline=plot3(Cells_cell{j}(:,1),Cells_cell{j}(:,2),10*j*ones(size(Cells_cell{j}(:,1))),'Color',colourscheme(j,:),'LineWidth',2);
    hold on
end

axis equal
axis([xmin xmax ymin ymax])

title([sprintf('Cell: %d, ',cellnum) '\color{blue}' sprintf('Angled Rep event:%d, ',class(celltestsetidx).perfect) '\color[rgb]{0 .5 0}' sprintf('Straight Rep event:%d, ',class(celltestsetidx).wrong_turns) '\color{red}' sprintf('Straight path:%d, ',class(celltestsetidx).vac_perfect) '\color{magenta}' sprintf('Wobbly path:%d ',class(celltestsetidx).wobbly)])


uicontrol('Style', 'slider',...
    'SliderStep',[1 1]/(L3-1),...
    'Min',1,'Max',L3,'Value',1,...
    'Position', [550 20 120 20],...
    'Callback', {@levelslider,plandles});

uicontrol('Style', 'pushbutton',...
    'String','Next',...
    'Position', [700 20 50 20],...
    'Callback', {@plotstuff,min(cellnum+1,max(test_set)),cell_idx,test_set,Output_classes,NewCellArray,class,hax});

uicontrol('Style', 'pushbutton',...
    'String','Last',...
    'Position', [470 20 50 20],...
    'Callback', {@plotstuff,max(cellnum-1,min(test_set)),cell_idx,test_set,Output_classes,NewCellArray,class,hax});

end

function plotstuff(hObj, event, cellnum,cell_idx,test_set,Output_classes,NewCellArray,class,hax)
clf
set(hax,'toolbar','figure');
%  fullpos=fullpos+1;
%cellnum=cell_idx(i);
celltestsetidx=find(test_set==cellnum);
L3=sum(cell_idx==cellnum);


colourscheme=zeros(L3,3);
colourscheme(Output_classes{celltestsetidx}==1,1)=1;
colourscheme(Output_classes{celltestsetidx}==2,1)=1;
colourscheme(Output_classes{celltestsetidx}==2,3)=1;
colourscheme(Output_classes{celltestsetidx}==3,3)=1;
colourscheme(Output_classes{celltestsetidx}==4,2)=1;

temp=cell2mat(NewCellArray(cell_idx==cellnum));
Cells_cell=NewCellArray(cell_idx==cellnum);
xmin=min(temp(:,1));
xmax=max(temp(:,1));
ymin=min(temp(:,2));
ymax=max(temp(:,2));
%         turn_locs=corners_idx{cellnum};
%subpos=mod(fullpos-1,sub_a*sub_b)+1;
hold off
hold on
for j=1:L3
    plandles(j).cell_outline=plot3(Cells_cell{j}(:,1),Cells_cell{j}(:,2),10*j*ones(size(Cells_cell{j}(:,1))),'Color',colourscheme(j,:),'LineWidth',2);
    hold on
end

axis equal
axis([xmin xmax ymin ymax])

title([sprintf('Cell: %d, ',cellnum) '\color{blue}' sprintf('Angled Rep event:%d, ',class(celltestsetidx).perfect) '\color[rgb]{0 .5 0}' sprintf('Straight Rep event:%d, ',class(celltestsetidx).wrong_turns) '\color{red}' sprintf('Straight path:%d, ',class(celltestsetidx).vac_perfect) '\color{magenta}' sprintf('Wobbly path:%d ',class(celltestsetidx).wobbly)])


uicontrol('Style', 'slider',...
    'SliderStep',[1 1]/(L3-1),...
    'Min',1,'Max',L3,'Value',1,...
    'Position', [550 20 120 20],...
    'Callback', {@levelslider,plandles});

uicontrol('Style', 'pushbutton',...
    'String','Next',...
    'Position', [700 20 50 20],...
    'Callback', {@plotstuff,min(cellnum+1,max(test_set)),cell_idx,test_set,Output_classes,NewCellArray,class,hax});

uicontrol('Style', 'pushbutton',...
    'String','Last',...
    'Position', [470 20 50 20],...
    'Callback', {@plotstuff,max(cellnum-1,min(test_set)),cell_idx,test_set,Output_classes,NewCellArray,class,hax});

end
