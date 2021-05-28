%% Plotting LSPR position as a function of time %%
%clear

%Parameters to be changed
Total_particle = count;
Frames = endframe;
Potential = 0.29;
Power = 'High';
Place2SAVE = 'C:\Users\ks77\Documents\MATLAB\Dissolution Project\210520';
Place2Save = fullfile(Place2SAVE, Power); 
Place2save = fullfile(Place2Save, string(Potential) + 'V'); 

for i = 1:Total_particle
load(fullfile(Place2save, 'params_stack_P' + string(i) + '.mat'))
end
% need to be changed
%cell = {params_stack_P1, params_stack_P2, params_stack_P3, params_stack_P4, params_stack_P5, params_stack_P6};
cell = {params_stack_P1, params_stack_P2, params_stack_P3};

figure(4)
for i = 1:Total_particle
plot(1:Frames,cell{1,i}(:,2) - cell{1,i}(1,2));
hold on
end
hold off

title('LSPR position over time at '+ string(Potential)+ 'V ' + Power)
xlabel('time (s)')
ylabel('Peak resonance Shift (nm)')
%legend('P1','P2','P3','P4','P5','P6')

set(gcf,'PaperPositionMode','auto');
pic_path1 = strcat(Place2save, '/LSPR.png');
saveas(gcf, pic_path1)

figure(5)
for i = 1:Total_particle
plot(1:Frames,cell{1,i}(:,1) .* 100 ./ max(cell{1,i}(:,1)) - cell{1,i}(1,1) .* 100 ./ max(cell{1,i}(:,1)) );
hold on
end
hold off

title('Intensity over time at '+ string(Potential)+ 'V ' + Power)
xlabel('time (s)')
ylabel('Intensity decrease (%)')
%legend('P1','P2','P3','P4')
%legend('P1','P2','P3','P4','P5','P6')

set(gcf,'PaperPositionMode','auto');
pic_path1 = strcat(Place2save, '/Intensity.png');
saveas(gcf, pic_path1)

figure(6)
for i = 1:Total_particle
plot(1:Frames,cell{1,i}(:,3)  - cell{1,i}(1,3));
hold on
end
hold off

title('FWHM over time at '+ string(Potential)+ 'V ' + Power)
xlabel('time (s)')
ylabel('FWHM change (nm)')
%legend('P1','P2','P3','P4')
%legend('P1','P2','P3','P4','P5','P6')
set(gcf,'PaperPositionMode','auto');
pic_path1 = strcat(Place2save, '/FWHM.png');
saveas(gcf, pic_path1)
