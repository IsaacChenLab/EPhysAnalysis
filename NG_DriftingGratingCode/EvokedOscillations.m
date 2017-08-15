function Raw_LFPs = EvokedOscillations(outputFolder, channelsToPlot, redChannels,...
                            CSCData, times, screenTime, duration, loneChannels)

% FUNCTION ARGUMENTS
%   outputFolder = name (in SINGLE quotes) of output folder which will be
%       created, and into which all of the output will be saved. If outputFolder
%        = 'dont save' then no .fig or .mat files will be saved and the script
%       will run much faster. If outputFolder is a complete path, then  '@'
%       should be added to the beginning so that user won't be prompted to
%       choose output directory later
%   channelsToPlot = a vector containing the channels you want to analyze ie 1:32
%   CSCData = a matrix where each row is the LFP for a channel (should have
%       32 rows)
%   times = a single row vector with a time corresponding to each column in
%       CSCData. The number of columns in CSCData and times should be the
%       same
%   screenTime = vector of two numbers. First number is the time the screen
%       came on. Second number is the time the screen turns off.
%   duration = the number of seconds before and after the screen was turned
%       on/off that will be plotted
%   loneChannels = optional; set to 'no lone channels' if you dont want to
%       plot an of the channels individually, only the one big plot with all
%       the channels together

% PLOTS GENERATED
%   1. plot at the time when the screen turned on (each channel, and all
%       channels together)
%   2. plot at the time when the screen turned off (each channel, and all
%       channels together)


if(ispc)
    slash = '\';
else
    slash = '/';
end

%prompt for file where output should be saved and create folder
if ~(strcmpi(outputFolder, 'dont save') || outputFolder(1) == '@')
    fprintf('\tSelect folder where output files should be placed...');
    target_folder = uigetdir('', 'Select output folder');
    fprintf('Selected!\n');
    target_folder = strcat(target_folder, slash, outputFolder);
    mkdir(target_folder);
end

screenOnTime = screenTime(1);
screenOffTime = screenTime(2);

screenOnTime = screenOnTime-times(1);
screenOffTime = screenOffTime-times(1);
times = times-times(1);
sampleRate = (length(times)-1)/(times(end) - times(1));

%set up the figures with all the channels plotted together
all_f1 = figure;
all_ax1 = axes;
xlim([screenOnTime-duration screenOnTime+duration]);
title(all_ax1, 'All Channels -- Screen On');

all_f2 = figure;
all_ax2 = axes;
xlim([screenOffTime-duration screenOffTime+duration]);
title(all_ax2, 'All Channels -- Screen Off');

for AX = [all_ax1 all_ax2]
    curtick = get(AX, 'XTick');
    set(AX, 'XTickLabel', cellstr(num2str(curtick(:))));
    curtick = get(AX, 'YTick');
    set(AX, 'YTickLabel', cellstr(num2str(curtick(:))));
    
    xlabel(AX,'Time (s)');
    ylabel(AX,'Local Field Potential (microvolts)');
    
    hold(AX, 'on');
end

Raw_LFPs = cell(32,1);

for c = channelsToPlot
    
    if sum(c == redChannels) > 0
        color = 'r';
    else
        color = 'b';
    end
    
    LFP = CSCData(c,:);
    ctimes = times(1:length(LFP));
    s = struct();
    
    for q = 1:2
        if q == 1
            focus = screenOnTime;
            name = ['LFP_Channel' num2str(c) '_screenOnPlot'];
            name2 = ' screenOnPlot';
        else
            focus = screenOffTime;
            name = ['LFP_Channel' num2str(c) '_screenOffPlot'];
            name2 = ' screenOffPlot';
        end
        
        startIndex = floor((focus-duration)*sampleRate);
        stopIndex = floor((focus+duration)*sampleRate);
        
        if q == 1
            plot(all_ax1, ctimes(startIndex:stopIndex), LFP(startIndex:stopIndex), color);
            s.ScreenOn = [ctimes(startIndex:stopIndex)', LFP(startIndex:stopIndex)'];
        else
            plot(all_ax2, ctimes(startIndex:stopIndex), LFP(startIndex:stopIndex), color);
            s.ScreenOff = [ctimes(startIndex:stopIndex)', LFP(startIndex:stopIndex)'];
        end
        
        if ~exist('loneChannels','var') || ~strcmpi(loneChannels, 'no lone channels')
            f = figure;
            ax2 = axes;
            hold(ax2,'on');
            xlim([focus-duration focus+duration]);
            
            plot( ctimes(startIndex : stopIndex),LFP(startIndex : stopIndex), color);
            line([focus,focus], ylim(ax2), 'Color', 'red','LineWidth',2.5);
            
            curtick = get(gca, 'XTick');
            set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
            curtick = get(gca, 'YTick');
            set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));
            
            title(ax2,['LFP Channel' num2str(c) name2]);
            xlabel(ax2,'Time (s)');
            ylabel(ax2,'Local Field Potential (microvolts)');
            
            if ~strcmpi(outputFolder,'dont save')
                saveas(f, strcat(target_folder, slash, name, '.fig'));
            end
        end  
    end
    
    Raw_LFPs{c} = s;
end

plot(all_ax1,[screenOnTime,screenOnTime], ylim(all_ax1), 'Color', 'red','LineWidth',2.5);
plot(all_ax2,[screenOffTime,screenOffTime], ylim(all_ax2), 'Color', 'red','LineWidth',2.5);

if ~strcmpi(outputFolder,'dont save')
    saveas(all_f1, strcat(target_folder, slash, 'AllChannels_ScreenOn.fig'));
    saveas(all_f2, strcat(target_folder, slash, 'AllChannels_ScreenOff.fig'));
    save(strcat(target_folder, slash, 'LFP_Raw_Data.mat'), 'Raw_LFPs');
end

end
