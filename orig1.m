clear all;

figure(1)
orig_file = xlsread('orig1.xlsx'); 
ox = orig_file(:,1);
oy = orig_file(:,2);
oz = orig_file(:,3);
scatter3(ox,oy,oz);

hold on;
lbr = importrobot('urdf/t12a_14.urdf'); % 14 kg payload version
lbr.DataFormat = 'row';
show(ldr)