#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 21:06:47 2021

@author: raezhao
"""

#   This script trains synthetic BME680 Temp data ranging from -40degC to 85degC.
#   Polynomial regression model is used.
#   Raw Temp data are obtained by reversing the conversion routine from bme680.c file.
import math
import pandas as pd
import glob
import numpy as np
import matplotlib.pyplot as plt

calibratedTemp = pd.read_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Data/SyntheticTrainingData/SyntheticTempInt.csv") 
testPath = r'/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Data/TestData' 

li2, rawADC, testTemp, trueTemp, Pi_1t, Pi_4t = ([] for i in range(6))

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

d2 = read_csv(testPath, li2)

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

#   Iterate over synthetic training data
for i in range(0, 121):
    t_fine = (calibratedTemp['0'][i] * 100 * (2**8) - 128) / 5
    radicand = (t2**2) / (2**22) + t3 * t_fine / (2**21)
    var1 = (-t2 / (2**11) + math.sqrt(radicand)) * (2**22) / t3
    temp_ADC = (2**3) * (var1 + 2 * t1)
    Pi_1t.append(calibratedTemp['0'][i]/(t1**2))
    Pi_4t.append(t1/temp_ADC)

#pi_2t and pi_3t are constants and so will not be modelled in our relationship here
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
xp = np.linspace(0.034, 0.11, 10) 
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
dx.to_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyRegSyn28/TestValues.csv")
dy = pd.DataFrame(trueTemp, columns= None)
dy.to_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyRegSyn28/TrueValues.csv")
dz = pd.DataFrame(rawADC, columns= None)
dz.to_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyRegSyn28/rawADC.csv")