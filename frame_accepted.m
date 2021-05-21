    part_num = part_num + 1;
    part_y_pixel_list(part_num) = part_y_pixel;
    part_x_pixel_list(part_num) = part_x_pixel;
    
    subplot(fh1)
    hold on;
    text(part_x_pixel_list(part_num),part_y_pixel_list(part_num),num2str(part_num),'color','w');
    hold off;
    
    coordinates(part_num,:) = [part_x_pixel, part_y_pixel, bg_y_pixel];

