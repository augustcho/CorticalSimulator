function plot_alpha_phase_and_excitability_results(results, config, varargin)
%PLOT_ALPHA_PHASE_RESULTS Plot alpha phase vs excitability
%   plot_alpha_phase_results(results, config)
%   plot_alpha_phase_results(results, config, 'compareStudies', true)

p = inputParser;
addParameter(p, 'compareStudies', false, @islogical);
parse(p, varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6;
linewidth2 = 2;

% Normalize simulator results
CSphase = results.phase_bin_avg(:,1);
val_idx = find(~isnan(CSphase));
CSphase(val_idx) = zscore(CSphase(val_idx));

simX = results.pbin_idx(val_idx);
simY = CSphase(val_idx);

figure;
plot(simX, simY, ...
    'LineWidth', linewidth1, 'DisplayName','Cortical Simulator');
hold on;

if compareStudies
    load Haegens2011NFphase
    load Haegens2011NFphaseSTD
    load Schalk2017

    % ----- Haegens 2011 -----
    new_data = Haegens2011NFphase([6 1:5]); % reorder
    Haegens_xaxis = linspace(-pi,pi,length(Haegens2011NFphase));
    plot(Haegens_xaxis, zscore(new_data), ...
        'LineWidth', linewidth2, 'DisplayName','Haegens 2011');

    % Correlation
    [r_haegens, p_haegens] = corr_btw_study(simX, simY, ...
                                            Haegens_xaxis, ...
                                            zscore(new_data));
    fprintf('Haegens 2011 phase: r = %.3f, p = %.3g\n', r_haegens, p_haegens);

    % ----- Schalk 2017 -----
    plot(SchalkPhaseX, zscore(SchalkPhaseY), ...
        'LineWidth', linewidth2, 'DisplayName','Schalk 2017');

    [r_schalk, p_schalk] = corr_btw_study(simX, simY, ...
                                          SchalkPhaseX, ...
                                          zscore(SchalkPhaseY));
    fprintf('Schalk 2017 phase: r = %.3f, p = %.3g\n', r_schalk, p_schalk);
end

legend show;
xlabel('\alpha Phase'); ylabel('Cortical Excitability');
set(gca,'FontSize',20,'LineWidth',linewidth2);
xticks([-pi 0 pi]); xticklabels({'-\pi','0','\pi'});
ylim([-2 3]); grid off; box off;

end
