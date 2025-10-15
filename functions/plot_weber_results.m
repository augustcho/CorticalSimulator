function plot_weber_results(results)
%PLOT_WEBER_RESULTS Plot Weber fraction relationship

linewidth1=6; linewidth2=2;

val_idx = find(results.response_rate > 50);
stimulus_intensities = results.stimulus_intensities;
m_rts = results.m_rts;

%% Pairwise Weber fraction
weber_fraction = nan(length(stimulus_intensities));
RT_fraction = nan(length(stimulus_intensities));

for i=1:length(stimulus_intensities)
    for j=1:length(stimulus_intensities)
        if i~=j
            weber_fraction(i,j) = abs(stimulus_intensities(i)-stimulus_intensities(j))/stimulus_intensities(i);
            RT_fraction(i,j) = abs(m_rts(i)-m_rts(j));
        end
    end
end

xdata = weber_fraction(val_idx(1):end, val_idx(1):end);
ydata = RT_fraction(val_idx(1):end, val_idx(1):end);

mask = ~isnan(xdata) & ~isnan(ydata) & xdata>0 & ydata>0;
x = xdata(mask);
y = ydata(mask)*1000; % ms

%% Fit
b1 = x\y;
yCalc1 = b1*x;

figure;
scatter(x,y,'k','filled'); hold on;
plot(x,yCalc1,'LineWidth',linewidth2);
xlabel('Weber Fraction'); ylabel('\Delta RT (ms)');
set(gca,'FontSize',20,'LineWidth',linewidth2);
xlim([0 0.17]); ylim([0 42]); box off;
% title(sprintf('Slope = %.2f, R^2 = %.2f',b1, 1 - sum((y-yCalc1).^2)/sum((y-mean(y)).^2)));

[R,P] = corrcoef(x,y);
disp('Correlation:');
disp([R(2) P(2)]);

end
