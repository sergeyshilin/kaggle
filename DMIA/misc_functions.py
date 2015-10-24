def build_features(data):
    data['Word'] = data['Word'].apply(lambda word: word.decode('utf-8'))
    data['Length'] = data['Word'].apply(lambda word: len(word))

    vowels = [ 'а',  'я', 'ё', 'у','е', 'о', 'э', 'ю', 'и', 'ы', 'Ё', 'У', 'Е', 'Ы','А', 'О', 'Э', 'Ю', 'И', 'Я' ]
    vowels = [let.decode('utf-8') for let in vowels]
    data['Vowels'] = data['Word'].apply(lambda word: len([letter for letter in word if letter in vowels]))
    data['Consonants'] = data['Length'] - data['Vowels']

    data['is_lower'] = data['Word'].apply(lambda word: int( word[0] >= 'а'.decode('utf-8')))

    data['Double'] = data['Word'].apply(lambda word: countDoubles(word))
    data['Caps'] = data['Word'].apply(lambda x: x.upper() == x)
    data['Frac_vowels'] = data['Vowels'].apply(float) / data['Consonants']
    for i, substr in enumerate(['сон', 'ы', 'э', 'щ', 'ъ', 'й', 'ф']):
        s = substr.decode('utf-8')
        data['has_{}'.format(i)] = data['Word'].apply(lambda x: x.find(s) >= 0)
    for i, substr in enumerate(['.*ин.?.?$', '.*ов.?.?$']):
        s = substr.decode('utf-8')
        data['has_re_{}'.format(i)] = data['Word'].apply(lambda x: re.match(substr, x, re.UNICODE) is not None)

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
