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

% Last Modified by GUIDE v2.5 24-May-2015 13:12:16

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
backgroundImage = imread('background.jpg');
image(backgroundImage);

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
handles.board = zeros(9, 10);
handles.board(1, 1) = 3;
handles.board(2, 1) = 4;
handles.board(3, 1) = 5;
handles.board(4, 1) = 6;
handles.board(5, 1) = 7;
handles.board(6, 1) = 6;
handles.board(7, 1) = 5;
handles.board(8, 1) = 4;
handles.board(9, 1) = 3;
handles.board(1, 4) = 1;
handles.board(3, 4) = 1;
handles.board(5, 4) = 1;
handles.board(7, 4) = 1;
handles.board(9, 4) = 1;
handles.board(2, 3) = 2;
handles.board(8, 3) = 2;
handles.board(1, 10) = -3;
handles.board(2, 10) = -4;
handles.board(3, 10) = -5;
handles.board(4, 10) = -6;
handles.board(5, 10) = -7;
handles.board(6, 10) = -6;
handles.board(7, 10) = -5;
handles.board(8, 10) = -4;
handles.board(9, 10) = -3;
handles.board(1, 7) = -1;
handles.board(3, 7) = -1;
handles.board(5, 7) = -1;
handles.board(7, 7) = -1;
handles.board(9, 7) = -1;
handles.board(2, 8) = -2;
handles.board(8, 8) = -2;

% used for controlling game.
handles.player = 1;
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
                'Position', [35 + 50 * (i - 1) 35 + 50 * (j - 1) 30 30], ...
                'Fontsize', 15, ...
                'Callback', {@selectChess});
    end
end
% upper half board button
for i = 1:9
    for j = 6:10
        buttons.(['board' num2str(i) num2str(j)]) = ...
            uicontrol('Style', 'pushbutton', ...
                'Position', [35 + 50 * (i - 1) 288 + 50 * (j - 6) 30 30], ...
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

%
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