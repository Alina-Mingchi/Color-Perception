clear;

%load and combine the data;
load CDexpSubj1.txt;
data1=CDexpSubj1;
data1_1=data1(4:length(data1),2:8);

load CDexpSubj11.txt;
data11=CDexpSubj1;
data1_2=data11(4:length(data11),2:8);

load CDexpSubj111.txt;
data111=CDexpSubj111;
data1_3=data111(4:length(data111),2:8);

load CDexpSubj2.txt;
data2=CDexpSubj2;
data2_1=data2(4:length(data2),2:8);

load CDexpSubj22.txt;
data22=CDexpSubj22;
data2_2=data22(4:length(data22),2:8);

load CDexpSubj222.txt;
data222=CDexpSubj222;
data2_3=data222(4:length(data222),2:8);

%datafirst is the matrix for all 3 sessions from participant 1
%same for datasecond
%columns 2 to 8 are trial number, trial ID, background color, response,
%reference r, left r, right r
%same referenc means same color genre, e.g. blue or bluish green...


%pseudodatafirst=sortrows([data1_1;data1_2;data1_3],1);
%pseudodatafirst=sortrows([data2_1;data2_2;data2_3],1);
pseudodatafirst=sortrows([data1_1;data1_2;data1_3;data2_1;data2_2;data2_3],1);

nonzero = find(pseudodatafirst(:,1) == 1);
nonzero = nonzero(1);

datafirst = sortrows(pseudodatafirst(nonzero:length(pseudodatafirst),2:7),4);
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
    green((i-num_bg),1) = abs(datafirst(i,5)-datafirst(i,6));
    if mod(datafirst(i,1),2) == 0
        green((i-num_bg),2) = 0;
    else
        green((i-num_bg),2) = 1;
    end
    green((i-num_bg),3) = abs(green((i-num_bg),2)-datafirst(i,3));
    
end

num_b = size(find(datafirst(:,4) == 72),1);
blue = zeros(num_b,3);
for i = (num_bg+num_g+1): (num_bg+num_g+num_b)
    blue((i-num_bg-num_g),1) = abs(datafirst(i,5)-datafirst(i,6));
    if mod(datafirst(i,1),2) == 0
        blue((i-num_bg-num_g),2) = 0;
    else
        blue((i-num_bg-num_g),2) = 1;
    end
    blue((i-num_bg-num_g),3) = abs(blue((i-num_bg-num_g),2)-datafirst(i,3));
end

num_yg = size(find(datafirst(:,4) == 83),1);
yellowgreen = zeros(num_yg,3);
for i = (num_bg+num_g+num_b+1): (num_bg+num_g+num_b+num_yg)
    yellowgreen((i-num_bg-num_g-num_b),1) = abs(datafirst(i,5)-datafirst(i,6));
    if mod(datafirst(i,1),2) == 0
        yellowgreen((i-num_bg-num_g-num_b),2) = 0;
    else
        yellowgreen((i-num_bg-num_g-num_b),2) = 1;
    end
    yellowgreen((i-num_bg-num_g-num_b),3) = abs(yellowgreen((i-num_bg-num_g-num_b),2)-datafirst(i,3));
end

num_y = size(find(datafirst(:,4) == 128),1);
yellow = zeros(num_y,3);
for i = (num_bg+num_g+num_b+num_yg+1): (num_bg+num_g+num_b+num_yg+num_y)
    yellow((i-num_bg-num_g-num_b-num_yg),1) = abs(datafirst(i,5)-datafirst(i,6));
    if mod(datafirst(i,1),2) == 0
        yellow((i-num_bg-num_g-num_b-num_yg),2) = 0;
    else
        yellow((i-num_bg-num_g-num_b-num_yg),2) = 1;
    end
    yellow((i-num_bg-num_g-num_b-num_yg),3) = abs(yellow((i-num_bg-num_g-num_b-num_yg),2)-datafirst(i,3));
end

num_yr = size(find(datafirst(:,4) == 155),1);
yellowred = zeros(num_yr,3);
for i = (num_bg+num_g+num_b+num_y+num_yg+1): (num_bg+num_g+num_b+num_y+num_yg+num_yr)
    yellowred((i-num_bg-num_g-num_b-num_y-num_yg),1) = abs(datafirst(i,5)-datafirst(i,6));
    if mod(datafirst(i,1),2) == 0
        yellowred((i-num_bg-num_g-num_b-num_y-num_yg),2) = 0;
    else
        yellowred((i-num_bg-num_g-num_b-num_y-num_yg),2) = 1;
    end
    yellowred((i-num_bg-num_g-num_b-num_y-num_yg),3) = ...
        abs(yellowred((i-num_bg-num_g-num_b-num_y-num_yg),2)-datafirst(i,3));
