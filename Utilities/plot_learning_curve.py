from sklearn.model_selection import learning_curve

def plot_learning_curve(mod, X, y, cv, n_jobs, title, ax=None, invert=True):
    '''
    Generates a simple plot of test & training learning curves.
    Inspired from https://github.com/cs109/a-2017/blob/master/Sections/Standard/section_9_student.ipynb
    and from lecture/section.
    
    Inputs:
    -----------------------------------------------------------------
     mod: model for which learning curve must be plotted
     X: predictor data 
     y: true labels
     cv: number cross validation iterations
     n_jobs: number of cores (-1 for all available)
     ax: optional matplotlib Axes object on which to plot
    
    Outputs:
    -----------------------------------------------------------------
     None: plotted learning curves
    '''
    plt.style.use('seaborn-whitegrid')
    
    train_sizes, train_scores, test_scores = learning_curve(mod, X=X, y=y_train.values.ravel(), cv=20, n_jobs=-1)

    train_scores_mean = np.mean(train_scores, axis=1)
    train_scores_std = np.std(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)
    test_scores_std = np.std(test_scores, axis=1)
    
    if ax == None: fig, ax = plt.subplots(figsize=(12, 7))
    if invert: ax.invert_yaxis()
        
    ax.plot(train_sizes, train_scores_mean, 'o-', color='r', label='training score')
    ax.plot(train_sizes, test_scores_mean, 'o-', color='g', label='test score')
    ax.set_xlabel('Training Examples')
    ax.set_ylabel('Score')
    ax.set_title(title)
    ax.grid(alpha=0.5)
    sns.despine(bottom=True, left=True)
    ax.legend(loc='best')
    ax.fill_between(train_sizes, train_scores_mean - train_scores_std,
                     train_scores_mean + train_scores_std, alpha=0.1,
                     color="r")
    ax.fill_between(train_sizes, test_scores_mean - test_scores_std,
                     test_scores_mean + test_scores_std, alpha=0.1, color="g")
    
    return None
