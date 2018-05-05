# paul washburn
import numpy as np
import pandas as pd
import keras
import time # add decorator to time functions
from functools import wraps # add decorator to time functions
from matplotlib import pyplot as plt
import seaborn as sns
%matplotlib inline


def plot_loss(history_obj, width=11):
    '''
    Leans on Keras' history.history object to visualize fit of model.
    '''
    plt.clf()
    loss = history_obj['loss']
    val_loss = history_obj['val_loss']
    d_loss = np.subtract(loss, val_loss)
    epochs = range(1, len(loss)+1)
    sns.set_style("whitegrid")
    fig, ax = plt.subplots(figsize=(width, 6))
    ax.plot(epochs, loss, 'g', label='Training Loss', linestyle='--')
    ax.plot(epochs, val_loss, 'b', label='Validation Loss', linestyle='-.')
    ax.set_title('Training & Validation Loss')
    ax.set_xlabel('')
    ax.set_ylabel('Loss')
    ax.grid(alpha=0.3)
    ax.legend(loc='best')
    sns.despine()
    plt.suptitle('Training vs. Validation of Sequential Network Model Over Various Epochs')
    
    fig2, ax2 = plt.subplots(figsize=(width, 3))
    ax2.plot(epochs, d_loss, c='black', label='train_loss - val_loss')
    ax2.grid(alpha=0.3)
    ax2.set_xlabel('Epochs')
    ax2.set_ylabel('Loss Differential (Train-Val)')
    ax2.legend(loc='best')
    ax2.axhline(0, c='black', linestyle=':')
    ax2.set_title('Difference of Curves Above')

    sns.despine()
    plt.show()
    return None
