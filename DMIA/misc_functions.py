def check_substring(data, substr):
    has_substr = data[data['Word'].str.find(substr) > 0]
    is_name = has_substr[has_substr['Label'] == 1]
    if len(is_name) == 0:
        return None, None
    return float(len(is_name)) / len(has_substr), len(has_substr)


    for i, substr in enumerate(['сон']):
        s = substr.decode('utf-8')
        data['has_{}'.format(i)] = data['Word'].apply(lambda x: x.find(s) >= 0)

def check_substring(data, substr):
    has_substr = data[data['Word'].str.find(substr) > 0]
    is_name = has_substr[has_substr['Label'] == 1]
    if len(is_name) == 0:
        return None, None
    return float(len(is_name)) / len(has_substr), len(has_substr)

res = []
for substr in ['очк', 'ичк', 'сон', 'дин', 'нов', 'нин', 'й', 'щ', 'ы', 'ева', 'ев']:
    #percent, count = check_substring(train, substr.decode('utf-8'))
    #percent_test, count_test = check_substring(test, substr.decode('utf-8'))
    tr = train[train['Word'].str.find(substr.decode('utf-8')) > 0]
    #tr = test[test['Word'].str.find(substr.decode()) > 0]
    print substr, float(len(tr[tr['Label'] == 1])) / len(train[train['Label'] == 1]), float(len(tr[tr['Label'] == 0])) / len(train[train['Label'] == 0])
    #print substr, percent, count
