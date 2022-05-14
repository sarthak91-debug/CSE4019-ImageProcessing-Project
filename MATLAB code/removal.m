function [test_im,test_im1] = removal(seg, segnum, between, label, near, url)
    
disp 'Shadow Removal'
im = imread(url);

l_label = label;

c_im = double(rgb2hsv(im));
c1_im = c_im(:,:,1);
c2_im = c_im(:,:,2);
c3_im = c_im(:,:,3);
lab = calHsvHist(c_im, seg, segnum);
    
for i = 1:size(label,2)
    if label(i) == 0
        j = near(i);
        num = 0;
        while label(j) ~= 255
            [~, j] = min(between(i,:));
            between(i,j) = 100;
            num = num + 1;
                
        end
        near(i) = j;
    end
end
   
for i = 1:size(label, 2)
    if label(i) == 0 && label(near(i)) == 255
        j = near(i);
        temp3 = reshape(lab(j,101:150),[50,1]);
        c3_im(seg==i) = hist_match(c3_im(seg==i),temp3);
        temp2 = reshape(lab(j,51:100),[50,1]);
        c2_im(seg==i) = hist_match(c2_im(seg==i),temp2);
        temp1 = reshape(lab(j,1:50),[50,1]);
        c1_im(seg==i) = hist_match(c1_im(seg==i),temp1);
        
    end
end
c_im(:,:,1) = c1_im;
c_im(:,:,2) = c2_im;
c_im(:,:,3) = c3_im;
    
%% Smoothening of Shadow Boundary.
test_im = hsv2rgb(c_im);
test_im1 = hsv2rgb(c_im);       %display purpose
circle = zeros(size(c_im, 1), size(c_im, 2));
for i = 8 : size(c_im, 1)-8
    for j = 8 : size(c_im, 2)-8
        if label(seg(i,j)) ~= label(seg(i-1,j)) || ...
            label(seg(i,j)) ~= label(seg(i+1,j)) || ...
            label(seg(i,j)) ~= label(seg(i,j-1)) || ...
            label(seg(i,j)) ~= label(seg(i,j+1))
            circle(i-1:i+1,j-1:j+1) = 1;            
        end
    end
end
h = fspecial('gaussian', 15, 15);
pattern = imfilter(test_im, h);

label = l_label;

%% Intersection of blur image and test image
for i = 1:segnum
    if label(i) == 0
        for ch = 1:3
            fig = test_im(:,:,ch);
            for x = 20:size(fig, 1) - 20
                for y = 20:size(fig,2) - 20        
                    if seg(x,y) == i && seg(x-4, y) ~= i && circle(x,y) == 1
                        %if abs(test_im(x,y,3) - avg(i,3)) > 0.05
                        fig(x,y) = pattern(x,y,ch);
                        fig(x-4,y) = pattern(x,y,ch);
                        %end
                        %
                    elseif seg(x,y) == i && seg(x+4, y) ~= i && circle(x,y) == 1
                        %if abs(test_im(x,y,3) - avg(i,3)) > 0.05
                        fig(x,y) = pattern(x,y,ch);
                        fig(x+4,y) = pattern(x,y,ch);
                        %end
                        %
                    elseif seg(x,y) == i && seg(x, y+4) ~= i && circle(x,y) == 1
                        %if abs(test_im(x,y,3) - avg(i,3)) > 0.05
                        fig(x,y) = pattern(x,y,ch);
                        fig(x,y+4) = pattern(x,y,ch);
                        %end
                        %
                    elseif seg(x,y) == i && seg(x, y-4) ~= i && circle(x,y) == 1
                        %if abs(test_im(x,y,3) - avg(i,3)) > 0.05
                        fig(x,y) = pattern(x,y,ch);
                        fig(x,y-4) = pattern(x,y,ch);
                        %end
                        %
                    end
                end
            end
            test_im(:,:,ch) = fig;
        end
    end
end
end