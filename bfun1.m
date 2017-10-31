function feature = bfun1(im)

data_img=im.data;
feature = ( hist(data_img(:),24))';
feature=feature./sqrt(sum(feature.^2));

end