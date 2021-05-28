%% Plotting LSPR position as a function of time

Particle_number = part_num;
date = get(findobj(gcf,'Tag','date'),'String');
Potential = str2double(get(findobj(gcf,'Tag','potential'),'String'));
Power = get(findobj(gcf,'Tag','power'),'String');
Frames = endframe;

%Path
Origin = 'C:\Users\ks77\Documents\MATLAB\Dissolution Project\';

%Create today's folder
if ~exist(Origin + string(date), 'dir')
   mkdir(Origin + string(date)); 
end

%Create each power folder
cd(Origin + string(date));
if ~exist(Origin + string(date) + string(Power), 'dir')
  mkdir(string(Power)); 
end

%Create each potential folder
cd(string(Power));
if ~exist(Origin + string(date) + string(Power) + string(Potential) + 'V', 'dir')
  mkdir(string(Potential) + 'V'); 
end

%% Save each param_stack

cd(string(Potential) + 'V');
save('params_stack_P' + string(Particle_number), 'params_stack')
%% Plotting Peak shift, Intensity and FWHM as a function of time
figure(3)
subplot(1,3,1)
plot(1:Frames,params_stack(:,2) - params_stack(1,2));
title('LSPR position over time at '+ string(Potential)+ 'V ' + Power)
xlabel('time (s)')
ylabel('Peak resonance Shift (nm)')
%ylim([-15,10])

% set(gcf,'PaperPositionMode','auto');
% pic_path1 = strcat(Place2save,'LSPR_' + string(Potential) + 'V_P' + Particle_number + Power + '.png');
% saveas(gcf, pic_path1)

subplot(1,3,2)
% plot(1:120,params_stack(:,1) .* 100 ./max(params_stack(:,1)) - 100);
plot(1:Frames,params_stack(:,1) .* 100 ./ max(params_stack(:,1)) - params_stack(1,1) .* 100 ./ max(params_stack(:,1)));
title('Intensity over time')
xlabel('time (s)')
ylabel('Intensity decrease (%)')

% set(gcf,'PaperPositionMode','auto');
% pic_path2 = strcat(Place2save, 'Intensity_' + string(Potential) + 'V_P' + Particle_number + Power +'.png');
% saveas(gcf, pic_path2)

subplot(1,3,3)
plot(1:Frames,params_stack(:,3)- params_stack(1,3));
title('FWHM over time')
xlabel('time (s)')
ylabel('FWHM change (nm)')

%% Save
% set(gcf,'PaperPositionMode','auto');
% pic_path2 = strcat(Place2save, string(Potential) + 'V_P' + Particle_number + Power +'.png');
% saveas(gcf, pic_path2)