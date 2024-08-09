# -*- coding: utf-8 -*-
"""
Created on Wed Aug 19 14:00:59 2020

@author: Z
"""


import pandas as pd
import numpy as np
from sklearn import ensemble as eb
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn import metrics as mt
from matplotlib import pyplot as plt
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.model_selection import GridSearchCV


if __name__ == '__main__':  
    
    #读取数据集
    fr=pd.read_excel('MainFactor.xlsx',header = None);
    #无首行字符串 ，取出1到31全部列       
    data = fr[0:]
    
    #数据转换为325*31的float矩阵
    datset=np.array(data).tolist()
    datset=np.matrix(datset)
    
    #1到30列作为输入数据，31列作为输出数据 
    data_input =datset[:,0:-1]
    data_labels =datset[:,-1]
    sc_data_input = MinMaxScaler(feature_range=(0, 1))
    sc_data_labels = MinMaxScaler(feature_range=(0, 1))
    data_input_Norm = sc_data_input.fit_transform(data_input)
    data_labels_Norm = sc_data_labels.fit_transform(data_labels)
    
    #fit函数需传入y值为一维数组
    data_labels_Norm_array = np.array(data_labels_Norm).flatten()      
    
    
    ##设置参数
    #    model_gbdt = eb.GradientBoostingRegressor(loss='ls',learning_rate=0.1,subsample=0.8,\
#                    n_estimators=50,criterion='friedman_mse',min_samples_split = 2,\
#                    min_samples_leaf = 1,max_depth=15,random_state=0)
    tuned_parameters= [{
                  'loss':['ls','lad','huber','quantile'],
                  'n_estimators': range(20,50,2),
                  'learning_rate':[0.1],
                  'max_depth':range(3,14,2),
                  'subsample':[0.75,0.8,0.9],
                  }]
    ##设置分数计算方法精度/召回
    scores = ['r2']  ## ['precision', 'recall']
    for score in scores:
        print("评测选择 %s" % score)
        clf = GridSearchCV(GradientBoostingRegressor(), tuned_parameters, cv=5, scoring='%s' % score)
        clf.fit(data_input_Norm, data_labels_Norm)
        #print(clf.grid_scores_)
        print(clf.best_params_)
        print(clf.best_score_)
    
    
    
    
    

