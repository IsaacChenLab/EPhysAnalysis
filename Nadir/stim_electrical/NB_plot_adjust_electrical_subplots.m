% Nadir Bilici
% nadir.bilici@uphs.upenn.edu
% Last edited: July 18, 2016

disp ('Set axes');
subplot(10,10,[1 2 3 4 5 11 12 13 14 15 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45 51 52 53 54 55 61 62 63 64 65 71 72 73 74 75 81 82 83 84 85])    

[xTemp, yTemp] = ginput(2)

yMax = yTemp(1)
yMin = yTemp(2)
yAxisChange = 1;

subplot(10,10,[1 2 3 4 5 11 12 13 14 15 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45 51 52 53 54 55 61 62 63 64 65 71 72 73 74 75 81 82 83 84 85])    
axis([offsetms ms+offsetms yMin*yAxisChange yMax*yAxisChange]);

subplot(10,10,[6 7 8 9 10 16 17 18 19 20 26 27 28 29 30 36 37 38 39 40 46 47 48 49 50 56 57 58 59 60 66 67 68 69 70 76 77 78 79 80 86 87 88 89 90]);
axis([offsetms ms+offsetms yMin*yAxisChange yMax*yAxisChange]);



for forever = 1:1000;
    userAdjustY = input('Adjust offset: 1/2. Adjust y-axis: 3/4. Reset axes: 5. Save: 0. ');

    if userAdjustY == 1
        disp ('Increase offset')
        offsetgraph = offsetgraph + 100
        NB_plot32_stim_rateHistogram_regraph
        axis tight;
    elseif userAdjustY == 2
        disp ('Decrease offset')
        offsetgraph = offsetgraph - 100
        NB_plot32_stim_rateHistogram_regraph
        axis tight;
    elseif userAdjustY == 3
        disp ('Increase axes')
        yAxisChange = yAxisChange*1.1
    elseif userAdjustY == 4
        disp ('Decrease axes')
        yAxisChange = yAxisChange*.9
    elseif userAdjustY == 5
        disp ('Reset axes')
        [xTemp, yTemp] = ginput(2)
        yMax = yTemp(1)
        yMin = yTemp(2)
        yAxisChange = 1;
        axis([offsetms ms+offsetms yMin*yAxisChange yMax*yAxisChange]);    
    elseif userAdjustY == 0
        NB_saveFigures
        break
    end
    
    subplot(10,10,[1 2 3 4 5 11 12 13 14 15 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45 51 52 53 54 55 61 62 63 64 65 71 72 73 74 75 81 82 83 84 85])    
    axis([offsetms ms+offsetms yMin*yAxisChange yMax*yAxisChange]);
    subplot(10,10,[6 7 8 9 10 16 17 18 19 20 26 27 28 29 30 36 37 38 39 40 46 47 48 49 50 56 57 58 59 60 66 67 68 69 70 76 77 78 79 80 86 87 88 89 90]);
    axis([offsetms ms+offsetms yMin*yAxisChange yMax*yAxisChange]);
    
end