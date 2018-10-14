function [filt] = gauss1D(n, sigma)
	% Description
	% 	: Returns a 1D gaussian filter with the specified sigma and window size
	% 	: n must be odd (window size)

    x = 0:n-1;
    x = x - ((n-1)/2)*ones(1,n);
    filt = exp(-x.^ 2/(2 * sigma^2));
    filt = filt/sum(filt); 				% normalization
    
end