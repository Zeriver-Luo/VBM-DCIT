function [A , t ]=Transm_dust_concentration(img,BackGround_img)
%%
%      该函数用于计算粉尘图像透光率，粉尘浓度.
%      输入为img:待测试的粉尘图像;BackGround_img:背景图像,都为m*n*channel的彩色图像.
%      输出为A：全局大气光值，为m*n*channel的彩色图像.
%            t:透光率,大小为m*n.   

% This function is used to calculate the transmittance and concentration of dust image.
%  input:
%      Input the dust image (img) to be tested and background image (BackGround_img), which both are the  color images for m*n*channel.
%  output:
%      A: It is global atmospheric light value. Use A as output which is the color image for m*n*channel .
%      t: It is Image Transmission value. Use t as output which is the image for m*n.
%%
t0=0.9;%设置初始化透光率 ( Set initialization transmittance. )
H=fspecial('average',7);   %7*7的均值滤波模板 ( Mean filtering template for 7*7. )
Input_img=imfilter(img,H,'replicate'); %对粉尘图像进行均值滤波 ( Average filtering of dust images. )
BackGround_img=imfilter(BackGround_img,H,'replicate'); %对背景图像进行均值滤波 ( Average filtering of background Image. )
CI=double(Input_img)-double(BackGround_img); % 背景差分; ( Background difference. )
[m,n,channel]=size(Input_img);%返回图像长宽和通道 ( Returns image width and channel. )
dx=floor(7/2);%窗口半径 ( Window radius. )
Input_img_darktemp=zeros(m,n);%初始化一个矩阵用于存放sub-windows内的最小值 ( Initializes a matrix to hold the minimum values within the sub-windows. )
Input_img_darkchannel=min(Input_img,[],3); %返回Input_img中3维范围中的最小值 ( Returns the minimum value in the 3D range in Input_img. )
CI_darktemp=zeros(m,n);%初始化一个矩阵用于存放sub-windows内的最小值 ( Initializes a matrix to hold the minimum values within the sub-windows. )
CI_darkchannel=min(CI,[],3); %返回差分图像CI中3维范围中的最小值 ( Returns the minimum value in the 3D range in the difference image CI. )
R_darkchannel=CI(:,:,1); %分别取差分图像CI中的三通道 ( Three channels in differential Image CI. )
G_darkchannel=CI(:,:,2); 
B_darkchannel=CI(:,:,3); 
for i=(1:m)
    for j=(1:n)
        i_low=i-dx;i_high=i+dx;
        j_low=j-dx;j_high=j+dx;
        if(i-dx<1)
            i_low=1;
        end
        if(i+dx>m)
            i_high=m;
        end
        if(j-dx<1)
            j_low=1;
        end
        if(j+dx>n)
            j_high=n;
        end
        %求Input_img_darkchannel矩阵中sub-windows内的最小值
        %Finding the minimum value of sub-windows in Input_img_darkchannel Matrices.
        Input_img_darktemp(i,j)= min(min(Input_img_darkchannel(i_low:i_high,j_low:j_high)));
        %求CI_darkchannel矩阵中sub-windows内的最小值
        %Finding the minimum value of sub-windows in Input_img_darkchannel Matrices
        CI_darktemp(i,j)= min(min(CI_darkchannel(i_low:i_high,j_low:j_high)));
        
        if (CI_darktemp(i,j)==0)
            CI_darktemp(i,j)=0.001;%设定为0.001,避免t_c计算时除数为0. ( Set to 0.001 to avoid the divisor of 0 when t _ c is calculated. )
        end
        t_c(i,j)=(1-t0)/(1-Input_img_darktemp(i,j)/CI_darktemp(i,j));%德塔t
        
        R_darktemp(i,j)= -min(min(R_darkchannel(i_low:i_high,j_low:j_high)./t_c(i,j)));
        G_darktemp(i,j)= -min(min(G_darkchannel(i_low:i_high,j_low:j_high)./t_c(i,j)));
        B_darktemp(i,j)= -min(min(B_darkchannel(i_low:i_high,j_low:j_high)./t_c(i,j)));
    end
end
A=zeros(m,n,3);   %全局大气光 ( Global Atmospheric Light.)
A(:,:,1)=uint8(R_darktemp);
A(:,:,2)=uint8(G_darktemp);
A(:,:,3)=uint8(B_darktemp);
t=t0+t_c; %透光率 ( Image Transmission )
end
