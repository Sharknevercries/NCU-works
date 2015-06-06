function [h] = playerTurn(h)
    if (h.player == 1 && h.board(h.c, h.r) > 0) || ...
       (h.player == 2 && h.board(h.c, h.r) < 0)
        h.ipr = h.r;
        h.ipc = h.c;
    elseif h.ipr ~= 0 && h.ipc ~= 0
        h.fpr = h.r;
        h.fpc = h.c;
        [res, h] = checkMove(h);
        if res == 1
            h = newHistory(h);
            h.board(h.fpc, h.fpr) = h.board(h.ipc, h.ipr);
            h.board(h.ipc, h.ipr) = 0;
            h.player = 3 - h.player;
            h.ipr = 0;
            h.ipc = 0;
            h.fpr = 0;
            h.fpc = 0;
            loser = checkLose(h);
            if loser ~= 0
                if loser == 2
                    msgbox('Red army wins', 'Game Result');
                elseif loser == 1
                    msgbox('Black army wins', 'Game Result');
                else
                    msbox('BUG! no two kings!');
                end
                set(h.regret, 'Enable', 'off');
                set(h.surrender, 'Enable', 'off');
                h.player = 0;
            end        
        else
            msgbox('Invalid move', 'Error', 'error');
            h.ipr=0;
            h.ipc=0;
            h.fpr=0;
            h.fpc=0;
        end
    end  
    draw(h);
end

function [ handles ] = newHistory(handles)
    handles.prevBoard(:,:,handles.stackPtr) = handles.board;
    name1 = chessName(handles.board(handles.ipc, handles.ipr), 'ch');
    coor1 = ['(' num2str(handles.ipc) ', ' num2str(handles.ipr) ')'];
    name2 = chessName(handles.board(handles.fpc, handles.fpr), 'ch');
    coor2 = ['(' num2str(handles.fpc) ', ' num2str(handles.fpr) ')'];
    if handles.stackPtr == 1
        handles.history = char([name1 coor1 '-->' name2 coor2]);
    else
        handles.history = char(handles.history, [name1 coor1 '-->' name2 coor2]);
    end
    handles.stackPtr = handles.stackPtr + 1;
end

