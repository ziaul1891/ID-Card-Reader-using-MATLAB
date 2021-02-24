clear all
clc

original = imread('C:\Users\ZIAUL\Desktop\ID Card\ID1.jpg');
original=rgb2gray(original);


%[inputfilename,dirname] = uigetfile('*.*');
%inputfilename = [dirname, inputfilename];
distorted=imread('C:\Users\ZIAUL\Desktop\ID Card\ID3_1024_654.jpg'); %img read
%distorted=imread(inputfilename); %img read
distorted=rgb2gray(distorted);
figure, imshow(distorted);
title('Input Image');



ptsOriginal  = detectSURFFeatures(original);% Detect interest points and mark their locations
ptsDistorted = detectSURFFeatures(distorted);

%{
    extractFeatures Extract interest point descriptors
    extractFeatures extracts feature vectors, also known as descriptors,
    from a binary or intensity image. Descriptors are derived from pixels
    surrounding an interest point. They are needed to describe and match 
    features specified by a single point location.
%}
[featuresOriginal,  validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresInputImage, validPtsInputImage] = extractFeatures(distorted, ptsDistorted);


indexPairs = matchFeatures(featuresOriginal, featuresInputImage);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedInputImage = validPtsInputImage(indexPairs(:,2));

%{
estimateGeometricTransform Estimate geometric transformation from matching point pairs.
    tform = estimateGeometricTransform(matchedPoints1,matchedPoints2,
    transformType) returns a 2-D geometric transform which maps the
    inliers in matchedPoints1 to the inliers in matchedPoints2.
%}
[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedInputImage, matchedOriginal, 'similarity');

Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc)
thetaRecovered = atan2(ss,sc)*180/pi

f=double(thetaRecovered)

CorrectedInput=imrotate(InputImage,-f);
figure, imshow(CorrectedInput)
title('Corrected Input Image');




 %Resized=imresize(distorte,[1000 NaN]); %resize korlam
 Resized=imresize(CorrectedInput,[1000 1550]);
 %RGBtoGray=rgb2gray(Resized); %rgb theke gray te nilam
 NoiseRemoved=medfilt2(Resized,[3 3]);  %median filter diye noise remove
 figure,imshow(NoiseRemoved);
 title('Resized & Noiseless Image');
 %CroppedImage = imcrop(NoiseRemoved,[550.5 504.5 442 80]); %crop korlam id er part
 CroppedImage = imcrop(NoiseRemoved,[543.5 499.5 438 90]);
figure,imshow(CroppedImage);
 title('ID Part Cropped');
 
%thresholding korlam
[x y]=size(CroppedImage);
 G = uint8(zeros(x,y));

 for i=1:x
    for j=1:y
       if(CroppedImage(i,j)>=70)
             CroppedImage(i,j) = 0;
       else
             CroppedImage(i,j) = 255;
       end
    end
 end
 G=CroppedImage;
 figure,imshow( G);
 title('Thresholding on Cropped ID Part');
 %thresholding korlam
 
 
%dot remove korlam
%{
bwareaopen(BW,P) removes from a binary image all connected
components (objects) that have fewer than P pixels
%}
RemoveDot = bwareaopen(G,200);
figure,imshow(RemoveDot);
title('Removed The Dots');
%imshow(RemoveDot);
%dot remove korlam
% 
% 
% %ekhn edge detect korbo
%  se = strel('disk',1);
%  Edge=imdilate(RemoveDot,se);
%  RE=Edge-RemoveDot;
% [a1 b1]=size(RE);
% figure,imshow(RE);
% title('Finding out the Edges');
% %edge detect kora and show kora shesh



%jeshob letter er vitor faka ase oigula fill korbo
%{
BW2 = imfill(BW1,'holes') fills holes in the input image.  A hole is
    a set of background pixels that cannot be reached by filling in the
    background from the edge of the image.
%}
% F=imfill(RE,'holes');     
% figure,imshow(F);
% title('Filling the holes of 0,4,6,8,9');
%holes fill kora shesh korlam


%template function call korlam number match korar jonno
yyy=template(2);
%template function call shesh korlam 

%rectengale diye show korabo segment gula
figure,imshow(RemoveDot);
title('Segmented ID Part');
%regionprops er kahini ta bujhte hobe
Iprops=regionprops(RemoveDot,'BoundingBox','Image');
hold on
for n=1:size(Iprops,1)
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','y','LineWidth',2); 
end
hold off

%rectengale diye show korabo segment gula


