pathname = pwd;
filename = '20190710_001_nomovie_MPC.mat';

fullpathname = strcat(pathname,'/', filename);

load(fullpathname)

size_heat = size(data.dat.heat_param);


x = [];
for i = 1:size_heat(2)
    x(i) = data.dat.heat_param(i).intensity;
end

y = data.dat.rating;

figure
suptitle('MPC callibration result')
scatter(x,y)
axis([min(x)-1 max(x)+1 0 max(y)+0.1]);
xlabel('Demends', 'FontSize', 10, 'Color', 'w');
ylabel('Rating', 'FontSize', 10, 'Color', 'w');
hold on

mdl = fitlm(x,y)
plotAdded(mdl)

