function filtered_stats = license_plate_locations(img)
    img_gray = rgb2gray(img);
    img_gray = imresize(img_gray , [480, 640]);
    
    img_gray = histeq(img_gray);
        
    % İşlem resmi ir_img
    ir_img = medfilt2(img_gray, [5,5]); % 5x5
    %ir_img = medfilt2(ir_img, [3,3]); % 5x5

    %medyan = median(ir_img(:));
    %low = 0.67 * medyan / 255;
    %high = 1.33 * medyan / 255;

    % edge detection
    kenarlik = edge(ir_img, 'canny');

    % dilation
    img_dilate = imdilate(kenarlik, strel('rectangle', [1,10]));
    img_erode = imerode(img_dilate , strel('rectangle', [1,10]));

    % Filling the gaps in the edges
    img_fill = imfill(img_erode, 'holes');

    img_sum = img_fill + img_erode + img_dilate;
    img_sum = img_sum./3;
    img_thresholding2 = im2bw(img_sum,0.7);

    kenarlik2 = edge(ir_img, 'sobel');
    img_ans = img_thresholding2 - kenarlik2;
    
    se = strel('rectangle',[1 1]);
    img_erode3 = imerode(img_ans,se);
    img_dilate3 = imdilate(img_erode3,se);

    se = strel('rectangle',[2 1]);
    img_erode4 = imerode(img_dilate3,se);

    se = strel('square',5);
    img_dilate4 = imdilate(img_erode4,se);

    se = strel('line',20,0);
    img_dilate5 = imdilate(img_dilate4,se);
    
    kenarlik = img_dilate5;

    % Using morphological closing to enhance the edges
    se = strel('disk', 3);
    kenarlik = imclose(kenarlik, se);
    
    % Finding connected components
    %cc = bwconncomp(kenarlik);
    
    imshowpair(kenarlik, img_gray , 'montage');

    % Dikdörtgenleri algıla (regionprops kullanarak)
    stats = regionprops(kenarlik, 'BoundingBox');
    
    min_height = 24; % Algılanacak dikdörtgenlerin minimum yüksekliği
    min_width = 48; % Algılanacak dikdörtgenlerin minimum genişliği

    filtered_stats = [];

    for i = 1:size(stats, 1)
        bbox = stats(i).BoundingBox;
        x = bbox(1);
        y = bbox(2);
        w = bbox(3);
        h = bbox(4);
        if (h > min_height && w > min_width && h < 240 && w < 320 && w/h > 2 && w/h < 4.5)
            filtered_stats = [filtered_stats; bbox];
        end
    end


end
