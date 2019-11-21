function out=fit_fun( t , c , fitType , out)
%  常见函数拟合或拟合公式进行粉尘浓度计算.
%  当out不输入时，默认拟合，输入拟合系数时，计算粉尘浓度.
%  t,c分别为粉尘图像透光率与粉尘浓度值,
%             当拟合时为拟合粉尘图像的透光率与粉尘浓度值.
%             计算粉尘浓度时为测试的粉尘图像的透光率与粉尘浓度值,此时c随便输入一占位.
%  fitType为拟合方式.out为拟合系数，拟合时无需输入，测试时需输入相应的拟合系数.


%   Calculation of dust concentration by fitting common function or fitting formula
%   When the out is not input, the default fitting, when the fitting coefficient is input, the dust concentration is calculated.
%   t is the transmittance of dust image.
%   c is the value of dust concentration.
%      When used as a fitting, 
%           t is the transmittance of Fitting image and 
%           c is the dust concentration value of the Fitting image.
%      When calculate the dust concentration, 
%           t is the transmittance of Test image and 
%           c is the dust concentration value of the Test image, then c enter a placeholder casually.
%   fitType is fitting mode and out is fitting coefficient. No input is required for fit, and the corresponding fitting factor is required for test.


    if nargin < 4
        f = fit(t',c',fitType);
        if ( strcmp(fitType,'Fourier1'))%傅里叶
            out=[f.a0,f.a1,f.w,f.b1];
        elseif( strcmp(fitType, 'Gauss1'))%高斯拟合
            out=[f.a1,f.b1,f.c1];
        elseif( strcmp(fitType, 'exp1'))%指数拟合
            out=[f.a,f.b];
        elseif( strcmp(fitType, 'power1'))%幂函数拟合
            out=[f.a,f.b];
        elseif( strcmp(fitType, 'poly2'))%多项式拟合
            out=[f.p1,f.p2,f.p3];
        end
    else
        c=0;
        if ( strcmp(fitType,'Fourier1'))%傅里叶
            out =  out(1)+ out(2)*cos(t*out(3)) + out(4)*sin(t*out(3));
        elseif( strcmp(fitType, 'Gauss1'))%高斯拟合
            out =  out(1)*exp(-((t-out(2))/out(3))^2);
        elseif( strcmp(fitType, 'exp1'))%指数拟合
            out = out(1)*exp(out(2)*t)
        elseif( strcmp(fitType, 'power1'))%幂函数拟合
            out = out(1)*t.^(out(2));
        elseif( strcmp(fitType, 'poly2'))%多项式拟合
            out =out(1)*t.^2 + out(2)*t +out(3);
        end       
    end
end
