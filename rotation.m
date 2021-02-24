original = imread('C:\Users\ZIAUL\Desktop\ID Card\ID1.jpg');
original=rgb2gray(original);
%imshow(original);
% text(size(original,2),size(original,1)+15, ...
%     'Image courtesy of Massachusetts Institute of Technology', ...
%     'FontSize',7,'HorizontalAlignment','right');

scale = 0.7;
% J = imresize(original, scale); % Try varying the scale factor.
% 
% theta = 30;
% distorted = imrotate(J,theta); % Try varying the angle, theta.
distorted=imread('C:\Users\ZIAUL\Desktop\ID Card\ID1_402_258_rorated67.jpg');
distorted=rgb2gray(distorted);
figure, imshow(distorted)


ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);

[featuresOriginal,  validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);


indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));


% figure;
% showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted);
% title('Putatively matched points (including outliers)');

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedDistorted, matchedOriginal, 'similarity');

% figure;
% showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted);
% title('Matching points (inliers only)');
% legend('ptsOriginal','ptsDistorted');

Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc)
thetaRecovered = atan2(ss,sc)*180/pi

f=double(thetaRecovered)
%angleInDegrees = radtodeg(thetaRecovered)
%angleInRadians = degtorad(thetaRecovered)



distorte=imrotate(distorted,-f);
figure, imshow(distorte)
title('Final');