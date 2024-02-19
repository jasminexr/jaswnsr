function clusterfig(X)
X1=[randn(200,2)];
X2=[randn(300,2)];
X3=[randn(400,2)];
X4=[randn(500,2)];
x0=10;
y0=10;width=600;height=600;
figure (1);
set(gcf,'position',[x0,y0,width,height]);
sgtitle('Random Node Deployment in Network');
subplot(5,1,1)
gscatter(X(:,1),X(:,2));
legend('Nodes');
subtitle('Number of nodes=100');
subplot(5,1,2)
gscatter(X1(:,1),X1(:,2));
legend('Nodes');
subtitle('Number of nodes=200');
subplot(5,1,3)
gscatter(X2(:,1),X2(:,2));
legend('Nodes');
subtitle('Number of nodes=300');
subplot(5,1,4)
gscatter(X3(:,1),X3(:,2));
legend('Nodes');
subtitle('Number of nodes=400');
subplot(5,1,5)
gscatter(X4(:,1),X4(:,2));
legend('Nodes');
subtitle('Number of nodes=500');
pcode Barneshut
[Y,loss,L,D]=Barneshut(X);
[Y1,loss,L,D]=Barneshut(X1);
[Y2,loss,L,D]=Barneshut(X2);
[Y3,loss,L,D]=Barneshut(X3);
[Y4,loss,L,D]=Barneshut(X4);

figure (2);
sgtitle('Cluster Formation');
set(gcf,'position',[x0,y0,width,height]);
subplot(5,1,1)
gscatter(X(:,1),X(:,2),Y,'bgm');
legend('Cluster 1','Cluster 2','Cluster 3')
subtitle('Number of nodes=100');
subplot(5,1,2)
gscatter(X1(:,1),X1(:,2),Y1,'bgm');
legend('Cluster 1','Cluster 2','Cluster 3')
subtitle('Number of nodes=200');
subplot(5,1,3)
gscatter(X2(:,1),X2(:,2),Y2,'bgm');
legend('Cluster 1','Cluster 2','Cluster 3')
subtitle('Number of nodes=300');
subplot(5,1,4)
gscatter(X3(:,1),X3(:,2),Y3,'bgm');
legend('Cluster 1','Cluster 2','Cluster 3')
subtitle('Number of nodes=400');
subplot(5,1,5)
gscatter(X4(:,1),X4(:,2),Y4,'bgm');
legend('Cluster 1','Cluster 2','Cluster 3')
subtitle('Number of nodes=500');
