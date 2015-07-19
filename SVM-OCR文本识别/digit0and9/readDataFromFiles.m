function [x1, y1, x2, y2] = readDataFromFiles(filePath)

file = dir(filePath); % ��ȡ filePath �µ������ļ����ļ���
file = {file(1:size(file)).name};
file(ismember(file, {'.','..'})) = []; % ɾ�� '.' �� '..' ��Ŀ¼
x1 = [];
x2 = [];

for i = 1:size(file, 2)
    data = double(textread([filePath, '/', file{i}], '%c') - '0');
    
    if file{i}(1) == '1'
        x1 = cat(2, x1, data(:));
    elseif file{i}(1) == '9'
        x2 = cat(2, x2, data(:));
    end
end

y1 = ones(1, size(x1, 2));
y2 = -ones(1, size(x2, 2));
