import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from sklearn import preprocessing
from sklearn import preprocessing
from sklearn.preprocessing import StandardScaler
# Creating labelEncoder
le = preprocessing.LabelEncoder()


def preprocess(df):
    # Converting string labels into numbers.
    df['Socio_Economic Status'] = le.fit_transform(df['Socio_Economic Status'])
    df['Education Status'] = le.fit_transform(df['Education Status'])
    df['Sex'] = le.fit_transform(df['Sex'])
    df['Education Status'] = le.fit_transform(df['Education Status'])
    df['Observable_symptom'] = le.fit_transform(df['Observable_symptom'])
    df['Burning_sensation'] = le.fit_transform(df['Burning_sensation'])
    df['Observable_symptom'] = le.fit_transform(df['Observable_symptom'])
    df['Dental_pain'] = le.fit_transform(df['Dental_pain'])
    df['Medical_history'] = le.fit_transform(df['Medical_history'])
    df['Oral_Habits'] = le.fit_transform(df['Oral_Habits'])
    df['Dietary_Habits'] = le.fit_transform(df['Dietary_Habits'])
    df['Spicy/Non_Spicy'] = le.fit_transform(df['Spicy/Non_Spicy'])
    # df['Subject_Tag']=le.fit_transform(df['Subject_Tag'])
    df['binary_case1'] = le.fit_transform(df['binary_case1'])
    df['binary_case2'] = le.fit_transform(df['binary_case2'])

    # DATA PREPROCESSING
    # filling the unavailable categorical data with mode
    col = df.columns.values.tolist()
    # df_y.fillna(value=df_y.median(), inplace = True)
    categorical = ["Socio_Economic Status", "Education Status", "Sex", "Observable_symptom", "Burning_sensation",
                   "Dental_pain", "Medical_history", "Oral_Habits", "Dietary_Habits", "Spicy/Non_Spicy"]
    # for c in col:
    # if c not in categorical:
    #  datainput[c].fillna(value=datainput[c].median(), inplace=True)
    for c in categorical:
        df[c] = df[c].fillna(value=df[c].mode()[0])

    numerical = ["Age", "Weight_kg", "Height_metre", "BMI_kg/metre2"]
    for c in numerical:
        df[c].fillna(value=df[c].median(), inplace=True)

    df = df.drop(['binary_case1'], axis=1)
    df = df.drop(['binary_case2'], axis=1)
    df = df.drop(['Patient ID'], axis=1)
    return df
