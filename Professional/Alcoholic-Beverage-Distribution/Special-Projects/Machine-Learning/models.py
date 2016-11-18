'''
Shipping Labor Model
'''

import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.cross_validation import train_test_split
import matplotlib.pyplot as plt
import seaborn as sns


pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 100)
pd.set_option('display.width', 100)

labor_model = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Projects/Shipping Labor Prediction Model/Labor Prediction Model Data.csv'
monthly = pd.read_csv(labor_model, header=0)
monthly.House = monthly.House.map({'STL':1, 'KC':0})



cols = ['Std Cases Sold', 'Mark-Up', 'House', 'Production Days']
sns.pairplot(monthly[cols], size=2.5, hue='House', kind='reg')

print('''
Accepts a DataFrame of montly data on: 
    * Avg mark-up on cost (P-C/C) (%)
    * House (STL=1, KC=0)
    * Production Days for that month (integer)
    * Y is a 1-D array of Std Cases Sold (total) for month
Q(House, Avg mark-up on cost, production days)
''')



X = monthly[['Mark-Up', 'House', 'Production Days']]
Y = monthly['Std Cases Sold']
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.25)

demand = LinearRegression(normalize=True)
demand.fit(X_train, Y_train)
Y_train_predict = demand.predict(X_train)
Y_test_predict = demand.predict(X_test)

plt.scatter(Y_train_predict, Y_train_predict - Y_train, c='blue', marker='o', label='Training Data')
plt.scatter(Y_test_predict, Y_test_predict - Y_test, c='lightgreen', marker='s', label='Testing Data')
plt.xlabel('Predicted Values')
plt.ylabel('Residuals')
plt.legend(loc='upper left')
plt.hlines(y=0, xmin=-10, xmax=50, lw=2, color='red')
plt.tight_layout()
plt.show()

sns.set(style="ticks", color_codes=True)

sns.lmplot(x='Mark-Up', y='Std Cases Sold', hue='House', data=monthly,
    markers=['o','x'], palette='Set1', col='House', size=4)

demand_model_plot = sns.pairplot(x_vars=['Mark-Up', 'House', 'Production Days'], y_vars=['Std Cases Sold'], hue='House', 
    data=monthly, kind='reg', size=8, aspect=0.8)
plt.subplots_adjust(top=1)
demand_model_plot.fig.suptitle('Three Variables Used to Model Demand')






monthly.head()







