function [ name ] = chessName( type )
    switch(type)
        case 0
            name = '';
        case 1
            name = '�L';
        case -1
            name = '��';
        case 2
            name = '��';
        case -2
            name = '�]';
        case 3
            name = '?';
        case -3
            name = '��';
        case 4
            name = '�X';
        case -4
            name = '��';
        case 5
            name = '��';
        case -5
            name = '�H';
        case 6
            name = '�K';
        case -6
            name = '�h';
        case 7
            name = '��';
        case -7
            name = '�N';
        otherwise
            name = 'Bug';
    end
end

