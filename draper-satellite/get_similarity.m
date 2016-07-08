function [ result_row ] = get_similarity( images_data, img_num )
    t_inv_cur = [];
    cur_index = 1;
    for j = 1:5
        if img_num ~= j
            indexPairs = matchFeatures(images_data{img_num}{1}, images_data{j}{1});
            matched_first = images_data{img_num}{2}(indexPairs(:,1));
            matched_second = images_data{j}{2}(indexPairs(:,2));
            [tform] = estimateGeometricTransform(matched_second, matched_first, 'similarity');
            t_inv = tform.invert.T;
            ss = t_inv(2, 1);
            sc = t_inv(1, 1);
            scale = sqrt(ss * ss + sc * sc);
            theta = atan2(ss, sc) * 180 / pi;
            tx = t_inv(3, 1);
            ty = t_inv(3, 2);
            t_inv_cur(:, cur_index) = [scale, theta, tx, ty, length(indexPairs)];
            cur_index = cur_index + 1;
        end
    end
    result_row = [min(t_inv_cur(1,:)), max(t_inv_cur(1,:)), mean(t_inv_cur(1,:)), ...   % scale
        min(t_inv_cur(2,:)), max(t_inv_cur(2,:)), mean(t_inv_cur(2,:)), ...             % theta
        min(t_inv_cur(3,:)), max(t_inv_cur(3,:)), mean(t_inv_cur(3,:)), ...             % tx
        min(t_inv_cur(4,:)), max(t_inv_cur(4,:)), mean(t_inv_cur(4,:)), ...             % ty
        min(t_inv_cur(5,:)), max(t_inv_cur(5,:)), mean(t_inv_cur(5,:))                  % num_segments
        ];
end

