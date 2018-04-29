def generate_two_tail_categories(y, label_pct_change_cutoff,
                                as_matrix=True, as_integers=True):
    upper = y >= label_pct_change_cutoff
    lower = y <= -label_pct_change_cutoff
    nochg = (upper == False) & (lower == False)
        
    y_categorical = pd.DataFrame(OrderedDict({'upper': upper,
                                  'lower': lower, 
                                  'nochg': nochg})).astype(np.int64)
    
    if as_integers: 
        ycols = y_categorical.columns
        new_col_ix = [np.int32(i) for i in np.arange(1, len(ycols)+1)]
        ycol_category_dict = dict(zip(new_col_ix, ycols))
        y_categorical.columns = new_col_ix
        y_categorical = y_categorical.idxmax(axis=1)
    
    if as_matrix: 
        y_categorical = y_categorical.as_matrix()

    return y_categorical
