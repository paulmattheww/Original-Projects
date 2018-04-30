B0, B1 = ols_results.params[0], ols_results.params[1]
print('Intercept = %.4f\nSlope = %.4f\n' %(B0, B1))

def show_confidence_intervals(ols_results, level):
    B0_confint_low, B0_confint_hi = ols_results.conf_int(level)[0]
    B1_confint_low, B1_confint_hi = ols_results.conf_int(level)[1]
    
    level = 1 - level
    print('Intercept lower confidence at %.2f = %.4f\nIntercept upper confidence at %.2f = %.4f\n' \
          %(level, B0_confint_low, level, B0_confint_hi))
    print('Slope lower confidence at %.2f = %.4f\nSlope upper confidence at %.2f = %.4f\n' \
          %(level, B1_confint_low, level, B1_confint_hi))
    return None

show_confidence_intervals(ols_results, .05)
show_confidence_intervals(ols_results, .01)

with sns.plotting_context('poster'):
    ax = plt.subplot(111, axisbg='white');
    plt.scatter(X, ols_results.resid, alpha=.5, label='residuals');
    plt.axhline(0, c='black');
    plt.xlabel('Time of Day in Minutes, Normalized');
    plt.ylabel('Residual Error');
    plt.title('Residual Analysis');
    plt.tick_params(axis='both', which='both', length=0);
    plt.legend(loc='best');
