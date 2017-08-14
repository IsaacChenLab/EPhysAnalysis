function Cell_Locations = CellLocator(outputFolder, cellCount, redCells, blueCells,...
                                      show_figs, spikesFile)
 
% INPUT
%   outputFolder = name (in SINGLE quotes) of output folder which will be 
%       created, and into which all of the output will be saved. If outputFolder 
%        = 'dont save' then no .fig or .mat files will be saved and the script
%       will run much faster. If outputFolder is a complete path, then  '@'
%       should be added to the beginning so that user won't be prompted to
%       choose output directory later.
%   cellsCount = number of cells in the recording
%   redCells, blueCells = each are vectors of the cells you want to be red
%       and blue respectively. By convention, the redCells should be the
%       simple cells and the blue should be the complex cells. All other
%       cells are black.
%   show_figs = optional; set to 'dont show' if you don't want the figure
%       windows to pop up. They'll still be saved unless 'dont save' is
%       specified
%  spikesFile =  optional; spikes.mat file. If not given, user will be prompted
%       to browse for the file.
 
% PLOTS GENERATED
%   1. Plot of relative locations of all the cells detected, based on which
%       probe they are nearest to. re
%   --- figures are displayed and saved in the output folder ---
 
% OUTPUT
%   Cell_Locations = struct with three fields: Simple Cells, Complex
%       Cells, All Other Cells. Each field contains an matrix with 4 columns.
%       Each row represents a different cell.
%       Column 1 = the cell number
%       Column 2 = the channel (ie probe) to which that cell is closest
%       Column 3 = corresponding x coordinate
%       Column 4 = correspinding y coordinate
 
%handle some input
if exist('show_figs', 'var') && strcmp(show_figs, 'dont show')
   set(0,'DefaultFigureVisible','off');
else
    set(0,'DefaultFigureVisible','on');
end

% old code
% if ~exist('threshold', 'var')
%    threshold = 0.6;
% end
 
% make sure that channelLocations.mat is in the same directory as this script
% this is where channels_xy comes from
load('channelLocations.mat');
 
% get and read the Orientation Selectivity file
% this is where resultantVectors comes from
% if ~exist('selectivityFile', 'var')  
%     fprintf("\tSelect orientation selectivity file...");
%     [data_file, data_path] = uigetfile('*.mat','Select .mat file...');
%     fprintf("Selected!\n");
%     selectivityFile = strcat(data_path, data_file);
%     load(selectivityFile);
% else
%     resultantVectors = selectivityFile;
% end
 
% get and load the spikes.mat file
% this is where dvSpikes comes from
if ~exist('spikesFile', 'var')
    fprintf("\tSelect spike data file...");
    [data_file, data_path] = uigetfile('*.mat','Select .mat file...');
    fprintf("Selected!\n");
    spikesFile = strcat(data_path, data_file);
    load(spikesFile);
else
    dvSpikes = spikesFile;
end
 
%prompt for file where output should be saved and create folder
if ~(strcmpi(outputFolder, 'dont save') || outputFolder(1) == '@')
    fprintf('Select folder where output files should be placed...');
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
 
%maxChannels = [9,11,6,24,9,30,24,18,6,27,13,26,27,12,17,5,6,31,11,4,5,18,20,22,20,27,11,25,13,17,15,10,9,28,8];
 
%set maxChannels and count repeats
maxChannels = zeros(cellCount, 1);
repeats = zeros(cellCount, 1);
for i = 1:cellCount
    maxChannels(i) = dvSpikes.units(i).maxChannel;
    for j = 1:i-1
        if maxChannels(j) == maxChannels(i)
            repeats(i) = repeats(i) + 1;
        end
    end
end

% old code
% redCells = resultantVectors(resultantVectors(:,3) > threshold, 1);
% blueCells = setdiff(allCells, redCells);

allCells = 1:cellCount;
blackCells = setdiff(allCells,redCells);
blackCells = setdiff(blackCells,blueCells);

red_repeats = repeats(redCells);
blue_repeats = repeats(blueCells);
black_repeats = repeats(blackCells);
 
redChannels = maxChannels(redCells);
blueChannels = maxChannels(blueCells);
blackChannels = maxChannels(blackCells);
 
red_xy = channels_xy(redChannels+1,2:3);
blue_xy = channels_xy(blueChannels+1,2:3);
black_xy = channels_xy(blackChannels+1,2:3);
 
% make it so the repeated dots go *outside* of the original dot
red_repeats(red_xy(:,1) == 0) = red_repeats(red_xy(:,1) == 0) * -1;
blue_repeats(blue_xy(:,1) == 0) = blue_repeats(blue_xy(:,1) == 0) * -1;
black_repeats(black_xy(:,1) == 0) = black_repeats(black_xy(:,1) == 0) * -1;
 
% apply the repeat offset to the x coordinate
red_xy_repeats = red_xy + [red_repeats*1.2 zeros(length(redCells),1)];
blue_xy_repeats = blue_xy + [blue_repeats*1.2 zeros(length(blueCells),1)];
black_xy_repeats = black_xy + [black_repeats*1.2 zeros(length(blackCells),1)];

%plot the points
f = figure('Name', 'Cell Locations', 'NumberTitle','off');
ax1 = axes;
hold(ax1, 'on');
scatter( ax1, red_xy_repeats(:,1), red_xy_repeats(:,2),25,... 
         'filled', 'r', 'DisplayName', 'Putative Simple Cells');
scatter( ax1, blue_xy_repeats(:,1), blue_xy_repeats(:,2),25,...
         'filled', 'b',  'DisplayName', 'Putative Complex Cells');
scatter( ax1, black_xy_repeats(:,1), black_xy_repeats(:,2),25,...
         'filled', 'k',  'DisplayName', 'All Other Cells');

% format the plot
xlim(ax1, [-25, 50]);
ylim(ax1, [-200, 900]);
title(ax1, 'Relative Location of Detected Cells Based on Nearest Probe');
xlabel(ax1, 'Microns');
ylabel(ax1, 'Microns');
legend('show');
 
Cell_Locations = struct('Putative_Simple_Cells', [redCells' redChannels red_xy],...
                        'Putative_Complex_Cells', [blueCells' blueChannels blue_xy],...
                        'All_Other_Cells', [blackCells' blackChannels black_xy]);
 
%save the output analysis
if ~strcmpi(outputFolder, 'dont save')
    saveas(f, strcat(target_folder, '/Cell_Locations.fig'));
    save(strcat(target_folder,'/Cell_Locations.mat'), 'Cell_Locations');
end
 
end
