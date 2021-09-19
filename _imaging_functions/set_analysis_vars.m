function [ in ] = set_analysis_vars(dataset,roi )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


% in struct saves all the input variables
in=struct;

% analysis variables
in.animal=cell2mat(fieldnames(dataset)); 
in.smoother=0; % 0=off, 1=on
in.sigma=1.5;  % for smoother (1.5 default)                                    
in.on_thresh=2;   % threshold times std of bl, (2-3 recommended)
in.off_thresh=.5;  % threshold 
in.frame_window=[22 42]; % two element vector, where to look for onsets
in.freq_active_thresh=.20;

% selections variable
in.roi=roi; 
in.day_choice={};           
in.cell_choice=[];
in.trial_choice=[]; %note, trial choice overrides the vars choics
in.vars={};   %choices: 'bt' 'bb' 'run' 'cr' 'noCr' 'preRun' 'noRun' 'probe' 'paired' 'cs' 'us' 'dac1' 'dac2' 'blank'
in.stim_vec=21:60; % HACK
end

