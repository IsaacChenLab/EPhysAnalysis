function CSC2Dat(CSCs, outputFile)

% where are the CSCs
fprintf('\tSelect folder where CSCs are located...');
CSC_folder = uigetdir('', 'Select CSCs folder');
fprintf('Selected!\n');


frac = 1/512;
output = struct('data',[],'times',13);

for c = CSCs
    fileName = fullfile(CSC_folder, ['CSC' num2str(c) '.ncs']);
    csc = read_neuralynx_ncs(fileName);
    data = reshape(csc.dat,1,[]);
    data = data(1:end-511);
    %length(data)
    %length(tvector)
    output.data(c,:) = data;
    
    if(output.times == 13)
        tvector = interp1(1:length(csc.TimeStamp), double(csc.TimeStamp), 1:frac:length(csc.TimeStamp));
        output.times = tvector;
    end
end

saveFile = fullfile(CSC_folder, [outputFile '.mat']);
save(saveFile,'output');
