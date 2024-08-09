# -*- coding: utf-8 -*-
"""
Created on Wed Aug 19 14:00:59 2020

@author: Z
"""


import pandas as pd
import numpy as np
import time
from sklearn import ensemble as eb
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn import metrics as mt
from matplotlib import pyplot as plt
from sklearn.externals import joblib


def plot_train_test(y_train,y_test,predict_train,predict_test):
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.plot(list(range(y_train.shape[0])),predict_train,'c*-',label='predicted Value')
    ax.plot(list(range(y_train.shape[0])),y_train,'m.-',label='True Value')
    plt.title('Comparison of training set prediction results:Y1')
    plt.ylabel('Sample Value')
    plt.xlabel('Sample Number')
    plt.legend()
    plt.show()
    
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.plot(list(range(y_test.shape[0])),predict_test,'c*-',label='predicted Value')
    ax.plot(list(range(y_test.shape[0])),y_test,'m.-',label='True Value')
    plt.title('Comparison of testing set prediction results:Y1')
    plt.ylabel('Sample Value')
    plt.xlabel('Sample Number')
    plt.legend()
    plt.show()



if __name__ == '__main__':  
    #读取数据集
    fr=pd.read_excel('test_datSet_new.xlsx',header = None);
    #无首行字符串 ，取出全部      
    input_new_data = fr[0:]
    
    #数据转换为324*30的float矩阵
    input_new_datset=np.array(input_new_data).tolist()
    X_new=np.matrix(input_new_datset)

    
    #读训练集
    fr=pd.read_excel('training_datSet.xlsx',header = None);
    #无首行字符串 ，取出全部       
    traindata = fr[0:]
    #数据转换为float矩阵
    traindatset=np.array(traindata).tolist()
    traindatset=np.matrix(traindatset)
    #1到30列作为输入数据，31列作为输出数据 
    X_train=traindatset[:,0:-1]
    y_train=traindatset[:,-1]
    
    #读测试集
    fr=pd.read_excel('test_datSet.xlsx',header = None);
    #无首行字符串 ，取出全部       
    testdata = fr[0:]
    #数据转换为float矩阵
    testdatset=np.array(testdata).tolist()
    testdatset=np.matrix(testdatset)
    #1到30列作为输入数据，31列作为输出数据 
    X_test=testdatset[:,0:-1]
    y_test=testdatset[:,-1]    
            
    
    #对数据归一化
    sc_train_X = MinMaxScaler(feature_range=(0, 1))
    sc_train_y = MinMaxScaler(feature_range=(0, 1))
    
    X_train_Norm = sc_train_X.fit_transform(X_train)
    X_test_Norm = sc_train_X.transform(X_test)
    X_new_Norm = sc_train_X.transform(X_new)
    y_train_Norm = sc_train_y.fit_transform(y_train)
    y_test_Norm = sc_train_y.transform(y_test)

    #fit函数需传入y值为一维数组
    y_train_Norm_array = np.array(y_train_Norm).flatten()
    y_test_Norm_array = np.array(y_test_Norm).flatten()
    
    #建立GBDT模型
    model_gbdt = eb.GradientBoostingRegressor(loss='ls',learning_rate=0.1,subsample=0.8,\
                    n_estimators=40,criterion='friedman_mse',min_samples_split = 2,\
                    min_samples_leaf = 1,max_depth=5,random_state=0)
    
    #开始训练并计时
    startTime = time.time() 
    model_gbdt.fit(X_train_Norm, y_train_Norm_array)
    
    #调用sklearn库函数，并计算模型mse值并输出
    gbdt_score=mt.mean_squared_error(y_train_Norm, model_gbdt.predict(X_train_Norm))
    print('sklearn梯度提升决策树-回归模型mse值',gbdt_score)
    
    #输出模型训练用时
    stopTime = time.time()
    sumTime = stopTime - startTime
    print('总时间是：', sumTime)
    
    #反归一化保存预测值与真实值
    predict_train_Norm = model_gbdt.predict(X_train_Norm)
    predict_train = sc_train_y.inverse_transform(np.matrix(predict_train_Norm.tolist()).T)
    predict_test_Norm = model_gbdt.predict(X_test_Norm)
    predict_test = sc_train_y.inverse_transform(np.matrix(predict_test_Norm.tolist()).T)#没有sc_test_y
    predict_new_Norm = model_gbdt.predict(X_new_Norm)
    predict_new = sc_train_y.inverse_transform(np.matrix(predict_new_Norm.tolist()).T)
    
    #计算MSE值
    mse_train = mt.mean_squared_error(y_train,predict_train)**2
    mse_test = mt.mean_squared_error(y_test,predict_test)**2
    print('训练集真实值与预测值MSE值',mse_train)
    print('测试集真实值与预测值MSE值',mse_test)
    
    #计算RMSE值
    rmse_train = mt.mean_squared_error(y_train,predict_train)#,squared = False
    rmse_test = mt.mean_squared_error(y_test,predict_test)#,squared = False
    print('训练集真实值与预测值RMSE值',rmse_train)
    print('测试集真实值与预测值RMSE值',rmse_test)
    
    #计算MAE值
    mae_train = mt.mean_absolute_error(y_train,predict_train)
    mae_test = mt.mean_absolute_error(y_test,predict_test)
    print('训练集真实值与预测值MAE值',mae_train)
    print('测试集真实值与预测值MAE值',mae_test)
    
    #计算R^2值
    r2_train = mt.r2_score(y_train,predict_train)
    r2_test = mt.r2_score(y_test,predict_test)
    print('训练集真实值与预测值R^2值',r2_train)
    print('测试集真实值与预测值R^2值',r2_test)
    
    #将预测值和真实值放在同一个矩阵变量中对比
    result_train = np.hstack((y_train,predict_train))
    result_test = np.hstack((y_test,predict_test))
    
    #将训练集真实值和预测值数据并写入文件
    data_train = pd.DataFrame(result_train)
    data_train.columns = ['真实值','预测值']
    writer_train = pd.ExcelWriter('GBDT_data_train.xlsx')
    data_train.to_excel(writer_train)  
    writer_train.save()  
    
    #将测试集真实值和预测值数据并写入文件
    data_test = pd.DataFrame(result_test)
    data_test.columns = ['真实值','预测值']
    writer_test = pd.ExcelWriter('GBDT_data_test.xlsx')
    data_test.to_excel(writer_test)  
    writer_test.save()
    
    #将X_new对应的输出predict_new存到excel
    y_new = pd.DataFrame(predict_new)
    writer_new = pd.ExcelWriter('y_new.xlsx')
    y_new.to_excel(writer_new)
    writer_new.save()
    
    #绘制图像
    plot_train_test(y_train,y_test,predict_train,predict_test)
    
    
    
    
    

