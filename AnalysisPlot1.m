%% Plotting LSPR position as a function of time %%

Particle_number = 3;
Potential = 0.27;
Power = 'High';
Frames = 480;
Place2Save = 'C:\Users\ks77\Documents\MATLAB\Dissolution Project\210520';
Place2save = fullfile(Place2Save, Power); 

%% Save param_stack  %%

% need to be chaged P*
params_stack_P3 = params_stack;
% clear('params_stack');

Filename = string(Potential) + 'V';
newfolder = fullfile(Place2save, Filename); 

        %status = mkdir(newfolder); 
   % if status
       % mkdir(fullfile(newfolder, Filename)); 
    %end 
    
    if ~exist((Place2save + Filename), 'dir') %check if dir doesnt exist
        mkdir(fullfile(newfolder, Filename)); %make it if it doesent exist
    end

save(fullfile(newfolder, 'params_stack_P'+ string(Particle_number)),'params_stack_P'+ string(Particle_number))

%% Plotting Peak shift, Intensity and FWHM as a function of time %%
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
