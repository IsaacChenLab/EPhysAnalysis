function [resultantVectors] = PolarPlots(outputFolder, cellsToPlot, ...
                                       showPlots, screenOff, dataMatrix)

% INPUT
%   outputFolder = name (in SINGLE quotes) of output folder which will be 
%       created, and into which all of the output will be saved. If outputFolder 
%        = 'dont save' then no jpgs or .mat files will be saved and the script
%       will run much faster. If outputFolder is a complete path, then  '@'
%       should be added to the beginning so that user won't be prompted to
%       choose output directory later.
%   cellsToPlot = a vector containing the cell number of each cell to be
%        plotted
%   showPlots = optional; set to 'dont show' if you don't want the figure
%       windows to pop up. They'll still be saved unless 'dont save' is
%       specified.
%   screenOff = optional; set to 'screenOff' if the columns for 'screenOff' are
%       included in the dataMatrix (ie the dataMatrix is N x 10 instead of 
%       N x 8, where N is the number of cells). The screenOff columns need
%       to be the first and last columns (these will be trimmed away). If
%       those columns are not present set screenOff to ''.
%   dataMatrix =  optional; n x 8 (or n x 10) matrix where n is # of cells.
%       The 8 columns are as follows: -180, -135, -90, -45, 0, 45, 90, 135.
%       Each entry is the firing rate in spikes/s. If dataMatrix is
%       left out then user will be prompted for a csv file containing the
%       matrix (csv should have no labels, just the matrix).

% PLOTS GENERATED
%   1. Plot firing rate vs orientation for each cell
%   2. A sinlge plot with orientation selectivity vectors plotted for every cell
%   --- figures are displayed and saved in the output folder ---

% OUTPUT
%   resultantVectors = an N x 3 matrix where N is the number of cells.
%       Column 1 is the cell number. Column 2 is the direction of the resultant
%       vector in degrees. Column 3 is the normalized amplitude of that vector
%       [0,1]. The rows of the matrix are sorted according to amplitude.


%handle some input
if exist('showPlots', 'var') && strcmp(showPlots, 'dont show')
   set(0,'DefaultFigureVisible','off');
else
    set(0,'DefaultFigureVisible','on');
end

%get and read the csv
if ~exist('dataMatrix', 'var')  
    fprintf("\tSelect csv file...");
    [data_file, data_path] = uigetfile('*.csv','Select csv file...');
    fprintf("Selected!\n");
    M = csvread(strcat(data_path, data_file)); 
else
    M = dataMatrix;
end

%if the 'screenOff' columns are still in there
if exist('screenOff', 'var') && strcmp(screenOff, 'screenOff')
    M = M(2:end-1,:);
end

%prompt for file where output should be saved and create folder
if ~(strcmpi(outputFolder, 'dont save') || outputFolder(1) == '@')
    fprintf('\tSelect folder where output files should be placed...');
    target_folder = uigetdir('', 'Select output folder');
    fprintf('Selected!\n');
    target_folder = strcat(target_folder, '/', outputFolder);
end

%if complete path was given as outputFolder argument, set target_folder to
%output folder
if outputFolder(1) == '@'
    target_folder = outputFolder(2:end);
end

%create output folder
if ~strcmpi(outputFolder, 'dont save')
   mkdir(target_folder);
end

rads = deg2rad([180,225,270,315,0,45,90,135]);

%set up resultant vector figure
v = figure('Name', 'Orientation Selectivity', 'NumberTitle','off');
title(sprintf("Normalized Orientation Selectivity for Each Cell\n"));

paxV = polaraxes;
hold(paxV, 'on')
thetaticks(0:15:360);
rticks(0:.2:1);
rlim(paxV,[0 1]);
resultantVectors = zeros(length(cellsToPlot), 3);

for c = cellsToPlot
    
    %set up firing activity the figure
    name = sprintf('Cell_%.0f', c);
    f = figure('Name', name, 'NumberTitle','off');
    title(sprintf(strcat("Firing Rate vs Grating Orientation for Cell ", num2str(c), "\n")));
    
    pax1 = polaraxes;
    thetaticks(pax1,0:15:360);
    rticks(0:2:26);
    
    % do the main plot, adding the 180 point back to the end so that things connect
    polarplot(pax1, [rads pi], [M(c,:) M(c,1)]);
    
    %save the file
    if ~strcmpi(outputFolder, 'dont save')
        saveas(f,strcat(target_folder, '/', name, '.fig'));
    end
    
    %compute orientation selectivity (ie the resultant vector)
    c_x = sum( M(c,:) .* cos(rads));
    c_y = sum( M(c,:) .* sin(rads));
    selectivity = sqrt(c_x.^2 + c_y.^2) / sum(M(c,:));
    
    pref_theta = atan(c_y / c_x);
    if(c_x < 0)
        pref_theta = pref_theta+pi;
    end
    
    resultantVectors(c, :) = [c rad2deg(pref_theta) selectivity];
    
    %plot orientation selectivity
    polarscatter(paxV, pref_theta, selectivity,[],'k');
end

resultantVectors = sortrows(resultantVectors, 3, 'descend');
resultantVectors(resultantVectors(:,2) < 0,2) = resultantVectors(resultantVectors(:,2) < 0,2) + 360;

%save the file
if ~strcmpi(outputFolder, 'dont save')
    saveas(v,strcat(target_folder, '/Orientation_Selectivity.fig'));
    save( strcat(target_folder,'/Orientation_Selectivity.mat'), 'resultantVectors');
end

end
