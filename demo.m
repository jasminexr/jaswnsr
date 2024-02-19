clc;
clear all;
close all;
warning off;

%% PARAMETER INITIALIZATION

xm=100;
ym=100;
sink.x=0.5*xm;             %location of sink on x-axis
sink.y=0.5*ym;             %location of sink on y-axis
n=100;                     %nodes
P=0.1;                     %probability of cluster heads
Eo=0.5;                    %Initial Energy
Echeck=Eo;
ETX=50*0.000000001;        %tx energy
ERX=50*0.000000001;        %rx energy
Efs=10*0.000000000001;     %free space loss
Emp=0.0013*0.000000000001; %multipath loss 
EDA=5*0.000000001;         %compression energy
a=1.5;                     %fraction of energy enhancment of advance nodes
rmax=5000;                 %maximum number of rounds
do=sqrt(Efs/Emp);          %distance do is measured
Et=0; 
m=0.5;
mo=0.4;
b=3;
normal=n*(1-m);
advance=n*m*(1-mo);
monaysuper=n*m*mo;
A=0;
Sp = 500;
sX = 50;
sY = 25;
nWPoints = 5;
d1=0.765*xm/2;                                  %Intra-cluster distance
K=sqrt(0.5*n*do/pi)*xm/d1^2;                    %Network Connectivity
d2=xm/sqrt(2*pi*K);                             %sink distance
Er=4000*(2*n*ETX+n*EDA+K*Emp*d1^4+n*Efs*d2^2);  %Residual Energy
S(n+1).xd=sink.x;S(n+1).yd=sink.y;               
            
%% CLUSTER FORMATION

tic;
rng('default') 
X=[randn(100,2)];
clusterfig(X);
%% CH SELECTION

countCHs=0;               %variable, counts the cluster head
cluster=1;                %cluster is initialized as 1
allive=n;
flag_first_dead=0;      
flag_teenth_dead=0;       
flag_all_dead=0;          
dead=0;                   
first_dead=0;
teenth_dead=0;
all_dead=0;
for i=1:1:monaysuper
 S(i).xd=rand(1,1)*xm;  
 XR(i)=S(i).xd;
 S(i).yd=rand(1,1)*ym;  
 YR(i)=S(i).yd;
 S(i).G=0; 
 S(i).E=Eo*(1+b);
 E(i)= S(i).E;
 Et=Et+E(i);  
 S(i).type='N';
end
 talha1=monaysuper+advance;
for i=monaysuper:1:talha1
 S(i).xd=rand(1,1)*xm;  
 XR(i)=S(i).xd;
 S(i).yd=rand(1,1)*ym;  
 YR(i)=S(i).yd;
 S(i).G=0; 
 S(i).E=Eo*(1+a);
 E(i)= S(i).E;
 Et=Et+E(i); 
 S(i).type='N';
end
for i=talha1:1:n
S(i).xd=rand(1,1)*xm;  
XR(i)=S(i).xd;
S(i).yd=rand(1,1)*ym;  
YR(i)=S(i).yd;
S(i).G=0; 
S(i).E=Eo;
E(i)= S(i).E;
Et=Et+E(i);  
S(i).type='N';
end
N_samples=50000; 
type_alg=1; 
[x_samples,time,AR,NP]=Chselection(N_samples,type_alg);

%% OPTIMAL PATH SELECTION

