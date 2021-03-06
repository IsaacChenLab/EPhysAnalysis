% Nadir Bilici
% nadir.bilici@uphs.upenn.edu
% Last edited: July 5, 2016

% for thisCSC = 1:32;
%     
%     % Name of CSC file, for example 'CSC1.ncs'
%     thisCSCFile = strcat('CSC', num2str(thisCSC), '.ncs');
%     
%     % Loads CSC Timestamp, Frequency, and Sample information
%     if exist (thisCSCFile) == 2
%         % CSC information, for example 
%         % CSC1_Timestamp, CSC1_SampleFrequency, CSC1_Samples
%         thisCSC_Timestamp = strcat('CSC', num2str(thisCSC), '_Timestamp');
%         thisCSC_SampleFrequency = strcat('CSC', num2str(thisCSC), '_SampleFrequency');   
%         thisCSC_Samples = strcat('CSC', num2str(thisCSC), '_Samples');
% 
%         [sprintf(thisCSC_Timestamp), thisCSC_SampleFrequency, thisCSC_Samples] = importCSC_v3(thisCSCFile);
%         disp (strcat('CSC',num2str(thisCSC), ' information loaded'));
%     else
%     end
%         
% % end


% Adapted from LoadCSCs_v3:

% load CSCs
    
[CSC1_Timestamp,CSC1_SampleFrequency,CSC1_Samples] = importCSC_v3('CSC1.ncs');

test = importCSC_v3('CSC1.ncs');

disp 'CSC1 loaded'

[CSC2_Timestamp,CSC2_SampleFrequency,CSC2_Samples] = importCSC_v3('CSC2.ncs');

disp 'CSC2 loaded'
       
[CSC3_Timestamp,CSC3_SampleFrequency,CSC3_Samples] = importCSC_v3('CSC3.ncs');

disp 'CSC3 loaded'
        
[CSC4_Timestamp,CSC4_SampleFrequency,CSC4_Samples] = importCSC_v3('CSC4.ncs');

disp 'CSC4 loaded'
        
[CSC5_Timestamp,CSC5_SampleFrequency,CSC5_Samples] = importCSC_v3('CSC5.ncs');

disp 'CSC5 loaded'

[CSC6_Timestamp,CSC6_SampleFrequency,CSC6_Samples] = importCSC_v3('CSC6.ncs');

disp 'CSC6 loaded'
[CSC7_Timestamp,CSC7_SampleFrequency,CSC7_Samples] = importCSC_v3('CSC7.ncs');

disp 'CSC7 loaded'

[CSC8_Timestamp,CSC8_SampleFrequency,CSC8_Samples] = importCSC_v3('CSC8.ncs');

disp 'CSC8 loaded'

[CSC9_Timestamp,CSC9_SampleFrequency,CSC9_Samples] = importCSC_v3('CSC9.ncs');

disp 'CSC9 loaded'

[CSC10_Timestamp,CSC10_SampleFrequency,CSC10_Samples] = importCSC_v3('CSC10.ncs');

disp 'CSC10 loaded'

[CSC11_Timestamp,CSC11_SampleFrequency,CSC11_Samples] = importCSC_v3('CSC11.ncs');

disp 'CSC11 loaded'

[CSC12_Timestamp,CSC12_SampleFrequency,CSC12_Samples] = importCSC_v3('CSC12.ncs');

disp 'CSC12 loaded'
    
[CSC13_Timestamp,CSC13_SampleFrequency,CSC13_Samples] = importCSC_v3('CSC13.ncs');

disp 'CSC13 loaded'
    
[CSC14_Timestamp,CSC14_SampleFrequency,CSC14_Samples] = importCSC_v3('CSC14.ncs');

disp 'CSC14 loaded'
    
[CSC15_Timestamp,CSC15_SampleFrequency,CSC15_Samples] = importCSC_v3('CSC15.ncs');

disp 'CSC15 loaded'
    
[CSC16_Timestamp,CSC16_SampleFrequency,CSC16_Samples] = importCSC_v3('CSC16.ncs');

disp 'CSC16 loaded'
    
[CSC17_Timestamp,CSC17_SampleFrequency,CSC17_Samples] = importCSC_v3('CSC17.ncs');

disp 'CSC17 loaded'
    
[CSC18_Timestamp,CSC18_SampleFrequency,CSC18_Samples] = importCSC_v3('CSC18.ncs');

disp 'CSC18 loaded'
    
[CSC19_Timestamp,CSC19_SampleFrequency,CSC19_Samples] = importCSC_v3('CSC19.ncs');

disp 'CSC19 loaded'
    
[CSC20_Timestamp,CSC20_SampleFrequency,CSC20_Samples] = importCSC_v3('CSC20.ncs');

disp 'CSC20 loaded'

[CSC21_Timestamp,CSC21_SampleFrequency,CSC21_Samples] = importCSC_v3('CSC21.ncs');

disp 'CSC21 loaded'

[CSC22_Timestamp,CSC22_SampleFrequency,CSC22_Samples] = importCSC_v3('CSC22.ncs');

disp 'CSC22 loaded'

[CSC23_Timestamp,CSC23_SampleFrequency,CSC23_Samples] = importCSC_v3('CSC23.ncs');

disp 'CSC23 loaded'

[CSC24_Timestamp,CSC24_SampleFrequency,CSC24_Samples] = importCSC_v3('CSC24.ncs');

disp 'CSC24 loaded'

[CSC25_Timestamp,CSC25_SampleFrequency,CSC25_Samples] = importCSC_v3('CSC25.ncs');

disp 'CSC25 loaded'

[CSC26_Timestamp,CSC26_SampleFrequency,CSC26_Samples] = importCSC_v3('CSC26.ncs');

disp 'CSC26 loaded'

[CSC27_Timestamp,CSC27_SampleFrequency,CSC27_Samples] = importCSC_v3('CSC27.ncs');

disp 'CSC27 loaded'

[CSC28_Timestamp,CSC28_SampleFrequency,CSC28_Samples] = importCSC_v3('CSC28.ncs');

disp 'CSC28 loaded'

[CSC29_Timestamp,CSC29_SampleFrequency,CSC29_Samples] = importCSC_v3('CSC29.ncs');

disp 'CSC29 loaded'

[CSC30_Timestamp,CSC30_SampleFrequency,CSC30_Samples] = importCSC_v3('CSC30.ncs');

disp 'CSC30 loaded'

[CSC31_Timestamp,CSC31_SampleFrequency,CSC31_Samples] = importCSC_v3('CSC31.ncs');

disp 'CSC31 loaded'

[CSC32_Timestamp,CSC32_SampleFrequency,CSC32_Samples] = importCSC_v3('CSC32.ncs');
    
disp 'CSC32 loaded'