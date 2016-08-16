function   Run_DynamicDisplay( )
aPath='/Users/iasmam/Desktop/_Analysis'
dPath = fullfile(aPath, 'DynamicData.mat');
data = load(dPath);
dynamicData=data.DynamicData;
Dynamics_display(dynamicData, aPath, 'speeds')
end

