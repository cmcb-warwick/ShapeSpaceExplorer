function [ model_g] = gen_hmm_model4_design2( ploton )
%GEN_HMM_MODEL Summary of this function goes here
%   Detailed explanation goes here

%observable data based on DM output
load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/NecessaryData/refinedSCORE.mat')
load('/Volumes/annelab/sam/Microscope_data/TemporalAnalysis/Turns/NecessaryData/cellarrayandindex.mat')
SCORE2=(10^7)*SCORE;
d=2; %dims used

%GAUSS model
nstates=4;

%predefinedstates
load('training_state_data_4set2');
training_cell_list=[27 29 35 38 51 60 85 109 133 176 177 223 251 281 324 343 351 361 374];
state_set{1}=[];
state_set{2}=[];
state_set{3}=[];
state_set{4}=[];
pi=zeros(nstates,1);
for i=1:length(training_cell_list)
    DM_path{i}=SCORE2(cell_idx==training_cell_list(i),1:2);
    eval(sprintf('states_idx=states%d;',training_cell_list(i))) 
    state_set{1}=[state_set{1}; DM_path{i}(states_idx==1,:)];
    state_set{2}=[state_set{2}; DM_path{i}(states_idx==2,:)];
    state_set{3}=[state_set{3}; DM_path{i}(states_idx==3,:)];
    state_set{4}=[state_set{4}; DM_path{i}(states_idx==4,:)];
    z=states_idx(logical(states_idx));
    A = accumarray([z(1:end-1)', z(2:end)'], 1, [nstates, nstates]); % count transitions
    A = normalize(A + 0.05*ones(size(A)), 2);
    A_all(:,:,i)=A;
    pi=pi+accumarray(z',1,[nstates 1]);
end

A_init=mean(A_all,3);
pi=pi/sum(pi);


if ploton
    figure
    plot(SCORE2(:,1),SCORE2(:,2),'k.','MarkerSize',3);
    hold on
    plot(state_set{1}(:,1),state_set{1}(:,2),'ko','MarkerFaceColor',[1 0 0],'MarkerSize',15)
    plot(state_set{2}(:,1),state_set{2}(:,2),'ko','MarkerFaceColor',[0 1 0],'MarkerSize',15)
    plot(state_set{3}(:,1),state_set{3}(:,2),'ko','MarkerFaceColor',[1 1 0],'MarkerSize',15)
    plot(state_set{4}(:,1),state_set{4}(:,2),'ko','MarkerFaceColor',[0 0 1],'MarkerSize',15)
end
%fit gaussians to each state

mu=[];
Sigma=[];
for i=1:nstates
    model_temp(i)=gaussFit(state_set{i});
    mu=[mu model_temp(i).mu(:)];
    Sigma=cat(3, Sigma, model_temp(i).Sigma);
end

% emission=structure(mu,Sigma,nstates,d);
% 
% emission.prior.mu    = zeros(1, d);
% emission.prior.Sigma = 0.1*eye(d);
% emission.prior.k     = 0.01;
% emission.prior.dof   = d + 1;
% 
% emission.cpdType='condGauss';
% emission.fitFn= @condGaussCpdFit;
% emission.fitFnEss= @condGaussCpdFitEss;
% emission.essFn= @condGaussCpdComputeEss;
% emission.logPriorFn= @logPriorFn;
% emission.rndInitFn= @rndInit;

emission = condGaussCpdCreate(mu, Sigma);
if ploton
    figure
    plot(SCORE2(:,1),SCORE2(:,2),'k.','MarkerSize',3);
    hold on
    plot(state_set{1}(:,1),state_set{1}(:,2),'ko','MarkerFaceColor',[1 0 0],'MarkerSize',15)
    plot(state_set{2}(:,1),state_set{2}(:,2),'ko','MarkerFaceColor',[0 1 0],'MarkerSize',15)
    plot(state_set{3}(:,1),state_set{3}(:,2),'ko','MarkerFaceColor',[1 1 0],'MarkerSize',15)
    plot(state_set{4}(:,1),state_set{4}(:,2),'ko','MarkerFaceColor',[0 0 1],'MarkerSize',15)
    colors='rgyb';
    for k=1:nstates
        gaussPlot2d(emission.mu(:,k), emission.Sigma(:,:,k),...
            'color',colors(k),'plotMarker','false');
    end
end
%good_set=[281 251 38 343 93 374 133 223 97 330 27 207 337 324 345 85 351 35 326 109 29 361 332 132 177 178 128 84 127 226 51 52 176 290 225 231];
%good_set=[281 251 38 343 93 374 133 223 97 27 337 324 85 351 35 326 109 29 361 332 177 178 84 226 51 176 225 231];
%good_set=union(training_cell_list,good_set);

%for i=1:36
%for i=1:28
%for i=1:length(training_cell_list)
%for i=1:440
%for i=1:30

%    c_i=training_cell_list(i);
%    c_i=good_set(i);
%    data{i}=SCORE2(cell_idx==c_i,1:2)';
%end

%Initialising A
%t_set=union(training_cell_list,good_set);




%[model_g, loglikHist_g] = hmmFit(data',nstates,'gauss','trans0',A_init,'emission0',emission);
%[model_g, loglikHist_g] = hmmFit(data',nstates,'gauss','emission0',emission);
type='gauss';
A=A_init;


model_g=hmmCreate(type, pi, A, emission);

end

