function desc = calHsi(rgb_im, seg, numRegion)
    
    hsi = rgb2hsi_refine(rgb_im);
    
    ind={};
    for iReg=1:numRegion
        ind{iReg} = seg(:)==iReg;
    end
    
    desc = zeros([numRegion 3]);
    
    for ch=1:3
        for iReg = 1:numRegion
            feature = hsi(:,:,ch);
            feature = feature(ind{iReg});
            desc(iReg, ch) = sum(feature) / sum(ind{iReg});
        end
    end
    
end
