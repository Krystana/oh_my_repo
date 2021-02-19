
import requests
import re
from bs4 import BeautifulSoup
import pandas as pd
import time
import glob
import os
import seaborn as sns
import numpy as np

from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.pipeline import make_pipeline
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.linear_model import LogisticRegression



PATH = '/Users/krystanafoh/lyrics/modestmouse/'

PATH2 = '/Users/krystanafoh/lyrics/violentfemmes/'

def lyrics_to_list(path:str):
    """returns a list of lyricstrings"""

    textfile = glob.glob(os.path.join(path, '*.text'), recursive=False)

    lyrics = []
   
    for file_path in textfile:
        with open(file_path) as f_input:
            lyrics.append(f_input.read())

    return lyrics


LIST_MM = lyrics_to_list(PATH)

LIST_VF = lyrics_to_list(PATH2)

CORPUS = LIST_MM + LIST_VF

LABELS = ["Modest Mouse"] * len(LIST_MM) + ["Violent Femmes"] * len(LIST_VF)

X = CORPUS
Y = LABELS

XTEST, XTRAIN, YTEST, YTRAIN = train_test_split(X, Y, stratify=Y, random_state=42)

def clean_text(TEXT):

    # replace "n'" with ng:
    TEXT = re.sub(r"\w(n')\s","", TEXT)   
        
    #remove punctuation:
    TEXT = re.sub(r"[^\w\s']","",TEXT)
    
    # replace "\n" by whitespace : 
    TEXT = re.sub(r"\\n", " ", TEXT)
      
    # lowercase    
    TEXT = TEXT.lower()
    
    #removing duble whitespaces:
    TEXT = re.sub(r"\s+"," ", TEXT)
    
    return TEXT

def clean_list(X_split):
    """applies clean_text function to every item in list (of songtexts)"""
    
    clean_list = []
    for song in X_split:
        clean_list.append(clean_text(song))
    return clean_list

CLEAN_LR_PIPE = Pipeline([
    ("cleaning_text", FunctionTransformer(clean_list)),
    ("vectorize", TfidfVectorizer(ngram_range=(1,1), smooth_idf=True, stop_words='english')),
    ("model", LogisticRegression())
])


def fit_pipeline(XTRAIN, YTRAIN):
    CLEAN_LR_PIPE.fit(XTRAIN, YTRAIN)


def predict(CLEAN_LR_PIPE, new_text):
    """
    Takes the pre-trained pipeline model and predicts new artist.
    """
    prediction = CLEAN_LR_PIPE.predict(new_text)
    probs = CLEAN_LR_PIPE.predict_proba(new_text)
    return prediction[0], probs.max()





