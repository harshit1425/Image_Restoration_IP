function fft_seq = myFFT1D(input_sequence, n_points)
	% Returns the 1D-DFT of a sequence by FFT algorithm

	% Finding the nearest power of 2
	near_pow2 = pow2(nextpow2(n_points));
	pad_points = near_pow2-n_points;

	% Zero padding the input_sequence to achieve the nearest power of 2 in length of the sequence
	if pad_points > 0
		pad_array = zeros(1, pad_points);
		pad_input = double([input_sequence, pad_array]);
	else
		pad_input = input_sequence;
	end
	
	% Calculating the 1D-DFT using FFT 
	fft_seq = myFFT1D_helper(pad_input, near_pow2);

end