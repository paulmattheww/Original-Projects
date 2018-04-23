import numpy as np
import pandas as pd
import keras
import time # add decorator to time functions
from functools import wraps # add decorator to time functions
from matplotlib import pyplot as plt
import seaborn as sns
%matplotlib inline
def plot_accuracy_loss(history_obj, width=16):
    '''
    Leans on Keras' history.history object to visualize fit of model.
    '''
    plt.clf()
    loss = history_obj['loss']
    val_loss = history_obj['val_loss']
    d_loss = np.subtract(loss, val_loss)
    acc = history_obj['acc']
    val_acc = history_obj['val_acc']
    d_acc = np.subtract(acc, val_acc)
    epochs = range(1, len(loss)+1)
    sns.set_style("whitegrid")
    fig, ax = plt.subplots(1, 2, figsize=(width, 6))
    ax[0].plot(epochs, loss, 'g', label='Training Loss', linestyle='--')
    ax[0].plot(epochs, val_loss, 'b', label='Validation Loss', linestyle='-.')
    ax[0].set_title('Training & Validation Loss')
    ax[0].set_xlabel('')
    ax[0].set_ylabel('Loss')
    ax[0].grid(alpha=0.3)
    ax[0].legend(loc='best')
    ax[1].plot(epochs, acc, 'g', label='Training Accuracy', linestyle='--')
    ax[1].plot(epochs, val_acc, 'b', label='Validation Accuracy', linestyle='-.')
    ax[1].set_title('Training & Validation Accuracy')
    ax[1].set_xlabel('')
    ax[1].set_ylabel('Accuracy')
    ax[1].grid(alpha=0.3)
    ax[1].legend(loc='best')
    sns.despine()
    plt.suptitle('Training vs. Validation of Sequential Network Model Over Various Epochs')
    fig2, ax2 = plt.subplots(1, 2, figsize=(width, 3))
    ax2[0].plot(epochs, d_loss, c='black', label='train_loss - val_loss')
    ax2[0].grid(alpha=0.3)
    ax2[0].set_xlabel('Epochs')
    ax2[0].set_ylabel('Loss Differential (Train-Val)')
    ax2[0].legend(loc='best')
    ax2[0].axhline(0, c='black', linestyle=':')
    ax2[0].set_title('Difference of Curves Above')
    ax2[1].plot(epochs, d_acc, c='black', label='train_accuracy - val_accuracy')
    ax2[1].grid(alpha=0.3)
    ax2[1].set_xlabel('Epochs')
    ax2[1].set_ylabel('Accuracy Differential (Train-Val)')
    ax2[1].legend(loc='best')
    ax2[1].axhline(0, c='black', linestyle=':')
    ax2[1].set_title('Difference of Curves Above')
    sns.despine()
    plt.show()
    return None
