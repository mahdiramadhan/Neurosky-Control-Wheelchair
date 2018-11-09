%muhammad mahdi ramadhan

clc;
clear;
close all; 
Data=zeros(30,1);%you just get data from 0 to 30, you can change the number depend on what you need
Rata=zeros(30,1);

%communication to Neurosky
ComPort = '\\.\COM5';%make sure your port is true, if you akready try every port and still get wrong, no problem just restart yout matlab
TG_BAUD_57600=57600;
TG_STREAM_PACKETS=0;
TG_DATA_RAW = 4;
TG_DATA_ATTENTION = 2;
TG_DATA_MEDITATION = 3;
loadlibrary('thinkgear.dll');%make sure your directory already include the true library, understand you use library 32 bit or 64 bit
Dllversion=calllib('thinkgear','TG_GetVersion');
ConnectionId=calllib('thinkgear','TG_GetNewConnectionId');
CommERR=calllib('thinkgear','TG_Connect',ConnectionId,ComPort,TG_BAUD_57600,TG_STREAM_PACKETS);
if CommERR < 0
disp('Wrong port'); 
end

%communication to module bluetooth HC-05
b=serial('COM9','BaudRate',9600);
fopen(b) ;%open bluetooth communication 
%set initial data
i=1;
j=1;
k=1;
l=1;

while i < 30 && l < 30 
%Call library from neurosky
if (calllib('thinkgear','TG_ReadPackets',ConnectionId,1)==1)
if (calllib('thinkgear','TG_GetValueStatus',ConnectionId,TG_DATA_ATTENTION ) ~= 0)
if (calllib('thinkgear','TG_GetValueStatus',ConnectionId,TG_DATA_MEDITATION ) ~= 0)
j = j + 1;
i = i + 1;
k = j + 1;
l = i + 1;

%Data
Data(j)=calllib('thinkgear','TG_GetValue',ConnectionId,TG_DATA_ATTENTION);
Rata(k)=calllib('thinkgear','TG_GetValue',ConnectionId,TG_DATA_MEDITATION);

%task, easy change depend on what you want
if(Rata(k) < 60 && Data(j) >= 60)
    fwrite(b,'1');
elseif (Rata(k) >= 60 && Data(j) <60 )
    fwrite(b,'0');
elseif (Rata(k) < 60 && Data(j) < 60)
    fwrite(b,'5');
elseif (Rata(k) >= 60 && Data(j) >=60)
    fwrite(b,'5');
end

%Make a Graphic
subplot(2,1,1)          
plot(Data)
title('Attention');
drawnow
subplot(2,1,2)
plot(Rata)
title('Meditation');
drawnow
end
end
end
end

%Disconnect Neurosky & Bluetooth
fwrite(b,'5');
fclose(b)
calllib('thinkgear', 'TG_FreeConnection', ConnectionId );
calllib('thinkgear', 'TG_Disconnect', ConnectionId );