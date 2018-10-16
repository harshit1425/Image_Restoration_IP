function [output] = myFFT1D_helper(input, N)
%%%% N  = some power of 2
%%%%% input - input sequence

%%%% case when N =2 
	if N == 2
		% Do nothing since input(1) is already set
		output = [input(1)+input(2), input(1)-input(2)];
		return
    end
    
    % Separate even and odd indexed elements
	even_inputs = input(1:2:N-1);
	odd_inputs = input(2:2:N);

	% Calling the recursions
	Even_k = myFFT1D_helper(even_inputs, N/2);
	Odd_k = myFFT1D_helper(odd_inputs, N/2);

	v = 0:N/2-1;
	z = exp(-1i*2*pi*v/N);

	% Using the cyclicity; DFT(k) = DFT(k+N/2)
	half_1 = Even_k + z.*Odd_k;
	half_2 = Even_k - z.*Odd_k;

	% Combining the two halves
	output = [half_1, half_2];

end