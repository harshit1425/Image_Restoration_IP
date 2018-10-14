function [enhanced_img] = filter_image(original_img, filt2D)
	% Input:
	%       original_img    -> Original Input Image
	%		filt2D		-> Filter
	%
	% Output:
	%		enhanced_img -> 2D DFT of the input image 
	%
	% Description:
	%		: Filters the image with the given 2D filter with sliding window method
	%		: All the operations are performed on the variable "img_intensity"
	%       : For colored images the same algorithm is performed on the Value(V) plane in HSV

	if ndims(original_img) == 3						% Colored Images
		img_hsv = rgb2hsv(original_img);
		img_intensity = 255.0*img_hsv(:,:,3);	% To ensure range of value is in 255*[0,1]
	else
		img_intensity = original_img;				% Grayscale Images
	end
	
	[M,N] = size(img_intensity);
    [n,n] = size(filt2D);
    
	ext = (n-1)/2;        	              		% Is an integer for odd n's

	% Zero-paddings in both dimensions
	pad_img = padarray(img_intensity, [ext, ext], 0);
	pad_img = double(pad_img);

	% applying the window
	enhanced_img = ones([M,N]);
	for i = 1:M
		for j = 1:N
			enhanced_img(i,j) = sum(sum(pad_img(i:(i+2*ext), j:(j+2*ext)).*filt2D));
		end
	end

	if ndims(original_img) == 3						% Colored Images
		img_hsv(:,:,3) = enhanced_img/255.0;	% to ensure the range if "V" in HSV is [0,1]
		enhanced_img = uint8(255*hsv2rgb(img_hsv));
	else 										% Grayscale Images
		enhanced_img = uint8(enhanced_img);		% Casting the image into 8-bit integers
	end

end

