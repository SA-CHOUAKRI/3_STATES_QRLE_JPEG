% CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m is appication of
% CHOUAKRI_3_STATES_QRLE function to a classical JPEG RGB image compression algorithm. 
% In this code, DCT-AC coefficients Huffman coding is replaced by CHOUAKRI_3_STATES_QRLE function.   
%  CHOUAKRI_3_STATES_QRLE function is based on a so-called QRLE (Quantized Run Length Encoding) -see https://ieeexplore.ieee.org/abstract/document/8855775- 
% The basic idea is to treat the zero run numbers of the AC zig-zag coefficients, according 
% to 3 pre-defined ranges as follows whwre it comes the expression 3 States QRLE: [1..127], [128..255], and [256..maximum. 
% For more information see : - https://www.researchgate.net/publication/366802356_Three_States_QRLE_Quantized_Run_Length_Encoding_Based_JPEG_Image_Compression_Method -
% 
% CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m improves considerably the Compression
% Ratio CR compared to the classical JPEG RGB image compression algorithm.
% The compared obtained reults, empolying CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m VS. CLASSICAL JPEG algorithms in terms of CR are,respectiveley, 39.6654, 74.0682, and 53.4297 
% VS. 18.9290, 20.7876, and 17.8256 by testing 'peppers.png', 'ngc6543a.jpg',and 'house.tiff' RGB images
% However,the PSNR values are kept the same for both algorithms since
% CHOUAKRI_3_STATES_QRLE function and Huffman coding are lossyless
% compression methods.
% 
% Running program, the name of RGB image,as string, e.g. 'ngc6543a.jpg' and
% the Quantification Quality, as scalar ususally equals to 3 have to
% entered
% The CR and PSNR values are provided at the end of execution as well as
% the figure of the original, reconstructed,and the diffrence versions of
% the tested RGB image
% 
% Similarly to the classical JPEG code, CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m
% appeals a set of third-party functions such as 'DCdif_fn.m',
%  'DC_Huff_fn.m'...
% Contreversely to the classical JPEG code,
% CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m appeals CHOUAKRI_3_STATES_QRLE
% function instead of 'AC_De_Huff.m', 'AC_Huff.m',and 'AC_Huff_fn.m'



clc; close all; clear all;prompt1 = 'Enter Image Name  ';
result1 = input(prompt1)
imNTU2 = imread(result1); 
[rows1, columns1, numberOfColorChannels] = size(imNTU2);


prompt2 = 'Enter Quantification Quality ';
var = input(prompt2)


figure(1)
imshow(imNTU2);
title('ORIGINAL RGB IMAGE')

%------------------------resizing image---------
BlockSize = 8*6*2;   %la taille de chaque bloque 

e1=floor(rows1/BlockSize);
e2=floor(columns1/BlockSize);
   h1 = e1*BlockSize;
   h2 = e2*BlockSize;
   HH= mean ([h1; h2]);
   imNTU1 = imresize(imNTU2,[HH  HH]) ;
%----------------------------------------------------------------------

fprintf('la taille de lmage originale est :' )
info = imfinfo(result1)
% % % % info = imfinfo('peppers.png')
% % % % % % %  info = imfinfo('two.tif')
% % % info = imfinfo('ngc6543a.jpg')
ImageSize = info.FileSize
%___________________________________________________


a = size(imNTU1);           
width = a(1); height = a(2);
imNTU = double(imNTU1);      %%%transfer to 'double type' for calculation
R = imNTU(:, :, 1);
G = imNTU(:, :, 2);
B = imNTU(:, :, 3);





%% YCbCr  && four_two_zero DownSampling
trans = [0.299 0.587 0.114 ; -0.169 -0.334 0.500 ; 0.500 -0.419 -0.081];  %RGB -> YCbCr ªº¯x°}
inv_trans = inv(trans); %YCbCr -> RGB ªº¯x°}
Y =  trans(1,1)* R + trans(1,2)* G + trans(1,3)* B;
Cb = trans(2,1)* R + trans(2,2)* G + trans(2,3)* B +128;
Cr = trans(3,1)* R + trans(3,2)* G + trans(3,3)* B +128;

Cb1(:,:) = Cb(1:2:end,1:2:end);  % 2 for 1
Cr1(:,:) = Cr(1:2:end,1:2:end);  % 2 for 1 

