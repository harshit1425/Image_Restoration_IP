function [filt] = gauss2D(n, sig_x, sig_y)
	% Description
	% 	: Returns a 2D gaussian filter with the specified sigma and window size
	% 	: n must be odd (nxn -> window size)

    f1 = gauss1D(n, sig_x);
    f2 = gauss1D(n, sig_y);
    
    filt = transpose(f2)*f1;
    
end