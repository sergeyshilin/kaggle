function mse = maskedMSE(original, recovered) 
original_small = imresize(original, 0.2);
recovered_small = imresize(recovered, 0.2);
mask = uint8(imbinarize(recovered_small, 1/255));
original_mask = original_small .* mask;

mse = immse(imgaussfilt(original_mask,2), imgaussfilt(recovered_small,2));
end