function [ name ] = chessName( type )
    switch(type)
        case 0
            name = '';
        case 1
            name = '兵';
        case -1
            name = '卒';
        case 2
            name = '炮';
        case -2
            name = '包';
        case 3
            name = '?';
        case -3
            name = '車';
        case 4
            name = '傌';
        case -4
            name = '馬';
        case 5
            name = '像';
        case -5
            name = '象';
        case 6
            name = '仕';
        case -6
            name = '士';
        case 7
            name = '帥';
        case -7
            name = '將';
        otherwise
            name = 'Bug';
    end
end

