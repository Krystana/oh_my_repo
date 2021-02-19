SPICED ACADEMY DATA SCIENCE BOOTCAMP - week 4: "Text Classification" - Building a text classification model to predict the artist from a piece of text.

While learning about webscraping, Regular Expressions, parsing HTML, language models and command line interfaces, I build 3 models to predict whether a piece of 
text is more probably part of a song by Modest Mouse or by Violent Femmes - a Logistic Regression, a Random Forest Classifier and a Multinomial NaiveBayes model.

I wrote a command line interface to run a program that performs these important predictions after receiving user input. 

In all 3 approaches I used the ScikitLearn CountVectorizer to transform the textcorpus into a matrix and the TfidfTransformer to normalize the counts in a ScikitLearn 
pipeline. For webscraping I used the requests library and for parsing HTML files RegEx and BeautifulSoup. 

If you are having problems distinguishing between Modest Mouse and Violent Femmes lyrics as well, feel free to use my code ;)
