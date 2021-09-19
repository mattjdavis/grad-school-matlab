function [result] = import_eb_data(file,type)

format_spec_cr = '%f%f%[^\n\r]';
%format_spec_latency2max = 'f%[^\n\r]'
%format_spec_latency2crit ='f%[^\n\r]';
%format_spec_maxAmp ='f%[^\n\r]';
format_spec ='%f';

switch type
    case 'CR'
        
        file_id = fopen(file,'r');
        startRow = 2;
        data_array = textscan(file_id, format_spec_cr, 'Delimiter', '/t', 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
        fclose(file_id);

        cr = data_array{:, 1};
        gb = data_array{:, 2};

        yes_cr = logical(cr);                
        no_cr = ~cr;                                         
        bad_blink = ~gb;   

        result=[yes_cr,no_cr,bad_blink];
        result=double(result);
        
    case 'WaterFall'
        result = import_waterfall_text( file );

        
   otherwise
        file_id = fopen(file,'r');
        startRow = 2;
        %result = textscan(file_id, format_spec, 'Delimiter', '\r', 'HeaderLines',startRow-1, 'ReturnOnError', false,'TreatAsEmpty','','EmptyValue',0);
        result = textscan(file_id, format_spec, 'Delimiter', '\r', 'HeaderLines',startRow-1, 'ReturnOnError', false,'EmptyValue',0);
       
        result= cell2mat(result);
         %if result(end)== 0; result=[result;0]; end; % fix last zero issues
        fclose(file_id);
end
    
end

