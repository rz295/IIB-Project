## Project Logbook
---
### Wednesday - October 14th, 2020 - Rae + Phillip
In terms of next steps, Rae would need to:
* Complete Hazard Assessment Form
* Read the 3 suggested background materials sent (2 about Dimensional Function Synthesis and 1 about Machine Learning)

### Thursday - October 22nd, 2020 - Rae + Phillip
In terms of next steps, Rae would need to:
* Look into warp-data-stream repository, inspect the available sensing measurements and propose 6 potential sensing applications from adopting at least one sensor given (e.g. pendulum could be one of the possible applications)
* Look into pedometer repository, observe how the pedometer example is implemented and write in C for a pendulum example that takes in accelerometer or gyrometer data and outputs oscillation period
* Submit a project timeline proposal after having a better understanding of the project over this weekend

### Wednesday - October 28th, 2020 - Rae + Vasilis
* Adapted the pedometer example for pendulum and incorporated that into the c file on repository
* Gained access to all the data for variable-g pendulum experiment, mentioned in DFS paper
* Raw data sampled from the sensors on the pendulum mass are in raw_data

### Thursday - October 29th, 2020 - Rae + Phillip
Progress made following the last meeting:
* Available sensors from warp-data-stream repository include the following:
Infrared sensors; temperature sensors; accelerometers; magnetometers; gyroscopes; pressure sensors; humidity sensors; environmental sensors (Co2 and TVOC)
* At least one sensor from the above is chosen for the 6 potential sensing applications below:
i)	Pendulum
Accelerometer
ii)	Time of the day or air-conditioning functions
Temperature sensor; humidity sensor
iii)	Air Quality
Environmental sensors (Co2 and TVOC)
iv)	Industrial setting (e.g. test if the reduction in pressure of the gearbox is due to loss of oil or just increase in temperature due to friction)
Pressure sensor; temperature sensor
v)	Aircraft’s altitude and heading reference system
Magnetometer; gyroscope; pressure sensor
vi)	Home security system for detecting motion
Infra-red sensor

### Thursday - November 5th, 2020 - Rae + Phillip
Progress made following the last meeting:
* Observe how the pedometer example is implemented and write in C for a pendulum example that takes in accelerometer or gyrometer data and outputs oscillation period:
A raw pendulum example file and makefile are written locally and the example file has been successfully compiled to compute period of a pendulum. 
However, I am still trying to make sense of the example pedometer folder in the repository and to figure out further modifications required in order to incorporate this new pendulum example into the repository. 
Vasileios mentioned that he is happy to guide me through this process
* Progress reviewed: Some project marks are allocated for mid-of-term project review, project seems to be on track
* Michaelmas Project Presentation is scheduled on Wednesday 25th November

### Thursday - November 12th, 2020 - Rae + Phillip
Project timeline is proposed below:
* Nov 13th to Nov 18th: prepare for project presentation, meanwhile research on machine learning methods and implement the pendulum example using the actual measurements provided
* Nov 19th  – Nov 25th: Michaelmas project presentation
* Nov 26th – Dec 3rd: implement an ML method for the pendulum example and compare actual results with the theoretical results obtained from C files written in the sunflower repository
* During Christmas vacation: work on technical milestone report
* Beginning of LT: submit technical milestone report
* LT plans: apply similar ideas for the other 5 applications proposed
* During Easter vacation: finish off with project work and start to draft report and prepare for presentation
* ET plans: work on technical abstract, final project report and final presentation
* Week 5 of ET: submit technical abstract and final project report
* Week 6/7 of ET: final presentation

### Tuesday - November 17th, 2020 - Rae + James
* Further discussed how the bme680 conversion routine works
* Explained how calibration parameters are deployed in the conversion routines for temperature, humidity and pressure

### Thursday - November 19th, 2020 - Rae + Phillip
In terms of next steps, Rae would need to:
* Focus on 3 applications namely pendulum, aircraft altitude and air quality and list all necessary sensor signals for each application
* Talk to James about the bme file and ask how the equations corresponding to the conversion routines work in order to get more hints about additional parameters that could be used to form the dimensionless groups
* Speak to Vasileios about the ideas of forming dimensionless groups using the newton interface, and write newton descriptions for each example
* Work on presentation draft and discuss if things are unclear

### Tuesday - November 24th, 2020 - Rae + Vasilis
* Demonstrated the work for RTL code generation as part of a Newton backend, which corresponds to the DCS work
* Added to private repository that includes auto-generated code from the Newton RTL backend

