%% run as a single script (not as cells waiting for use input) 

% Initialization 
clear all;

% some initial global setup
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));
RestrictKeysForKbCheck( [] );
Screen('Preference','VisualDebugLevel', 0);
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');

% initialize the task structure
numSessions = 1;
numBlocks = 2;
taskStruct = initTaskStruct(numSessions, numBlocks);
% include all blocks in the first and only session
taskStruct.sessionBlocks(1,:) = 1:numBlocks;

% subejct ID info
taskStruct.subID = input('Participant number :\n','s');
% output folder
taskStruct.outputFolder = fullfile('..', 'data');
% check to see if the output folder exists
if exist(taskStruct.outputFolder, 'dir') == 0
    % folder does not exist - create it
    mkdir( taskStruct.outputFolder );
end
taskStruct.fileName = [taskStruct.subID '_Sub_ExpExpPractice_' datestr(now, 'mm-dd-yyyy_HH-MM-SS')];

% initialize the I/O
% stimDir = fullfile('.', 'images', 'practice');
stimDir = fullfile('.', 'pictures', 'practice');
ioStruct = initIOStruct(taskStruct, stimDir);

% disable input capture and run instructions
HideCursor(); ListenChar(2);
% showCasinoInstructions(ioStruct, fullfile('.', 'images', 'casinoInstructions'));
showCasinoInstructions(ioStruct, fullfile('.', 'pictures', 'practiceInstructions'));

% Sesson to run
sessionID = 1;
% specify trials to run in session 1
isSessionBlock = ismember(taskStruct.allTrials.blockID, taskStruct.sessionBlocks(sessionID,:));
% label block's session IDs, and extract index of trials to run
taskStruct.allTrials.sessionID( isSessionBlock ) = sessionID;
sessionTrials = find( isSessionBlock );
% run the session
taskStruct = runCasinoSession(taskStruct, ioStruct, sessionTrials);
save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'ioStruct', 'taskStruct');

% clear the screen
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
sessionEndText = 'We''re done with practice.\n\n Please let the experimenter know if you have any questions,\n otherwise let them know that you''re ready to begin.';
Screen('TextSize', ioStruct.wPtr, 30);
Screen('TextColor', ioStruct.wPtr, [255 255 255]);
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, sessionEndText, 'center', 'center');
% show feedback for prescribed time, then clear screen
Screen(ioStruct.wPtr, 'Flip');
RestrictKeysForKbCheck( KbName('space') );
KbWait(-3,2);

% enable input
ListenChar(1); ShowCursor(); sca;