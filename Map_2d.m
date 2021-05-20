% draw 2D map to identify each particle
figure;imagesc(pos);

for(count = 1:numel(ak11))
    hold on;
    text(xcc_rec(count),ak11(count),num2str(count),'color','w')
end