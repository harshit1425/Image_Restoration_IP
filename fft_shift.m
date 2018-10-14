function out_img = fft_shift(orig_img)
	% Returns the centralised version of a DFT by swapping quadrants in frequency domain
	% Based on the cyclic property of DFT

	[M,N] = size(orig_img);
	out_img = ones(M,N);

	% Swapping 1st and 3rd quadrant
	out_img(1:M/2, 1:N/2) = orig_img(M/2+1:M, 1+N/2:N);
 	out_img(M/2+1:M, 1+N/2:N) = orig_img(1:M/2, 1:N/2);

 	% Swapping 2nd and 4th quadrant
	out_img(M/2+1:M, 1:N/2) = orig_img(1:M/2, 1+N/2:N);
 	out_img(1:M/2, 1+N/2:N) = orig_img(M/2+1:M, 1:N/2); 

end