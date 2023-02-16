%% Initialization 
clear all;

% some initial global setup
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));
RestrictKeysForKbCheck( [] );
Screen('Preference','VisualDebugLevel', 0); % this prevents the red (!) to appear
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
    
% added to facilitate memory probe stim presentation by MS and GR on
% 9/18/19
probeStruct = struct();
probeStruct.highRew = [];
probeStruct.lowRew = [];
probeStruct.medRew = [];
probeStruct.holdout = [];

% initialize the task strcuture
numSessions = 2;
numBlocks = 10;
[taskStruct, probeStruct]= initTaskStruct(numSessions, numBlocks, probeStruct);
taskStruct.sessionBlocks(1,:) = 1:5;
taskStruct.sessionBlocks(2,:) = 6:10;

% subejct ID info
taskStruct.subID = input('Participant number :\n','s');
% output folder
taskStruct.outputFolder = fullfile('..', 'data'); % this lets me go back one path and save the data in the folder data 
% check to see if the output folder exists
if exist(taskStruct.outputFolder, 'dir') == 0
    % folder does not exist - create it
    mkdir( taskStruct.outputFolder );
end
taskStruct.fileName = [taskStruct.subID '_Sub_ExpExpTask_' datestr(now, 'mm-dd-yyyy_HH-MM-SS')];

% hide input to prevent participant from over-writing into the script
% HideCursor(); ListenChar(2);

% initialize the IO for the task
stimDir = fullfile('.', 'pictures', 'task');


% % % if lines 46 and 47 are fine then you can get rid of probeStruct in
% the next line
% [ioStruct,probeStruct] = initIOStruct(taskStruct, stimDir,probeStruct);
ioStruct = initIOStruct(taskStruct, stimDir);

probeStruct.sceneNames = ioStruct.casinoNames(1:10); % loading the scenes into our probeStruct 
probeStruct.creatureNames = ioStruct.creatureNames(1:10);
probeStruct.blockDifficulty = taskStruct.blockSpecs.blockDifficulty;
probeStruct.familiarHoldoutTrial = taskStruct.blockSpecs.familiarHoldoutTrial;
probeStruct.novelHoldoutTrial = taskStruct.blockSpecs.novelHoldoutTrial;

%clean up probe struct for memory probe later
for block = 1:numBlocks
    probeStruct.highRewName{block} = ioStruct.allImageFiles(probeStruct.highRew(block)).name;
    probeStruct.lowRewName{block} = ioStruct.allImageFiles(probeStruct.lowRew(block)).name;
    probeStruct.medRewName{block} = ioStruct.allImageFiles(probeStruct.medRew(block)).name;

end

% wait for experimentor input to prompt wait for scanner pulse
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
Screen('TextSize', ioStruct.wPtr, 30);
Screen('TextColor', ioStruct.wPtr, [255 255 255]);
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, 'Waiting for technician to mark ready status.', 'center', 'center');
% show prompt
Screen(ioStruct.wPtr, 'Flip');
RestrictKeysForKbCheck( KbName('space') );
KbWait(-3,2);



%%%%%%%%%%%%%%%%%%%%
%% run session 1

sessionID = 1;
% specify trials to run in session 1
isSessionBlock = ismember(taskStruct.allTrials.blockID, taskStruct.sessionBlocks(sessionID,:));
% label block's session IDs, and extract index of trials to run
taskStruct.allTrials.sessionID( isSessionBlock ) = sessionID;
sessionTrials = find( isSessionBlock );
% if something fails, and the task needs to be aborted, 
% reload the participants data file, and modify the list of trials to be run during the session, 
% starting with the last trial that was successfully run

% wait for scanner pulse
taskStruct.tSessionStart(sessionID) = GetSecs();
% run the session
taskStruct = runCasinoSession(taskStruct, ioStruct, sessionTrials);
% track session duration
taskStruct.tSessionEnd(sessionID) = GetSecs();

% mark end of session
% wait for experimentor input to prompt wait for scanner pulse
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
Screen('TextSize', ioStruct.wPtr, 30);
Screen('TextColor', ioStruct.wPtr, [255 255 255]);
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, 'Time for a short break.\n\nWaiting for technician to mark ready status.', 'center', 'center');
% show prompt
Screen(ioStruct.wPtr, 'Flip');
RestrictKeysForKbCheck( KbName('space') );
KbWait(-3,2);



%%%%%%%%%%%%%%%%%%%%
%% run session 2
sessionID = 2;
% specify trials to run in session 1
isSessionBlock = ismember(taskStruct.allTrials.blockID, taskStruct.sessionBlocks(sessionID,:));
% label block's session IDs, and extract index of trials to run
taskStruct.allTrials.sessionID( isSessionBlock ) = sessionID;
sessionTrials = find( isSessionBlock );

% wait for scanner pulse
taskStruct.tSessionStart(sessionID) = GetSecs();
% run the session
taskStruct = runCasinoSession(taskStruct, ioStruct, sessionTrials);
% track session duration
taskStruct.tSessionEnd(sessionID) = GetSecs();
save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'ioStruct', 'taskStruct','probeStruct');


% clear the screen
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
% sessionEndText = 'And we''re done!.\n\n Someone will be with you in a few moments.';
% Screen('TextSize', ioStruct.wPtr, 30);
% Screen('TextColor', ioStruct.wPtr, [255 255 255]);
% Screen('TextFont', ioStruct.wPtr, 'Helvetica');
% DrawFormattedText(ioStruct.wPtr, sessionEndText, 'center', 'center');

% Show end slides
% % % Added by Gail on 10/29/19 to display final number of coins found
finalCoins = num2str(nansum(taskStruct.allTrials.outcome));
sessionEndText = ['Great Job!\n\nYou found ' finalCoins ' coins!'];
Screen('TextSize', ioStruct.wPtr, 30);
Screen('TextColor', ioStruct.wPtr, [255 255 255]);
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, sessionEndText, 'center', 'center');
% % % Make this the coin and make it appear with the 
% Screen('DrawTexture', ioStruct.wPtr, end1, [], ioStruct.casinoRect);

Screen(ioStruct.wPtr, 'Flip'); 
RestrictKeysForKbCheck( KbName('space') );
KbWait(-3,2);

end1 = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile('pictures', 'endTask1.jpeg'))); 
Screen('DrawTexture', ioStruct.wPtr, end1, [], ioStruct.casinoRect);
Screen(ioStruct.wPtr, 'Flip'); 
WaitSecs(ioStruct.BLOCK_END_WAIT); % show screen for 4ish seconds
end2 = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile('pictures', 'endTask2.jpeg')));
Screen('DrawTexture', ioStruct.wPtr, end2, [], ioStruct.casinoRect);
% show feedback for prescribed time, then clear screen
Screen(ioStruct.wPtr, 'Flip');
RestrictKeysForKbCheck( KbName('space') );
KbWait(-3,2);

disp(['Coins found: ' finalCoins]);

sca;
ShowCursor();
ListenChar();