clear all;
close all;
clc;
path(pathdef)

load 33fab_Oneway_newdata
% 
% rng('shuffle');

% class_nos=[];
% dname='images';        % folder path of the dataset
% 
% [ FList, cnos ] = ReadImageNames(dname);
% unique_nos=unique(cnos);
% orig_names=[];
% for i=1:length(unique_nos)
%     ind=find(strcmp(cnos,unique_nos(i))==1);
%     tnames=FList(ind);
%     orig_names = [orig_names; tnames];
%     class_nos=[class_nos; repmat(i,[length(ind) 1])];
% end


contrast_feat=[];
% run('vlfeat-0.9.19-bin\vlfeat-0.9.19\toolbox\vl_setup')  % setup filepath of vlfeat

for j=1:size(Test_samples1,2)
    class_nos(j,1) = Test_samples1(j).Class_label;
    data = [Test_samples1(j).Exploration_data1(:,1:16)']';% ; Test_samples1(j).Exploration_data1(:,9)'; Test_samples1(j).Exploration_data1(:,16)']';
    contrast_feat(j,:)= cont1D(data);
        j
end
save('features_contrast','contrast_feat','class_nos');
