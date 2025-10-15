function out = reformsig(in,n_trials)
% function out = reformsig(in,n_trials)
% 
% *** INPUT ***
% in : 2D or 3D signal
%   2D : [times  x  channels]
%   3D : [times  x  channels  x  trials]
% 
% n_trials : # of trials (required only when 'in' = 2D)
%
%
% *** OUTPUT ***
% out
%       when 'in' = 2D  -> 'out' = 3D[times  x  channels  x  trials]
%       when 'in' = 3D  -> 'out' = 2D[times  x  channels]
% 
% *** USAGE ***
% out = reformsig(in,n_trials) for 'in' = 2D
% out = reformsig(in) for 'in' = 3D
% 
% 
% *** FUNC. NEEDED ***
% 
% 
% *** MODIFICATION ***
% 2010.08.13 : Minkyu Ahn
% - first written
% 
%--------------------------------------------------------------------------
% Minkyu Ahn        frerap@gist.ac.kr
% http://biocomput.gist.ac.kr


n_size = size(in);
n_dim = length(n_size);

% When 2D signal, 2D -> 3D
if n_dim == 2
% 	msg('2D -> 3D [times  x  channels  x  trials]');
    n_chan = n_size(2);
    n_times = n_size(1) / n_trials;
    
    out = zeros(n_times, n_chan, n_trials);
    for it=1:n_trials
        sp = (it-1)*n_times+1;
        ep = it*n_times;
        out(:,:,it) = in(sp:ep, :);
    end
    
% When 3D signal, 3D -> 2D
elseif n_dim ==3
% 	msg('3D -> 2D [times  x  channels]');
    n_times = n_size(1);
	n_chan = n_size(2);
    n_trials = n_size(3);
    
    out = zeros(n_times * n_trials, n_chan);
    for it=1:n_trials
        sp = (it-1)*n_times+1;
        ep = it*n_times;
        out(sp:ep,:) = in(:,:,it);
    end
    
end








%% Sub mes function
function msg(str)
disp(['reformsig(): ' str]);











