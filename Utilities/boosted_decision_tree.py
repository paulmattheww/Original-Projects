from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import AdaBoostRegressor

model = DecisionTreeRegressor(max_depth=None, 
                              random_state=7,
                              criterion='mae')
boosted_model = AdaBoostRegressor(model,
                                 n_estimators=10,
                                 random_state=77)

# grid = GridSearchCV(model, param_grid)
boosted_model.fit(X_train, y_train)

val_score = r2_score(y_val, [int(p) for p in boosted_model.predict(X_val)])
test_score = r2_score(y_test, [int(p) for p in boosted_model.predict(X_test)])
train_score = r2_score(y_train, [int(p) for p in boosted_model.predict(X_train)])

print('Train Score = {}, Validation Score = {}, Test Score = {}'
      .format(train_score, val_score, test_score))
boosted_model
