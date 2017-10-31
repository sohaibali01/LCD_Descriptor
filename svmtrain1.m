function models = svmtrain1(TrainingSet,GroupTrain)
u=unique(GroupTrain);
numClasses=length(u);

% TrainingSet = scale_normalize(TrainingSet,1,0);

TrainingSet=TrainingSet';
GroupTrain=GroupTrain';

%% kernels
% Kdata = alldist2(TrainingSet, 'chi2') ;
Kdata = hist_isect_svm(TrainingSet', TrainingSet');
clear TrainingSet

% Kdata = vl_alldist2(TrainingSet, 'kchi2') ;
% name=strcat('Ktrain',num2str(sp));
% save(name,'Kdata','-v7.3');
% load (name)
% load Kdata-ns-chi.mat
% Kdata= Kdata ./ std(Kdata(:));
% Kdata=Kdata-mean(Kdata(:));
% mu=0.2;
% mu= 1 ./ mean(Kdata(:))
% Kdata = exp(- mu * Kdata) ;

%%%% Gaussian%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         X = TrainingSet';
%         norm1 = sum(X.^2,2);
%         norm2 = sum(X.^2,2);
%         dist = (repmat(norm1 ,1,size(X,1)) + repmat(norm2',size(X,1),1) - 2*X*X');
%         mu=sqrt(mean(dist(:))/2)
% %         mu=0.0002;
%         Kdata = exp(-0.5/mu^2 * dist);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

% Kdata= Kdata./std(Kdata(:));
% Kdata=Kdata-mean(Kdata(:));
% Kdata = exp(0.2*Kdata);

%%
%build models
for k=1:numClasses
    Y = 2 * (GroupTrain==u(k)) - 1; 
    models(k) = svmtrain(Y(:), double([(1:length(GroupTrain))' Kdata]), [' -t 4 -s 0 -w-1 1 -w1 ' num2str(length(find(Y==-1))/length(find(Y==1))) ' -c 1.0']) ;
     
    ap = mean(models(k).sv_coef(Y(models(k).SVs) > 0)) ;
    am = mean(models(k).sv_coef(Y(models(k).SVs) < 0)) ;
    if ap < am
        % fprintf('svmflip: SVM appears to be flipped. Adjusting.\n') ;
        models(k).sv_coef  = - models(k).sv_coef ;
        models(k).rho      = - models(k).rho ;
    end
%     % test it on train
%     train_scores = models(k).sv_coef' * Kdata(models(k).SVs, :) - models(k).rho ;
%     errs = train_scores .* Y < 0 ;
%     err  = mean(errs) ;
    
end

