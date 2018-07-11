from sklearn.metrics import accuracy_score, f1_score
from sklearn.externals import joblib

def accuracy_f1_scores(y_train, X_train, y_val, X_val, model, verbose=1):
    '''
    Function to compute accuracy score and f1 score for a given classification
    model.  Model must support model.predict().
    
    Inputs:
    -----------------------------------------------------------------
     y_train: np.array of labels for training set
     X_train: np.ndarray of training features
     y_val: np.array of labels for test set
     X_val: np.array of predictors/features for validation set
     model: sklearn model or other with a `model.predict()` method
     verbose: 0 if desire values, 1 if printed to console
    
    Outputs:
    -----------------------------------------------------------------
     train_acc, val_acc, train_f1, val_f1: returned only if verbose=0
      else the function will print to console
    '''
    train_acc = accuracy_score(y_train, model.predict(X_train))
    val_acc = accuracy_score(y_val, model.predict(X_val))
    train_f1 = f1_score(y_train, model.predict(X_train))
    val_f1 = f1_score(y_val, model.predict(X_val))
    if verbose:
        print('''
        Training Accuracy:           %.4f
        Validation Accuracy:         %.4f
        
        Training F1-Score:           %.4f
        Validation F1-Score:         %.4f
        ''' %(train_score, val_score))
    else:
        return train_acc, val_acc, train_f1, val_f1
    
