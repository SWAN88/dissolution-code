startframe = str2double(get(findobj(gcf,'Tag','sf'),'String')); %get the start frame

if plot_data.Value == 1
    figure
    set(gcf,'position',[100 100 1600 800])
end

% For particle accepted
[~,part_x_pixel] = find(img_z == max(max(img_z(:,100:end))));
part_x_pixel = part_x_pixel(1);

% function defined in stackfit.m 
params = stackfit(rounded_part_y_pixel, bg_y_pixel, spec, img_z, plot_data.Value, startframe);
