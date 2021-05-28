%% Plotting LSPR position as a function of time %%

%Parameters
Total_particle = part_num;

filename = 'C:\Users\ks77\Documents\MATLAB\Dissolution Project\' + string(date) + '\' + string(Power) + '\' + string(Potential) + 'V';

all_params = cell(1, Total_particle);
for i = 1:Total_particle
all_params{1, i} = load(filename + '\params_stack_P' + string(i));
end

Legend = cell(Total_particle,1);
for i = 1:Total_particle
Legend{i,1} = 'Particle ' + string(i);
end

figure(4)
for i = 1:Total_particle
plot(1:Frames,all_params{1,i}.params_stack(:,2) - all_params{1,i}.params_stack(1,2));
hold on
end
hold off

title('LSPR position over time at '+ string(Potential)+ 'V ' + Power)
xlabel('Time (s)')
ylabel('Peak Resonance Shift (nm)')
legend(Legend)

set(gcf,'PaperPositionMode','auto');
pic_path1 = strcat(filename, '/LSPR.png');
saveas(gcf, pic_path1)

figure(5)
for i = 1:Total_particle
plot(1:Frames,all_params{1,i}.params_stack(:,1) .* 100 ./ max(all_params{1,i}.params_stack(:,1)) - all_params{1,i}.params_stack(1,1) .* 100 ./ max(all_params{1,i}.params_stack(:,1)) );
hold on
end
hold off

title('Intensity over time at '+ string(Potential)+ 'V ' + Power)
xlabel('time (s)')
ylabel('Intensity decrease (%)')
legend(Legend)

set(gcf,'PaperPositionMode','auto');
pic_path1 = strcat(filename, '/Intensity.png');
saveas(gcf, pic_path1)

figure(6)
for i = 1:Total_particle
plot(1:Frames, all_params{1,i}.params_stack(:,3)  - all_params{1,i}.params_stack(1,3));
hold on
end
hold off

title('FWHM over time at '+ string(Potential)+ 'V ' + Power)
xlabel('time (s)')
ylabel('FWHM change (nm)')
legend(Legend)

set(gcf,'PaperPositionMode','auto');
pic_path1 = strcat(filename, '/FWHM.png');
saveas(gcf, pic_path1)
