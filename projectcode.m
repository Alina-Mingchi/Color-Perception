clear;

%load and combine the data;
load CDexpSubj1.txt;
data1=CDexpSubj1;
data1_1=data1(4:length(data1),3:8);

load CDexpSubj11.txt;
data11=CDexpSubj1;
data1_2=data11(4:length(data11),3:8);

load CDexpSubj111.txt;
data111=CDexpSubj111;
data1_3=data111(4:length(data111),3:8);

load CDexpSubj2.txt;
data2=CDexpSubj2;
data2_1=data2(4:length(data2),3:8);

load CDexpSubj22.txt;
data22=CDexpSubj22;
data2_2=data22(4:length(data22),3:8);

load CDexpSubj222.txt;
data222=CDexpSubj222;
data2_3=data222(4:length(data222),3:8);

%datafirst is the matrix for all 3 sessions from participant 1
%same for datasecond
%colume 1 is the response: 1 stands for pressing left, 0 for right
%column 2 is the reference red rgb value
%column 3 is the left red rgb value
%column 4 is the right red rgb value
%same referenc means same color genre, e.g. blue or bluish green...
%datafirst=sortrows([data1_1;data1_2;data1_3],4);
datafirst=sortrows([data2_1;data2_2;data2_3],4);

%%
%Create another matrix such that the first colom is the difference in left
%and right circle, the second column is the correct answer 0 or 1, 1 stands
%for left is the same color as the reference circle
%the third colum is the correctness of the participant, 0 correct, 1 not
num_bg = size(find(datafirst(:,4) == 27),1);
bluegreen = zeros(num_bg,3);
for i = 1:num_bg
    bluegreen(i,1) = abs(datafirst(i,5)-datafirst(i,6));
    if mod(datafirst(i,1),2) == 0
        bluegreen(i,2) = 0;
    else
        bluegreen(i,2) = 1;
    end
    bluegreen(i,3) = abs(bluegreen(i,2)-datafirst(i,3));
end

num_g = size(find(datafirst(:,4) == 47),1);
green = zeros(num_g,3);
for i = (num_bg+1): (num_bg+num_g)
    green(i,1) = abs(datafirst(i,5)-datafirst(i,6));
    if (datafirst(i,4)-datafirst(i,5)) == 0
        green(i,2) = 1;
    else
        green(i,2) = 0;
    end
    green(i,3) = abs(green(i,2)-datafirst(i,3));
    
end

num_b = size(find(datafirst(:,4) == 72),1);
blue = zeros(num_b,3);
for i = (num_bg+num_g+1): (num_bg+num_g+num_b)
    blue(i,1) = abs(datafirst(i,5)-datafirst(i,6));
    if (datafirst(i,4)-datafirst(i,5)) == 0
        blue(i,2) = 1;
    else
        blue(i,2) = 0;
    end
    blue(i,3) = abs(blue(i,2)-datafirst(i,3));
end

num_yg = size(find(datafirst(:,4) == 83),1);
yellowgreen = zeros(num_yg,3);
for i = (num_bg+num_g+num_b+1): (num_bg+num_g+num_b+num_yg)
    yellowgreen(i,1) = abs(datafirst(i,5)-datafirst(i,6));
    if (datafirst(i,4)-datafirst(i,5)) == 0
        yellowgreen(i,2) = 1;
    else
        yellowgreen(i,2) = 0;
    end
    yellowgreen(i,3) = abs(yellowgreen(i,2)-datafirst(i,3));
end

num_y = size(find(datafirst(:,4) == 128),1);
yellow = zeros(num_y,3);
for i = (num_bg+num_g+num_b+num_yg+1): (num_bg+num_g+num_b+num_yg+num_y)
    yellow(i,1) = abs(datafirst(i,5)-datafirst(i,6));
    if (datafirst(i,4)-datafirst(i,5)) == 0
        yellow(i,2) = 1;
    else
        yellow(i,2) = 0;
    end
    yellow(i,3) = abs(yellow(i,2)-datafirst(i,3));
end

num_yr = size(find(datafirst(:,4) == 155),1);
yellowred = zeros(num_yr,3);
for i = (num_bg+num_g+num_b+num_y+num_yg+1): (num_bg+num_g+num_b+num_y+num_yg+num_yr)
    yellowred(i,1) = abs(datafirst(i,5)-datafirst(i,6));
    if (datafirst(i,4)-datafirst(i,5)) == 0
        yellowred(i,2) = 1;
    else
        yellowred(i,2) = 0;
    end
    yellowred(i,3) = abs(yellowred(i,2)-datafirst(i,3));
end

result_bg = zeros(6, 2);
result_bg(:,1) = (1:6)';
sorted_bg = sort(bluegreen,1);
for j = 1:6
    result_bg(j,2) =1-mean(sorted_bg((1+(j-1)*30):30*j,3));
        %horizontal axis difference in munsell color system: 1,2,3,4,5,6
end
result_g = zeros(6, 2);
result_g(:,1) = (1:6)';
sorted_g = sort(green,1);
for j = 1:6
    result_g(j,2) =1-mean(sorted_g((1+(j-1)*30):30*j,3));
        %horizontal axis difference in munsell color system: 1,2,3,4,5,6
