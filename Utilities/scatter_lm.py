import matplotlib as mpl
mpl.use('agg')  

x_col = 'Avg Probability'
y_col = 'Percent Accurate'
size_color_col = 'Number Observations'
xlab = 'Average Probability/Confidence of ARTHUR\'s Predicted Class'
ylab = 'Percent Accuracy within NCCI Code within NCCI Code'
title = 'Avg. Probability of Predicted Class vs. Percentage of Accurate Predictions\nGrouped by NCCI Code'

def scatter_lm(df, x_col, y_col, size_color_col,
              xlab, ylab, title):
    # create linear regression formula for plotting
    fit = np.polyfit(df[x_col], df[y_col], 1)
    fit_fn = np.poly1d(fit)

    fig, ax = plt.subplots(figsize=(15, 8))
    sc = ax.scatter(x=df[x_col], 
                    y=df[y_col], 
                    c=np.log(df[size_color_col]), 
                    s=np.log(df[size_color_col])**2)
    ax.plot(df[x_col], fit_fn(df[x_col]), '-.k')
    ax.grid(alpha=.3)
    sns.despine()
    ax.set_xlabel(xlab)
    ax.set_ylabel(ylab)
    ax.set_title(title)
    ax.legend()
    plt.show()

scatter_lm(prob_df, x_col, y_col, size_color_col, xlab, ylab, title)
