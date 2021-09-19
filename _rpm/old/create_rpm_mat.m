function [ rpm ] = create_rpm_mat(rpm_full_path,raw_folder)

[rpm_path,name]=fileparts(rpm_full_path);

mat_file=strcat(rpm_path,'\',name,'.mat');
rpm=struct;
if exist(rpm_full_path,'file')
    if ~exist(mat_file,'file')
        rpm = scientifica_get_rpm(raw_folder);
        rpm = process_rpm(rpm,rpm_full_path);
        save(mat_file,'rpm');
        display(strcat('RPM file created: ', mat_file));
    else
        clear rpm;
        load(mat_file);
        display(strcat('RPM file loaded: ', mat_file));
    end
    
end

close all;

end

