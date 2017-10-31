
function [feature] = cont1D(data)

number_channels = size(data,2);

%% atrous based
feature = [];
for i=1:number_channels
    K1=(1/4).*[1 2 1]';       %% 1D linear atrous vector
    nplanes=3;

    I=data(:,i);
    I=mat2gray(I-mean(I(:)));
    LP=I;

    for j=1:nplanes

        %%% Get 2D response %%%% 
            Kernel=K1;%*K1';      %%% contruct 2D filter from 1D linear filter
            LP(:,j+1)=conv(LP(:,j),Kernel,'same');
            wave_plane=(LP(:,j)-LP(:,j+1))./LP(:,j+1);
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
          LOG_scaled4(:,j)=mat2gray(1./(1+exp(-(w1-avgv)./(stdv))));
          
%             w1=mat2gray(log(w1-min(w1)));
%            LOG_scaled4(:,j)= w1;
          data_img = LOG_scaled4(:,j);
          feature = [feature ; ( hist(data_img(:),10))'];

    end
end
% feature = ( hist(data_img(:),20))';
% feature=feature./sqrt(sum(feature.^2));

% tic
% nhood{1}=[4 4];
% nhood{2}=[6 6];
% nhood{3}=[8 8];
% parfor ii=1:nplanes
%     B(:,:,ii)  = blockproc(LOG_scaled4(:,:,ii),[8 8],@bfun1,'UseParallel',1,'BorderSize',nhood{ii},'TrimBorder',0);
% end
% % toc
% % tic
% 
% %%
% 
% model.numSpatialX=[1 1 1];
% model.numSpatialY=[1 1 1];
% xind=repmat((1:8:nrows)',[1 ncols/8]);
% yind=repmat((1:8:ncols),[nrows/8 1]);
% frames(1,:)=yind(:);
% frames(2,:)=xind(:);
% % tic
%  feature_vector=[];
% for ii=1:nplanes
% 
%      feat=reshape(B(:,:,ii),24,[]);
% 
%     binsa = double(vl_kdtreequery(kdtree{ii},double(vocab(:,:,ii)),feat,'MaxComparisons', 50)) ;
%       binsx = vl_binsearch(linspace(1,ncols,model.numSpatialX(ii)+1), frames(1,:)) ;
%       binsy = vl_binsearch(linspace(1,nrows,model.numSpatialY(ii)+1), frames(2,:)) ;
% 
%       % combined quantization
%       bins = sub2ind([model.numSpatialY(ii), model.numSpatialX(ii),  kdtree{ii}.numData], ...
%                      binsy,binsx,binsa) ;
%       hist = zeros(model.numSpatialY(ii) * model.numSpatialX(ii) *  kdtree{ii}.numData, 1) ;
%       hist= vl_binsum(hist, ones(size(bins)), bins) ;
%       hists = single(hist / sum(hist)) ;
%     feature_vector = [feature_vector hists'] ;
% end

end
