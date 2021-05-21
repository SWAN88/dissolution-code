% draw 2D map to identify each particle
figure;
imagesc(pos);

for part_num = 1:numel(part_y_pixel_list)
    hold on;
    text(part_x_pixel_list(part_num),part_y_pixel_list(part_num),num2str(part_num),'color','w')
end