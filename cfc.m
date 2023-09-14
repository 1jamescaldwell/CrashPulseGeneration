function Y=cfc(X,T,CFC)
%CFC Channel Frequency Class filtering
%   y = CFC(x,dt,cfc) filters the vector of measurements x taken at time
%   intervals dt using filter type cfc.
%
%   X(t)    Input data sequence
%   Y(t)    Filtered output data sequence
%   CFC     Channel Frequency Class type
%   T       Sampling rate in seconds
%   
%   CFC filters are analog or digital filters. The filters can be phased or
%   un-phased. The following table lists the most common filter types.
%    _____________ _______________________________________
%   | Filter Type | Filter Parameters
%   |_____________|_______________________________________
%   | CFC 60      | 3 dB limit frequency | 100 Hz
%   |             | Stop damping         | -30 dB
%   |_____________| Sampling frequency   | at least 600 Hz
%   | CFC 180     | 3 dB limit frequency | 300 Hz
%   |             | Stop damping         | -30 dB
%   |_____________| Sampling frequency   | at least 1800 Hz
%   | CFC 600     | 3 dB limit frequency | 1000 Hz
%   |             | Stop damping         | -40 dB
%   |_____________| Sampling frequency   | at least 6 kHz
%   | CFC 1000    | 3 dB limit frequency | 1650 Hz
%   |             | Stop damping         | -40 dB
%   |_____________| Sampling frequency   | at least 10 kHz
%
%   In accordance with SAE J211, a 4-channel Butterworth low pass with
%   linear phase and special starting conditions is used as a digital
%   filter.
%
%   Taewung Kim, Center for Applied Biomechanics (comments: JP Donlon)
%   http://zone.ni.com/reference/en-XX/help/370859H-01/crash/misc_cfc/
%   JP Donlon: expanded 4/6/2022 to handle NANs/gaps by piecewise filtering

wd=2*pi*CFC*2.0775;
wa=(sin(wd*T/2))/(cos(wd*T/2));
a0=(wa^2)/(1+wa*(2^.5)+wa^2);
a1=2*a0;
a2=a0;
b1=-2*((wa^2)-1)/(1+wa*(2^.5)+wa^2);
b2=(-1+wa*(2^.5)-wa^2)/(1+wa*(2^.5)+wa^2);

A=[1 -b1 -b2];
B=[a0 a1 a2];

p=[1;find(gradient(isnan(X)));length(X)];
Y=X;
flag=true;
for pdx=1:length(p)/2
    if flag
        Y(p((pdx-1)*2+1):p((pdx-1)*2+2))=filtfilt(B,A,X(p((pdx-1)*2+1):p((pdx-1)*2+2)));
    else
        Y(p((pdx-1)*2+1):p((pdx-1)*2+2))=nan;
    end
    flag=~flag;
end
% Y=filtfilt(B,A,X);
