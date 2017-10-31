function [feature_vector] = contrast_vocab1(d_image)

I = double(d_image);
[nrows, ncols]=size(I);
b1=round(nrows/8);
b2=round(ncols/8);

I=imresize(I,[8*b1 8*b2]);
[nrows ,ncols]=size(I);
LOG_scaled4=zeros(nrows,ncols,3);

I=mat2gray(I-mean(I(:)));


%% atrous based
K1=(1/4).*[1 2 1]';       %% 1D linear atrous vector
nplanes=3;

LP=I;

for j=1:nplanes

    %%% Get 2D response %%%% 
        Kernel=K1*K1';      %%% contruct 2D filter from 1D linear filter
        LP(:,:,j+1)=imfilter(LP(:,:,j),Kernel);
        wave_plane=(LP(:,:,j)-LP(:,:,j+1))./LP(:,:,j+1);
        K1=upsample(K1,2);      %%% upsample the 1D linear filter
        K1=K1(1:length(K1)-1,:);  %%% remove last element (zero) of filter to make number of elements odd
 
        w1=wave_plane;
           
        w1(isnan(w1))=0;
   
        w1(isinf(w1))=0;
         w1=mat2gray(w1);
         low_high_w1 = stretchlim(w1,[0.01 0.99]);
          ind1 = find( (w1>low_high_w1(1)) &  (w1<low_high_w1(2)));
          
         avgv=mean(w1(ind1));
        stdv=std(w1(ind1));
      LOG_scaled4(:,:,j)=mat2gray(1./(1+exp(-(w1-avgv)./(stdv))));
end
% tic
nhood{1}=[4 4];
nhood{2}=[6 6];
nhood{3}=[8 8];
parfor ii=1:nplanes
    B(:,:,ii)  = blockproc(LOG_scaled4(:,:,ii),[8 8],@bfun1,'UseParallel',1,'BorderSize',nhood{ii},'TrimBorder',0);
end
% toc
% tic

%%

% % tic
 feature_vector=[];
for ii=1:nplanes
    feature_vector(:,:,ii)=reshape(B(:,:,ii),24,[]);
end

end
