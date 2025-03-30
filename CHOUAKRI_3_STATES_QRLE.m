%  CHOUAKRI_3_STATES_QRLE function is based on a so-called QRLE (Quantized Run Length Encoding) -see https://ieeexplore.ieee.org/abstract/document/8855775- 
% technique where the couple of values (‘zero’ followed by its run number) is replaced just by one value. The key idea of the QRLE method is to guarantee that the MSB bit of 
% the binary representation of the non-null values is ‘0’ while that of the ‘zero’ run number is ‘1’; this is done by 
% adding the value 2^(N-1) to that number where N is its binary representation length. 
% However, given that the zero run numbers could exceed (2*(7)-1?127) value, provided that the RGB colored images are 8 bits long, the MSB is, 
% necessarily, ‘1’. Even worse, the zero run number can be greater than 255 which implies occupying more than 
% one octet. To solve that; the basic idea is to treat the zero run numbers of the AC zig-zag coefficients, according 
% to 3 pre-defined ranges as follows whwre it comes the expression 3 States QRLE: [1..127], [128..255], and [256..maximum. For the first range, ‘128’ value is 
% added to the zero run numbers; while for the second one, the zero run numbers are unchanged but preceded by 
% ‘0’ value. Finally, for the third range, the zero run numbers are kept unchanged while preceded by the number of 
% octets of their binary representation. 
% For more information see  - https://www.researchgate.net/publication/366802356_Three_States_QRLE_Quantized_Run_Length_Encoding_Based_JPEG_Image_Compression_Method -
% 



function [TRE_STAT_QRLE, en_pp, aan] = CHOUAKRI_3_STATES_QRLE(AC_zig)

F=AC_zig;  hh=size(F);   nn=hh(2)
en=[];  run_M = 0;
i=1;    j=1;     h=1;  zz=1;    ss=1;
le=0;  be=0; gr=0;


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % %  CLASSICAL RLE ENCODING
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

switch F(1)
    case 0
        while i<(nn)
            en_NZ=[];
            while ((F(i)==0)  &&   (i<nn)) 
                run_M = run_M + 1;  
                i=i+1;
            end
                
            run(zz)=run_M;  run_pos(zz)=i-1; 
            
            if run(zz)<128   
                le=le+1;
                elseif (run(zz)>127)  &&  (run(zz)<256)   
                    be=be+1;
            else
                gr=gr+1;
            end
                zz=zz+1; en{h}=[0  run_M];   h=h+1;  run_M =0;
                while ( (F(i)~= 0)  &&   (i<nn)  )
                    	en_NZ=[en_NZ  F(i)];
                        en_sans_run(ss)=F(i);   
                        i=i+1;
                        ss=ss+1;
                end
                        en{h}=en_NZ;   h=h+1;
        end
                        
    otherwise
        while i<(nn)
	en_NZ=[];
    
     while ( (F(i)~= 0)  &&   (i<nn)  )
		en_NZ=[en_NZ  F(i)];
		en_sans_run(ss)=F(i);   
		i=i+1;
		ss=ss+1;
       end

en{h}=en_NZ;   h=h+1;

        while ((F(i)==0)  &&   (i<nn)) 
            run_M = run_M + 1;  
            i=i+1;	
     	end

run(zz)=run_M;  run_pos(zz)=i-1; 

if run(zz)<128   
    le=le+1;
elseif (run(zz)>127)  &&  (run(zz)<256)     
    be=be+1;
else
    gr=gr+1;
end

zz=zz+1; en{h}=[0  run_M];   h=h+1;  run_M =0;

     

        end

end


en = cell2mat(en);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NON-NULL COEFFICIENTS NORMALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BETWEEN 5 AND 127 TO KEEP THE MSB = 0


    aan=min(en_sans_run)   %%%%%%%%%% ELEVATE NON-NULL COEFFICIENTS TO RESTORE THE POSITIVE VALUES
    oon=max(en_sans_run)	
    en_pp=oon-aan
    enn1=en-aan;
    %%%%%%%%% NORMALIZE NON-NULL COEFFICIENT TO LESS THAN 120 KEEPING IN
    %%%%%%%%% MIND THE ADDITIVE NOISE
    enn2=(enn1*120)/en_pp;
    enn2_DC=enn2+5;       %%%%%%%%%% '+5' IS USED TO DISTINGUISH THE NORMALIZED NON-NULL FROM THE 3-STATE QRLE COEFFICIENTS 

 
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     
%%%%%%%%%%%%  3-STATES QRLE
% % % % % % % % % % % % % % % % % % % % % % % % % 



dd=size(en);  ddl=dd(2)
w=1; wq=1;
QR=[];
dif_zero=0;
zero_inf_128=0;
zero_sup_127=0;
zero_sup_255=0;



while w<ddl+1
        while en(w)~=0
		QR(wq)=enn2_DC(w);  wq=wq+1;   w=w+1;
        dif_zero=dif_zero +1;
		
		
        end

        while ( w<ddl+1  &&  en(w)== 0   )
            w=w+1;
            if en(w)<128    
			QR(wq)=en(w)+128;   wq=wq+1;    w=w+1;
            zero_inf_128=zero_inf_128+1;
				
		   	elseif    (en(w)<256)  &&  (en(w)>127) 
			QR(wq)=0;   wq=wq+1;
			QR(wq)=en(w);  wq=wq+1; 	w=w+1;
            zero_sup_127=zero_sup_127+1;
			
            else
                QR(wq)=ceil(log10(en(w)+1)/log10(256));  wq=wq+1;
                
                
                a=en(w);
                cei=ceil(log10(a+1)/log10(256));
                b=dec2bin(a,8*cei);
                c=reshape(b,[],8);
                c1=reshape(b,8,[]);
                d=bin2dec(c1');
                e=d';


if cei==3 
    QR(wq)=e(1);  wq=wq+1;   
    QR(wq)=e(2);  wq=wq+1;   
    QR(wq)=e(3);  wq=wq+1;   
    w=w+1;
    zero_sup_255=zero_sup_255+1;

else
    QR(wq)=e(1);  wq=wq+1;   
    QR(wq)=e(2);  wq=wq+1;     
    w=w+1;
    zero_sup_255=zero_sup_255+1;

end
		   	end
		end
end


TRE_STAT_QRLE= QR;
