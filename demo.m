BackGround_img=imread('.\���ͼƬ\0.17.jpg');%����ͼ�� ( Background image. )
fitType='poly2';%��Ϸ�ʽ ( Type of fitting. )
t_all=[];%��ʼ�����ͼƬ��͸���� ( Initialize the transmittance of Fitting image. )
dust_concentration=[20.07 93 137 267 275 340 418 432 857]; %���ͼƬ��Ũ��ֵ ( Concentration value of Fitting image. )
for fream=1:length(dust_concentration)
%�ַ������Ӻ������õ���Ҫ�����ͼ�����Ƽ�·�� (String concatenation function to get the name and path of the image to be read in. )
s=strcat('.\���ͼƬ\',num2str(dust_concentration(fream)),'.jpg'); 
img=imread(s);
[A , t ]=Transm_dust_concentration(img,BackGround_img);%��͸���� ( Calculate transmission. )
t_all=[t_all mean(mean(t))];
end
varargout=fit_fun( t_all , dust_concentration , fitType);%��Ϻ�������ȡ���ϵ��. ( Fitting function to get fitting coefficient. )
%  ����ͼƬ������Ũ��ֵ ( Calculate concentration value by Test image. )
img=imread('.\����ͼƬ\247.jpg');%��ȡ����ͼƬ ( Read Test image file. )
[A , t ]=Transm_dust_concentration(img,BackGround_img);%��͸���� ( Caculate transmission. )
dust_concentration_test=mean(mean(fit_fun( t, 1 ,fitType, varargout)));%����۳�Ũ��. ( Calculate dust concentration. )
