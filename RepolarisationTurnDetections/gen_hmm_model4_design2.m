function [ model_g] = gen_hmm_model4_design2( SCORE,cell_indices,ploton )
%GEN_HMM_MODEL Summary of this function goes here
%   Detailed explanation goes here

SCORE2=(10^7)*SCORE;
d=2; %dims used

%GAUSS model
nstates=4;

%predefinedstates
matObj = matfile('training_state_data');
training_states = who(matObj);
training_cell_list = cellfun(@(x) str2double(strsplit(x, 'states')), training_states, 'UniformOutput', false);
training_cell_list = sort(cellfun(@(x) x(2), training_cell_list));
load('training_state_data');
state_set{1}=[];
state_set{2}=[];
state_set{3}=[];
state_set{4}=[];
pi=zeros(nstates,1);
for i=1:length(training_cell_list)
    DM_path{i}=SCORE2(cell_indices==training_cell_list(i),1:2);
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

type='gauss';
A=A_init;

model_g=hmmCreate(type, pi, A, emission);

end

