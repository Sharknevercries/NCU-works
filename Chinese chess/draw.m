% set text about buttons
function draw(handles)

global buttons;

for i = 1:9
    for j = 1:10
        h = buttons.(['board' num2str(i) num2str(j)]);
        value = chessName(handles.board(i, j), 'en');
        img = handles.([value 'Image']);
        img = double(img)/255;
        sty = 21 + (i - 1) * 52;
        if j >= 6
            stx = 22 + (10 - j) * 52;
        end
        if j <= 5
            stx = 287 + (5 - j) * 52;
        end
        x = [stx:stx+31];
        y = [sty:sty+31];
        bk = handles.backgroundImage;
        bk = bk(x, y, :);
        bk = double(bk)/255;
        indexWhite = handles.([value 'ImageWhite']);
        for idx = 1 : 3
           rgb = img(:,:,idx);     % extract part of the image
           rgbb = bk(:,:,idx);
           rgb(indexWhite) = rgbb(indexWhite);  % set the white portion of the image to NaN
           img(:,:,idx) = rgb;     % substitute the update values
        end
        %set(pb, 'CData', img)     % Update the CData variable
        set(h, 'CData', img);
    end
end
name = '';
coor = '';
if handles.ipc ~= 0 && handles.ipr ~= 0
    name = chessName(handles.board(handles.ipc, handles.ipr), 'ch');
    coor = ['(' num2str(handles.ipc) ', ' num2str(handles.ipr) ')'];
end
set(buttons.playerSelect, 'String', [name coor]);
if handles.player == 0
    set(buttons.playerMove, 'ForegroundColor', 'black', 'String', '²×');
elseif handles.player == 1
    set(buttons.playerMove, 'ForegroundColor', 'red', 'String', '«Ó');
    set(buttons.playerSelect, 'ForegroundColor', 'red');
else
    set(buttons.playerMove, 'ForegroundColor', 'black', 'String', '±N');
    set(buttons.playerSelect, 'ForegroundColor', 'black');
end

set(buttons.history, 'String', handles.history);