end
result_b = zeros(6, 2);
result_b(:,1) = (1:6)';
sorted_b = sort(blue,1);
for j = 1:6
    result_b(j,2) =1-mean(sorted_b((1+(j-1)*30):30*j,3));
        %horizontal axis difference in munsell color system: 1,2,3,4,5,6
end
result_y = zeros(6, 2);
result_y(:,1) = (1:6)';
sorted_y = sort(yellow,1);
for j = 1:6
    result_y(j,2) =1-mean(sorted_y((1+(j-1)*30):30*j,3));
        %horizontal axis difference in munsell color system: 1,2,3,4,5,6
end
result_yg = zeros(6, 2);
result_yg(:,1) = (1:6)';
sorted_yg = sort(yellowgreen,1);
for j = 1:6
    result_yg(j,2) =1-mean(sorted_yg((1+(j-1)*30):30*j,3));
        %horizontal axis difference in munsell color system: 1,2,3,4,5,6
end
result_yr = zeros(6, 2);
result_yr(:,1) = (1:6)';
sorted_yr = sort(yellowred,1);
for j = 1:6
    result_yr(j,2) =1-mean(sorted_yr((1+(j-1)*30):30*j,3));
        %horizontal axis difference in munsell color system: 1,2,3,4,5,6
end

%%create same and different
result_s = zeros(6,2);
result_d = zeros(6,2);
same = [result_b; result_g; result_y];
different = [result_yr; result_yg; result_bg];
sorted_s = sort(same,1);
for k=1:6
    result_s(k,:) = mean(sorted_s((1+(k-1)*3):k*3));
end
sorted_d = sort(different,1);
for k=1:6
    result_d(k,:) = mean(sorted_d((1+(k-1)*3):k*3));
end
% % %edit_data is the mean of the six participants
% % 
% % result = zeros(20,2);
% % for c = 1:20
% %     result(c,1) = mean(data4_4(12*c-11 : 12*c,1));
% %     result(c,2) = mean(data4_4(12*c-11 : 12*c,2));
% % end
% % %plot(result(:,1),result(:,2))
% % hold on
% % 
% % stderror = zeros(20,1);
% % for d = 1:20
% %     temp1 = data(12*d-11 : 12*d,[2,4,6,8,10,12]);
% %     temp2 = temp1(:);
% %     stderror(d) = std(temp2);
% % end
% % errorbar(result(:,1),result(:,2),stderror)
% indiv1 = data(:,[1,2]);
% ind_r_1 =zeros(20,1);
% for a = 1:20
%     ind_r_1(a,1) = mean(edit_data(12*a-11 : 12*a,1));
%     ind_r_1(a,2) = mean(edit_data(12*a-11 : 12*a,2));
% end
% plot(ind_r_1(:,1),ind_r_1(:,2))


% I do not think we need this
%create frequency table?
% nt=tabulate(data(:,1)); % this is to determine the number of trials per condition. If all is the same, then it is not needed.
% cnt=cumsum(nt(:,2));
% 
% nnt=length(nt);
%  for i=0:nnt-1
%      freq1(i+1) = sum(data(1+cnt(1)*i:cnt(i+1), 2));
%  end
%  relfreq1=freq1./nt(:,2)'; 

% x=1:1:7
% y= [0 0 0 0 0 0.166666667 0.083333333 0.166666667 0 0.25 0.25 0.416666667 0.166666667 0.25 0.25 1 0.916666667 1 0.833333333	0.916666667]
% 
% %repetition 12 times
% 
% 
% N=12; %in the example
% 
% stderr=sqrt(y.*(1-y)./N);
% err=0.05*ones(size(y));
 

%% Logistic
% 
% x = x';
% y = result_s(:,2);
% y = y';
% myfittype = fittype('1./(1+exp(-(x-a)/b))',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'a','b'});
%  [myfit , ~] = fit(x',y',myfittype);
% 
% figure(1)
% plot(myfit,x,y)

% % print (gcf, '-deps2c',  '-r300',  [name of file you want to print])    
% 
% %% Weibull
% x = [0.01	0.11474	0.21947	0.32421	0.42895	0.53368	0.63842	0.74316	0.84789	0.95263	1.0574	1.1621	1.2668	1.3716	1.4763	1.5811	1.6858	1.7905	1.8953	2];
% y = [0.125	0.083333333	0.180555556	0.083333333	0.152777778	0.416666667	0.513888889	0.416666667	0.486111111	0.458333333	0.486111111	0.569444444	0.486111111	0.513888889	0.486111111	0.944444444	0.986111111	0.958333333	0.930555556	0.944444444];
% myfittype = fittype('1-exp(-(x/a)^b)',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'a','b'});
%  [myfit gof] = fit(x',y',myfittype);
% figure(2) 
% plot(myfit,x,y, 'MarkerSize',10)
% 
% %% 
% 
% myfittype = fittype('1/sqrt(2*pi*b^2)*exp(- ((x-a)^2)/2*b^2)',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'a','b'});
%  [myfit gof] = fit(x',y',myfittype);
% 
% figure(3)
% plot(myfit,x,y)
