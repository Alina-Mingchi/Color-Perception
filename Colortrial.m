

  % ---------------------------------------------------------------------
    % ENTER PARTICIPANT NUMBER AND AGE
    % ---------------------------------------------------------------------
%% Participant Info 
clear
    fail1 = 'Program aborted. Participant number or age not entered'; % error message which is printed to command window
	prompt = {'Participant number:' 'Age' 'Gender (f=1, m=2)' 'SessionID'};
	dlg_title = 'New Participant';
	num_lines = 1;
	def = {'' '' '' '' };      
	answer = inputdlg(prompt,dlg_title,num_lines,def); % Presents box to enter data into
    switch isempty(answer)
        case 1 % deals with both cancel and X presses
            error(fail1)
        case 0
            subID = str2double(answer{1});
            age = str2double(answer{2});
            gender = str2double(answer{3});
            session= str2double(answer{4});
    
    end;

% Make sure the script is running on Psychtoolbox-3:
AssertOpenGL;

%set default values for input arguments
if ~exist('subID','var')
    subID=66;
end

%warn if duplicate sub ID
fileName=['CDexpSubj' num2str(subID) '.txt'];
if exist(fileName,'file')
    if ~IsOctave
        resp=questdlg({['the file ' fileName 'already exists']; 'do you want to overwrite it?'},...
            'duplicate warning','cancel','ok','ok');
    else
        resp=input(['the file ' fileName ' already exists. do you want to overwrite it? [Type ok for overwrite]'], 's');
    end
    
    if ~strcmp(resp,'ok') %abort experiment if overwriting was not confirmed
        disp('experiment aborted')
        return
    end
end

%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prepare conditions;
%the first two elements in each row code for linelength,
%the last two for head orientation
backgroundColor = 0;
circleradius = 100; %pixel
rep = 30; %How often should a trial be presented? (repetitions)
ntrain=3; %number of training trials

keyLeft = 'a'; %key "left is the same"
keyRight = 'l'; %key "right is the same"

%!!!change the color of the circle
condtable=repmat(linspace(5,50,10),1,rep);

condtable2=repmat(linspace(100,120,10),1,rep);

condtable3=repmat(linspace(200,250,10),1,rep);
    
