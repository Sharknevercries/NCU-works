function varargout = chineseChess(varargin)
% CHINESECHESS MATLAB code for chineseChess.fig
%      CHINESECHESS, by itself, creates a new CHINESECHESS or raises the existing
%      singleton*.
%
%      H = CHINESECHESS returns the handle to a new CHINESECHESS or the handle to
%      the existing singleton*.
%
%      CHINESECHESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHINESECHESS.M with the given input arguments.
%
%      CHINESECHESS('Property','Value',...) creates a new CHINESECHESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chineseChess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chineseChess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chineseChess

% Last Modified by GUIDE v2.5 05-Jun-2015 01:40:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chineseChess_OpeningFcn, ...
                   'gui_OutputFcn',  @chineseChess_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before chineseChess is made visible.
function chineseChess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chineseChess (see VARARGIN)

% Choose default command line output for chineseChess
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chineseChess wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% show background

handles.backgroundImage = imread('pic/board.png');
axes(handles.background);
image(handles.backgroundImage);
axis off;

% initialize board status
% 0    空格
% 1, -1 兵, 卒
% 2, -2 炮, 包
% 3, -3 車, ?
% 4, -4 傌, 馬
% 5, -5 像, 象
% 6, -6 仕, 士
% 7, -7 帥, 將

global buttons;
clc
handles.string = char('space', 'rking', 'rguard', 'relephant', 'rhorse', ...
                    'rcar', 'rcanon', 'rsoldier', ...
                    'bking', 'bguard', 'belephant', 'bhorse', ...
                    'bcar', 'bcanon', 'bsoldier');
for i = 1 : size(handles.string, 1)
    name = handles.string(i, :);
    name = name(~isspace(name));
    handles.([name 'Image']) = imread(['pic/' name '.png']);
    handles.([name 'ImageWhite']) = getOuterWhite(handles.([name 'Image']));
end
handles.board = zeros(9, 10);
handles.board = ...
            [
                3   0   0   1   0   0   -1  0   0   -3;
                4   0   2   0   0   0   0  -2   0   -4;
                5   0   0   1   0   0   -1  0   0   -5;
                6   0   0   0   0   0   0   0   0   -6;
                7   0   0   1   0   0   -1  0   0   -7;
                6   0   0   0   0   0   0   0   0   -6;
                5   0   0   1   0   0   -1  0   0   -5;
                4   0   2   0   0   0   0  -2  0    -4;
                3   0   0   1   0   0   -1  0   0   -3;];
                
% used for controlling game.
handles.player = 2;
handles.ipr = 0;
handles.ipc = 0;
handles.fpr = 0;
handles.fpc = 0;
handles.r   = 0;
handles.c   = 0;
handles.stackPtr = 1;
handles.history = char();
handles.prevBoard = zeros(9, 10, 100);

% lower half board button
for i = 1:9
    for j = 1:5
        buttons.(['board' num2str(i) num2str(j)]) = ...
            uicontrol('Style', 'pushbutton', ...
                'Units', 'pixels', ...
                'Position', [20 + 52 * (i - 1) 25 + 52 * (j - 1) 32 32], ...
                'Fontsize', 15, ...
                'Callback', {@selectChess});
    end
end
% upper half board button
for i = 1:9
    for j = 6:10
        buttons.(['board' num2str(i) num2str(j)]) = ...
            uicontrol('Style', 'pushbutton', ...
                'Position', [20 + 52 * (i - 1) 290 + 52 * (j - 6) 32 32], ...
                'Fontsize', 15, ...
                'Callback', {@selectChess});
    end
end
buttons.playerMove = uicontrol('Style', 'pushbutton', ...
                    'Position', [565 460 30 30], ...
                    'Fontsize', 15);

buttons.playerSelect = uicontrol('Style', 'pushbutton', ...
                    'Position', [535 360 90 30], ...
                    'Fontsize', 15);

buttons.history = uicontrol('Style', 'listbox', ...
                    'Position', [515 50 130 250], ...
                    'Fontsize', 10);

draw(handles);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = chineseChess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function selectChess(hObject, eventdata)
handles = guidata(hObject);
cur = gcbo;
pos = get(cur, 'Position');
handles.c = floor(pos(1) / 50) + 1;
handles.r = floor(pos(2) / 50) + 1;
handles = playerTurn(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function regret_Callback(hObject, eventdata, handles)
% hObject    handle to regret (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.history
if handles.stackPtr > 1
    handles.board = handles.prevBoard(:,:,handles.stackPtr - 1);
    handles.history = handles.history(1:handles.stackPtr - 2,:);
    handles.player = 3 - handles.player;
    handles.stackPtr = handles.stackPtr - 1;
else
    msgbox('Can not regret!');
end
draw(handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function surrender_Callback(hObject, eventdata, handles)
% hObject    handle to surrender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if handles.player == 1
    msgbox('Black army wins', 'Game Result');
else
    msgbox('Red army wins', 'Game Result');
end
set(handles.regret, 'Enable', 'off');
set(handles.surrender, 'Enable', 'off');
handles.player = 0;
draw(handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();

function [ white ] = getOuterWhite( img )
img = double(img)/255;
index1 = img(:,:,1) == 1;
index2 = img(:,:,2) == 1;
index3 = img(:,:,3) == 1;
white = index1+index2+index3==3;
white = findOuterWhite(white);

function [ res ] = findOuterWhite(array)
outer = array;
[n m] = size(array);
outer = floodFill(1, 1, outer, 0);
outer = floodFill(m, 1, outer, 0);
outer = floodFill(1, n, outer, 0);
outer = floodFill(m, n, outer, 0);
res = xor(outer, array);

function [ array ] = floodFill(x, y, array, value)
import java.util.LinkedList
q = LinkedList();

%flood fill image 
[n m] = size(array);
array(y, x) = value;
q.add([y, x]);
while q.size() > 0
    pt = q.removeLast();
    y = pt(1);
    x = pt(2);
    if (y < n && array(y+1, x) ~= value) 
        array(y+1,x) = value;
        q.add([y+1, x]); 
    end
    if (y > 1 && array(y-1, x) ~= value) 
        array(y-1,x) = value;
        q.add([y-1, x]); 
    end
    if (x < m && array(y, x+1) ~= value) 
        array(y,x+1) = value;
        q.add([y, x+1]); 
    end
    if (x > 1 && array(y, x-1) ~= value) 
        array(y,x-1) = value;
        q.add([y, x-1]); 
    end
end