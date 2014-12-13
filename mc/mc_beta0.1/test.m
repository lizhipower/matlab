
[lolp1 beta1] = mcNSeq_for(1);
% [lolp2 beta2] = mcNSeq_for(2);
[lolp4 beta4] = mcNSeq_for(4);

subplot(2,1,1);
bar(lolp1,'g');
hold on;
bar(lolp2,'b');
hold on;
bar(lolp4,'r');
hold off;
subplot(2,1,2);
bar(beta1,'g');
hold on;
bar(beta2,'b');
hold on;
bar(beta4,'r');
hold off;