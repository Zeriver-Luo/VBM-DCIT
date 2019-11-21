BackGround_img=imread('.\拟合图片\0.17.jpg');%背景图像 ( Background image. )
fitType='poly2';%拟合方式 ( Type of fitting. )
t_all=[];%初始化拟合图片的透光率 ( Initialize the transmittance of Fitting image. )
dust_concentration=[20.07 93 137 267 275 340 418 432 857]; %拟合图片的浓度值 ( Concentration value of Fitting image. )
for fream=1:length(dust_concentration)
%字符串连接函数，得到将要读入的图像名称及路径 (String concatenation function to get the name and path of the image to be read in. )
s=strcat('.\拟合图片\',num2str(dust_concentration(fream)),'.jpg'); 
img=imread(s);
[A , t ]=Transm_dust_concentration(img,BackGround_img);%求透光率 ( Calculate transmission. )
t_all=[t_all mean(mean(t))];
end
varargout=fit_fun( t_all , dust_concentration , fitType);%拟合函数，求取拟合系数. ( Fitting function to get fitting coefficient. )
%  测试图片，计算浓度值 ( Calculate concentration value by Test image. )
img=imread('.\测试图片\247.jpg');%读取测试图片 ( Read Test image file. )
[A , t ]=Transm_dust_concentration(img,BackGround_img);%求透光率 ( Caculate transmission. )
dust_concentration_test=mean(mean(fit_fun( t, 1 ,fitType, varargout)));%计算粉尘浓度. ( Calculate dust concentration. )
