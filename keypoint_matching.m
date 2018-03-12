function [ keypoint_matchings ] = keypoint_matching(image1, image2)
% git clone git://github.com/vlfeat/vlfeat.git
run('vlfeat-0.9.21-bin/vlfeat-0.9.21/toolbox/vl_setup')

%KEYPOINT_MATCHING Find the keypoint matchings between two images.
% Input arguments:
%   image1, image2     Rgb or grayscale images.
% Dependencies:
%   VLFeat (see http://www.vlfeat.org/install-matlab.html)

close ALL % close all figures

% set default images to 'boat'
if nargin == 0
    image1 = imread('boat1.pgm');
    image2 = imread('boat2.pgm');
end

% transform to grayscale if necessary
[ ~, ~, c1 ] = size(image1);
if c1 == 3
image1 = rgb2gray(image1);
end
[ ~, ~, c2 ] = size(image2);
if c2 == 3
image2 = rgb2gray(image2);
end

% show original image1
figure, imshow(image1)

% transform to single
image1 = single(image1);
image2 = single(image2);

% compute the SIFT frames (keypoints) and descriptors
% see http://www.vlfeat.org/overview/sift.html
[f1, d1] = vl_sift(image1);
[f2, d2] = vl_sift(image2);

%%%%%%%
% show 50 randomly selected features and their descriptors on top of image1
perm = randperm(size(f1, 2));
sel = perm(1:50);
h1 = vl_plotframe(f1(:,sel));
h2 = vl_plotframe(f1(:,sel));
set(h1, 'color', 'k', 'linewidth', 3);
set(h2, 'color', 'y', 'linewidth', 2);

h3 = vl_plotsiftdescriptor(d1(:,sel), f1(:,sel));
set(h3, 'color', 'g');
% code hierboven puur voor visualisatie, kan later weg
%%%%%%%

% find matching features
[keypoint_matchings, ~] = vl_ubcmatch(d1, d2);

end

