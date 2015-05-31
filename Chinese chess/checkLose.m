function [ loser ] = checkLose( h )
    flag1 = 0;
    flag2 = 0;
    for i = 1:9
        for j = 1:10
            if h.board(i, j) == 7
                flag1 = 1;
            end
            if h.board(i, j) == -7
                flag2 = 1;
            end
        end
    end
    if flag1 == 1 && flag2 == 1
        loser = 0;
    elseif flag1 == 0
        loser = 1;
    elseif flag2 == 0;
        loser = 2;
    else
        loser = 3;
    end
end

