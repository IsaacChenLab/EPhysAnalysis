%  import TTs

function [Timestamp, CellNumbers, DataPoints] = importTT (FileName)

        FieldSelection(1) = 1;
        FieldSelection(2) = 0; %ScNumbers
        FieldSelection(3) = 1;
        FieldSelection(4) = 0; %Params 
        FieldSelection(5) = 1;

        ExtractHeader = 0;
         
        ExtractMode = 1;
 
[Timestamp, CellNumbers, DataPoints] = Nlx2MatSpike(FileName, FieldSelection, ExtractHeader,ExtractMode);
         
%end
