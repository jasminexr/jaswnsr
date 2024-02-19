function xx=fermiparadox(aj,eta)

format long e;
range=8.;
if eta > 0.
   range=sqrt(eta+64.);
end;
h=0.5;
nmax=range/h;
sum=0.;
if aj== (-0.5)
   sum=1./(1.+exp(-eta));
end;
for i=1:nmax
   u=i*h;
   ff=2.*(u^(2.*aj+1))/(1.+exp(u*u-eta));
   sum=sum+ff;
end;
pol=0.;
npole=0;

bk1=0;
while bk1 <= 14.*pi
   npole=npole+1;
   bk=(2*npole -1)*pi;
   rho=sqrt(eta*eta+bk*bk);
   t1=1;
   t2=0;
   if eta < 0;
      tk=- aj*(atan(-bk/eta)+pi);
   elseif eta ==0;
      tk=0.5*pi*aj;
   else;
      eta > 0;
      tk=aj*atan(bk/eta);
   end;
   rk=- (rho^aj);
   tk=tk+0.5*atan(t2/t1);
   if eta < 0
      rk= -rk;
   end;
   ak=(2.*pi/h)*sqrt(0.5*(rho+eta));
   bk1=(2.*pi/h)*sqrt(0.5*(rho-eta));
   if bk1 <= (14.*pi)
   gama=exp(bk1);
   t1=gama*sin(ak+tk)-sin(tk);
   t2=1.-2.*gama*cos(ak)+gama*gama;
   pol=pol+4.*pi*rk*t1/t2;
   end; 
  end; 
  npole=npole-1;
  fdp=sum*h+pol;
  xx=fdp/gamma(1+aj);
  disp('Energy desipated per round ');
  disp(xx);
 
