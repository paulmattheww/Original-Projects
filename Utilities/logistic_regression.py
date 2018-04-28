from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.externals import joblib

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
