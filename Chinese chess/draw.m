% set text about buttons
% 0    �Ů�
% 1, -1 �L, ��
% 2, -2 ��, �]
% 3, -3 ��, ?
% 4, -4 �X, ��
% 5, -5 ��, �H
% 6, -6 �K, �h
% 7, -7 ��, �N
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
    set(buttons.playerMove, 'ForegroundColor', 'black', 'String', '��');
elseif handles.player == 1
    set(buttons.playerMove, 'ForegroundColor', 'red', 'String', '��');
    set(buttons.playerSelect, 'ForegroundColor', 'red');
else
    set(buttons.playerMove, 'ForegroundColor', 'black', 'String', '�N');
    set(buttons.playerSelect, 'ForegroundColor', 'black');
end

set(buttons.history, 'String', handles.history);