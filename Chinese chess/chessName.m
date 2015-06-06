function [ name ] = chessName( type, nameType )
    if strcmp(nameType, 'en') == 1
        switch(type)
            case 0
                name = 'space';
            case 1
                name = 'rsoldier';
            case -1
                name = 'bsoldier';
            case 2
                name = 'rcanon';
            case -2
                name = 'bcanon';
            case 3
                name = 'rcar';
            case -3
                name = 'bcar';
            case 4
                name = 'rhorse';
            case -4
                name = 'bhorse';
            case 5
                name = 'relephant';
            case -5
                name = 'belephant';
            case 6
                name = 'rguard';
            case -6
                name = 'bguard';
            case 7
                name = 'rking';
            case -7
                name = 'bking';
            otherwise
                name = 'Bug';
        end
    elseif strcmp(nameType, 'ch') == 1
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
                name = '��';
            case 3
                name = '��';
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
end

