%% 1.4 B 5/6; 2.8; 4.3; 5.7; 7.1; 8.6; Reference: 10B 5/6
stimuli_b = zeros(7,3);
stimuli_b = [30,134,146;34,133,149;42,132,152;49,131,155;57,130,157;65,129,158;72,128,159];

stimuli_y = zeros(7,3);
stimuli_y = [152,116,51;148,117,48;144,119,45;140,121,43;136,122,42;132,123,42;128,125,42];

stimuli_g = zeros(7,3);
stimuli_g = [75,134,88;67,135,95;61,135,101;57,136,105;53,136,108;50,136,112;47,136,115];

stimuli_bg = zeros(7,3);
stimuli_bg = [44,136,118;41,135,122;37,135,127;33,135,131;29,135,134;28,135,139;27,134,143];

stimuli_yr = zeros(7,3);
stimuli_yr = [168,106,81;167,107,77;165,108,72;163,110,68;161,111,64;158,112,59;155,114,55];

stimuli_yg = zeros(7,3);
stimuli_yg = [123,126,45;118,128,49;112,129,54;105,130,60;97,132,67;90,133,74;83,134,81];

Vari = [stimuli_b(1:6,:)',stimuli_g(1:6,:)',stimuli_y(1:6,:)',stimuli_bg(1:6,:)',stimuli_yg(1:6,:)',stimuli_yr(1:6,:)'];
Reference = zeros(3,36);
Reference = [repmat(stimuli_b(7,:)',1,6),repmat(stimuli_g(7,:)',1,6),repmat(stimuli_y(7,:)',1,6),repmat(stimuli_bg(7,:)',1,6),repmat(stimuli_yg(7,:)',1,6),repmat(stimuli_yr(7,:)',1,6)]
Stimuli = [Vari;Reference];

% stimuli_g = zeros(7,3);
% stimuli_g = [75,134,88;67,135,95;61,135,101;57,136,105;53,136,108;50,136,112;47,136,115];
% for i = 1 : 7
% x = [0 1 1 0] ; y = [0 0 1 1] ;
% figure
% fill(x,y,stimuli_y(i,:)/255)
% end

% stimuli_yr = zeros(7,3);
% stimuli_yr = [168,106,81;167,107,77;165,108,72;163,110,68;161,111,64;158,112,59;155,114,55];

% stimuli_yg = zeros(7,3);
% stimuli_yg = [123,126,45;118,128,49;112,129,54;105,130,60;97,132,67;90,133,74;83,134,81];

% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
imageSizeX = 640;
imageSizeY = 480;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
centerX = 320;
centerY = 240;
radius = 100;
circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
% circlePixels is a 2D "logical" array.
% Now, display it.
image(circlePixels) ;
colormap([0,0,0;30/255,134/255,146/255]);
title('1.4B 5/6');
