clc
clear all
close all
tic
%% ѵ������Ԥ��������ȡ����һ��

% �������������ź�
load HW1503data X y
[row, col] = size(X);
classNum = 10;
trainNum = 4000;
testNum = 1000;

% �����������,��1άΪ����ʶ����24άΪ���������ź�
input = ones(row, col+1);
input(:,2:end) = X;

outputClass = y;
output = zeros(1, classNum * row);
output(classNum .* (0:row-1)' + outputClass) = 1;
output = (reshape(output, [classNum, row]))';

% �����ȡ4000������Ϊѵ��������1000������ΪԤ������
nPerm = randperm(row); % ��1��5000���������
input_train = input(nPerm(1 : trainNum), :)';
output_train = output(nPerm(1 : trainNum), :)';
input_test = input(nPerm(trainNum+1 : row), :)';
output_test = output(nPerm(trainNum+1 : row), :)';

% �������ݹ�һ��
[inputn,inputps] = mapminmax(input_train);

%% ����ṹ��ʼ��
inNum = col+1;
midNum = 25;
outNum = classNum;
 
% Ȩֵ��ʼ��
epsilonInit = sqrt(6) / sqrt(inNum + outNum);
W10 = rands(midNum, inNum) * epsilonInit;
W21 = rands(outNum, midNum) * epsilonInit;

% ѧϰ��
eta = 0.01;

%% ����ѵ��
iterMax = 200;
eIter = zeros(iterMax, 1);
for iter = 1:iterMax
    for n = 1:trainNum
        % ȡһ������
        oneIn = inputn(:, n);
        oneOut = output_train(:, n);
        
        % ���ز����             
        hOut = 1 ./ (1 + exp(- W10 * oneIn));

        % ��������
        yOut = W21 * hOut;
        
        % �������
        eOut = oneOut - yOut;     
        eIter(iter) = eIter(iter) + sum(abs(eOut));
        
        % �������������� delta2
        delta2 = eOut;
        
        % �������ز������ delta1
        FI = hOut .* (1 - hOut);
        delta1 = (FI .* (W21' * eOut));
        
        % ����Ȩ��
        W21 = W21 + eta * delta2 * hOut';
        W10 = W10 + eta * delta1 * oneIn';
    end
end
 

%% ����
inputn_test = mapminmax('apply', input_test, inputps);

% ���ز���� 
hOut = 1 ./ (1 + exp(- W10 * inputn_test));

% ��������
fore = W21 * hOut;

%% �������
% ������������ҳ�������������
[output_fore, ~] = find(bsxfun(@eq, fore, max(fore)) ~= 0);

%BP����Ԥ�����
error = output_fore' - outputClass(nPerm(trainNum+1 : row))';

%% ������ȷ��
% �ҳ�ÿ���жϴ���Ĳ���������
kError = zeros(1, classNum);  
outPutError = bsxfun(@and, output_test, error);
[indexError, ~] = find(outPutError ~= 0);

for class = 1:classNum
    kError(class) = sum(indexError == class);
end

% �ҳ�ÿ����ܲ���������
kReal = zeros(1, classNum);
[indexRight, ~] = find(output_test ~= 0);
for class = 1:classNum
    kReal(class) = sum(indexRight == class);
end

% ��ȷ��
rightridio = (kReal-kError) ./ kReal
meanRightRidio = mean(rightridio)
%}

%% ��ͼ

% �������ͼ
figure
stem(error, '.')
title('BP����������', 'fontsize',12)
xlabel('�ź�', 'fontsize',12)
ylabel('�������', 'fontsize',12)

% ��Ŀ�꺯��
figure
plot(eIter)
title('ÿ�ε����ܵ����', 'fontsize', 12)
xlabel('��������', 'fontsize', 12)
ylabel('������������', 'fontsize', 12)

