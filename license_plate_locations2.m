function filtered_stats = license_plate_locations2(img)
    img_gray = rgb2gray(img);
    img_gray = imresize(img_gray , [480, 640]);
    
    img_gray = histeq(img_gray);
        
    % İşlem resmi ir_img
    ir_img = medfilt2(img_gray, [5,5]); % 5x5
    ir_img = medfilt2(ir_img, [3,3]); % 5x5

    %medyan = median(ir_img(:));
    %low = 0.67 * medyan / 255;
    %high = 1.33 * medyan / 255;

    % edge detection
    kenarlik = edge(ir_img, 'canny');

    % dilation
    img_dilate = imdilate(kenarlik, strel('rectangle', [1,4]));
    
    % Filling the gaps in the edges
    kenarlik = imfill(img_dilate, 'holes');


    % Using morphological closing to enhance the edges
    se = strel('disk', 2);
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

        region_median = median(img_gray(ceil(y):floor(h+y), ceil(x):floor(w+x)), 'all'); % Bölge medyanını hesapla
        %&& region_median > 30 && region_median < 85
        if (h > min_height && w > min_width && h < 240 && w < 320 && w/h > 2 && w/h < 4.5 )
            filtered_stats = [filtered_stats; bbox];
        end
    end

end
