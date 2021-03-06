%% Search for a specified operating point for the model - newsyscase1.
%
% This MATLAB script is the command line equivalent of the trim model
% tab in linear analysis tool with current specifications and options.
% It produces the exact same operating points as hitting the Trim button.

% MATLAB(R) file generated by MATLAB(R) 8.4 and Simulink Control Design (TM) 4.1.
%
% Generated on: 10-Feb-2017 14:42:17

%% Specify the model name
model = Mname;

%% Create the operating point specification object.
opspec = operspec(model);

%% Set the constraints on the states in the model.
% - The defaults for all states are Known = false, SteadyState = true,
%   Min = -Inf, and Max = Inf.

% State (1) - newsyscase1/Subsystem/H1C1/Integrator
% - Default model initial conditions are used to initialize optimization.

% State (2) - newsyscase1/Subsystem/H1C2/Integrator
% - Default model initial conditions are used to initialize optimization.

% State (3) - newsyscase1/Subsystem/H2C1/Integrator
% - Default model initial conditions are used to initialize optimization.

% State (4) - newsyscase1/Subsystem/H2C2/Integrator
% - Default model initial conditions are used to initialize optimization.

% State (5) - newsyscase1/Subsystem/H2C3/Integrator
% - Default model initial conditions are used to initialize optimization.


%% Create the options
opt = findopOptions('DisplayReport','iter');

%% Perform the operating point search.
[op,opreport] = findop(model,opspec,opt);
