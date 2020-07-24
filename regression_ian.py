import pandas as pd
import quandl
import math
import numpy as np
from sklearn import preprocessing, svm
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split

quandl.ApiConfig.api_key = "vXjpZ_4yhL-fBNf1EVZC"
df = quandl.get('WIKI/GOOGL')


#useful data
df = df[['Adj. Open', 'Adj. High', 'Adj. Low', 'Adj. Close', 'Adj. Volume']]

#creating high low percent (high-low/low)
df['HL_PCT'] = (df['Adj. High'] - df['Adj. Low']) / df['Adj. Low'] *100

#creating percent change (close-open/open)
df['PCT_change'] = (df['Adj. Close'] - df['Adj. Open']) / df['Adj. Open'] *100

#new useful data
df =df[['Adj. Close', 'HL_PCT', 'PCT_change', 'Adj. Volume']]

#forecast variable
forecast_col = 'Adj. Close'

#cant machine learn with NaN, replace with -99999 as outlier
df.fillna(-99999, inplace=True)

#rounds to whole integer values (.01 predicts 30 days into the future)
forecast_out = int(math.ceil(0.01*len(df)))
print(forecast_out)

#shift by certain number of days in forecast_out
df['label'] = df[forecast_col].shift(-forecast_out)
df.dropna(inplace=True)

#features x axis
X = np.array(df.drop(['label'],1))
#scaling using preprocessing alongside other values
X = preprocessing.scale(X)
#label y axis
y = np.array(df['label'])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)

#set linear regression model, fit data, and test data
clf_ln = LinearRegression()
clf_ln.fit(X_train, y_train)
acc_ln= clf_ln.score(X_test, y_test)

#set simple vector machine regression model
clf_svm = svm.SVR()
clf_svm.fit(X_train, y_train)
acc_svm= clf_svm.score(X_test, y_test)


print(acc_ln)
print(acc_svm)
