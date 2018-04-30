import statsmodels.api as sm
from statsmodels.api import OLS

def sm_linear_regression(Y, X, intercept=True):
    if intercept: X = sm.add_constant(X)
    lin_model = sm.OLS(Y, X)
    lin_model_results = lin_model.fit()
    print(lin_model_results.summary())
    return lin_model_results

def sm_linear_prediction(X_test, ols_results, intercept=True):
    if intercept: X_test = sm.add_constant(X_test)
    Y_hat = ols_results.predict(X_test)
    return Y_hat

y_col = 'split_cases_delivered_per_day'
leave_out = ['date', 'stops_per_day', 'routes_per_day', 'year_2016', 'year_2017', 'year_2018',
             'month_april', 'month_august', 'month_december', 'month_february', 'month_january', 
             'month_july', 'month_june', 'month_march', 'month_may', 'month_november', 'month_october', 
             'month_september', 'is_holiday_week', 'location_col'] + [y_col]
X_cols = [col for col in df_modeling.columns if col not in leave_out]
continuous_cols = []

X_train, X_test, y_train, y_test, std_scaler = split_scale_data(df_modeling, 
                                                               y_col, 
                                                               leave_out, 
                                                               train_size=.7,
                                                               continuous_cols=continuous_cols)

# split off hold out set
pct_hold_out = .5
nrow_train = int(pct_hold_out * X_test.shape[0])
X_val, y_val = X_test.iloc[:nrow_train], y_test.iloc[:nrow_train]
X_test, y_test = X_test.iloc[nrow_train:], y_test.iloc[nrow_train:]

ols_results = sm_linear_regression(y_train, X_train)
y_predict = sm_linear_prediction(X_test, ols_results)
r2_test = r2_score(y_test, y_predict)
r2_train = r2_score(y_train, sm_linear_prediction(X_train, ols_results))
print('\nR-squared training = %5f\nR-squared testing = %5f\n' %(r2_train, r2_test))
