function compose_images(img1, img2)
    img3 = imfuse(img1, img2, 'blend', 'Scaling', 'joint');
    imshow(img3);
end