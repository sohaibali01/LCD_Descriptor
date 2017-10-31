clear all;
close all;
clc;
path(pathdef)
rng('shuffle');

timgs=20; 
dname='images';           % folder path of the dataset
[ FList, cnos ] = ReadImageNames(dname);
unique_nos=unique(cnos);
names=[];
for i=1:length(unique_nos)
    ind=find(strcmp(cnos,unique_nos(i))==1);
    tnames=FList(ind);
    rand_nos=randperm(length(ind),timgs);
    names = [names; tnames(rand_nos)];
end

contrast_feat=[];
parfor j=1:length(names)
    fname=names{j};
                image=(imread(fname));
                if (size(image,3)~=1)
                    image=rgb2gray(image);
                end
                [dim1, dim2]=size(image);
                if (dim1*dim2>500*500)
                   j
                    if dim1>dim2
                        image=imresize(image,[500 NaN]);
                    else
                        image=imresize(image,[NaN 500]);
                    end
                end

        contrast_feat = [ contrast_feat single(contrast_vocab1(image))];
end


run('vlfeat-0.9.19-bin\vlfeat-0.9.19\toolbox\vl_setup')      % setup filepath of vlfeat
for i=1:3
      i
     contrast_vocab(:,:,i) = vl_kmeans(contrast_feat(:,:,i), 300, 'verbose', 'algorithm', 'elkan', 'MaxNumIterations', 75) ;
     contrast_kdtree{i} = vl_kdtreebuild(contrast_vocab(:,:,i)) ;

end
 save('contrast_vocabulary','contrast_vocab','contrast_kdtree');