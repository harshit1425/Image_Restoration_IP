degraded_img = imread('images/tanay.jpg');
kernel = imread('kernel/kernel4.png');

kernel = double(kernel)/sum(sum(kernel));

disp('The process of fft is going on...keep patience!!');

 %Handling the colored images
if ndims(degraded_img) == 3										% Colored Images
	img_hsv = rgb2hsv(degraded_img);
	degraded_img_grayscale = 255.0*img_hsv(:,:,3);				% To ensure range of value is in mapped to [0,255]
else
	degraded_img_grayscale = degraded_img;						% Grayscale Images
end

%finding the size of the degraded image and kernel and the next power of 2 for FFT
[M,N] = size(degraded_img_grayscale);
[M_kernel,N_kernel] = size(kernel);

M_new = pow2(nextpow2(M));
N_new = pow2(nextpow2(N));

%Padding the degraded image
padded_image = zeros(M_new,N_new);			
padded_image(1:M, 1:N) = degraded_img_grayscale;
degraded_img_grayscale = padded_image;

%Padding the kernel
padded_kernel = zeros(M_new,N_new);
padded_kernel(1:M_kernel,1:N_kernel) = kernel;
kernel = padded_kernel;

%finding DFT of degraded image
degraded_img_dft = fft_shift(fft2(degraded_img_grayscale));

%finding DFT of the kernel
kernel_dft = fft_shift(fft2(kernel));

disp('Press any key to give any of the below listed filter as input:');
disp('1. full_inverse');
disp('2. truncated_inverse');
disp('3. wiener_filter');
disp('4. clsf');
pause

prompt = 'Enter the filter name: ';
str = input(prompt,'s');
if isempty(str)
	disp('No filter was entered......');
end

if strcmp(str,'full_inverse')
		restored_img_dft = degraded_img_dft./kernel_dft;
	

	%truncated inverse filtering 	
	elseif strcmp(str,'truncated_inverse')

		% constructing low pass filter with origin at center
		prompt = 'Enter the radius to be used for Low Pass filter (20-100):';
		radius = input(prompt);
		
		x = 1:M_new;
		x = x - (M_new+1)/2;	
		y = 1:N_new;
		y = y - (N_new+1)/2;

		% Constructing a grid
		[nx, ny] = ndgrid(x, y);

		% mask construction
		mask_LPF = (nx.^2 + ny.^2 <= radius^2);
        %imshow(mask_LPF);
		degraded_img_dft = degraded_img_dft.*mask_LPF;
		restored_img_dft = degraded_img_dft./kernel_dft;


	%approximate wiener filter
	elseif strcmp(str,'wiener_filter')
		prompt = 'Enter the parameter K (0-1):';
		K = input(prompt);
		restored_img_dft = conj(kernel_dft).*degraded_img_dft./(abs(kernel_dft).^2 + K.*ones(M_new,N_new));


	%Constrained least square filter
	elseif strcmp(str,'clsf')
		prompt = 'Enter the parameter y (0-1):';
		y = input(prompt);
		P = [0 -1 0; -1 4 -1; 0 -1 0];
		%finding DFT of matrix P
		padded_P = zeros(M_new,N_new);
		padded_P(1:3,1:3) = P;
		DFT_P = fft_shift(myFFT2D(padded_P));
		restored_img_dft = conj(kernel_dft).*degraded_img_dft./(abs(kernel_dft).^2 + y.*(abs(DFT_P).^2));

	else 
		fprintf('The name of the filter entered is not correct......')
		return;
	end

disp('The process of restoring image and ifft is going on, wait for a while!!');

restored_img = abs(ifft2(fft_shift(restored_img_dft)));
restored_img = restored_img(1:M,1:N);

if ndims(degraded_img) == 3								% Colored Images
	img_hsv(:,:,3) = restored_img/255.0;			% range for V in HSV must be in [0,1]
	restored_img = uint8(255*hsv2rgb(img_hsv));
end

[filename, foldername] = uiputfile('.jpg','File Selector');
	complete_name = fullfile(foldername, filename);
	imwrite(restored_img, complete_name);

figure
subplot(232);
imshow(degraded_img);
title('Degraded Image');

subplot(233);
imshow(degraded_img_dft);
title('Degraded image dft');

subplot(234);
imshow(log_transform(linear_contrast(abs(restored_img_dft))));
title('Restored Image DFT');

subplot(235);
imshow(restored_img);
title('Restored Image');

subplot(236);
imshow(kernel_dft);
title('DFT of the kernel');