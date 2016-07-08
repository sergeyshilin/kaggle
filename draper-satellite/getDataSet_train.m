function getDataSet_train() 
format longG;
format compact;
warning off;
fileID = fopen('test_29_70_ext2.json','w');

names = [143];
% после проверки раскомментировать строку ниже! P.S. и не учитывать результаты проверки
%names = [144 158 160 165 171 173 175 176 178 190 194 201 203 205 211 217 218 220 223 224 229 239 241 251 252 255 257 264 268 274 277 279 285 297 298 301 303 307 311 327 340 342];
I = length(names);
for i = 1 : I
    if i == 1
        fprintf(fileID, '[{\n');
    else
        fprintf(fileID, '},{\n');
    end; 
    fprintf(fileID, '\t"index":%d,\n', i + 28);
    fprintf(fileID, '\t"name":"set%s_",\n', num2str(names(i)));  
    fprintf(fileID, '\t"format":"jpeg",\n');   
    fprintf(fileID, '\t"data": {\n');  
    for j = 1 : 5
        fprintf(fileID, '\t\t"%d": {\n', j);  
        for k = 1 : 5
            fname1 = ['set' num2str(names(i)) '_' num2str(j) '.jpeg'];
            fname2 = ['set' num2str(names(i)) '_' num2str(k) '.jpeg'];
            if j == k 
                res = [0 0 1 0 0 0];
            else
                res = getSimilarity(fname1, fname2, 1);
            end;
            if k == 5
                fprintf(fileID, '\t\t\t"%d": {"dx":%f, "dy":%f, "scale":%f, "angle":%f, "matched_points":%d, "mse":%f}\n', k, res(1), res(2), res(3), res(4), res(5), res(6)); 
            else
                fprintf(fileID, '\t\t\t"%d": {"dx":%f, "dy":%f, "scale":%f, "angle":%f, "matched_points":%d, "mse":%f},\n', k, res(1), res(2), res(3), res(4), res(5), res(6)); 
            end;            
        end;     
        if j == 5
            fprintf(fileID, '\t\t}\n');
        else
            fprintf(fileID, '\t\t},\n');
        end;
    end;
    fprintf(fileID, '\t}\n'); 
end;
fprintf(fileID, '}]');
fclose(fileID);
end