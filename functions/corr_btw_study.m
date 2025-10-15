function [R, P] = corr_btw_study(simX, simY, studyX, studyY)
% Correlation between simulator and study data with interpolation

    % 보간: study 데이터를 simulator 축에 맞춤
    studyY_interp = interp1(studyX(:), studyY(:), simX(:), 'linear', 'extrap');

    % 길이 보장
    simY   = simY(:);
    studyY_interp = studyY_interp(:);

    n = min(length(simY), length(studyY_interp));
    simY = simY(1:n);
    studyY_interp = studyY_interp(1:n);

    % NaN 제거
    valid = ~isnan(simY) & ~isnan(studyY_interp);

    % correlation
    [R, P] = corr(simY(valid), studyY_interp(valid), 'rows', 'complete');
end
