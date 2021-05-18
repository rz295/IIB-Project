#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 21:06:47 2021

@author: raezhao
"""

#   This script trains a selection of BME680 Temp data from warp-data-stream repo.
#   Polynomial regression model is used.
#   Calibrated Temp data are obtained using conversion routine from bme680.c file.
import pandas as pd
import glob
import numpy as np
import matplotlib.pyplot as plt

trainingPath = r'/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Data/TrainingData'
testPath = r'/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Data/TestData2' 

li1, li2, li_3, rawADC, testTemp, trueTemp, Pi_1t, Pi_4t = ([] for i in range(8))

#   Set the order of polynomial 
Order = 3

#   Calibration parameter values from sensorCalibData.xlsx
t1LSB = 0x04
t1MSB = 0x67
t2LSB = 0xC0
t2MSB = 0x4E
t3 = 0x66
t1 = int((hex(t1MSB * (2**8))), 16) | int((hex(t1LSB)), 16)
t2 = int((hex(t2MSB * (2**8))), 16) | int((hex(t2LSB)), 16)

#   Extract BME680 Temp raw strings from csv files
def read_csv(Path, li):
    Files = glob.glob(Path + "/*.csv")
    for filename in Files:
        df = pd.read_csv(filename, index_col=None, header=0)
        li.append(df)
    frameTraining = pd.concat(li, axis=0, ignore_index=True)
    d = pd.DataFrame(frameTraining, columns = [' BME680 Temp'])
    return d

#   Concatenate strings tempMSB, tempLSB and tempXLSB into temp_adc
def concatenate_temp_adc(string, iterations):
    rawTemp = string.iloc[iterations,].values
    split=str.split(rawTemp[0])
    tempMSB = int(split[0],16)
    tempLSB = int(split[1],16)
    tempXLSB = int(split[2],16)
    temp_adc = int((hex((tempMSB & 0xFF) * (2**12))), 16) | int((hex((tempLSB & 0xFF) * (2**4))), 16) | int(hex((tempXLSB & 0xF0) // (2**4)), 16)
    return temp_adc

#   Adapted from conversion routine in BME680.c for temperature in integers
def calib_temp(temp_adc):
    var1 = (temp_adc / (2**3)) - (t1 * 2)
    var2 = (var1 * t2) / (2**11)
    var3 = ((((var1 / 2) * (var1 /2)) / (2**11)) * (t3 * (2**4))) / (2**14)
    t_fine = var2 + var3
    calc_temp = (((t_fine) * 5) + 128) / (2**8) / 100
    return calc_temp

d1 = read_csv(trainingPath, li1)
d2 = read_csv(testPath, li2)

#   Iterate over training data
for i in range(0, 1050000, 10):
    temp_train_adc = concatenate_temp_adc(d1, i)
    calc_temp_train = calib_temp(temp_train_adc)
    
    #   First dimensionless group (pi group 0) computed from Newton Web Interface using TempIntShortened.nt ignoring unitHavingConstant1
    Pi_1t.append(calc_temp_train/(t1**2))
    Pi_4t.append(t1/temp_train_adc)

Pit_groups = {
                'Pi_1t': Pi_1t,
                'Pi_4t': Pi_4t       
                }

dg = pd.DataFrame(Pit_groups,columns=['Pi_1t', 'Pi_4t'])

#   Here we have 2 variables for polynomial regression as pi_2 and pi_3 are constants
Xt = dg['Pi_4t'] 
Yt = dg['Pi_1t']

#   Perform polynomial regression model with polyfit
p = np.poly1d(np.polyfit(Xt, Yt, Order))

#   Plot the polynomial fit over original training data
xp = np.linspace(0.02, 0.11, 100) # Zoom out
#xp = np.linspace(0.0490, 0.0517, 10) # Zoom in
#plt.ylim(3.02e-08,4.1e-08) #Zoom in
plt.plot(Xt, Yt, '.', label = "True Data")
plt.plot(xp, p(xp), '-', label = "3rd Order Polynomial Fit")
plt.xlabel('Pi_4 (unitless)')
#   Set the y axis label of the current axis.
plt.ylabel('Pi_1 (unitless)')
#   Set a title of the current axes.
plt.title('3rd Order Polynomial Fit Data VS Raw Data')
#   show a legend on the plot
plt.legend()
#   Display a figure.
plt.show()

#   Iterate over test data
for i in range(0, 45000):
    #   Computed rawADC 
    temp_test_adc = concatenate_temp_adc(d2, i)
    rawADC.append(temp_test_adc)

    #   Computed testTemp
    Pi_2 = t3
    Pi_3 = t1 / t2
    Pi_4 = t1/temp_test_adc
    modelEqn = p(Pi_4)
    testTemp.append(modelEqn * (t1**2))

    #   Computed trueTemp 
    calc_temp_true = calib_temp(temp_test_adc)
    trueTemp.append(calc_temp_true)

dx = pd.DataFrame(testTemp, columns= None)
dx.to_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyReg22/TestValues.csv")
dy = pd.DataFrame(trueTemp, columns= None)
dy.to_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyReg22/TrueValues.csv")
dz = pd.DataFrame(rawADC, columns= None)
dz.to_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyReg22/rawADC.csv")