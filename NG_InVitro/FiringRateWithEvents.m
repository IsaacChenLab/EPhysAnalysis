function binVector = FiringRateWithEvents(fileName, spikeTimes, startTime,...
                                          endTime, eventTimes, eventNames, binSize)

% INPUT
%   fileName = the name that the output files will be saved as. Use 'dont
%       save' if you dont want any files to be saved
%   spikeTimes = vector with list of times for all the spikes (in seconds)
%   startTime,endTime = boundaries of time period to be analyzed (in seconds)
%   binSize = length of time for each bin
%   eventTimes = vector of the times at which any events occured
%   eventNames = cell array of strings which are the names of each event
%       (remember that cell array is defined with {} not [])

% OUTPUT
%   binVector = vector of the firing rate in each bin.

% FILES SAVED
%   fileName.mat -- contains binVector variable
%   fileName.fig -- plot of binVector with all of the events marked


numBins = floor((endTime - startTime) / binSize);
binVector = zeros(1, numBins);

%compute the binVector
for currBin = 1:numBins 
    binStart = startTime + binSize*(currBin-1);
    binEnd = binStart + binSize;
    spikesInBin = length( find( spikeTimes>=binStart & spikeTimes<binEnd));
    binVector(currBin) = (spikesInBin / binSize);
end

%make the figure
f = figure('Name', fileName, 'NumberTitle', 'off');
ax1 = axes;
hold on;
xlim(ax1,[startTime endTime]);
xlabel('Time(s)');
ylabel('Firing Rate (spikes/s)');
title(fileName);

%plot the data
plot(ax1,linspace(startTime,endTime,numBins),binVector);

% mark all the events
events = eventTimes;
for c = 1:length(eventTimes)
    events(c) = plot(ax1,[eventTimes(c) eventTimes(c)], ylim);
end
legend(events,eventNames);

%save the files
if ~strcmpi(fileName, 'dont save')
    save([fileName '.mat'], 'binVector');
    saveas(f, [fileName '.fig']);
end

end
