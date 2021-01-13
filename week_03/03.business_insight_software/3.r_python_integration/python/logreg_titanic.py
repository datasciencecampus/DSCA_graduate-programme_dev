# -*- coding: utf-8 -*-
"""
Spyder Editor

2.0 Model Selection
purpose of script: compare logreg vs knn on titanic_train
"""


# import libraries
import os
import pandas as pd
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import StandardScaler
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split

#set wd
os.chdir("C:\\Users\\leyshr\\OneDrive - Office for National Statistics\\Graduate Curriculum\\DSCA_graduate-curriculum_dev\\week_03\\03.business_insight_software\\3.r_python_integration\\python")


# import training & test data
titanic_train = pd.read_csv('../data/titanic.csv')


# Define functions to preprocess features

def preprocess_features(df) :
    #extract features series
    features = df.drop('survived', axis=1)
    #remove features that cannot be converted to float: name, ticket & cabin
    features = features.drop(['name', 'ticket', 'cabin'], axis=1)
    # dummy encoding of any remaining categorical data
    features = pd.get_dummies(features, drop_first=True)
    # ensure np.nan used to replace missing values
    features.replace('nan', np.nan, inplace=True)
    return features


# preprocess target from titanic_train
target = titanic_train['survived'].values

#preprocess features from titanic_train
features = preprocess_features(titanic_train)

# X == features. y == target. Use 25% of data as 'hold out' data.
# Use a random state of 36.
X_train, X_test, y_train, y_test = train_test_split(features, target,
                                                    test_size=0.25,
                                                    random_state=36)

#impute median for NaNs in age column
imp = Imputer(missing_values=np.nan, strategy='median')

# instantiate classifier
logreg = LogisticRegression()

steps = [
    # impute medians on NaNs
    ('imputation', imp),
    # scale features
    ('scaler', StandardScaler()),
    # fit logreg classifier
    ('logistic_regression', logreg)]

# establish pipeline
pipeline = Pipeline(steps)

#train model
pipeline.fit(X_train, y_train)

# predict labels
y_pred = pipeline.predict(X_test)


# class report
class_report = classification_report(y_test, y_pred)


# need the class report as a df for import to PBI
def classification_report_df(report):
    report_data = []
    lines = report.split('\n')
    for line in lines[2:-3]:
        row = {}
        row_data = line.split('      ')
        row['class'] = row_data[0]
        row['precision'] = float(row_data[1])
        row['recall'] = float(row_data[2])
        row['f1_score'] = float(row_data[3])
        row['support'] = float(row_data[4])
        report_data.append(row)
    dataframe = pd.DataFrame.from_dict(report_data)
    return(dataframe)

class_report = classification_report_df(class_report)
class_report['class'] = class_report.index


# tidy up environment
del X_test, X_train, features, steps, target, y_pred, y_test, y_train