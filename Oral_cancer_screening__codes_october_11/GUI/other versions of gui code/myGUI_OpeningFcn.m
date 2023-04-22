% --- Executes just before myGUI is made visible.
function myGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myGUI (see VARARGIN)
% Choose default command line output for myGUI
handles.output = hObject;
% if the user supplied 'exit' as an argument, save it in the handles
% structure
if ~isempty(varargin) && ischar(varargin{1}) && strcmp(varargin{1},'exit')
      handles.closeFigure = true;
end
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes myGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = myGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% if the user suppled an 'exit' argument, close the figure by calling
% figure's CloseRequestFcn
if (isfield(handles,'closeFigure') && handles.closeFigure)
      figure1_CloseRequestFcn(hObject, eventdata, handles)
end
% - Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);