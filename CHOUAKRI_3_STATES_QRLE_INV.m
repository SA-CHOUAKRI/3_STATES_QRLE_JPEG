% CHOUAKRI_3_STATES_QRLE_INV function is the inverse process of CHOUAKRI_3_STATES_QRLE function

function [AC_decode] = CHOUAKRI_3_STATES_QRLE(TRE_STAT_QRLE, en_pp, aan)

QR=TRE_STAT_QRLE;
ddi=size(QR);  ddli=ddi(2)
wi=1; wqi=1;
QRi=[];

while wi<ddli+1
	        if QR(wi)== 0
                wi=wi+1;
                QRi=[QRi zeros(1,QR(wi))];
                wi=wi+1;
            elseif  QR(wi)==2   ||  QR(wi)==3             
                if QR(wi)==3
                    a_rec=(QR(wi+1)*256*256)+(QR(wi+2)*256)+QR(wi+3);
                    QRi=[QRi zeros(1,a_rec)];
                    wi=wi+4;
                else 
                    a_rec=(QR(wi+1)*256)+QR(wi+2);
                    QRi=[QRi zeros(1,a_rec)];
                    wi=wi+3;
                end
            elseif   QR(wi)>127
                zero_sup=QR(wi)-128;
                QRi=[QRi zeros(1,zero_sup)];
                wi=wi+1;
            else
                QRi=[QRi (((QR(wi)-5)*en_pp)/120)+ aan];
                wi=wi+1;
            end
end
         

AC_decode =  [QRi  0];
