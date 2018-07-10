import os
import pandas as pd
import numpy as np
from keras.preprocessing.text import Tokenizer
from matplotlib import pyplot as plt
import seaborn as sns
%matplotlib inline

# read in data and preprocess
train_df = pd.read_csv('c:/users/washburp/documents/kaggle/arthur/data/train_df.csv')

# drop missing descriptions
train_df.dropna(inplace=True, subset=['desc_of_operations'])

# derive length of description & filter long/short ones
train_df['len_description'] = train_df.desc_of_operations.apply(len)
reasonable_sized_texts = (train_df.len_description.astype(int) >= 1) | (train_df.len_description.astype(int) <= 200)
train_df = train_df.loc[reasonable_sized_texts]

# clean up text
from text_cleanup import TextCleaner

train_df['clean_desc'] = TextCleaner().transform(train_df.desc_of_operations.values)
train_df.head()

sentences = []
for description in train_df.clean_desc.tolist():
    sentences.append(description.split())
    
sentences[:1]

import gensim

model = gensim.models.Word2Vec(iter=1, min_count=10, size=150, workers=4)
model.build_vocab(sentences)
model.train(sentences, total_examples=model.corpus_count, epochs=model.epochs)

topn = 20

dat = model.most_similar(['salon'], topn=topn)
df = pd.DataFrame(dat, columns=['word', 'prob']).set_index('word')
df
