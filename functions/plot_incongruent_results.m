function plot_incongruent_results(results)
%PLOT_INCONGRUENT_RESULTS Plot congruent vs incongruent simulation

linewidth1=6; linewidth2=2;

%% RT figure
figure;
errorbar(1:2, mean(results.m_rt)*1000 - mean(mean(results.m_rt)*1000), ...
    mean(results.s_rt)*1000, 'LineWidth',linewidth1,'CapSize',18);
ylabel('Reaction Time (ms)');
xticks([1 2]); xticklabels({'Congruent','Incongruent'});
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylim([-200 200]); xlim([0.5 2.5]); box off; hold on;

load Molholm2004.mat
errorbar(1:2, RT-mean(RT), RT_std, 'LineWidth',linewidth2);

legend('Cortical Simulator','Molholm 2004');

%% RR figure
figure;
errorbar(1:2, mean(results.RR)-mean(mean(results.RR)), std(results.RR), ...
    'LineWidth',linewidth1,'CapSize',18);
ylabel('Response Rate (%)');
xticks([1 2]); xticklabels({'Congruent','Incongruent'});
set(gca,'FontSize',20,'LineWidth',linewidth2);
xlim([0.5 2.5]); box off; hold on;

load Guttman2005.mat
errorbar(1:2, (RR-mean(RR))*100, RR_std*100, 'LineWidth',linewidth2);

legend('Cortical Simulator','Guttman 2005');

end
