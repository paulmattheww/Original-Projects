from sklearn.model_selection import GridSearchCV
from sklearn.metrics import confusion_matrix

def multiclass_confusion_matrix(y, yhat, model_name='unspecified',
                               verbose=1):
    '''
    Inputs:
    ------------------------------------------------------
    y: true labels 
    yhat: predicted labels 
    model_name: name of model for printing
    
    Outputs:
    ------------------------------------------------------
    cm: confusion matrix (easily readable)
    metrics: dict of metrics on multiclass classification
    '''
    # organize confusion matrix from sklearn into readable format
    sk_confusion_matrix = confusion_matrix(y, yhat).transpose()#; print(sk_confusion_matrix)
    
    # put in pd.DataFrame and add names
    cm = pd.DataFrame(sk_confusion_matrix)
    IX = ['Test_' + str(i+1) for i in cm.index]
    COLS = ['Condition_' + str(i+1) for i in cm.columns]
    cm.columns, cm.index = COLS, IX
    
    # add totals
    cm['Total'] = cm.sum(axis=1)
    cm.loc['Total'] = cm.sum(axis=0)
    
    # get performance scores
    N = cm.loc['Total', 'Total']
    TP = np.diag(cm.loc[IX, COLS]).sum()
    ACC = np.divide(TP, N)
    MCR = 1 - ACC
    
    metrics = {'accuracy':ACC, 'misclassification':MCR}
    
    if verbose:
        print('''
        Confusion Matrix for Model: %s
        ------------------------------------------------------''' %model_name)
        print(cm)
        print('''
        Metrics for Model: %s
        ------------------------------------------------------
        Accuracy Rate = %.5f
        Misclassification Rate = %.5f
        ''' %(model_name, ACC, MCR))
        return None

    return cm, metrics

def memory():
    '''
    Measure memory usage; modified from:
    https://stackoverflow.com/questions/938733/total-memory-used-by-python-process
    '''
    #w = WMI('.')
    #result = w.query("SELECT WorkingSet FROM Win32_PerfRawData_PerfProc_Process WHERE IDProcess=%d" % os.getpid())
    result = psutil.virtual_memory()[3]
    
    return result#int(result[0].WorkingSet)
