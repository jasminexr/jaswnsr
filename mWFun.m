function Iw = mWFun(SZX,SZY)

wFss = 0.1;
if ~exist('SZX','var')
SZX = 50;
SZY = 50;
end
N = 50; 
NL = 40; 
NP = 500;
rx = randn(NL,N);
rx = interpft(rx,NP);
ry = randn(NL,N);
ry = interpft(ry,NP);
I = (rx*ry');

[xgi,ygi] = meshgrid(linspace(1,2 + 498*wFss,SZX+1),linspace(1,2 + 498*wFss,SZY+1));
Iw = 10*interp2(1:500,1:500,I,xgi,ygi);

