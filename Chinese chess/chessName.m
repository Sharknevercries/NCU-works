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
                name = '兵';
            case -1
                name = '卒';
            case 2
                name = '炮';
            case -2
                name = '炮';
            case 3
                name = '車';
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
end

