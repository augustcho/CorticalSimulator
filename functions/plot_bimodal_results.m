function plot_bimodal_results(results)
%PLOT_BIMODAL_RESULTS Plot Uni vs Bimodal sensory simulation results

linewidth1=4; linewidth2=2;

%% Figure 1: Reaction Time
figure;
errorbar(1:3, results.m_rt*1000 - mean(results.m_rt)*1000, ...
    results.s_rt*1000,'o','LineWidth',linewidth1,'CapSize',18);
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylabel('Reaction Time (ms)');
xticks([0.5 1 2 3 3.5]);
xticklabels({'','V','A','V+A',''});
xlim([0.5 3.5]); ylim([-100 100]);
title('Reaction Time: Cortical Simulator vs Studies'); hold on;

% Molholm 2002
load molholm2002.mat
RT_idx=3:-1:1;
errorbar(1:3, RT(RT_idx)-mean(RT(RT_idx)), RT_std(RT_idx), ...
    'o','LineWidth',linewidth2);

% Senkowski 2011
load Senkowski2011.mat
RT_idx=1:3;
errorbar(1:3, RT(RT_idx)-mean(RT(RT_idx)), RT_std(RT_idx), ...
    'o','LineWidth',linewidth2);

legend('Cortical Simulator','Molholm 2002','Senkowski 2011');
box off;

%% Figure 2: Response Rate
figure;
plot(1:3, zscore(results.response_rate),'x','LineWidth',linewidth1,'MarkerSize',20);
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylabel('Normalized Response Rate');
xticks([0.5 1 2 3 3.5]);
xticklabels({'','V','A','V+A',''});
xlim([0.5 3.5]);
title('Response Rate: Cortical Simulator vs Studies'); hold on;

load giard1999RR.mat
plot(1:3,zscore(RR),'x','LineWidth',linewidth2,'MarkerSize',20);

legend('Cortical Simulator','Giard 1999A','Giard 1999B');
box off;

end