%% DCT2D_fn 
Cf = dctmtx(8);
%[YF ,CbF ,CrF] = DCT2D_fn(Y,Cb1,Cr1,width,height,Cf);
YF  = blkproc(Y  ,[8 8],'P1*x*P2',Cf,Cf');
CbF = blkproc(Cb1,[8 8],'P1*x*P2',Cf,Cf');
CrF = blkproc(Cr1,[8 8],'P1*x*P2',Cf,Cf');



    

%% Quantization
Qy = floor(var * [16 11 10 16 24 40 51 61;
                 12 12 14 19 26 58 60 55;
                 14 13 16 24 40 57 69 56;
                 14 17 22 29 51 87 80 62;
                 18 22 37 56 68 109 103 77;
                 24 35 55 64 81 104 113 92;
                 49 64 78 87 103 121 120 101;
                 72 92 95 98 112 100 103 99]);
             %Yªº¶q¤Æ¯x°}
Qc = floor(var * [17 18 24 47 99 99 99 99;
                 18 21 26 66 99 99 99 99;
                 24 26 56 99 99 99 99 99;
                 47 66 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99;
                 99 99 99 99 99 99 99 99]); %Cb Cr ªº¶q¤Æ¯x°}
             
YQ  = blkproc(YF ,[8 8],'round(x./P1)',Qy);
CbQ = blkproc(CbF,[8 8],'round(x./P1)',Qc);
CrQ = blkproc(CrF,[8 8],'round(x./P1)',Qc);




%% DC differential encoding (Interlaced Scanning   Y => Cb => Cr )
% AC  ZigZag scanning
[DC,  AC_zig] = DCdif_fn(YQ,CbQ,CrQ,width,height); %% DC+AC

%% Huffman Encoding
DC_Huff = DC_Huff_fn(DC);
% % % % % L = width*height*1.5/64;

[QR, en_pp, aan]=CHOUAKRI_3_STATES_QRLE(AC_zig);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % 3-STATES-QPLE COMPRESSED RGB IMAGE TRANSMISSION
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

AC_decode = CHOUAKRI_3_STATES_QRLE_INV(QR, en_pp, aan);

% % % % % % % F=AC_zig;




% % % % % % % % % % % % % % % % % % 
% % % Compression Ratio
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % data_len(i) = length(AC_Huff) + length(DC_Huff) ; 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % bit_rate(i) = data_len(i)/width/height;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % Compression_Ratio(i) = 24/bit_rate(i);

RGB_SIZE=rows1* columns1* numberOfColorChannels*8;
data_len_QRLE = (length(QR)*8) + length(DC_Huff);  

COMPRESSION_RATIO_3_STATE_QRLE=RGB_SIZE/data_len_QRLE




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % %
%% JPEG Decoder
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % %



DC_decode = DC_De_Huff(DC_Huff);
[YY CbCb CrCr] = MatCom_fn(DC_decode,AC_decode,Cf,Qy,Qc);
Cbr = four_two_zero_recovery(width,height,CbCb);
Crr = four_two_zero_recovery(width,height,CrCr); 


R2 = inv_trans(1,1)* YY + inv_trans(1,2)* (Cbr-128) + inv_trans(1,3)* (Crr-128) ;
G2 = inv_trans(2,1)* YY + inv_trans(2,2)* (Cbr-128) + inv_trans(2,3)* (Crr-128) ;
B2 = inv_trans(3,1)* YY + inv_trans(3,2)* (Cbr-128) + inv_trans(3,3)* (Crr-128) ;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % %
% % % % % PSNR  &   ORIGINAL VS. RECONSTRUCTED RGB IMAGE  DISPLAY
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % %

imfinal = cat(3,R2,G2,B2) ;
imfinali = imresize(imfinal,[rows1 columns1]) ;
imfinalii=uint8(imfinali);
imNTU2i=double(imNTU2);
sei = abs(imNTU2i-imfinali).^2;



PSNR = 10*log10(255*255 * 3*rows1*columns1/sum(sei(:) ) )





figure(1)
imshow(imNTU2);
title('ORIGINAL RGB IMAGE')



figure(2)
imshow(imfinalii)
title('3 STATES QRLE RECONSTRUCTED RGB IMAGE')


figure(3)
imshow(imfinalii-imNTU2)
title('ORIGINAL - RECONSTRUCTED RGB IMAGE')