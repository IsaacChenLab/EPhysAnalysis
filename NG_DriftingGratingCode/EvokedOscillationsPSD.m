function EvokedOscillationsPSD(outputFolder, channelsToPlot, CSCdata,...
                               times, screenTime, freqBand, freqBandName,...
                               duration, points_per_Hz)
% Oscillatoins
    % Gamma = 20-50 Hz
    % Beta = 12-30 Hz
    % Theta = 4-12 Hz
    % Delta = 1-4 Hz
    
                           
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
%   freqBand = vector of two numbers. First number is the lower bound of
%       the frequency band to be plotted, the second number is the upper bound
%   freqBandName = the name of the frequency band you are analyzing, ie
%       'Gamma'
%   duration = the number of seconds before and after the screen was turned
%       on/off from which data will be collected
%   points_per_Hz = the PSD looks nicer when it is smoothed out a bit. We
%       do this by taking all the points between 30Hz and 31Hz (for example)
%       and averageing them together into one point (if points_per_Hz = 1).
%       The is argument is for the number of points you to be plotted for
%       each Hz.

% PLOTS GENERATED
%   1. Double axis plot of PSD before and after screen turns ON
%   2. Log scale plot of fold change in power comparing after the screen
%   has been turned on to before
%   3,4. Same as 1 and 2 but for screen turning off



SF = duration / points_per_Hz;
if SF ~= floor(SF)
    error('NOTE ---- duration/points_per_Hz must be a whole number');
end

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
    
    LFP = CSCdata(c,:);
    
    for q = 1:2
        
        if q == 1
            focus = screenOnTime;
            name = [freqBandName 'PSD_Channel' num2str(c) '_ScreenOn'];
            name2 = ' Screen On ';
        else
            focus = screenOffTime;
            name = [freqBandName 'PSD_Channel' num2str(c) '_ScreenOff'];
            name2 = ' Screen Off ';
        end
        
        %figure out what times to plot based on when screen goes on and off
        focusIndex = floor(focus*sampleRate);
        startIndex = floor((focus-duration)*sampleRate);
        stopIndex = floor((focus+duration)*sampleRate);
        beforeLFP = LFP(startIndex:focusIndex);
        afterLFP = LFP(focusIndex:stopIndex);
        
        
        %compute power spectrum
        beforePSD = periodogram(beforeLFP,rectwin(length(beforeLFP)),length(beforeLFP), sampleRate);
        beforePSD = beforePSD(1:end-1);
        
        afterPSD = periodogram(afterLFP,rectwin(length(afterLFP)),length(afterLFP), sampleRate);
        afterPSD = afterPSD(1:end-1);
        
        
        %set the X axis
        beforeFreqs = (0:length(beforePSD)/2) / duration;
        afterFreqs = (0:length(afterPSD)/2) / duration;
        
        
        %only plot the frequency band of interest
        xlimit = [duration*freqBand(1), duration*freqBand(2)-1];
        beforePSD = beforePSD(xlimit(1):xlimit(2));
        afterPSD = afterPSD(xlimit(1):xlimit(2));
        beforeFreqs = beforeFreqs(xlimit(1):xlimit(2));
        afterFreqs = afterFreqs(xlimit(1):xlimit(2));
        
        
        %smooth out the PSD
        temp_bPSD = reshape(beforePSD,floor(SF),[]);
        smooth_beforePSD = mean(temp_bPSD,1);
        
        temp_aPSD = reshape(afterPSD,floor(SF),[]);
        smooth_afterPSD = mean(temp_aPSD,1);
        
        smooth_beforeFreqs = downsample(beforeFreqs,SF, floor(SF/2));
        smooth_afterFreqs = downsample(afterFreqs,SF, floor(SF/2));
        
        
        %plot the LFP PSDs
        f = figure;
        ax1 = axes('Position', [0.1 0.6 0.8 0.3]);
        xlim(freqBand);
        ax2 = axes('Position', [0.1 0.1 0.8 0.3]);
        xlim(freqBand);
        
        plot(ax1,smooth_beforeFreqs,smooth_beforePSD);
        plot(ax2,smooth_afterFreqs,smooth_afterPSD);
        
        title(ax1,['Before' name2 'Channel', num2str(c)]);
        xlabel(ax1,'Time (Hz)');
        ylabel(ax1,'Amplitude');
        
        title(ax2,['After' name2 'Channel', num2str(c)]);
        xlabel(ax2,'Freq (Hz)');
        ylabel(ax2,'Amplitude');
        
        
        %plot the FoldChange plot
        t = figure;
        ax3 = axes;
        semilogy(ax3,smooth_beforeFreqs,smooth_afterPSD./smooth_beforePSD);
        hold(ax3,'on')
        semilogy(ax3,smooth_beforeFreqs,ones(length(smooth_beforeFreqs),1),'k');

        
        title(ax3,['Fold Change Following' name2 'Channel' num2str(c)]);
        xlabel(ax3,'Freq (Hz)');
        ylabel(ax3,'Fold Change');
        
        saveas(f, strcat(target_folder, slash, name, '.fig'));
        saveas(t, strcat(target_folder, slash, name,'_foldChange.fig'));
    end
    
    
end