ntrials=size(condtable',1);

    % This is our intro text. The '\n' sequence creates a line-feed:
    myText = ['In this experiment you are asked to compare\n' ...
              'the color of two circles at the bottom of the screen\n' ...
              'with the standard one at the top of the screen\n' ...
              '  Press  ' keyLeft '  if you think the left circle is the same color as the standard one\n' ...
              '  Press  ' keyRight '  if you think the right circle is the same color as the standard one\n' ...
              'You will begin with ' num2str(ntrain) ' training trials\n' ...
              '      (Press any key to start training)\n' ];
          
          
%% Initiating %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%re-order the trials randomly
shuffeldTrialIDs=randperm(ntrials);

%attach a randomly drawn subsample as training trials
order=[ceil(rand(1,ntrain)*ntrials), shuffeldTrialIDs];

%Prepare output
colHeaders = {'subID', 'trial no', 'trial ID', 'ColorDiff', 'Backgroundcolor',... 
    'response', 'rt PTB', 'rt ML', 'age', 'gender', 'session'};
results=NaN * ones(length(order),length(colHeaders)); %preallocate results matrix


%when working with the PTB it is a good idea to enclose the whole body of your program
%in a try ... catch ... end construct. This will often prevent you from getting stuck
%in the PTB full screen mode


%% Start Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    % Enable unified mode of KbName, so KbName accepts identical key names on
    % all operating systems (not absolutely necessary, but good practice):
    KbName('UnifyKeyNames');

    %funnily enough, the very first call to KbCheck takes itself some
    %time - after this it is in the cache and very fast
    %to make absolutely sure, we thus call it here once for no other
    %reason than to get it cached. This btw. is true for all major
    %functions in Matlab, so calling each of them once before entering the
    %trial loop will make sure that the 1st trial goes smooth wrt. timing.
    KbCheck;

    %disable output of keypresses to Matlab. !!!use with care!!!!!!
    %if the program gets stuck you might end up with a dead keyboard
    %if this happens, press CTRL-C to reenable keyboard handling -- it is
    %the only key still recognized.
    ListenChar(2);

    %Set higher DebugLevel, so that you don't get all kinds of messages flashed
    %at you each time you start the experiment:
    olddebuglevel=Screen('Preference', 'VisualDebuglevel', 3);

    %Choosing the display with the highest display number is
    %a best guess about where you want the stimulus displayed.
    %usually there will be only one screen with id = 0, unless you use a
    %multi-display setup:
    screens=Screen('Screens');
    screenNumber=max(screens);

    %open an (the only) onscreen Window, if you give only two input arguments
    %this will make the full screen white (=default)
    [expWin,rect]=Screen('OpenWindow',screenNumber,backgroundColor,[],[],2);

    %alternative: replace the above with smaller window for testing
    %   [expWin,rect]=Screen('OpenWindow',screenNumber,[],[10 20 1200 700]);
    %NOTE that smaller windows can induce synchronisation problems
    %and other issues, so they're not suitable for running real experiment
    %sessions. See >> help SyncTrouble

    %get the midpoint (mx, my) of this window, x and y
    [mx, my] = RectCenter(rect);
    positionOfCircle = [(mx-circleradius) (my-circleradius-246) (mx+circleradius) (my+circleradius-246)];

    positionOfCircle2 = [(mx-circleradius-200) (my-circleradius+100) (mx+circleradius-200) (my+circleradius+100)];

    positionOfCircle3 = [(mx-circleradius+200) (my-circleradius+100) (mx+circleradius+200) (my+circleradius+100)];

    %get rid of the mouse cursor, we don't have anything to click at anyway
    HideCursor;

    %         %Syntax for querying user input, e.g. subject initials:
    %         reply=Ask(expWin,'Enter subject initials: ',[],[],'GetChar',RectLeft,RectTop,20);

    %Preparing and displaying the welcome screen
    % We choose a text size of 24 pixels - Well readable on most screens:
    Screen('TextSize', expWin, 24);
    
   
    % Draw 'myText', centered in the display window:
    DrawFormattedText(expWin, myText, 'center', 'center', [255, 255, 255, 255]);

    % This chunk of code would do roughly the same: It uses the lower-level
    % 'DrawText' subcommand to draw text. DrawFormattedText is a
    % convenience wrapper that provides basic text formatting functions.
    % See 'help DrawFormattedTextDemo' for a demo of its capabilities...
    %
    %     lm=150; %left margin, adjust to suit the size of your screen
    %     Screen('DrawText', expWin, 'In this experiment you are asked to judge', lm, 50);
    %     Screen('DrawText', expWin, 'the relative length of two horizontal lines', lm, 80);
    %     Screen('DrawText', expWin, '  press  s  if the lines have the same length', lm, 110);
    %     Screen('DrawText', expWin, '  press  d  if the lines have different lengths', lm, 140);
    %     Screen('DrawText', expWin, ['you will begin with ' num2str(ntrain) ' training trials'], lm, 170);
    %     Screen('DrawText', expWin, '      (press any key to start training)', lm, 250);

    % Show the drawn text at next display refresh cycle:
    Screen('Flip', expWin);
    
     % Wait for key stroke. This will first make sure all keys are
     % released, then wait for a keypress and release:
    KbWait([], 3);

    %         %an example of preparing an offScreenwindow (for repeated use and fast drawing)
    %         [fixcross,rect2]=Screen('OpenOffscreenWindow',screenNumber,[],[0 0 20 20]);
    %         Screen('drawline',fixcross,[0 0 0],10,0,10,20,2);%mx-10,my,mx+10,my
    %         Screen('drawline',fixcross,[0 0 0],0,10,20,10,2);%mx,my-10,mx,my+10

    % Another way to create a fixation cross: Doing the above with textures,
    % by preparing a little Matlab matrix with the image of a fixation
    % cross:  --> Choose whatever you like more.
    FixCr=ones(20,20)*0;
    FixCr(10:11,:)=255;
    FixCr(:,10:11)=255;  %try imagesc(FixCr) to display the result in Matlab
    fixcross = Screen('MakeTexture',expWin,FixCr);

%% start trials loop (over training and test trials)
    
    for i=1:length(order)

        %prepare and display end of training/start experiment screen
        if i==ntrain+1  %before the first test trial
            DrawFormattedText(expWin, 'Are you ready for the experiment?\n(Press any key to start experiment)', 'center', 'center');
            Screen('Flip', expWin);
            KbWait([], 3);
        end

        % Copy the content of the previously prepared texture or offscreenWindow
        % into the backbuffer of the onscreen window, then flip it to the front
        % NOTE that offscreen windows and textures are almost the same
        % thing. Btw. although we specify the target region, this is not
        % strictly neccessary. A Screen('DrawTexture', expWin, fixcross);
        % would yield exactly the same result, as all textures are centered
        % in the target window by default.
        Screen('DrawTexture', expWin, fixcross,[],[mx-10,my-10,mx+10,my+10]);

        % We show the fixation cross at next display refresh cycle and
        % store the onset time of the fixation cross in 'tfixation'. Later
        % on we will use that as baseline to make sure the actual Mueller
        % Lyer test stim is shown 0.5 secs after onset of fixation:
        tfixation = Screen('Flip', expWin);

        %Prepare stimulus characteristics, make all aspects of the stimuli
        %proportional to stimsize so it can be dynamically changed
        Brighterthanbgrd=backgroundColor+condtable(1,order(i));
        
        Brighterthanbgrd2=backgroundColor+condtable2(1,order(i));
        
        Brighterthanbgrd3=backgroundColor+condtable3(1,order(i));
           
               
        %draw stimuli into backbuffer
        Screen('FillArc',expWin, Brighterthanbgrd,positionOfCircle,0,360);        
       
        Screen('FillArc',expWin, Brighterthanbgrd2,positionOfCircle2,0,360);
      
        Screen('FillArc',expWin, Brighterthanbgrd3,positionOfCircle3,0,360);

        %this would tell PTB that no further drawing commands will occur
        %before the next screen 'flip'. Apparently this can improve performance
        %telapsed is the time since the last flip command; use this if
        %you want to test how long it takes to draw into the backbuffer
        %   telapsed = Screen('DrawingFinished', expWin, [], 1);
        %However, its not needed here...

        %display stimuli and get onset time (two alternative ways). We ask
        %to show the stim 0.5 seconds after onset 'tfixation' of the
        %fixation cross:
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, tfixation + 0.5);
        tic;
        %these different timestamps are not exactly the same, e.g.:
        %   plot([VBLTimestamp StimulusOnsetTime FlipTimestamp tic])
        %the difference is negligible for most experiments

        %record response time, two methods again
        %this is just to compare between Matlab and PTB timing.
        %In your experiment, you should settle for one method --> 
        %the Psychtoolbox method of using 'StimulusOnsetTime' seems to be 
        %the more reliable solution, specifically on varying hardware
        %setups or under suboptimal conditions 
        [resptime, keyCode] = KbWait;
        MLrt=toc;
        rt=resptime-StimulusOnsetTime;

        %find out which key was pressed
        cc=KbName(keyCode);  %translate code into letter (string)

        %calculate performance or detect forced exit
        if isempty(cc) || strcmp(cc,'ESCAPE')
            break;   %break out of trials loop, but perform all the cleanup things
                     %and give back results collected so far
        elseif ~any(strcmp(cc,keyLeft) || strcmp(cc,keyRight))
            response = 9999;
        elseif strcmp(cc,keyLeft)
            response = 1;
        elseif strcmp(cc,keyRight)
            response = 0;

        end
       
              
        
        
        %enter results in matrix
        results(i,:) = [subID, i-ntrain, order(i), condtable(1,order(i)), backgroundColor, response, rt, MLrt, age, gender, session];



        %show between trial prompt and wait for button press
%         DrawFormattedText(expWin, 'Press any key to start next trial', 'center', 'center');
%         Screen('Flip', expWin);
%         KbWait([], 3); %wait for keystroke,

        %wait between trial 
        Screen('Flip', expWin);
        WaitSecs(1)

    end %of trials loop
%%
    %write results to comma delimited text file (use '\t' for tabs)
    dlmwrite(fileName, results);

    %         %alternative: write to excel format
    %         xlswrite(['MLIexpSubj' num2str(subID) '.xls'],[colHeaders; num2cell(results)]);

       %clean up before exit
    ShowCursor;
    sca; %or Screen('CloseAll');
    ListenChar(0);
    %return to olddebuglevel
    Screen('Preference', 'VisualDebuglevel', olddebuglevel);

catch
    % This section is executed only in case an error happens in the
    % experiment code implemented between try and catch...
    ShowCursor;
    Screen('CloseAll'); %or sca
    ListenChar(0);
    Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    %output the error message
    psychrethrow(psychlasterror);
end
