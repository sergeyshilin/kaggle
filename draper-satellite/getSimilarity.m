function m = getSimilarity(fname1, fname2, needresize) 
if needresize ~= 1
xImage1 = imresize(rgb2gray(imread(fname1)), needresize);
xImage2 = imresize(rgb2gray(imread(fname2)), needresize);
else
xImage1 = rgb2gray(imread(fname1));
xImage2 = rgb2gray(imread(fname2));
end;
pts1 = detectSURFFeatures(xImage1);
pts2 = detectSURFFeatures(xImage2);
[features1,  validPts1]  = extractFeatures(xImage1,  pts1);
[features2,  validPts2]  = extractFeatures(xImage2,  pts2);
indexPairs = matchFeatures(features1, features2);
matched1  = validPts1(indexPairs(:,1));
matched2  = validPts2(indexPairs(:,2));
[tform] = estimateGeometricTransform(matched2, matched1, 'similarity');
Tinv  = tform.invert.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc);
thetaRecovered = atan2(ss,sc)*180/pi;
outputView = imref2d(size(xImage1));
recovered  = imwarp(xImage2,tform,'OutputView',outputView);
mse = maskedMSE(xImage1, recovered);
m = [Tinv(3,1), Tinv(3,2), scaleRecovered, thetaRecovered, length(indexPairs), mse];
end