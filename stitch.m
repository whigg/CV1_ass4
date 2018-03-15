function stitch(image1, image2)
%stitch stitches two images together.
% Input parameters:
%   image1, image2      Rgb or grayscale images.

% transform to grayscale if necessary
image1_rgb = image1;
image2_rgb = image2;
if size(image1, 3) == 3
image1 = rgb2gray(image1);
end
if size(image2, 3) == 3
image2 = rgb2gray(image2);
end

[ trans_matrix, inliers_im1, inliers_im2 ] = RANSAC(image1, image2);

t_image = transform(image1, trans_matrix);

[ t_h, t_w, ~ ] = size(t_image);

overlap_y = ceil(max(inliers_im1(1:2:end)) - min(inliers_im1(1:2:end)));
overlap_x = ceil(max(inliers_im1(2:2:end)) - min(inliers_im1(2:2:end)));

est_h = size(t_image, 1) + size(image2, 1) - overlap_y;
est_w = size(t_image, 2) + size(image2, 2) - overlap_x;

stitched = zeros(est_h, est_w);
stitched(1:size(t_image, 1), 1:size(t_image, 2)) = t_image(:, :);
close ALL
imshow(mat2gray(stitched))

E

end