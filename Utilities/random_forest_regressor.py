from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score
from sklearn.externals import joblib

param_grid = {'n_estimators': np.arange(78, 91, 2),
             'max_features': np.arange(.6, .67, .01)}
model = RandomForestRegressor(n_jobs=-1, 
                              random_state=777,
                              criterion='mse')

grid = GridSearchCV(model, param_grid)
grid.fit(X_train, y_train)

val_score = r2_score(y_val, [int(pred) for pred in grid.predict(X_val)])
test_score = r2_score(y_test, [int(pred) for pred in grid.predict(X_test)])
train_score = r2_score(y_train, [int(pred) for pred in grid.predict(X_train)])

print('Train Score = {}, Validation Score = {}, Test Score = {}'
      .format(train_score, val_score, test_score))

joblib.dump(grid.best_estimator_, 'rtes_per_day_model_rf.pkl')

grid.best_params_
