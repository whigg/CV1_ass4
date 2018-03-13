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
    P = 1; % For testing set to one
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


% Repeat N times
for n = 1:N
    
    % Pick P matches at random from the total set of matches T
    perm = randperm(size(T, 2)); % shuffle indices randomly
    sel = perm(1:P); % pick the first P indices
    matches = T(:, sel); % take the corresponding pairs of T
    % First row of matches: indices of interest points in image1
    % Second row of matches: indices of interest points in image2

    % Using f1 and f2, get the coordinates of these points.
    % Currently P is set to ONE, so now it is for one point.
    % TODO: fix for multiple points (including solving Ax=b).
    
    x1 = f1(1, matches(1));
    y1 = f1(2, matches(1));
    x2 = f2(1, matches(2));
    y2 = f2(2, matches(2));
    
    % Construct a matrix A and vector b using the P pairs of points
    % and find transformation parameters (m1, m2, m3, m4, t1, t2) 
    % by solving the equation Ax = b.
    A = [ [ x1 y1 0 0 1 0 ]
        [ 0 0 x1 y1 0 1 ] ];
    b = [ x2 
         y2 ];
    x =  pinv(A) * b; % Solve Ax = b     x = [ m1, m2, m3, m4, t1, t2 ]'
    size(x)
    x
    
    
    % TODO
    % Using the transformation parameters, transform the locations of all T points in image1.
    % If the transformation is correct, they should lie close to their counterparts in image2. 
    % Plot the two images side by side with a line connecting the original T points in image1 
    % and transformed T points over image2.
    
    
end



% For visualization, show the transformations from image1 to image2 and from image2 to image1. 


end

