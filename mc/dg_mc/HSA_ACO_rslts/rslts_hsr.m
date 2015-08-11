a = [205 92 78 71 63];
b = [25 60 70 80 85];
c = [25.44 21.58 25.32 31.17 43.22];
x = 0 : 0.05 : 0.2;


% figure('color','w')
%第一个图
a1=axes;
plot(x,a);
% polyfit(x,a,2);
set(a1,'position',[.1,.1,.7,.85],'ycolor','b','box','off')
ylabel('y1')
xlim([0,0.2]);
%第二个图
a2=axes;
b=plot(a2,x,b);
set(a2,'position',[.1,.1,.7,.85],'ycolor','k','box','off','yaxislocation','right','color','none')
ylabel('y2')
xlim([0,0.2]);

%第三个图
a3=axes;
plot(a3,x,c);
set(a3,'position',[.1,.1,.7,.85],'visible','off')
xlim([0,0.2]);
a4=axes;
set(a4,'position',[.9,.1,eps,.85],'box','off','yaxislocation','right','color','none','ylim',get(a3,'ylim'),'ycolor','r')
ylabel('y3')

