function dim_val=BoxCountfracDim(im, show)
    newdim = 2^max(nextpow2(size(im)));
    im_pad = padarray(im,[newdim-size(im,1) newdim-size(im,2)],0,'post');
    maxpow2 = log2(newdim);
    boxCount_arr = zeros(1,maxpow2+1);
    res_arr = zeros(1,maxpow2+1);
    curboxsize = newdim;
    boxCount_arr(1)=1;
    res_arr(1)=1.0/curboxsize;
    curim = im_pad;
    
    for idx = 1:maxpow2
        sum_val = sum(curim(:));%Go with the finest scale to the coarsest
        boxCount_arr(2+maxpow2-idx)=sum_val;
        res_arr(2+maxpow2-idx)=2^(-(idx-1));
        curim = ((curim(1:2:end,1:2:end)+curim(1:2:end,2:2:end)+curim(2:2:end,1:2:end)+curim(2:2:end,2:2:end))>0);
    end
    
    D = polyfit(log(res_arr(1:9)), log(boxCount_arr(1:9)), 1);
    dim_val = D(1);
    plot(log(res_arr), log(boxCount_arr),'-o');
    titleName = "Box dimension is" + " " + num2str(D(1)) ;
    title(titleName, 'FontSize', 20, 'Interpreter', 'None');
    ylabel("$ln N(\epsilon)$",'Interpreter','latex', 'FontSize', 14)
    xlabel("$ln (\epsilon^{-1})$",'Interpreter','latex', 'FontSize', 14)

end
