function [ best_transformation ] = RANSAC(image1, image2, N, T, P)
%RANSAC Finds the best transformation between two images.
% Input parameters:
%   image1, image2      Rgb or grayscale images.
%   N                   Amount of iterations (default: 1).
%   T                   Total set of matches.
%   P                   Amount of (random) samples from T.

close ALL % close all figures

% set default parameters
if nargin == 0
    image1 = imread('boat1.pgm');
    image2 = imread('boat2.pgm');
end
if nargin < 3
    N = 1; % For testing set to one
end
if nargin < 4
    [ T, f1, f2 ] = keypoint_matching(image1, image2);
end
if nargin < 5
    P = 10; % For testing set to one
end

% transform to grayscale if necessary
%image1_rgb = image1;
%image2_rgb = image2;
%if size(image1, 3) == 3
%    image1 = rgb2gray(image1);
%end
%if size(image2, 3) == 3
%    image2 = rgb2gray(image2);
%end

matches_im1 = T(1, :);
matches_im2 = T(2, :);
% Repeat N times
for n = 1:N
    
    % Pick P matches at random from the total set of matches T
    perm = randperm(size(T, 2)); % shuffle indices randomly
    sel = perm(1:P); % pick the first P indices
    sel_matches_im1 = T(1, sel); % take the corresponding pairs of T in image 1
    sel_matches_im2 = T(2, sel); % take the corresponding pairs of T in image 2
    
    % First row of matches: indices of interest points in image1
    % Second row of matches: indices of interest points in image2

    % Using f1 and f2, get the coordinates of these points.
    % Currently P is set to ONE, so now it is for one point.
    % TODO: fix for multiple points (including solving Ax=b).
    

     x1 = f1(1, sel_matches_im1);
     y1 = f1(2, sel_matches_im1);
     x2 = f2(1, sel_matches_im2);
     y2 = f2(2, sel_matches_im2);

    
    % Construct a matrix A and vector b using the P pairs of points
    % and find transformation parameters (m1, m2, m3, m4, t1, t2) 
    % by solving the equation Ax = b.
    A = zeros(P*2, 6);
    A(1:2:end, 5)  = 1;
    A(2:2:end, 6)  = 1;
    
    A(1:2:end, 1) = x1;
    A(1:2:end, 2) = y1;
    A(2:2:end, 3) = x1;
    A(2:2:end, 4) = y1;    

    b = zeros(P*2, 1);
    b(1:2:end) = x2;
    b(2:2:end) = y2;    

    x =  pinv(A) * b; % Solve Ax = b     x = [ m1, m2, m3, m4, t1, t2 ]'
    
    %% TODO
    % Using the transformation parameters, transform the locations of all T points in image1.
    % If the transformation is correct, they should lie close to their counterparts in image2. 
    % Plot the two images side by side with a line connecting the original T points in image1 
    % and transformed T points over image2.

    x1 = f1(1, matches_im1);
    y1 = f1(2, matches_im1); 
    
    A = zeros(length(x1)*2, 6);
    A(1:2:end, 5)  = 1;
    A(2:2:end, 6)  = 1;
    
    A(1:2:end, 1) = x1;
    A(1:2:end, 2) = y1;
    A(2:2:end, 3) = x1;
    A(2:2:end, 4) = y1;  
    
    b = A*x;
    
    f1 = [ x1 ; y1 ];
    f2 = [ b(1:2:end), b(2:2:end) ]';
    size(f2)
    
    visualization(image1, image2, f1, f2)
    
end



% For visualization, show the transformations from image1 to image2 and from image2 to image1. 


end

function visualization(image1_rgb, image2_rgb, f1, f2)
figure, imshowpair(image1_rgb, image2_rgb, 'montage') % init figure
title('Matching features in both images')

[ ~, w, ~ ] = size(image1_rgb)

hold on

% Draw lines between each pair of points
for i = 50:60
    x = [f1(1, i) f2(1, i) + w];
    y = [f1(2, i) f2(2, i) ];
    line(x, y, 'Color', 'green', 'LineWidth', 1)
end


end

