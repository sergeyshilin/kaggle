function [ featured_data_set ] = get_featured_data( folder )
    tic;
    featured_data_set = [];
    sets = get_set_numbers(folder);
    for set = sets
        featured_images = {};
        for img = 1:5
            img_path = strcat('data/', folder, '/set', num2str(set), '_', num2str(img), '.jpeg');
            img_data = rgb2gray(imread(img_path));
            img_points  = detectSURFFeatures(img_data);
            [features, valid_points]  = extractFeatures(img_data,  img_points);
            featured_images{img} = {features, valid_points};
        end

       for i = 1:5
           featured_row = [set, i];
           featured_row = [featured_row, get_similarity(featured_images, i)];
           featured_data_set = [featured_data_set; featured_row];
       end
    end
    csvwrite(strcat(folder, '_features.csv'), featured_data_set);
    toc;
end


