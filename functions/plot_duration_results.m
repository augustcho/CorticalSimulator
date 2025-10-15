function plot_duration_results(results, varargin)
%PLOT_DURATION_RESULTS Plot reaction time vs stimulus duration
%   Optionally compare with classic studies.

p = inputParser;
addParameter(p,'compareStudies',true,@islogical);
parse(p,varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6; linewidth2 = 2;

xduration = linspace(2.5,2.5*results.stim_durations(end),length(results.stim_durations));
m_rt = mean(results.m_rts,1,'omitnan');
s_rt = mean(results.s_rts,1,'omitnan');

figure;
errorbar(xduration, m_rt*1000, s_rt*1000, ...
         'LineWidth',linewidth1,'DisplayName','Cortical Simulator','CapSize',20);
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylabel('Reaction Time (ms)'); xlabel('Stimulus Duration (ms)');
xlim([0 50]); box off; hold on;

simX = xduration(:);
simY = zscore(m_rt(:)*1000);

if compareStudies
    load Urich1998_v2.mat
    plot(duration_timex,RT, 'LineWidth',linewidth2,'DisplayName','Ulrich 1998');
    [r_ulrich,p_ulrich] = corr_btw_study(simX, simY, duration_timex(:), zscore(RT(:)));
    fprintf('Ulrich 1998: r=%.3f, p=%.3g\n', r_ulrich, p_ulrich);

    load Hildreth1973.mat
    load HIldreth1973std.mat
    hildreth_timex = 2.^[0:7];
    errorbar(hildreth_timex,RT,mean(std_data,2), ...
             'LineWidth',linewidth2,'DisplayName','Hildreth 1973');
    [r_hildreth,p_hildreth] = corr_btw_study(simX, simY, hildreth_timex(:), zscore(RT(:)));
    fprintf('Hildreth 1973: r=%.3f, p=%.3g\n', r_hildreth, p_hildreth);

    load Raab1962.mat
    plot(duration_timex,RT, 'LineWidth',linewidth2,'DisplayName','Raab 1962');
    [r_raab,p_raab] = corr_btw_study(simX, simY, duration_timex(:), zscore(RT(:)));
    fprintf('Raab 1962: r=%.3f, p=%.3g\n', r_raab, p_raab);
end

legend show;

end
