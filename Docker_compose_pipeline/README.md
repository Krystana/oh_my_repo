SPICED ACADEMY DATA SCIENCE BOOTCAMP - week 6: "The Data Pipeline" - Sentiment analysis on Twitter tweets, displayed by Slackbot. 


The project's goal was mainly to get a docker compose pipeline running, dealing with an SQL and a NOSQL server and practicing the ETL job. 

1. twitter_streamer.py

A twitter API streams filtered tweets to a mongoDB database. 

Twitter API --> https://developer.twitter.com/en/use-cases/listen-and-analyze

The code in twitter_streamer.py is based on the code in this repository: https://github.com/pawlodkowski/twitter-mongoDB, which was provided by SPICED ACADEMY and
adjusted by myself. 

2. etl.py

The tweets' text contents (and userid) then are requested and loaded to a created pandas dataframe.
Sentiment Analysis is performed on the text data and the sentiment compound score loaded to the dataframe. 

For the sentiment analysis I used a Vader Sentiment analysis tool --> https://github.com/cjhutto/vaderSentiment/blob/master/README.rst#installation, 
referring to: 
Hutto, C.J. & Gilbert, E.E. (2014). VADER: A Parsimonious Rule-based Model for Sentiment Analysis of Social Media Text. 
Eighth International Conference on Weblogs and Social Media (ICWSM-14). Ann Arbor, MI, June 2014.

The dataframe is then transferred to a Postgres database. 

3. slackbot.py

Text and sentiment values of the last row in the postgres table are then queried and then posted in a slackbot via a webhookURL. 

