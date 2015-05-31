% set text about buttons
% 0    空格
% 1, -1 兵, 卒
% 2, -2 炮, 包
% 3, -3 車, ?
% 4, -4 傌, 馬
% 5, -5 像, 象
% 6, -6 仕, 士
% 7, -7 帥, 將
function draw(handles)
global buttons;
for i = 1:9
    for j = 1:10
        h = buttons.(['board' num2str(i) num2str(j)]);
        name = chessName(handles.board(i, j));
        set(h, 'String', name);
        if handles.board(i,j) < 0
            set(h, 'ForegroundColor', 'black');
        else
            set(h, 'ForegroundColor', 'red');
        end
    end
end
name = '';
coor = '';
if handles.ipc ~= 0 && handles.ipr ~= 0
    name = chessName(handles.board(handles.ipc, handles.ipr));
    coor = ['(' num2str(handles.ipc) ', ' num2str(handles.ipr) ')'];
end
set(buttons.playerSelect, 'String', [name coor]);
if handles.player == 0
    set(buttons.playerMove, 'ForegroundColor', 'black', 'String', '終');
elseif handles.player == 1
    set(buttons.playerMove, 'ForegroundColor', 'red', 'String', '帥');
    set(buttons.playerSelect, 'ForegroundColor', 'red');
else
    set(buttons.playerMove, 'ForegroundColor', 'black', 'String', '將');
    set(buttons.playerSelect, 'ForegroundColor', 'black');
end

set(buttons.history, 'String', handles.history);