clear all;
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
im2 = imread(filename1);  % pos
im4 = imread(filename2);  % spec

W = awt1d(im4);  %W = AWT(I) computes the A Trou Wavelet Transform of image I. Code in awt1d.m.
im5 = sum(W(:,:,7:end),3);
count = 0;


subplot(2,2,2); imagesc(im5);  %spec
fh1 = subplot(2,2,1);imagesc(im2);  %pos
    
uicontrol('Style','Text',...                % A title for this group
    'String','Landes&Link Research Group Spectra Fitting Program',...
    'Position',[0 0 600 40],...
    'Tag','IP_Text','FontSize',16);


%positions
ppzs = [400 600 800 1000 1200];

%zoom in
uicontrol('Style','PushButton',...          % 
    'String','Zoom in',...
    'Position',[ppzs(1) 380 140 40],...
    'Callback','zoom on',...
    'Tag','Zoom in','FontSize',12);

%zoom off
uicontrol('Style','PushButton',...          % 
    'String','Zoom off',...
    'Position',[ppzs(2) 380 140 40],...
    'Callback','zoom off',...
    'Tag','Zoom off','FontSize',12);

%select particle
uicontrol('Style','PushButton',...          % 
    'String','Select a Particle',...
    'Position',[ppzs(3) 380 140 40],...
    'Callback','select_particle',...
    'Tag','Select a Particle','FontSize',12);

%select bg
uicontrol('Style','PushButton',...          % 
    'String','Select BG',...
    'Position',[ppzs(4) 380 140 40],...
    'Callback','Select_BG',...
    'Tag','Select_BG','FontSize',12);

%check images
uicontrol('Style','PushButton',...          % 
    'String','Check images',...
    'Position',[ppzs(1) 335 140 40],...
    'Callback','Check_images',...
    'Tag','Check_images','FontSize',12);

%fitting
uicontrol('Style','PushButton',...          % 
    'String','Fitting',...
    'Position',[ppzs(2) 335 140 40],...
    'Callback','single_frame',...
    'Tag','Fitting','FontSize',12);

%Accept particle
uicontrol('Style','PushButton',...          % 
    'String','Particle Accepted',...
    'Position',[ppzs(3) 335 140 40],...
    'Callback','frame_accepted',...
    'Tag','Frame Accepted','FontSize',12);

%Make map
uicontrol('Style','PushButton',...          % 
    'String','Make Map',...
    'Position',[ppzs(4) 335 140 40],...
    'Callback','Map_2d',...
    'Tag','2D Map','FontSize',12);

%save figure
save_figure = uicontrol('Style','checkbox',...          % 
    'String','Save Figure',...
    'Position',[ppzs(5) 400 140 40],...
    'Tag','aaaa','FontSize',12, ...
    'Value', 0);


plot_data = uicontrol('Style','checkbox',...          % 
    'String','Plot Data',...
    'Position',[ppzs(5) 370 140 40],...
    'Tag','aaaa','FontSize',12, ...
    'Value', 1);

%%  multi particle tools

%stack fitting
uicontrol('Style','PushButton',...          
    'String','Stack Fitting',...
    'Position',[ppzs(5) 335 140 40],...
    'Callback','multi_frame',...               
    'Tag','Stack Fitting','FontSize',12);

%text
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


%particle inputs
uicontrol('Style','Edit',...                % particle number 
    'String','1',...
    'Position',[280 415 70 20],...
    'Tag','partnum');

uicontrol('Style','Edit',...                % start frame input
    'String','1',...
    'Position',[280 375 70 20],...
    'Tag','sf');

uicontrol('Style','Edit',...                % end frame input
    'String','1',...
    'Position',[280 335 70 20],...
    'Tag','ef');