W_x = mWFun(sX,sY);
W_y = mWFun(sX,sY);
xx=fermiparadox(sX,sY);
objectiveFun = @(P) getFromPath(P,W_x,W_y,Sp,sX,sY,'pchip');
opts = optimset('fmincon');
opts.Display = 'iter';
opts.Algorithm = 'active-set';
opts.MaxFunEvals = 2000;
xWPoints = linspace(0,sX,nWPoints+2)';
yWPoints = sY/2 * ones(nWPoints+2,1);
ic = [xWPoints(2:end-1)'; yWPoints(2:end-1)'];
ic = ic(:);
lb = zeros(size(ic(:)));
ub = reshape([sX*ones(1,nWPoints); sY*ones(1,nWPoints)],[],1);
optimalWayPoints = fmincon(objectiveFun, ic(:), [],[],[],[],lb,ub,[],opts)
optimalWayPoints = [0 sY/2; reshape(optimalWayPoints,2,[])'; sX sY/2];
xWPoints = optimalWayPoints(:,1);
yWPoints = optimalWayPoints(:,2);
PathPoints = WayPoints_To_Path([xWPoints,yWPoints],'pchip',sX,sY,101);
LTway = getFromPath(PathPoints,W_x,W_y,Sp);
packets_TO_BS=0;
packets_TO_CH=0;
for r=0:1:rmax
 
if(mod(r, round(1/P) )==0)
for i=1:1:n
S(i).G=0;
S(i).cl=0;
end
end
end
Ea=Et*(1-r/rmax)/n;
dead=0;

for i=1:1:n
if (S(i).E<=0)
dead=dead+1;
if (dead==1)
if(flag_first_dead==0)
first_dead=r;
flag_first_dead=1;
end
end
if(dead==0.1*n)
if(flag_teenth_dead==0)
teenth_dead=r;
flag_teenth_dead=1;
end
end
if(dead==n)
if(flag_all_dead==0)
all_dead=r;
flag_all_dead=1;
end
end
end
if S(i).E>0
S(i).type='N';
end
end 

for r=0:1:rmax     
   
  if(mod(r, round(1/P) )==0)
    for i=1:1:n
        S(i).G=0;
        S(i).cl=0;
    end
  end
Ea=Et*(1-r/rmax)/n;
dead=0;
for i=1:1:n
   
    if (S(i).E<=0)
        dead=dead+1; 
        if (dead==1)
           if(flag_first_dead==0)
              first_dead=r;
              flag_first_dead=1;
           end
        end
        if(dead==0.1*n)
           if(flag_teenth_dead==0)
              teenth_dead=r;
              flag_teenth_dead=1;
           end
        end
        if(dead==n)
           if(flag_all_dead==0)
              all_dead=r;
              flag_all_dead=1;
           end
        end
    end
    if S(i).E>0
        S(i).type='N';
    end
end
STATISTICS.DEAD(r+1)=dead;
STATISTICS.ALLIVE(r+1)=allive-dead;
countCHs=0;
cluster=1;
for i=1:1:n
 if Ea>0
  p(i)=P*n*(1+a)*E(i)/(n+A)*(Ea);   
 if(S(i).E>0)
   temp_rand=rand;     
   if ( (S(i).G)<=0)  
        if(temp_rand<= (p(i)/(1-p(i)*mod(r,round(1/p(i))))))
            countCHs=countCHs+1;
            packets_TO_BS=packets_TO_BS+1;
            PACKETS_TO_BS(r+1)=packets_TO_BS;
             S(i).type='C';
            S(i).G=round(1/p(i))-1;
            C(cluster).xd=S(i).xd;
            C(cluster).yd=S(i).yd;
           distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
            C(cluster).distance=distance;
            C(cluster).id=i;
            X(cluster)=S(i).xd;
            Y(cluster)=S(i).yd;
            cluster=cluster+1;
           distance;
            if (distance>do)
                S(i).E=S(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance )); 
            end
            if (distance<=do)
                S(i).E=S(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance )); 
            end
        end     
    
   end
   
 end 
 end
end
STATISTICS.COUNTCHS(r+1)=countCHs;

for i=1:1:n
   if ( S(i).type=='N' && S(i).E>0 )
     if(cluster-1>=1)
       min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
       min_dis_cluster=0;
       for c=1:1:cluster-1
           temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
           if ( temp<min_dis )
               min_dis=temp;
               min_dis_cluster=c;
           end
       end
      
       if(min_dis_cluster~=0)    
            min_dis;
            if (min_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
      
            S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 ); 
            packets_TO_CH=packets_TO_CH+1;
       else 
            min_dis;
            if (min_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
            packets_TO_BS=packets_TO_BS+1;
            
       end
        S(i).min_dis=min_dis;
       S(i).min_dis_cluster=min_dis_cluster;
   else
            min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
            if (min_dis>do)
                S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis)); 
            end
            if (min_dis<=do)
                S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis)); 
            end
            packets_TO_BS=packets_TO_BS+1;
   end
  end
end
STATISTICS.PACKETS_TO_CH(r+1)=packets_TO_CH;
STATISTICS.PACKETS_TO_BS(r+1)=packets_TO_BS;
end
first_dead;
teenth_dead;
all_dead;

STATISTICS.DEAD(r+1);
STATISTICS.ALLIVE(r+1);
STATISTICS.PACKETS_TO_CH(r+1);
STATISTICS.PACKETS_TO_BS(r+1);
STATISTICS.COUNTCHS(r+1);
toc;
%% PERFORMANCE EVALUATION & COMPARISON
[PDR1,PDR2,PDR3,PDR4,RE1,RE2,RE3,throughput1,throughput2,throughput3]=fig(STATISTICS.DEAD,STATISTICS.ALLIVE,STATISTICS.PACKETS_TO_CH,STATISTICS.PACKETS_TO_BS,STATISTICS.COUNTCHS);
[packetsize,RE,T]=updation(n,m);
[throughput]= performance(packetsize,n,T);
fprintf('\n PERFORMANCE OF THE PROPOSED LEACH \n');
fprintf('Packet Delivery Ratio = %d \n',PDR1);
fprintf('Residual Energy = %s \n',RE);
fprintf('Throughput= %d \n',throughput1);
fprintf('\n PERFORMANCE OF THE PROPOSED M_GEAR \n');
fprintf('Packet Delivery Ratio = %d \n',PDR2);
fprintf('Residual Energy = %s \n',RE2);
fprintf('Throughput= %d \n',throughput2);
fprintf('\n PERFORMANCE OF THE PROPOSED DEEC \n');
fprintf('Packet Delivery Ratio = %d \n',PDR3);
fprintf('Residual Energy = %s \n',RE3);
fprintf('Throughput= %d \n',throughput3);
fprintf('\n PERFORMANCE OF THE PROPOSED ALGORITHM \n');
fprintf('Packet Delivery Ratio = %d \n',PDR4);
fprintf('Residual Energy = %s \n',RE1);
fprintf('Throughput= %d \n',throughput);


