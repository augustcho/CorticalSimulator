function plot_hit_rate_high_alpha_results(results, varargin)
%PLOT_ALPHA_PHASE_HIGH_RESULTS Plot phase-dependent hit rate, compare with Mathewson 2009.

p = inputParser;
addParameter(p,'compareStudies',true,@islogical);
parse(p,varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6; linewidth2 = 2;

% Compute phase averages
phase_bin_avg = mean(results.phase_alpha_table,2,'omitnan');

% Peak vs trough
pbin_idx = results.pbin_idx;
peak_idx = pbin_idx >= -pi/2 & pbin_idx <= pi/2;
trough_idx = pbin_idx < -pi/2 | pbin_idx > pi/2;

peak_hr_avg = mean(phase_bin_avg(peak_idx),'omitnan');
peak_hr_std = std(phase_bin_avg(peak_idx),'omitnan')/sqrt(sum(peak_idx));
trough_hr_avg = mean(phase_bin_avg(trough_idx),'omitnan');
trough_hr_std = std(phase_bin_avg(trough_idx),'omitnan')/sqrt(sum(trough_idx));

figure;
errorbar([peak_hr_avg trough_hr_avg] - mean([peak_hr_avg trough_hr_avg]), ...
         [peak_hr_std trough_hr_std], 'LineWidth',linewidth1,'CapSize',18, ...
         'DisplayName','Cortical Simulator');
xlim([0.5 2.5]);
ylabel('Centered Hit Ratio (%)');
set(gca,'XTickLabel',{'','Peak','','Trough'},'FontSize',20,'LineWidth',linewidth2);
box off; hold on;

if compareStudies
    load mathewson2009.mat
    m_avg = high_alpha;
    m_std = high_alpha_max - high_alpha;
    errorbar(m_avg-mean(m_avg), m_std, 'LineWidth',linewidth2, 'DisplayName','Mathewson 2009');
end

legend show;

end
