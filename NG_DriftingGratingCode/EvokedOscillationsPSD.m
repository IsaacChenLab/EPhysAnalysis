function EvokedOscillationsPSD(outputFolder, channelsToPlot, redChannels, CSCdata,...
                               times, screenTime, freqBand, freqBandName,...
                               duration, points_per_Hz, logAxis, loneChannels)

% FUNCTION ARGUMENTS
%   outputFolder = name (in SINGLE quotes) of output folder which will be
%       created, and into which all of the output will be saved. If outputFolder
%        = 'dont save' then no .fig or .mat files will be saved and the script
%       will run much faster. If outputFolder is a complete path, then  '@'
%       should be added to the beginning so that user won't be prompted to
%       choose output directory later
%   channelsToPlot = a vector containing the channels you want to analyze ie 1:32
%   redChannels =  a vector of channels you want to plot as red, ie [] is
%       all blue
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
%   logAxis = optional; set to 'log' if you want to plot the PSD y axis on
%       log scale. Recommended for plot that includes frequency under 20.
%   loneChannels = optional; set to 'no lone channels' if you dont want to
%       plot an of the channels individually, only the one big plot with all
%       the channels together

% PLOTS GENERATED
%   1. Plot of PSD before and after screen turns ON, for each channel and
%       all channels together
%   2. Log scale plot of fold change in power comparing after the screen
%       has been turned on to before, for each channel and all channels
%       together
%   3,4. Same as 1 and 2 but for screen turning off, for each channel and
%       all channels together
 
% FREQUENCY BANDS
%   Gamma = 20-50 Hz
%   Beta = 12-30 Hz
%   Theta = 4-12 Hz
%   Delta = 1-4 Hz
%   Broadband = 1-100 Hz

% COLORS
%   - black is always before the stimulus change and green is after
%   - red and blue are if you want to mark certain channels in the
%       "allChannels" plots

green = [0 0.72 0.24];


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


% Screen On, All channels, figs
all_f1 = figure;
all_on_ax = axes;
title(all_on_ax,'Screen On - All Channels - Before and After');

% Screen Off, All channels, figs
all_f2 = figure;
all_off_ax = axes;
title(all_off_ax,'Screen Off - All Channels - Before and After');

%Screen Off, All channels, foldChange
all_t1 = figure;
all_on_fold_ax = axes;
title(all_on_fold_ax,'Fold Change Following Screen On - All Channels');

%Screen Off, All channels, foldChange
all_t2 = figure;
all_off_fold_ax = axes;
title(all_off_fold_ax,'Fold Change Following Screen Off - All Channels');


allChannelAxes = [all_on_ax, all_off_ax, all_on_fold_ax, all_off_fold_ax];

%format all the AllChannel axes
for i = 1:4
    AX = allChannelAxes(i);
    xlim(AX, freqBand);
    xlabel(AX,'Freq (Hz)');
    if exist('logAxis','var') && strcmpi(logAxis, 'log')
        set(AX, 'Yscale', 'log');
    end
    if i <= 2
        ylabel(AX, 'Amplitude');
    else
        ylabel(AX, 'FoldChange');
        semilogy(AX,freqBand,ones(2,1),'k');
    end
    hold(AX, 'on');
end



for c = channelsToPlot
    
    LFP = CSCdata(c,:);
    
    if sum(c == redChannels) > 0
        color = 'r';
    else
        color = 'b';
    end
    
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
        
        
        % add this channel to this all channels plots
        if q == 1
            plot(all_on_ax,smooth_beforeFreqs,smooth_beforePSD, 'k');  %black
            plot(all_on_ax,smooth_afterFreqs,smooth_afterPSD, 'Color', green);    %green
            semilogy(all_on_fold_ax,smooth_beforeFreqs,smooth_afterPSD./smooth_beforePSD, color);
        else
            plot(all_off_ax,smooth_beforeFreqs,smooth_beforePSD, 'k');
            plot(all_off_ax,smooth_afterFreqs,smooth_afterPSD, 'Color', green);
            semilogy(all_off_fold_ax,smooth_beforeFreqs,smooth_afterPSD./smooth_beforePSD, color);
        end
               
        if ~exist('loneChannels','var') || ~strcmpi(loneChannels, 'no lone channels')
            %plot the LFP PSDs
            f = figure;
            ax1 = axes;
            if exist('logAxis','var') && strcmpi(logAxis, 'log')
                set(ax1, 'Yscale', 'log');  
            end
            hold(ax1,'on')
            xlim(freqBand);
            
            plot(ax1,smooth_beforeFreqs,smooth_beforePSD, 'k');
            plot(ax1,smooth_afterFreqs,smooth_afterPSD, 'Color', green);
            
            title(ax1,['Before and After' name2 'Channel', num2str(c)]);
            xlabel(ax1,'Freq (Hz)');
            ylabel(ax1,'Amplitude');
            
            
            %plot the FoldChange plot
            t = figure;
            ax_fold = axes;
            semilogy(ax_fold,smooth_beforeFreqs,smooth_afterPSD./smooth_beforePSD, color);
            hold(ax_fold,'on')
            semilogy(ax_fold,smooth_beforeFreqs,ones(length(smooth_beforeFreqs),1),'k');
            
            title(ax_fold,['Fold Change Following' name2 'Channel' num2str(c)]);
            xlabel(ax_fold,'Freq (Hz)');
            ylabel(ax_fold,'Fold Change');
            
            %save the figures
            if ~strcmpi(outputFolder,'dont save')
                saveas(f, strcat(target_folder, slash, name, '.fig'));
                saveas(t, strcat(target_folder, slash, name,'_foldChange.fig'));
            end
        end
    end
end


if ~strcmpi(outputFolder,'dont save')
    saveas(all_f1, strcat(target_folder, slash, 'AllChannels_ScreenOn.fig'));
    saveas(all_t1, strcat(target_folder, slash, 'AllChannels_ScreenOn_foldChange.fig'));
    saveas(all_f2, strcat(target_folder, slash, 'AllChannels_ScreenOff.fig'));
    saveas(all_t2, strcat(target_folder, slash, 'AllChannels_ScreenOff_foldChange.fig'));
end


end
