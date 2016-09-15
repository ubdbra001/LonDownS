function filenameOut = func_appendFilename(nameIn, text2Add)

temp = strsplit(nameIn, '.');
temp{1} = [temp{1},text2Add];
filenameOut = strjoin(temp, '.');
