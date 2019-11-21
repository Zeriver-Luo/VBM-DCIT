function out=fit_fun( t , c , fitType , out)
%  ����������ϻ���Ϲ�ʽ���з۳�Ũ�ȼ���.
%  ��out������ʱ��Ĭ����ϣ��������ϵ��ʱ������۳�Ũ��.
%  t,c�ֱ�Ϊ�۳�ͼ��͸������۳�Ũ��ֵ,
%             �����ʱΪ��Ϸ۳�ͼ���͸������۳�Ũ��ֵ.
%             ����۳�Ũ��ʱΪ���Եķ۳�ͼ���͸������۳�Ũ��ֵ,��ʱc�������һռλ.
%  fitTypeΪ��Ϸ�ʽ.outΪ���ϵ�������ʱ�������룬����ʱ��������Ӧ�����ϵ��.


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
        if ( strcmp(fitType,'Fourier1'))%����Ҷ
            out=[f.a0,f.a1,f.w,f.b1];
        elseif( strcmp(fitType, 'Gauss1'))%��˹���
            out=[f.a1,f.b1,f.c1];
        elseif( strcmp(fitType, 'exp1'))%ָ�����
            out=[f.a,f.b];
        elseif( strcmp(fitType, 'power1'))%�ݺ������
            out=[f.a,f.b];
        elseif( strcmp(fitType, 'poly2'))%����ʽ���
            out=[f.p1,f.p2,f.p3];
        end
    else
        c=0;
        if ( strcmp(fitType,'Fourier1'))%����Ҷ
            out =  out(1)+ out(2)*cos(t*out(3)) + out(4)*sin(t*out(3));
        elseif( strcmp(fitType, 'Gauss1'))%��˹���
            out =  out(1)*exp(-((t-out(2))/out(3))^2);
        elseif( strcmp(fitType, 'exp1'))%ָ�����
            out = out(1)*exp(out(2)*t)
        elseif( strcmp(fitType, 'power1'))%�ݺ������
            out = out(1)*t.^(out(2));
        elseif( strcmp(fitType, 'poly2'))%����ʽ���
            out =out(1)*t.^2 + out(2)*t +out(3);
        end       
    end
end
