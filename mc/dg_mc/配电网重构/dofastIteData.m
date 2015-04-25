initData = [
149.6 156 158.4 170.1 184.1 186.7 211.5 297.8 302.5 319.6 338.4 359.6 449 1102.1 1198.4
];
fastIteData = [
173.1 176.8 179.8 187.0 189.8 189.9 190.8 191.7 193.9 194.4 195.4 197.0 197.8 202.3 204.2
];
initSpd = diff(initData);
fastIteSpd = diff(fastIteData);

initSpdPercent = initSpd ./ initData(2:end)
fastIteSpdPercent = fastIteSpd ./ fastIteData(2:end)
plot(initSpdPercent(1:12))
hold on;
plot(fastIteSpdPercent(1:12))
hold off;