### Wednesday - November 25th, 2020 - Rae + Phillip
* Additional comments from Phillip regarding presentation draft: 
citations; talk to Vasilis about how to get Newton descriptions in in Verilog and then on FPGA and Marlann; adjust font size bigger; slide number added
* Completed Michaelmas Project Presentation

### Thursday - December 3rd, 2020 - Rae + Phillip
Progress made:
* Realised that the last two are only for obtaining sensor measurements rather than interpreting them, so came up with two other applications instead
a)	Friction for a glider down a cliff
b)	Terminal velocity of ball bearing in water
* Learnt how data read from a register and convert to readings, then using BME680 file example to assign units to these readings by multiplying it with a variable with units for example; will be useful to then replace this process by incorporating DFS approach

### Thursday - December 10th, 2020 - Rae + Phillip
Completed Michaelmas Project Presentation

### Wednesday - December 16th, 2020 - Rae + Phillip + Jossy
Received feedback from Michaelmas Project Presentation

### Tuesday - December 22nd, 2020 - Rae + Vasilis
* Spoke to Vasileios about the ideas of forming dimensionless groups using the newton interface, and wrote newton descriptions for each example
* Produced generated RTL files based on newton description for humidity, temperature integer (Phillip's), and temperature (my own) input specification files
* Each file contains two top modules - one which includes the core functionality (e.g., calcHumInvariantSerial), one how feeds this module with input from an LFSR random number generator (e.g., calcHumInvariantTopLFSR), and also includes the LFSR module which targets iCE40 FPGA

### Thursday - January 21st, 2021 - Rae 
Submitted Technical Milestone Report

### Thursday - January 28th, 2021 - Rae + Phillip
In terms of next steps:
* Run the humidity, temperature RTL files on FPGA and measure power, timing and resource usage
* Build ML model (e.g. dimensionless products as inputs and cal_temp as output)

### Thursday - February 4th, 2021 - Rae + Phillip
Progress made so far:
* Spoke to Vasileios for the pressure file; tried to generate RTL file but failed so there are probably bugs in the file that I will need to fix
* YoSys and NextPNR commands were executed to measure clock frequency and resource usage
In terms of next steps:
* Measure power
* Create a new repo to store RTL files, newton descriptions, etc.
* Implement ML model and will also watch online tutorials regarding neural networks

### Thursday - February 11th, 2021 - Rae + Phillip
Progress made from last meeting:
* Tried to build a ML model (e.g. dimensionless products as inputs and cal_temp as output)
  * Use the target parameter values that we already know (those who belong to dataset), and calibrate (train) models in stage 3 (so the models also appear in stage 3 but only want to train and test them)
  * The calibrated model runs in stage 4 in order to predict the target parameter using unknown input parameter that occur at run-time at the edge (deployed on an embedded board to predict new values)

### Thursday - February 18th, 2021 - Rae + Vasilis
Discussed the following:
* The Marlann Neural network accelerator refers to a HW unit that accelerates the run-time executing of a family of neural networks and we need the accelerator mainly for stage 4
* In order to have a correct accelerator you need to have trained the respective neural network in stage 3, and so if someone is to use Marlann, they need to know what types of networks does Marlann accelerate so that they train (calibrate) one of them against their dataset
* i.e. if using Marlann in stage 4, then stage 3 has to use neural networks that Marlann supports

### Thursday - February 25th, 2021 - Rae + Phillip
* Asked where test data, calibration parameters are located in the repository
* Checked whether variables involved in conversion routines are intermediary variables or input variables

### Thursday - March 4th, 2021 - Rae + Phillip
* Implemented linear regression model for test data
* Results seem to show overtraining as the test data span over very narrow range of temperature, humidty and pressure
* Suggested to create a synthetic dataset that can model over a wider range of data

### Thursday - March 11th, 2021 - Rae + Phillip
* Implemented linear regression model for synthetic dataset, and results seemed to be reasonable
* Explored the possibility of other training models (e.g. polynomial regression, neural networks, etc.)

### Friday - March 19th, 2021 - Rae + Phillip
Received feedback for Lent Term Progress and Industry:
* Being industrious and making good progress 

### Monday - March 22nd, 2021 - Rae + Bilgesu
Asked how the MATLAB files (namely estimatePiMultinomialPhysics) work to:
* Estimate Pi-polynomial equations of physics that verify the data, given a data matrix of instances of pi-products, piData
* Minimise the variance around a constant value when evaluated at the given piData points

### Thursday - March 25th, 2021 - Rae + Phillip
* Suggested to work on the project for a few more days and then move on for IIB Exam revision
* Meetings resumed from May 13th
* Final report due on June 2nd

### Thursday - May 13th, 2021 - Rae 
* Work on project dissertation from now onwards
* Upload relevant files to this GitHub repository
