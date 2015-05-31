function [ res, h ] = checkMove( h )
    type = h.board(h.ipc, h.ipr);
    xDelta = h.fpc - h.ipc;
    yDelta = h.fpr - h.ipr;
    % 0    空格
    % 1, -1 兵, 卒
    % 2, -2 炮, 包
    % 3, -3 車, ?
    % 4, -4 傌, 馬
    % 5, -5 像, 象
    % 6, -6 仕, 士
    % 7, -7 帥, 將
    if (type == 1)
        if h.ipr <= 5
            if h.fpc == h.ipc && h.fpr == h.ipr + 1
                res = 1;
            else
                res = 0;
            end
        elseif abs(xDelta) + abs(yDelta) == 1 && yDelta >= 0
            res = 1;
        else
            res = 0;
        end
    elseif (type == -1)
        if h.ipr >= 6
            if h.fpc == h.ipc && h.fpr == h.ipr - 1
                res = 1;
            else
                res = 0;
            end
        elseif abs(xDelta) + abs(yDelta) == 1 && yDelta <= 0
            res = 1;
        else
            res = 0;
        end
    elseif abs(type) == 2
        if (xDelta == 0 || yDelta == 0) && ...
                h.board(h.fpc, h.fpr) * type <= 0
            cnt = 0;
            if h.fpc ~= h.ipc
                L = h.ipc;
                R = h.fpc;
                if L > R
                    tmp = L;    L = R;  R = tmp;
                end
                for i = L : R
                    if h.board(i, h.ipr) ~= 0
                        cnt = cnt + 1;
                    end
                end
            else
                L = h.ipr;
                R = h.fpr;
                if L > R
                    tmp = L;    L = R;  R = tmp;
                end
                for i = L : R
                    if h.board(h.ipc, i) ~= 0
                        cnt = cnt + 1;
                    end
                end
            end
            if cnt == 3 && h.board(h.fpc, h.fpr) * type < 0 || ...
                    cnt == 1 && h.board(h.fpc, h.fpr) == 0
                res = 1;
            else
                res = 0;
            end
        else
            res = 0;
        end
    elseif abs(type) == 3
        if (xDelta == 0 || yDelta == 0) && ...
                h.board(h.fpc, h.fpr) * type <= 0
            cnt = 0;
            if h.fpc ~= h.ipc
                L = h.ipc;
                R = h.fpc;
                if L > R
                    tmp = L;    L = R;  R = tmp;
                end
                for i = L : R
                    if h.board(i, h.ipr) ~= 0
                        cnt = cnt + 1;
                    end
                end
            else
                L = h.ipr;
                R = h.fpr;
                if L > R
                    tmp = L;    L = R;  R = tmp;
                end
                for i = L : R
                    if h.board(h.ipc, i) ~= 0
                        cnt = cnt + 1;
                    end
                end
            end
            if cnt == 2 && h.board(h.fpc, h.fpr) * type < 0 || ...
                    cnt == 1 && h.board(h.fpc, h.fpr) == 0
                res = 1;
            else
                res = 0;
            end
        else
            res = 0;
        end
    elseif abs(type) == 4
        if abs(xDelta) + abs(yDelta) == 3 && ...
                xDelta ~= 0 && yDelta ~= 0 && ...
                h.board(h.fpc, h.fpr) * type <= 0
            if (xDelta == 2 && h.board(h.ipc + 1, h.ipr) == 0) || ...
                    (xDelta == -2 && h.board(h.ipc - 1, h.ipr) == 0) || ...
                    (yDelta == 2 && h.board(h.ipc, h.ipr + 1) == 0) || ...
                    (yDelta == -2 && h.board(h.ipc, h.ipr - 1) == 0)
                res = 1;
            else
                res = 0;
            end
        else
            res = 0;
        end
    elseif type == 5
        if h.fpr <= 5 && abs(xDelta) == 2 && abs(yDelta) == 2
            midX = (h.ipc + h.fpc) / 2;
            midY = (h.ipr + h.fpr) / 2;
            if h.board(midX, midY) == 0
                res = 1;
            else
                res = 0;
            end
        else
            res = 0;
        end
    elseif type == -5
        if h.fpr >= 6 && abs(xDelta) == 2 && abs(yDelta) == 2
            midX = (h.ipc + h.fpc) / 2;
            midY = (h.ipr + h.fpr) / 2;
            if h.board(midX, midY) == 0
                res = 1;
            else
                res = 0;
            end
        else
            res = 0;
        end
    elseif type == 6
        if abs(xDelta) == 1 && abs(yDelta) == 1 && ...
                h.fpc >= 4 && h.fpc <= 6 && ...
                h.fpr >= 1 && h.fpr <= 3
            res = 1;
        else
            res = 0;
        end
    elseif type == -6
        if abs(xDelta) == 1 && abs(yDelta) == 1 && ...
                h.fpc >= 4 && h.fpc <= 6 && ...
                h.fpr >= 8 && h.fpr <= 10
            res = 1;
        else
            res = 0;
        end
    elseif type == 7
        if abs(xDelta) + abs(yDelta) == 1 && ...
                h.fpc >= 4 && h.fpc <= 6 && ...
                h.fpr >= 1 && h.fpr <= 3
            res = 1;
        elseif abs(xDelta) == 0 && h.board(h.fpc, h.fpr) == -7
            cnt = 0;
            for i = h.ipr : h.fpr
                if h.board(h.ipc, i) ~= 0
                    cnt = cnt + 1;
                end
            end
            if cnt == 2
               res = 1;
            else
               res = 0;
            end
        else
            res = 0;
        end
    elseif type == -7
        if abs(xDelta) + abs(yDelta) == 1 && ...
                h.fpc >= 4 && h.fpc <= 6 && ...
                h.fpr >= 8 && h.fpr <= 10
            res = 1;
        elseif abs(xDelta) == 0 && h.board(h.fpc, h.fpr) == 7
            cnt = 0;
            for i = h.fpr : h.ipr
                if h.board(h.ipc, i) ~= 0
                    cnt = cnt + 1;
                end
            end
            if cnt == 2
               res = 1;
            else
               res = 0;
            end
        else
            res = 0;
        end
    end
end

