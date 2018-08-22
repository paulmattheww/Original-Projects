from sklearn.linear_model import LogisticRegression

param_grid = {'C': [.0001, .001, .01, .1, 1, 10, 100, 1000, 10000],
             'penalty': ['l1', 'l2']}
logit = LogisticRegression(n_jobs=-1, random_state=7)

grid = GridSearchCV(logit, param_grid)
grid.fit(X_train, y_train)

train_acc = accuracy_score(xgb.predict(X_train), y_train)
val_acc = accuracy_score(xgb.predict(X_val), y_val)

print('Training Accuracy = %.4f' %train_acc)
print('Validation Accuracy = %.4f' %val_acc)

# joblib.dump(grid.best_estimator_, 'clf006_logit_premium.pkl')

grid.best_params_
