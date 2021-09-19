
%path='X:\imaging\wheel_rna_1\rpm\md178_d01_wheel_2016_09_08_12_56_22_949.txt';
%t='08-Sep-2016 12:59:00';

%path='X:\imaging\wheel_rna_1\rpm\md179_d01_wheel_2016_09_08_02_58_13_382.txt';
%t='08-Sep-2016 15:01:00';


%path='X:\imaging\wheel_rna_1\rpm\md180_d01_eb_2016_09_08_02_11_31_086.txt';
%t='08-Sep-2016 14:12:00';


path='X:\imaging\wheel_rna_1\rpm\md181_d01_eb_2016_09_08_03_54_43_328.txt';
t='08-Sep-2016 13:52:00';


imgFlag=0;
imgPath='';

r=processRPM(path,imgFlag,imgPath,t,1800);
figure; subplot(211); plot(r{7}); subplot(212); imagesc(r{8}.runMask');


%% Calculate seconds 
runSeconds=sum(r{8,1}.runMask)/10;

%% Plot
X=1;
figure; subplot(211); plot(r{7,X}); subplot(212); imagesc(r{8,X}.runMask');