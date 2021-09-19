function [ s ] = new_day_struct(s, AnimalName, DayName )
    s.(AnimalName).(DayName)=struct;
    s.(AnimalName).(DayName)=setfield(s.(AnimalName).(DayName),'rpm',{});
    s.(AnimalName).(DayName)=setfield(s.(AnimalName).(DayName),'trial_type',{});
    s.(AnimalName).(DayName).eb=struct;
    
    s.(AnimalName).(DayName).trial_type=trial_type_struct();
    


  
end

%s.(AnimalName).(DayName).TrialTypeIndex