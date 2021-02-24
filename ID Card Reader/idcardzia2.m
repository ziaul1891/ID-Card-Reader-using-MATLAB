clear all
clc

original = imread('C:\Users\ZIAUL\Desktop\ID Card\ID1_458_267.jpg');
original=rgb2gray(original); %rgb theke gray te nilam


[inputfilename,dirname] = uigetfile('*.*');
inputfilename = [dirname, inputfilename];
%InputImage=imread('C:\Users\ZIAUL\Desktop\ID Card\ID1_1600_1026.jpg'); %img read
InputImage=imread(inputfilename); %img read
InputImage=rgb2gray(InputImage); %rgb theke gray te nilam
figure, imshow(InputImage);
title('Input Image');



%interesting point detect korlam
DetectInterestPointOriginal  = detectSURFFeatures(original);
DetectInterestPointInputImage = detectSURFFeatures(InputImage);
%interesting point detect korlam

%interesting point ke surround kore rakha area
[featuresOriginal,  validPtsOriginal]  = extractFeatures(original,  DetectInterestPointOriginal);
[featuresInputImage, validPtsInputImage] = extractFeatures(InputImage, DetectInterestPointInputImage);
%interesting point ke surround kore rakha area

%feature match korlam
MatchingFeatures = matchFeatures(featuresOriginal, featuresInputImage);
%feature match korlam

matchedOriginal  = validPtsOriginal(MatchingFeatures(:,1));
matchedInputImage = validPtsInputImage(MatchingFeatures(:,2));

%map korlam
[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedInputImage, matchedOriginal, 'similarity');
%map korlam

Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc)
thetaRecovered = atan2(ss,sc)*180/pi

f=double(thetaRecovered);

CorrectedInput=imrotate(InputImage,-f);
figure, imshow(CorrectedInput)
title('Corrected Input Image');


 Resized=imresize(CorrectedInput,[1000 1550]);%resize korlam
 NoiseRemoved=medfilt2(Resized,[3 3]);  %median filter diye noise remove
 figure,imshow(NoiseRemoved);
 title('Resized & Noiseless Image');
 %CroppedImage = imcrop(NoiseRemoved,[543.5 499.5 438 90]); %crop korlam id er part
 CroppedImage = imcrop(NoiseRemoved,[543.5 499.5 438 90]); %[XMIN YMIN WIDTH HEIGHT]
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
%dot remove korlam


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
yyy=template(1);
%template function call shesh korlam 


%rectengale diye show korabo segment gula
figure,imshow(RemoveDot);
title('Segmented ID Part');

%regionprops call korlam for drawing rectangle
Segment=regionprops(RemoveDot,'BoundingBox','Image');
hold on
for n=1:size(Segment,1)
    rectangle('Position',Segment(n).BoundingBox,'EdgeColor','y','LineWidth',2); 
end
hold off
%rectengale diye show korabo segment gula


