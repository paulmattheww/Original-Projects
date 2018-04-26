from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.externals import joblib

y_col = 'schlafly'
leave_out = ['date', 'stops_per_day', 'routes_per_day'] + [y_col]
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

param_grid = {'C': [.0001, .001, .01, .1, 1, 10, 100, 1000, 10000],
             'penalty': ['l1', 'l2']}
model = LogisticRegression(n_jobs=-1, random_state=7)

grid = GridSearchCV(model, param_grid)
grid.fit(X_train, y_train)

val_score = accuracy_score(y_val, [int(pred) for pred in grid.predict(X_val)])
test_score = accuracy_score(y_test, [int(pred) for pred in grid.predict(X_test)])
train_score = accuracy_score(y_train, [int(pred) for pred in grid.predict(X_train)])

print('Train Score = {}, Validation Score = {}, Test Score = {}'
      .format(train_score, val_score, test_score))

joblib.dump(grid.best_estimator_, 'logistic_test_of_schlafly_effect.pkl')

grid.best_params_
