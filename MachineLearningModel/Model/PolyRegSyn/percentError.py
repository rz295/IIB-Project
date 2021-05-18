#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 25 16:40:10 2021

@author: raezhao
"""

import pandas as pd 
import statistics as stats
import matplotlib.pyplot as plt

predictedData = pd.read_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyRegSyn28/TestValues.csv") 
trueData = pd.read_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyRegSyn28/TrueValues.csv") 
rawADC = pd.read_csv("/Users/raezhao/Desktop/IIB-Project/MachineLearningModel/Results/PolyRegSyn28/rawADC.csv") 
errorPer = []

for i in range(0, 45000):
    error = (predictedData['0'][i] - trueData['0'][i]) / trueData['0'][i] * 100
    errorPer.append(error)
    
print (stats.mean(errorPer))
print (stats.stdev(errorPer))

plot1 = plt.figure(1)
plt.plot(rawADC['0'], predictedData['0'], label = "Predicted Data")
plt.plot(rawADC['0'], trueData['0'], label = "True Data")
plt.xlabel('Raw ADC Data (V)')
#   Set the y axis label of the current axis.
plt.ylabel('Calibrated Data ($^\circ$C)')
#   Set a title of the current axes.
plt.title('True and Predicted Calibrated Data VS Raw ADC Data')
#   show a legend on the plot
plt.legend()
#   Display a figure.
plt.show()

plot2 = plt. figure(2)
plt. plot(rawADC['0'], errorPer)
plt.xlabel('Raw ADC Data (V)')
#   Set the y axis label of the current axis.
plt.ylabel('Percent Error (%)')
#   Set a title of the current axes.
plt.title('Percent Error VS Raw ADC Data')
#   show a legend on the plot
plt.legend()
#   Display a figure.
plt.show()