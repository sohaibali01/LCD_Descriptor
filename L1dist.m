
function Dist = L1dist(ref,features )

[dim1, ~]=size(features);
ref1=repmat(ref,[dim1 1]);
Dist=sum(abs(ref1 - features), 2); 

end