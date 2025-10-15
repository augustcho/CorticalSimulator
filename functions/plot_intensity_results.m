function plot_intensity_results(results, varargin)
%PLOT_INTENSITY_RESULTS Plot reaction time, std, and response rate vs intensity
%   Optionally compare with classic studies (Cattel, Vaughan, Pins, Nozza).

p = inputParser;
addParameter(p,'compareStudies',true,@islogical);
parse(p,varargin{:});
compareStudies = p.Results.compareStudies;

linewidth1 = 6; linewidth2 = 2;
val_idx = find(results.response_rate > 50);
xintensity = linspace(1,50,length(results.stimulus_intensities));

%% Reaction Time
figure;
simX = zscore(xintensity(val_idx));
simY = results.m_rts(val_idx)*1000;

errorbar(simX, simY, results.s_rts(val_idx)*1000, ...
         'LineWidth', linewidth1, 'DisplayName','Cortical Simulator','CapSize',20);
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylabel('Reaction Time (ms)'); xlabel('Normalized Stimulus Intensity');
ylim([120 320]); xlim([-2 2]); box off; hold on;

if compareStudies
    % --- Cattel 1886 ---
    load Cattel1886.mat
    cattelX = zscore(stim_intensity);
    cattelY = mean(RT,2);
    errorbar(cattelX, mean(RT,2), mean(RT_std,2), ...
             'LineWidth',linewidth2,'DisplayName','Cattel 1886');

    [r_cattel,p_cattel] = corr_btw_study(simX, zscore(simY), cattelX, zscore(cattelY));
    fprintf('Cattel 1886 (RT): r=%.3f, p=%.3g\n', r_cattel, p_cattel);

    % --- Vaughan 1966 ---
    load vaughan1966_4d.mat
    vaughanX = zscore(stim_intensity);
    vaughanY = mean(RT,2);
    plot(vaughanX, vaughanY, 'LineWidth',linewidth2, 'DisplayName','Vaughan 1966');

    [r_vaughan,p_vaughan] = corr_btw_study(simX, zscore(simY), vaughanX, zscore(vaughanY));
    fprintf('Vaughan 1966 (RT): r=%.3f, p=%.3g\n', r_vaughan, p_vaughan);

    % --- Pins 1996 ---
    load Pins1996.mat
    pinsX = zscore(stim_intensity);
    pinsY = mean(RT,2);
    plot(pinsX, pinsY, 'LineWidth',linewidth2, 'DisplayName','Pins 1996');

    [r_pins,p_pins] = corr_btw_study(simX, zscore(simY), pinsX, zscore(pinsY));
    fprintf('Pins 1996 (RT): r=%.3f, p=%.3g\n', r_pins, p_pins);
end
legend show;

%% STD of RT
figure;
simX = zscore(xintensity(val_idx));
simY = results.s_rts(val_idx)*1000;

plot(simX, simY, ...
     'LineWidth',linewidth1, 'DisplayName','Cortical Simulator');
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylabel('STD of Reaction Time (ms)'); xlabel('Stim. Intensity'); ylim([0 30]); box off; hold on;

if compareStudies
    load Cattel1886.mat
    cattelX = zscore(stim_intensity);
    cattelY = mean(RT_std,2);
    plot(cattelX, cattelY, 'LineWidth',linewidth2, 'DisplayName','Cattel 1886');

    [r_cattel_std,p_cattel_std] = corr_btw_study(simX, zscore(simY), cattelX, zscore(cattelY));
    fprintf('Cattel 1886 (STD of RT): r=%.3f, p=%.3g\n', r_cattel_std, p_cattel_std);
end
legend show;

%% Response Rate
figure;
simX = zscore(xintensity(val_idx));
simY = results.response_rate(val_idx);

plot(simX, simY, ...
     'LineWidth',linewidth1, 'DisplayName','Cortical Simulator');
set(gca,'FontSize',20,'LineWidth',linewidth2);
ylabel('Response Rate (%)'); xlabel('Normalized Stimulus Intensity'); ylim([50 115]); box off; hold on;

if compareStudies
    load Nozza1987.mat
    nozzaX = zscore(stim_intensity);
    nozzaY = RR*100;
    plot(nozzaX, nozzaY, 'LineWidth',linewidth2, 'DisplayName','Nozza 1987');

    [r_nozza,p_nozza] = corr_btw_study(simX, zscore(simY), nozzaX, zscore(nozzaY));
    fprintf('Nozza 1987 (RR): r=%.3f, p=%.3g\n', r_nozza, p_nozza);
end
legend show;

end
