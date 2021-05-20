close all;
path(pathdef); %clear all paths

SMSMain=figure('Name','Troika_SPT',...
    'Menubar','none',...
    'Position',[142 142 1400 800],...
    'NumberTitle','off', ...
    'DoubleBuffer','on');   % turn off the flickering

[filename1, filepath1] = uigetfile({'*.tif','*.mptiff'});
[filename2, filepath2] = uigetfile({'*.tif','*.mptiff'});

addpath(filepath1);
addpath(filepath2); 
pos = imread(filename1);
spec = imread(filename2);

W = awt1d(spec);  %W = AWT(I) computes the A Trou Wavelet Transform of image I. Code in awt1d.m.
im5 = sum(W(:,:,7:end),3);
count = 0; % for frame_accepted.m & Map_2d.m

subplot(2,2,1);
fh1 = imagesc(pos); 
subplot(2,2,2); 
imagesc(im5);

% A title for this gui
uicontrol('Style','Text',...               
    'String','Landes&Link Research Group Spectra Fitting Program',...
    'Position',[0 0 600 40],...
    'Tag','IP_Text','FontSize',16);

%Positions
ppzs = [400 600 800 1000 1200];

%Zoom In
uicontrol('Style','PushButton',...           
    'String','Zoom In',...
    'Position',[ppzs(1) 380 140 40],...
    'Callback','zoom on',...
    'Tag','Zoom in','FontSize',12);

%Zoom Off
uicontrol('Style','PushButton',...           
    'String','Zoom Off',...
    'Position',[ppzs(2) 380 140 40],...
    'Callback','zoom off',...
    'Tag','Zoom off','FontSize',12);

%Select a Particle
%call back to select_particle.m
uicontrol('Style','PushButton',...           
    'String','Select a Particle',...
    'Position',[ppzs(3) 380 140 40],...
    'Callback','select_particle',...
    'Tag','Select a Particle','FontSize',12);

%Select BG
%call back to Select_BG.m
uicontrol('Style','PushButton',...           
    'String','Select BG',...
    'Position',[ppzs(4) 380 140 40],...
    'Callback','Select_BG',...
    'Tag','Select_BG','FontSize',12);

%Check Images
%call back to Check_images.m
uicontrol('Style','PushButton',...          
    'String','Check Images',...
    'Position',[ppzs(1) 335 140 40],...
    'Callback','Check_images',...
    'Tag','Check_images','FontSize',12);

%Fitting
%call back to single_frame.m
uicontrol('Style','PushButton',...          
    'String','Fitting',...
    'Position',[ppzs(2) 335 140 40],...
    'Callback','single_frame',...
    'Tag','Fitting','FontSize',12);

%Particle Accepted
%call back to frame_accepted.m
uicontrol('Style','PushButton',...          
    'String','Particle Accepted',...
    'Position',[ppzs(3) 335 140 40],...
    'Callback','frame_accepted',...
    'Tag','Frame Accepted','FontSize',12);

%Make Map
%call back to Map_2d.m
uicontrol('Style','PushButton',...          
    'String','Make Map',...
    'Position',[ppzs(4) 335 140 40],...
    'Callback','Map_2d',...
    'Tag','2D Map','FontSize',12);

%Save Figure
save_figure = uicontrol('Style','checkbox',...          
    'String','Save Figure',...
    'Position',[ppzs(5) 400 140 40],...
    'Tag','aaaa','FontSize',12, ...
    'Value', 0);

%Plot Data
plot_data = uicontrol('Style','checkbox',...          
    'String','Plot Data',...
    'Position',[ppzs(5) 370 140 40],...
    'Tag','aaaa','FontSize',12, ...
    'Value', 1);

%% For multi frames

%Stack Fitting
%call back to multi_frame.m
uicontrol('Style','PushButton',...          
    'String','Stack Fitting',...
    'Position',[ppzs(5) 335 140 40],...
    'Callback','multi_frame',...               
    'Tag','Stack Fitting','FontSize',12);

%Texts
uicontrol('Style','Text',...                
    'String','Part. Num',...
    'Position',[150 415 100 20],...
    'Tag','ff_Label','FontSize',12);

uicontrol('Style','Text',...                
    'String','Start Frame',...
    'Position',[150 375 100 20],...
    'Tag','ff_Label','FontSize',12);

uicontrol('Style','Text',...                
    'String','End Frame',...
    'Position',[150 335 100 20],...
    'Tag','ff_Label','FontSize',12);


%Particle number
uicontrol('Style','Edit',...               
    'String','1',...
    'Position',[280 415 70 20],...
    'Tag','partnum');

%Start Frame input
uicontrol('Style','Edit',...                
    'String','1',...
    'Position',[280 375 70 20],...
    'Tag','sf');

 %End Frame input
uicontrol('Style','Edit',...              
    'String','1',...
    'Position',[280 335 70 20],...
    'Tag','ef');
