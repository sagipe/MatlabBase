function text = print_exception(ME)
% function print_exception(ME)
% 
% Prints Matlab exceptions to the command window
%
% Sagi Perel, 03/2011

    text = cell(1,length(ME.stack) + 5);
    text{1} = '===========================================================';
    text{2} = ME.message;
    text{3} = ME.identifier;
    for i=1:length(ME.stack)
        text{3+i} = ['[' num2str(i) '] ' ME.stack(i).file ': ' ME.stack(i).name ' line ' num2str(ME.stack(i).line)];
    end
    text{end-1} = ME.cause;
    text{end} = '======================= FAILED ============================';
    
    for i=1:length(text)
        disp(text{i});
    end