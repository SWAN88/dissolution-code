% get start and end frame
startframe = str2double(get(findobj(gcf,'Tag','sf'),'String')); 
endframe = str2double(get(findobj(gcf,'Tag','ef'),'String')); 
date = get(findobj(gcf,'Tag','date'),'String');
Potential = str2double(get(findobj(gcf,'Tag','potential'),'String'));
Power = get(findobj(gcf,'Tag','power'),'String');

clear params_stack spectra_stack

% for plotting on the independent tab
if plot_data.Value == 1
    figure
    set(gcf,'position',[100 100 1600 800])
end

% For particle accepted
[~,part_x_pixel] = find(img_z == max(max(img_z(:,100:end))));
part_x_pixel = part_x_pixel(1);

params_stack = NaN(endframe, 4);
%spectra_stack = NaN(2048,3,endframe);

%% Path 
Origin = filepath1;

%Create today's folder
if ~exist(Origin + string(date), 'dir')
   mkdir(Origin + string(date))
end

%Create each power folder
cd(Origin + string(date));
if ~exist(Origin + string(date) + string(Power), 'dir')
  mkdir(string(Power))
end

%Create each potential folder
cd(string(Power));
if ~exist(Origin + string(date) + string(Power) + string(Potential) + 'V', 'dir')
  mkdir(string(Potential) + 'V')
end

cd('U:\dissolution-code');
filepath = char(Origin + string(date) + '\' + string(Power) + '\' + string(Potential) + 'V');

%% multi_frame plot
for frame_number = startframe:endframe
    spec = imread(filename2, frame_number);
    
    % function defined in stackfit.m 
    [params, spectra] = stackfit(rounded_part_y_pixel, bg_y_pixel, spec, img_z, plot_data.Value, frame_number);
    params_stack(frame_number, :) = params;
    spectra_stack(:, :, frame_number) = spectra;
    
    % Save Figure
    if save_figure.Value == 1
        if ~exist([filepath '\spectra_p' num2str(part_num)], 'dir') %check if dir doesn't exist
            mkdir([filepath '\spectra_p' num2str(part_num)]) %make it if it doesen't exist
        end

        % save all spectra
        saveas(gcf,[filepath, '\spectra_p' num2str(part_num) '\frame_' num2str(frame_number) '.png'])
        
%         % save only start and end frame spectra
%         if frame_number == startframe || frame_number == endframe
%             saveas(gcf,[filepath1, 'spectra_p' num2str(part_num) '\frame_' num2str(frame_number) '.png'])
%         end
        
    end
end
