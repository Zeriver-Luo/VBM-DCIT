function [A , t ]=Transm_dust_concentration(img,BackGround_img)
%%
%      �ú������ڼ���۳�ͼ��͸���ʣ��۳�Ũ��.
%      ����Ϊimg:�����Եķ۳�ͼ��;BackGround_img:����ͼ��,��Ϊm*n*channel�Ĳ�ɫͼ��.
%      ���ΪA��ȫ�ִ�����ֵ��Ϊm*n*channel�Ĳ�ɫͼ��.
%            t:͸����,��СΪm*n.   

% This function is used to calculate the transmittance and concentration of dust image.
%  input:
%      Input the dust image (img) to be tested and background image (BackGround_img), which both are the  color images for m*n*channel.
%  output:
%      A: It is global atmospheric light value. Use A as output which is the color image for m*n*channel .
%      t: It is Image Transmission value. Use t as output which is the image for m*n.
%%
t0=0.9;%���ó�ʼ��͸���� ( Set initialization transmittance. )
H=fspecial('average',7);   %7*7�ľ�ֵ�˲�ģ�� ( Mean filtering template for 7*7. )
Input_img=imfilter(img,H,'replicate'); %�Է۳�ͼ����о�ֵ�˲� ( Average filtering of dust images. )
BackGround_img=imfilter(BackGround_img,H,'replicate'); %�Ա���ͼ����о�ֵ�˲� ( Average filtering of background Image. )
CI=double(Input_img)-double(BackGround_img); % �������; ( Background difference. )
[m,n,channel]=size(Input_img);%����ͼ�񳤿��ͨ�� ( Returns image width and channel. )
dx=floor(7/2);%���ڰ뾶 ( Window radius. )
Input_img_darktemp=zeros(m,n);%��ʼ��һ���������ڴ��sub-windows�ڵ���Сֵ ( Initializes a matrix to hold the minimum values within the sub-windows. )
Input_img_darkchannel=min(Input_img,[],3); %����Input_img��3ά��Χ�е���Сֵ ( Returns the minimum value in the 3D range in Input_img. )
CI_darktemp=zeros(m,n);%��ʼ��һ���������ڴ��sub-windows�ڵ���Сֵ ( Initializes a matrix to hold the minimum values within the sub-windows. )
CI_darkchannel=min(CI,[],3); %���ز��ͼ��CI��3ά��Χ�е���Сֵ ( Returns the minimum value in the 3D range in the difference image CI. )
R_darkchannel=CI(:,:,1); %�ֱ�ȡ���ͼ��CI�е���ͨ�� ( Three channels in differential Image CI. )
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
        %��Input_img_darkchannel������sub-windows�ڵ���Сֵ
        %Finding the minimum value of sub-windows in Input_img_darkchannel Matrices.
        Input_img_darktemp(i,j)= min(min(Input_img_darkchannel(i_low:i_high,j_low:j_high)));
        %��CI_darkchannel������sub-windows�ڵ���Сֵ
        %Finding the minimum value of sub-windows in Input_img_darkchannel Matrices
        CI_darktemp(i,j)= min(min(CI_darkchannel(i_low:i_high,j_low:j_high)));
        
        if (CI_darktemp(i,j)==0)
            CI_darktemp(i,j)=0.001;%�趨Ϊ0.001,����t_c����ʱ����Ϊ0. ( Set to 0.001 to avoid the divisor of 0 when t _ c is calculated. )
        end
        t_c(i,j)=(1-t0)/(1-Input_img_darktemp(i,j)/CI_darktemp(i,j));%����t
        
        R_darktemp(i,j)= -min(min(R_darkchannel(i_low:i_high,j_low:j_high)./t_c(i,j)));
        G_darktemp(i,j)= -min(min(G_darkchannel(i_low:i_high,j_low:j_high)./t_c(i,j)));
        B_darktemp(i,j)= -min(min(B_darkchannel(i_low:i_high,j_low:j_high)./t_c(i,j)));
    end
end
A=zeros(m,n,3);   %ȫ�ִ����� ( Global Atmospheric Light.)
A(:,:,1)=uint8(R_darktemp);
A(:,:,2)=uint8(G_darktemp);
A(:,:,3)=uint8(B_darktemp);
t=t0+t_c; %͸���� ( Image Transmission )
end
