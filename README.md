# Feature Extraction in Multi-Modal Sensor Data by Dimensional Function Synthesis on FPGAs

## Directory Layout
```
MachineLearningModel
   |-- Data
   |   |-- SyntheticTrainingData
   |   |   |-- SyntheticTempInt.csv # Synthetic training data for temperature ranging from -40degC to 85degC
   |   |-- TestData22
   |   |   |-- warp-data-stream-formatV1-03-05-2020-08:00-pip@mini-questions-Darwin-19.2.0-x86_64.csv.zip # Test data of 22degC 
   |   |-- TestData28
   |   |   |-- warp-data-stream-formatV0-01-31-2020-20:00-cpu3@physcomplab-cpu3-Linux-5.3.0-28-generic-x86_64.csv.zip # 28degC
   |   |-- TrainingData
   |   |   |-- TrainingData.zip # 29 files selected from warp-data-stream repo based on 3 different locations, dates and time 
   |   |-- sensorCalibData.xlsx # Includes calibration parameters
   |-- Model
   |   |-- LinReg # Linear Regression Model
   |   |   |-- linReg.py # Using training data from warp-data-stream repo
   |   |   |-- percentError.py
   |   |-- LinRegSyn
   |   |   |-- linRegSyn.py # Using synthetic training data 
   |   |   |-- percentError.py
   |   |-- PolyReg # Polynomial Regression Model
   |   |   |-- percentError.py 
   |   |   |-- polyReg.py # Using training data from warp-data-stream repo
   |   |-- PolyRegSyn
   |   |   |-- percentError.py
   |   |   |-- polyRegSyn.py # Using synthetic training data 
   |-- Results
   |   |-- LinReg22 # # Using 22degC test file
   |   |   |-- 3 CSV files that include raw ADC, test and true temperature values 
   |   |-- LinReg28 # Using 28degC test file
   |   |   |-- 3 CSV files 
   |   |-- LinRegSyn22
   |   |   |-- 3 CSV files 
   |   |-- LinRegSyn28
   |   |   |-- 3 CSV files 
   |   |-- PolyReg22
   |   |   |-- 3 CSV files 
   |   |-- PolyReg28
   |   |   |-- 3 CSV files 
   |   |-- PolyRegSyn22
   |   |   |-- 3 CSV files 
   |   |-- PolyRegSyn28
   |   |   |-- 3 CSV files 
NewtonDescriptions
   |-- Humidity
   |   |-- HumFP.nt # Produces floating point calibrated humidity values
   |   |-- HumFPShortened.nt # Removed intermediary variables
   |   |-- HumInt.nt # Produces calibrated humidity integer values
   |   |-- HumIntShortened.nt
   |-- NewtonBaseSignals.nt # Units of temperature, pressure are already defined here and can be quoted directly
   |-- Pressure
   |   |-- 4 files of similar format as Humidity's
   |-- Temperature
   |   |-- 4 files of similar format as Humidity's
RTLDescriptions
   |-- LFSR_Plus.v
   |-- OutputScripts
   |   |-- DragForPiGroupsTopLFSR.output # Output from running Yosys
   |   |-- calcHumInvariantFPTopLFSR.output
   |   |-- calcTempInvariantFPTopLFSR.output
   |-- calcHumInvariantFPTopLFSR.v
   |-- calcTempInvariantFPTopLFSR.v
   |-- calcTempInvariantIntTopLFSR.v
ProjectLogbook.md
README.md
```

## Data

[Provided data](https://github.com/physical-computation/Warp-data-stream) can be downloaded from this repository and it is also provided in the data folder of my IIB project repository.

## Model

Simple linear regression and polynomial regression models have been used and are shown in the model folder of my project repository.

## Results

The predicted and true temperature readings are saved in csv format in the results folder.

## Newton Descriptions

Parameters with units inferred from Bosch Sensortec's original conversion routines are specified as Newton descriptions in the Newton descriptions repository.

## RTL Descriptions

The RTL files generated from running YoSys and NextPNR tools for the selected Newton descriptions are in the RTL descriptions folder. 
