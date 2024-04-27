function img_with_rectangles = plot_license_plate(img, coords)
    img_with_rectangles = img;

    for i = 1:size(coords, 1)
        x = coords(i, 1);
        y = coords(i, 2);
        w = coords(i, 3);
        h = coords(i, 4);
        
        img_with_rectangles = insertShape(img_with_rectangles, 'Rectangle', [x y w h], 'LineWidth', 2, 'Color', 'red');
    end
end