function [result] = svmclassify1(models,TrainingSet,TestSet,num_classes)

% TrainingSet = scale_normalize(TrainingSet,1,0);
% TestSet = scale_normalize(TestSet,1,0);

TestSet=TestSet';
TrainingSet=TrainingSet';

%% kernels
% KTestdata = alldist2(TrainingSet,TestSet, 'chi2') ;
% KTestdata = vl_alldist2(TrainingSet,TestSet, 'kchi2') ;

KTestdata  = hist_isect_svm(TrainingSet', TestSet');
% save('KTestdata-n-chi','KTestdata');
% name=strcat('Ktest',num2str(sp));
% save(name,'KTestdata','-v7.3');

% load KTestdata-ns-chi.mat
% KTestdata = KTestdata ./ std(KTestdata(:)); 
% KTestdata = KTestdata -  mean(KTestdata(:)) ;
% mu=0.2;
% mu= 1 ./ mean(KTestdata(:)) 
% mu= 1000 ;
% KTestdata = exp(- mu * KTestdata) ;

%%%%%%%%%% Gaussian %%%%%%%%%%%%%%%%%%%%%%%%
%         X=TrainingSet';
%         Y = TestSet';
%         norm1 = sum(X.^2,2);
%         norm2 = sum(Y.^2,2);
%         dist = (repmat(norm1 ,1,size(Y,1)) + repmat(norm2',size(X,1),1) - 2*X*Y');
%         mu=sqrt(mean(dist(:))/2)
% %         mu=0.0002;
%          KTestdata = exp(-0.5/mu^2 * dist);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%%% Gaussian
% KTestdata= KTestdata./std(KTestdata(:));
% KTestdata=KTestdata-mean(KTestdata(:));
% KTestdata = exp(0.2*KTestdata);       %%%0.2
%%
clear TrainingSet
score_test = zeros(size(TestSet,2), num_classes);
clear TestSet
    for k=1:num_classes
        score_test(:,k) = models(k).sv_coef' * KTestdata(models(k).SVs,:) - models(k).rho ;
    end
[confidence,result] = max(score_test, [], 2);