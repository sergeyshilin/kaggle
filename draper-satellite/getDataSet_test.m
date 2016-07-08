function getDataSet_test() 
format longG;
format compact;
warning off;
fileID = fopen('test_1_274_ext.json','w');

names = [1 2 3 6 7 8 9 11 13 14 15 17 18 19 22 23 24 26 27 28 30 32 33 34 36 37 38 39 40 41 42 45 46 47 48 49 51 52 54 55 56 60 61 62 63 64 65 66 67 68 70 71 72 73 74 75 76 77 80 81 82 83 84 85 86 87 88 89 90 91 92 93 95 96 98 99 100 101 102 103 104 105 106 108 109 110 111 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 132 133 134 135 136 138 139 140 141 142 145 146 147 148 149 150 151 152 153 154 155 156 157 159 161 162 163 164 166 167 168 169 170 172 174 177 179 180 181 182 183 184 185 186 187 188 189 191 192 193 195 196 197 198 199 200 202 204 206 207 208 209 210 212 213 214 215 216 219 221 222 225 226 227 228 230 231 232 233 234 235 236 237 238 240 242 243 244 245 246 247 248 249 250 253 254 256 258 259 260 261 262 263 265 266 267 269 270 271 272 273 275 276 278 280 281 282 283 284 286 287 288 289 290 291 292 293 294 295 296 299 300 302 304 305 306 308 309 310 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 328 329 330 331 332 333 334 335 336 337 338 339 341 343 344];
I = length(names);
for i = 1 : I
    if i == 1
        fprintf(fileID, '[{\n');
    else
        fprintf(fileID, '},{\n');
    end; 
    fprintf(fileID, '\t"index":%d,\n', i);
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