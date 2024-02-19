function [x_samples,time,AR,NP]=PARS(N_samples,Delta)

a=1.2;
r=2;
V=@(x)(-(r/a)*x.^2+(2*r-1)*log(abs(x)))+log(double(x>=0));
D_v=@(x) ((2*r - 1)./x - (2*r.*x)/a)+log(double(x>=0));
S=[0.5,1,2];
S=sort(S);

x_samples=[];
count_acc_samples=0;
t=0; 
tic

 while count_acc_samples<=N_samples   
   
     t=t+1;
      
   m=D_v(S);
   b=V(S)-m.*S; 
   for i=1:length(S)-1
      [xint(i),yint(i)]=Inter_between_2Lines(m(i),b(i),m(i+1),b(i+1));
   end
 
S2=[0 xint +inf];
for i=1:length(S2)-1  
      AREA(i)=(1/m(i))*exp(m(i)*S2(i+1)+b(i))-(1/m(i))*exp(m(i)*S2(i)+b(i));
end

wn=AREA/sum(AREA);
chosen_piece=randsrc(1,1,[1:length(wn);wn]);
   
Ntot_pieces=length(S);       
if chosen_piece==Ntot_pieces+1
         y=exp(m(Ntot_pieces+1)*S2(Ntot_pieces+1)+b(Ntot_pieces+1))-exp(m(Ntot_pieces+1)*S2(Ntot_pieces+1)+b(Ntot_pieces+1))*rand(1,1);
        xpr=(log(y)-b(Ntot_pieces+1))/m(Ntot_pieces+1);
else
     y=exp(m(chosen_piece)*S2(chosen_piece)+b(chosen_piece))+(exp(m(chosen_piece)*S2(chosen_piece+1)+b(chosen_piece))-exp(m(chosen_piece)*S2(chosen_piece)+b(chosen_piece)))*rand(1,1);
     xpr=-(b(chosen_piece) - log(y))/m(chosen_piece);      
end

eval_TAR=exp(V(xpr));

eval_PROP=exp(m(chosen_piece)*xpr+b(chosen_piece));

 U=rand(1,1);
     if U<eval_TAR/eval_PROP 
        x_samples(end+1)=xpr;
        count_acc_samples=count_acc_samples+1;
     end
 
      if eval_TAR/eval_PROP<=Delta
         S=[S xpr];   
         S=sort(S);
      end
     
 end  
 time=toc; 
AR=count_acc_samples/t; 
NP=length(S);  


