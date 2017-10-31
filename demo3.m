clear all;
close all;
clc;

load features_contrast.mat


num_splits=20;

no_classes=length(unique(class_nos));
rng('shuffle');
tr_imgs=5;       % number of training images per class....... testing performed on all remaining samples of each class

for split=1:num_splits
        
       tr=[]; 
    for i=1:no_classes
        ind=find(class_nos==i);
   
        totimgs=length(ind);
        rand_ind=randperm(totimgs,tr_imgs);
        tr_ind = rand_ind(1:tr_imgs);
        
        temp_tr=zeros(totimgs,1);
        temp_tr(tr_ind)=1;
        tr = [tr; temp_tr];
    end
        
        tr_classes=class_nos(tr==1);
        tr_contrast=contrast_feat(tr==1,:);
        
        test_classes=class_nos(tr==0);
        test_contrast=contrast_feat(tr==0,:);
        contrast_mdl = ClassificationKNN.fit(tr_contrast, tr_classes,'NumNeighbors',1,'Distance',@L1dist);
        contrast_labels=predict(contrast_mdl,test_contrast);
        contrast_TPs=length(find(contrast_labels==test_classes));
        acc_contrast(split)= contrast_TPs./length(test_classes)
    
end
mean_contrast=mean(acc_contrast)
std_contrast=std(acc_contrast)
