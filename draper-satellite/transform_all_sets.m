function transform_all_sets()
    test_sets = get_set_numbers('test_sm');
    train_sets = get_set_numbers('train_sm');
    for te_s = test_sets
        transform_set('test_sm', te_s);
    end

    for tr_s = train_sets
        transform_set('train_sm', tr_s);
    end
end