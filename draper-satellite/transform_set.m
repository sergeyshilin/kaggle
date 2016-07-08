function transform_set(folder, set_n)
    set_path = strcat('data/', folder, '/set');
    new_folder_path = strcat('data/transformed/', num2str(set_n), '/');
    if ~ exist(new_folder_path, 'file')
        mkdir(new_folder_path);
    end

    original_path = strcat(set_path, num2str(set_n), '_1.jpeg');
    original = rgb2gray(imread(original_path));
    ptsOriginal  = detectSURFFeatures(original);
    [featuresOriginal, validPtsOriginal] = extractFeatures(original, ptsOriginal);
    new_original_path = strcat(new_folder_path, '1.jpeg');
    imwrite(original, new_original_path);
    
    for i = 2:5
        distorted_path = strcat(set_path, num2str(set_n), '_', num2str(i), '.jpeg');
        distorted = rgb2gray(imread(distorted_path));
        ptsDistorted = detectSURFFeatures(distorted);
        [featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);
        indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

        matchedOriginal = validPtsOriginal(indexPairs(:,1));
        matchedDistorted = validPtsDistorted(indexPairs(:,2));
        [tform] = estimateGeometricTransform(matchedDistorted, matchedOriginal, 'similarity');

        outputView = imref2d(size(original));
        recovered  = imwarp(distorted, tform, 'OutputView', outputView);
        recovered_path = strcat(new_folder_path, num2str(i), '.jpeg');
        imwrite(recovered, recovered_path);
    end
end