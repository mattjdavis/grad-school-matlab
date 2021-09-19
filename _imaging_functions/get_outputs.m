function [ grouped_output ] = get_outputs( in,dataset,tt_choice,day_choice,blank)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here


in.day_choice=day_choice;

switch tt_choice
    case 'BLINK'
        in.vars={'cr' 'bb' 'bt'};
        O1=process_fluor_data(in,dataset);

        in.vars={'no_cr' 'bb' 'bt'};
        O2=process_fluor_data(in,dataset);
        
        grouped_output={O1,O2};
        
        
        
    case 'TRAINED'
        in.vars={'paired' 'bb' 'bt'};
        O1=process_fluor_data(in,dataset);

        in.vars={'probe' 'bb' 'bt'};
        O2=process_fluor_data(in,dataset);
        
        grouped_output={O1,O2};
% 
%         in.vars={'blank' 'bb' 'bt'};
%         output3=process_fluor_data(in,dataset);
% 
%         grouped_output={output1, output2, output3};

    case 'CONTROL'
        in.vars={'cs' 'bb' 'bt'};
        O1=process_fluor_data(in,dataset);

        in.vars={'us' 'bb' 'bt'};
        O2=process_fluor_data(in,dataset);
        
        grouped_output={O1,O2};

        
    case 'RUN'
        
        in.vars={'run' 'bb' 'bt'};
        O1=process_fluor_data(in,dataset);

        in.vars={'no_run' 'bb' 'bt'};
        O2=process_fluor_data(in,dataset);

        grouped_output={O1, O2};
        
    case 'ALL'
        
        in.vars={};
        O1=process_fluor_data(in,dataset);
        grouped_output={O1};
        
end
end

