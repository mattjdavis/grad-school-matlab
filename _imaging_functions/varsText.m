function [ v ] = varsText( vars )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
v='';
 %bad trials
   if strfind(vars,'bt')
      v= [v ' NoBT ']; 
   end
   
   if strfind(vars,'bb')
       v= [v ' NoBB '] ;
   end
   
   if strfind(vars,'run')
        v= [v ' Run '];
   end
   
   if strfind(vars,'noRun')
       v= [v ' NoRun '];
   end
   
   if strfind(vars,'probe')
       v= [v ' Probe '];
   end

   if strfind(vars,'paired')
     v= [v ' Paired '];
   end
   
   if strfind(vars,'cr')
       v= [v ' Paired '];
   end
   
   if strfind(vars,'noCr')
        v= [v ' NoCr '];
   end
   
   if strfind(vars,'us')
        v= [v ' Puff '];
   end
   
   if strfind(vars,'cs')
        v= [v ' Light '];
   end
   
   if strfind(vars,'dac2')
        v= [v ' Tone '];
   end

end

