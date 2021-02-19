from colorama import Fore, Style #nice and simple library for coloring output!
import argparse

from lyricheck import lyrics_to_list, clean_text, clean_list, fit_pipeline, predict
from lyricheck import PATH, LIST_MM, PATH2, LIST_VF, CORPUS, LABELS, X, Y, CLEAN_LR_PIPE, XTEST, XTRAIN, YTEST, YTRAIN



parser = argparse.ArgumentParser(description="This program will tell you if what you entered is more probably part of a song by Modest Mouse or by Violent Femmes who are both excellent so it doesn't really matter.")  

parser.add_argument('given_text',help="Please enter some textsnippet as a string") 

args = parser.parse_args()

fit_pipeline(XTRAIN, YTRAIN)

prediction, probs = predict(CLEAN_LR_PIPE, [args.given_text])

print(Fore.MAGENTA + ('Alright, this should be part of a song by ' + prediction + ' ! Wonderful lyrics!') + Fore.RESET)
