from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

def split_scale_data(df_modeling, y_col, leave_out, train_size=.8, continuous_cols=[]):
    print('''Using X columns:'''); print(X_cols)
    print('''To predict Y column:'''); print(y_col)
    
    X_train, X_test, y_train, y_test = train_test_split(df_modeling[X_cols], 
                                                        df_modeling[y_col], 
                                                        train_size=train_size)
    if len(continuous_cols) > 0:
        std = StandardScaler()
        std.fit(X_train[continuous_cols].as_matrix())
        X_train[continuous_cols] = std.transform(X_train[continuous_cols])
        X_test[continuous_cols] = std.transform(X_test[continuous_cols])
    else: 
        std = None
    
    return X_train, X_test, y_train, y_test, std
    
y_col = 'routes_per_day'
leave_out = ['date', 'stops_per_day'] + [y_col] 
X_cols = [col for col in df_modeling.columns if col not in leave_out]

continuous_cols = ['split_cases_delivered_per_day']

X_train, X_test, y_train, y_test, std_scaler = split_scale_data(df_modeling, 
                                                               y_col, 
                                                               leave_out, 
                                                               train_size=.8,
                                                               continuous_cols=continuous_cols)

# split off hold out set
pct_hold_out = .5
nrow_train = int(pct_hold_out * X_test.shape[0])
X_val, y_val = X_test.iloc[:nrow_train], y_test.iloc[:nrow_train]
X_test, y_test = X_test.iloc[nrow_train:], y_test.iloc[nrow_train:]
print('Shape X_val: {}, Shape X_test: {}'.format(X_val.shape, X_test.shape))
