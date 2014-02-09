introduction-to-recommender-systems
===================================
**Repository of MATLAB scripts that I wrote for Coursera's [Introduction to Recommender Systems](https://www.coursera.org/course/recsys), a course on the concepts, applications, algorithms, programming, and design of recommender systems.**

- ***userUserCollabFilter.m*** employs a user-user [collaborative filter](http://en.wikipedia.org/wiki/Collaborative_filtering) to recommend movies. It receives as input a *movie* x *users* ratings matrix and parameters that specify the recipients and number of recommendations as well as the size of the similarity neighborhood. The algorithm uses correlation-weighted average ratings with and without normalization to make its recommendations.

- ***recSys.m***

- ***makeRatingsMatrix.m*** defines a function that receives as input a CSV file with 3 columns: the IDs of users, the IDs of the movies they watched, and the movie ratings that they provided. (For users who rated more than one movie, their IDs repeat across rows.) The function outputs a *users* x *movie* ratings matrix for use by ***recSys.m***.
