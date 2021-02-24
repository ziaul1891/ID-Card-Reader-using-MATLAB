clear all
I=imread('C:\Users\ZIAUL\Desktop\ID Card\ID1_458_267.jpg'); %img read
    

 Resized=imresize(I,[1000 NaN]); %resize korlam
 RGBtoGray=rgb2gray(Resized); %rgb theke gray te nilam
 NoiseRemoved=medfilt2(RGBtoGray,[3 3]);  %median filter diye noise remove
 CroppedImage = imcrop(NoiseRemoved,[550.5 504.5 442 80]); %crop korlam id er part
 RemoveDot = bwareaopen(CroppedImage,200);
 
 
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
 se = strel('disk',1);
 Edge=imdilate(RemoveDot,se);
 figure(1);
 imshow(Edge);
 %RE=RemoveDot-Edge;
 RE=Edge-RemoveDot;
 

% 
% conc=strel('disk',1);
% gi=imdilate(RemoveDot,conc);
% ge=imerode(RemoveDot,conc);            %%%% morphological image processing
% gdiff=imsubtract(gi,ge);
% gdiff=mat2gray(gdiff);
% gdiff=conv2(gdiff,[1 1;1 1]);
% gdiff=imadjust(gdiff,[0.5 0.7],[0 1],.1);
% B=logical(gdiff);
[a1 b1]=size(RE);
figure(2)
imshow(RE)

% 
% se2=strel('disk',100,0);
% er=imerode(RE,se2);
% figure(3)
% imshow(er)

% 
% out1=imsubtract(RE,er);
% figure(31);
% imshow(out1);
F=imfill(RE,'holes');      %%%filling the object
figure(4);
imshow(F);
%{
BW2 = imfill(BW1,'holes') fills holes in the input image.  A hole is
    a set of background pixels that cannot be reached by filling in the
    background from the edge of the image.
%}
% H=bwmorph(F,'thin',1);
% H=imerode(H,strel('line',3,90));
% figure(4)
% imshow(H)
%%
final=bwareaopen(F,floor((a1/15)*(b1/15))); 

figure(41);
imshow(final);
%final(1:floor(.9*a1),1:2)=1;
%final(a1:-1:(a1-20),b1:-1:(b1-2))=1;
yyy=template(2);
figure(5)
imshow(final)
Iprops=regionprops(final,'BoundingBox','Image');
hold on
for n=1:size(Iprops,1)
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','g','LineWidth',2); 
end
hold off
% NR=cat(1,Iprops.BoundingBox);   %%Data storage section
% [r ttb]=connn(NR);



























% 
% if ~isempty(r)
%     
%     
%     xlow=floor(min(reshape(ttb(:,1),1,[])));
%     xhigh=ceil(max(reshape(ttb(:,1),1,[])));
%     xadd=ceil(ttb(size(ttb,1),3));
%     ylow=floor(min(reshape(ttb(:,2),1,[])));    %%%%%area selection
%     yadd=ceil(max(reshape(ttb(:,4),1,[])));
%     final1=H(ylow:(ylow+yadd+(floor(max(reshape(ttb(:,2),1,[])))-ylow)),xlow:(xhigh+xadd));
%     [a2 b2]=size(final1);
%     final1=bwareaopen(final1,floor((a2/20)*(b2/20)));
%     figure(6)
%     imshow(final1)
%     
%    
%     Iprops1=regionprops(final1,'BoundingBox','Image');
%     NR3=cat(1,Iprops1.BoundingBox);
%     I1={Iprops1.Image};
%     
%     %%
%     carnum=[];
%     if (size(NR3,1)>size(ttb,1))
%         [r2 to]=connn2(NR3);
%         
%         for i=1:size(Iprops1,1)
%             
%             ff=find(i==r2);
%             if ~isempty(ff)
%                 N1=I1{1,i};
%                 letter=readLetter(N1,2);
%             else
%                 N1=I1{1,i};
%                 letter=readLetter(N1,1);
%             end
%             if ~isempty(letter)
%                 carnum=[carnum letter];
%             end
%         end
%     else
%         for i=1:size(Iprops1,1)
%             N1=I1{1,i};
%             letter=readLetter(N1,1);
%             carnum=[carnum letter];
%         end
%     end
%     %%
%     
%     fid1 = fopen('carnum.txt', 'wt');
%     fprintf(fid1,'%s',carnum);
%     fclose(fid1);
%     winopen('carnum.txt')
%    
% 
% 
% else
%     fprintf('license plate recognition failure\n');
%     fprintf('Characters are not clear \n');
% end
% 
% 
% 






