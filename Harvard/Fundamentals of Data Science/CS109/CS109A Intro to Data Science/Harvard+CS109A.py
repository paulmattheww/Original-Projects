
# coding: utf-8

# In[1]:

## Harvard CS109A Placement Coding Exam
## Paul Washburn 7-31-17

import pandas as pd
import numpy as np

path = 'C:/Users/pmwash/Desktop/Harvard/Intro to Data Science A/HorseshoeCrab.csv'
df = pd.read_csv(path, header=0)
print(df.head())


# In[2]:

print('''
Question 1

Load the data into a two-dimensional array structure (lists may work too). Then implement the following functionality in code, and provide answers to the questions.

a. Implement a function that computes the mean over a column. Now, using your function, compute the average width of a Horseshoe Crab.

b. Implement a median function. Find the median number of satellites in the dataset.

c. Implement a function that computes the standard deviation. Use it to compute the standard deviation of weights of the crabs.
''')

def getmean(series):
    '''Gets mean from vector'''
    N = len(series)
    SUM = np.sum(series)
    AVG = SUM / N
    return AVG

avg_width_crab = getmean(df.width.astype(np.float64))

def getmedian(vector):
    '''Gets median from vector'''
    VEC = sorted(vector)
    N = len(VEC)
    MID = N // 2
    if N % 2 != 0:
        MEDIAN = (VEC[MID] + VEC[MID-1]) / 2
    else:
        MEDIAN = VEC[MID]
    return MEDIAN

med_satellites = getmedian(df.satell)

def getstddev(vector):
    '''Gets std dev'''
    MEAN, Nless1 = getmean(vector), len(vector)-1
    ls = []
    for v in vector:
        SQDEV = (v - MEAN)**2
        ls.append(SQDEV)
    SUMSQDEV = np.sum(ls)
    STDDEV = np.sqrt(SUMSQDEV / Nless1)
    return STDDEV

stdev_width = getstddev(df.width)

print('''
Answers Question 1

Part A.
The average width of the Horseshoe Crabs in the dataset is %.2f

Part B.
The median width of the number of male Satellites in the dataset is %.2f

Part C.
The standard deviation of the Horseshoe Crab width in the dataset is %.2f
''' %(avg_width_crab, med_satellites, stdev_width))


print('''
Question 2

In this question we will compute aggregate (grouped) statistics. You may call or re-use any code written in Question 1, if desired.

a. Compute the mean width of crabs whose color is considered light (color codes 1 and 2).
 
b. Write a function that accepts a two-dimensional array as an input; computes the mean, median, and standard deviation for every column in the array, and outputs the result in a two-dimensional array. The descriptive statistics should be on the rows, and the features as columns. Apply it to the Horseshoe crab dataset.
''')

mean_lightcrabs = getmean(df.loc[df.color.isin([1,2]), 'width'])
#df.groupby('color').mean()
print('''
Answers Question 2

Part A.
Mean width of crabs considered light (codes 1 and 2) is %.2f

Part B.
See below:
''' %(mean_lightcrabs))

def get_meanmedianstd_from2darray(df):
    '''
    Takes 2d array input and computes 
    mean median std dev for each column
    outputs 2d array
    '''
    cols = df.columns
    means, meds, stds = [], [], []
    new_df = pd.DataFrame(index=cols, columns=['Mean','Median','StdDev'])
    for col in cols:
        new_df.loc[col, 'Mean'] = getmean(df[str(col)])
        new_df.loc[col, 'Median'] = getmedian(df[col])
        new_df.loc[col, 'StdDev'] = getstddev(df[col])
    new_df = new_df.transpose()
    
    return new_df

stat_df = get_meanmedianstd_from2darray(df)
print(stat_df)


# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:



