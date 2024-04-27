function [im_dilated] = detect_license_plate(img)

g_img = rgb2gray(img);

gray_im = imresize(g_img , [480,640]);

%median filter
m_g_im = medfilt2(gray_im , [5,5] );

%edge detection
medyan = median(m_g_im);
low = 0.67 * medyan;
high = 1.33 * medyan;

edges = edge(m_g_im, 'canny', [low,high] );

%dilation
se = strel('rectangle', [3,3]);
im_dilated = imdilate(edges, se);

%contour
[B,~] = bwboundaries(im_dilated, 'noholes');

% Sort contours according to areas
stats = regionprops(image, 'Area');
areas = [stats.Area];
[~, idx] = sort(areas, 'descend');
sorted_contours = B(idx);

h=480;
w=600;

[num_contours, ~] = size(cnt);
    for i = 1:num_contours
        c = cnt{i};
        rect = minBoundingBox(c);
        [x, y, w, h, ~] = minBoundingBox(rect);
        
        if ((w > h && w > h * 2) || (h > w && h > w * 2))
            box = int64(c);
            minx = min(box(:, 1));
            miny = min(box(:, 2));
            maxx = max(box(:, 1));
            maxy = max(box(:, 2));

            muh_plaka = img_gray(miny:maxy, minx:maxx);
            muh_medyan = median(muh_plaka, 'all');
            
            kon1 = muh_medyan > 84 && muh_medyan < 200;
            kon2 = h < 50 && w < 150;
            kon3 = w < 50 && h < 150;

            disp(['muh_plaka medyan:', num2str(muh_medyan), ' genislik: ', num2str(w), ' yukseklik:', num2str(h)]);

            if (kon1 && (kon2 || kon3))
                plaka = [minx, miny, w, h];
                return;
            end
        end
    end
    plaka = [];

end