end
%%
result_bg = zeros(6, 2);
result_bg(:,1) = (1:6)';
[M,I]= sort(bluegreen(:,1));
sorted_bg = bluegreen(I,:);

%num_b1 stands for number of trials with one difference in color threshold
bg1 = size(find(sorted_bg(:,1) == 0),1);
result_bg(1,2) = 1-mean(sorted_bg(1:bg1,3));
bg2 = size(find(sorted_bg(:,1) == 1),1);
result_bg(2,2) = 1-mean(sorted_bg(bg1:(bg1+bg2),3));
bg3 = size(find(sorted_bg(:,1) == 3),1);
result_bg(3,2) = 1-mean(sorted_bg((bg1+bg2):(bg1+bg2+bg3),3));
bg4 = size(find(sorted_bg(:,1) == 5),1);
result_bg(4,2) = 1-mean(sorted_bg((bg1+bg2+bg3):(bg1+bg2+bg3+bg4),3));
bg5 = size(find(sorted_bg(:,1) == 8),1);
result_bg(5,2) = 1-mean(sorted_bg((bg1+bg2+bg3+bg4):(bg1+bg2+bg3+bg4+bg5),3));
bg6 = size(find(sorted_bg(:,1) == 11),1);
result_bg(6,2) = 1-mean(sorted_bg((bg1+bg2+bg3+bg4+bg5):(bg1+bg2+bg3+bg4+bg5+bg6),3));

%%
result_g = zeros(6, 2);
result_g(:,1) = (1:6)';
[M,I]= sort(green(:,1));
sorted_g = green(I,:);

%num_b1 stands for number of trials with one difference in color threshold
g1 = size(find(sorted_g(:,1) == 2),1);
result_g(1,2) = 1-mean(sorted_g(1:g1,3));
g2 = size(find(sorted_g(:,1) == 4),1);
result_g(2,2) = 1-mean(sorted_g(g1:(g1+g2),3));
g3 = size(find(sorted_g(:,1) == 7),1);
result_g(3,2) = 1-mean(sorted_g((g1+g2):(g1+g2+g3),3));
g4 = size(find(sorted_g(:,1) == 9),1);
result_g(4,2) = 1-mean(sorted_g((g1+g2+g3):(g1+g2+g3+g4),3));
g5 = size(find(sorted_g(:,1) == 12),1);
result_g(5,2) = 1-mean(sorted_g((g1+g2+g3+g4):(g1+g2+g3+g4+g5),3));
g6 = size(find(sorted_g(:,1) == 16),1);
result_g(6,2) = 1-mean(sorted_g((g1+g2+g3+g4+g5):(g1+g2+g3+g4+g5+g6),3));

%%
result_b = zeros(6, 2);
result_b(:,1) = (1:6)';
[M,I]= sort(blue(:,1));
sorted_b = blue(I,:);

%num_b1 stands for number of trials with one difference in color threshold
b1 = size(find(sorted_b(:,1) == 5),1);
result_b(1,2) = 1-mean(sorted_b(1:b1,3));
b2 = size(find(sorted_b(:,1) == 10),1);
result_b(2,2) = 1-mean(sorted_b(b1:(b1+b2),3));
b3 = size(find(sorted_b(:,1) == 16),1);
result_b(3,2) = 1-mean(sorted_b((b1+b2):(b1+b2+b3),3));
b4 = size(find(sorted_b(:,1) == 21),1);
result_b(4,2) = 1-mean(sorted_b((b1+b2+b3):(b1+b2+b3+b4),3));
b5 = size(find(sorted_b(:,1) == 27),1);
result_b(5,2) = 1-mean(sorted_b((b1+b2+b3+b4):(b1+b2+b3+b4+b5),3));
b6 = size(find(sorted_b(:,1) == 32),1);
result_b(6,2) = 1-mean(sorted_b((b1+b2+b3+b4+b5):(b1+b2+b3+b4+b5+b6),3));

%%
result_yg = zeros(6, 2);
result_yg(:,1) = (1:6)';
[M,I]= sort(yellowgreen(:,1));
sorted_yg = yellowgreen(I,:);

