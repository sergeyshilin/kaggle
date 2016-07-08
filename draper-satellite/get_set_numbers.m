function [ numbers ] = get_set_numbers( path )
    numbers = [];
    full_path = strcat('data/', path);
    listing = dir(full_path);
    for i = 3:length(listing)
        if ~listing(i).isdir
            cur_name = listing(i).name;
            cur_num = str2double(cur_name(4:strfind(cur_name, '_')-1));
            numbers = [numbers, cur_num];
        end
    end
    numbers = unique(numbers);
end