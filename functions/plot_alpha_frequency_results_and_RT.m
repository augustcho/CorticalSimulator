function plot_alpha_frequency_results_and_RT(results, varargin)
%PLOT_ALPHA_FREQUENCY_RESULTS Plot RT vs frequency, compare with Surwillo 1961.

p = inputParser;
addParameter(p, 'compareStudies', false, @islogical);
parse(p, varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6;
linewidth2 = 2;

m_rt = mean(results.m_rts,2,'omitnan');
s_rt = mean(results.s_rts,2,'omitnan');

figure;
errorbar(results.osc_hz_list, zscore(m_rt*1000), ...
         zscore(s_rt*1000), 'LineWidth', linewidth1, 'DisplayName','Cortical Simulator',...
         'CapSize',20);
ylabel('Normalized Reaction Time (ms)');
xlabel('Alpha Frequency (Hz)');
set(gca,'FontSize',20,'LineWidth',linewidth2);
xlim([min(results.osc_hz_list)-0.5, max(results.osc_hz_list)+0.5]);
box off; hold on;

if compareStudies
    load surwillo1961.mat
    old_freq = 1./alpha_period_old*1000;
    young_freq = 1./alpha_period_young*1000;

    % Plot Surwillo fit and raw points
    plot(fit_X, zscore(fit_Y), 'Color','r','LineWidth',linewidth2, 'DisplayName','Surwillo fit');
    plot(old_freq, zscore(reaction_time_old), 'r*', 'DisplayName','Surwillo old');
    plot(young_freq, zscore(reaction_time_young), 'r*', 'HandleVisibility','off');

    % ----- Correlation with Surwillo fit -----
    simX = results.osc_hz_list(:);
    simY = zscore(m_rt(:)*1000);

    [r_fit, p_fit] = corr_btw_study(simX, simY, ...
                                    fit_X(:), ...
                                    zscore(fit_Y(:)));
    fprintf('Surwillo 1961 fit: r = %.3f, p = %.3g\n', r_fit, p_fit);
end

legend show;

end
