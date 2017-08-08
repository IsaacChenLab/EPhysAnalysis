function EvokedGamma(outputFolder, channelsToPlot, allChannels, times, screenOnTime, screenOffTime, width)

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


for c = channelsToPlot
    
    LFP = allChannels(c,:);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    screenOnTime = screenOnTime-times(1);
    screenOffTime = screenOffTime-times(1);
    times = times-times(1);
    sampleRate = (length(times)-1)/(times(end) - times(1));
    
    times = times(1:length(LFP));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    name = ['GammaOsc_Channel' num2str(c) '_wholeplot'];
    
    wholePlot = figure;
    ax1 = axes;
    hold(ax1,'on');
    plot(times,LFP);
    line([screenOnTime,screenOnTime], ylim(ax1), 'Color', 'red','LineWidth',2.5);
    line([screenOffTime,screenOffTime], ylim(ax1), 'Color', 'red','LineWidth',2.5);
    
    xticks(times(1):100:times(end));
    
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
        startIndex = floor((focus-width)*sampleRate);
        stopIndex = floor((focus+width)*sampleRate);
        plot( times(startIndex : stopIndex),LFP(startIndex : stopIndex));
        line([focus,focus], ylim(ax2), 'Color', 'red','LineWidth',2.5);
        
        xlim([focus-width focus+width]);
        
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