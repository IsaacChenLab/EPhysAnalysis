function EvokedOscillations(outputFolder, channelsToPlot, CSCData, times, screenTime, duration)

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

% PLOTS GENERATED
%   1. plot of the entire LFP
%   2. plot at the time when the screen turned on
%   2. plot at the time when the screen turned off



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


for c = channelsToPlot
    
    LFP = CSCData(c,:);
    ctimes = times(1:length(LFP));
    
    name = ['GammaOsc_Channel' num2str(c) '_wholeplot'];
    
    wholePlot = figure;
    ax1 = axes;
    hold(ax1,'on');
    plot(ctimes,LFP);
    line([screenOnTime,screenOnTime], ylim(ax1), 'Color', 'red','LineWidth',2.5);
    line([screenOffTime,screenOffTime], ylim(ax1), 'Color', 'red','LineWidth',2.5);
    
    xticks(ctimes(1):100:ctimes(end));
    
    curtick = get(gca, 'XTick');
    set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
    curtick = get(gca, 'YTick');
    set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));
    
    title(ax1,['GammaOsc Channel' num2str(c) ' wholeplot']);
    xlabel(ax1,'Time (s)');
    ylabel(ax1,'Local Field Potential');
    
    saveas(wholePlot, strcat(target_folder, slash, name, '.fig'));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for q = 1:2
        if q == 1
            focus = screenOnTime;
            name = ['GammaOsc_Channel' num2str(c) '_screenOnPlot'];
            name2 = ' screenOnPlot';
        else
            focus = screenOffTime;
            name = ['GammaOsc_Channel' num2str(c) '_screenOffPlot'];
            name2 = ' screenOffPlot';
        end
        
        f = figure;
        ax2 = axes;
        hold(ax2,'on');
        startIndex = floor((focus-duration)*sampleRate);
        stopIndex = floor((focus+duration)*sampleRate);
        plot( ctimes(startIndex : stopIndex),LFP(startIndex : stopIndex));
        line([focus,focus], ylim(ax2), 'Color', 'red','LineWidth',2.5);
        
        xlim([focus-duration focus+duration]);
        
        curtick = get(gca, 'XTick');
        set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
        curtick = get(gca, 'YTick');
        set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));
        
        title(ax2,['GammaOsc Channel' num2str(c) name2]);
        xlabel(ax2,'Time (s)');
        ylabel(ax2,'Local Field Potential');
        
        saveas(f, strcat(target_folder, slash, name, '.fig'));
    end
    
    
end
