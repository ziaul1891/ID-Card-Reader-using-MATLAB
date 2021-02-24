clear all
I=imread('C:\Users\ZIAUL\Desktop\ID Card\ID1_800_511.jpg'); %img read



 Resized=imresize(I,[1000 NaN]); %resize korlam
 RGBtoGray=rgb2gray(Resized); %rgb theke gray te nilam
 NoiseRemoved=medfilt2(RGBtoGray,[3 3]);  %median filter diye noise remove
 CroppedImage = imcrop(NoiseRemoved,[550.5 504.5 442 80]); %crop korlam id er part
 
 
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
 %thresholding korlam
 
 
%dot remove korlam
%{
bwareaopen(BW,P) removes from a binary image all connected
components (objects) that have fewer than P pixels
%}
RemoveDot = bwareaopen(G,200);
%imshow(RemoveDot);
%dot remove korlam
% 

%ekhn edge detect korbo
 se = strel('disk',1);
 Edge=imdilate(RemoveDot,se);
 figure(1);
 imshow(Edge);
 RE=Edge-RemoveDot;
 

[a1 b1]=size(RE);
figure(2)
imshow(RE)
%edge detect kora and show kora shesh



%jeshob letter er vitor faka ase oigula fill korbo
%{
BW2 = imfill(BW1,'holes') fills holes in the input image.  A hole is
    a set of background pixels that cannot be reached by filling in the
    background from the edge of the image.
%}
F=imfill(RE,'holes');     
figure(4);
imshow(F);
%holes fill kora shesh korlam


%159 pixel er niche thaka shob pixel remove korlam, naile output desired
%ashe na....karon choto choto object theke gele segment korte problem
%hoy....
final=bwareaopen(F,floor((a1/15)*(b1/15))); 
figure(41);
imshow(final);
%remove kora done

%template function call korlam number match korar jonno
yyy=template(2);
%template function call shesh korlam 

%rectengale diye show korabo segment gula
figure(5)
imshow(final)
%regionprops er kahini ta bujhte hobe
Iprops=regionprops(final,'BoundingBox','Image');
hold on
for n=1:size(Iprops,1)
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','y','LineWidth',2); 
end
hold off
%rectengale diye show korabo segment gula