%num_b1 stands for number of trials with one difference in color threshold
yg1 = size(find(sorted_yg(:,1) == 5),1);
result_yg(1,2) = 1-mean(sorted_yg(1:yg1,3));
yg2 = size(find(sorted_yg(:,1) == 10),1);
result_yg(2,2) = 1-mean(sorted_yg(yg1:(yg1+yg2),3));
yg3 = size(find(sorted_yg(:,1) == 15),1);
result_yg(3,2) = 1-mean(sorted_yg((yg1+yg2):(yg1+yg2+yg3),3));
yg4 = size(find(sorted_yg(:,1) == 20),1);
result_yg(4,2) = 1-mean(sorted_yg((yg1+yg2+yg3):(yg1+yg2+yg3+yg4),3));
yg5 = size(find(sorted_yg(:,1) == 26),1);
result_yg(5,2) = 1-mean(sorted_yg((yg1+yg2+yg3+yg4):(yg1+yg2+yg3+yg4+yg5),3));
yg6 = size(find(sorted_yg(:,1) == 30),1);
result_yg(6,2) = 1-mean(sorted_yg((yg1+yg2+yg3+yg4+yg5):(yg1+yg2+yg3+yg4+yg5+yg6),3));

%%
result_y = zeros(6, 2);
result_y(:,1) = (1:6)';
[M,I]= sort(yellow(:,1));
sorted_y = yellow(I,:);

%num_b1 stands for number of trials with one difference in color threshold
y1 = size(find(sorted_y(:,1) == 3),1);
result_y(1,2) = 1-mean(sorted_y(1:y1,3));
y2 = size(find(sorted_y(:,1) == 6),1);
result_y(2,2) = 1-mean(sorted_y(y1:(y1+y2),3));
y3 = size(find(sorted_y(:,1) == 8),1);
result_y(3,2) = 1-mean(sorted_y((y1+y2):(y1+y2+y3),3));
y4 = size(find(sorted_y(:,1) == 11),1);
result_y(4,2) = 1-mean(sorted_y((y1+y2+y3):(y1+y2+y3+y4),3));
y5 = size(find(sorted_y(:,1) == 14),1);
result_y(5,2) = 1-mean(sorted_y((y1+y2+y3+y4):(y1+y2+y3+y4+y5),3));
y6 = size(find(sorted_y(:,1) == 17),1);
result_y(6,2) = 1-mean(sorted_y((y1+y2+y3+y4+y5):(y1+y2+y3+y4+y5+y6),3));

%%
result_yr = zeros(6, 2);
result_yr(:,1) = (1:6)';
[M,I]= sort(yellowred(:,1));
sorted_yr = yellowred(I,:);

%num_b1 stands for number of trials with one difference in color threshold
yr1 = size(find(sorted_yr(:,1) == 2),1);
result_yr(1,2) = 1-mean(sorted_yr(1:yr1,3));
yr2 = size(find(sorted_yr(:,1) == 5),1);
result_yr(2,2) = 1-mean(sorted_yr(yr1:(yr1+yr2),3));
yr3 = size(find(sorted_yr(:,1) == 6),1);
result_yr(3,2) = 1-mean(sorted_yr((yr1+yr2):(yr1+yr2+yr3),3));
yr4 = size(find(sorted_yr(:,1) == 8),1);
result_yr(4,2) = 1-mean(sorted_yr((yr1+yr2+yr3):(yr1+yr2+yr3+yr4),3));
yr5 = size(find(sorted_yr(:,1) == 9),1);
result_yr(5,2) = 1-mean(sorted_yr((yr1+yr2+yr3+yr4):(yr1+yr2+yr3+yr4+yr5),3));
yr6 = size(find(sorted_yr(:,1) == 11),1);
result_yr(6,2) = 1-mean(sorted_yr((yr1+yr2+yr3+yr4+yr5):(yr1+yr2+yr3+yr4+yr5+yr6),3));


figure
p = plot(result_bg(:,1),result_bg(:,2),'b--o',result_g(:,1),result_g(:,2),'g',...
    result_b(:,1),result_b(:,2),'b',result_yg(:,1),result_yg(:,2),'g--o',...
    result_y(:,1),result_y(:,2),'k',result_yr(:,1),result_yr(:,2),'r--o');
p(1).LineWidth = 3;
p(2).LineWidth = 3;
p(3).LineWidth = 3;
p(4).LineWidth = 3;
p(5).LineWidth = 3;
p(6).LineWidth = 3;
grid on;
xlabel('Difference in threshold');
ylabel('Correctness');
title('Merged');
legend('bluegreen','green','blue','yellowgreen','yellow','yellowred');
%%
%create same and different
result_s = (result_b + result_g + result_y)/3;
result_d = (result_bg + result_yg + result_yr)/3;
figure
pp = plot(result_s(:,1),result_s(:,2),'m',result_d(:,1),result_d(:,2),'c');
pp(1).LineWidth = 3;
pp(2).LineWidth = 3;
grid on;
xlabel('Difference in threshold');
ylabel('Correctness');
title('Merged');
legend('Pure color','Transition');
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
