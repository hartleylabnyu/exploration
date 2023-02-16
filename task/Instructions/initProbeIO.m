function ioProbeStruct = initProbeIO(taskStruct, ioStruct, newStimDir, probeTaskStruct)
    % screen for debugging
    ioProbeStruct = struct();
    ioProbeStruct.bgColor = [60 60 60];
    ioProbeStruct.textColor = [200 200 200];
    debugWinSize = [0,0,800,600];
    fullWinSize = [];    
    [ioProbeStruct.wPtr, ioProbeStruct.wPtrRect] = Screen('OpenWindow', 0, ioProbeStruct.bgColor, fullWinSize);
    ioProbeStruct.centerX = round(ioProbeStruct.wPtrRect(3)/2);
    ioProbeStruct.centerY = round(ioProbeStruct.wPtrRect(4)/2);
    
    % Measure the vertical refresh rate of the monitor
    Screen('TextFont', ioProbeStruct.wPtr, 'Courier');
    % sho`w the loading screen
    Screen('TextSize', ioProbeStruct.wPtr, 45);
    Screen('TextColor', ioProbeStruct.wPtr, ioProbeStruct.textColor);
    DrawFormattedText(ioProbeStruct.wPtr, 'Loading', 'center', 'center');
    Screen(ioProbeStruct.wPtr, 'Flip');
    
    % response keys
    ioProbeStruct.LEFT = 1;
    ioProbeStruct.RIGHT = 2;
    ioProbeStruct.respKey_1 = ioStruct.respKey_1;
    ioProbeStruct.respKeyName_1 = ioStruct.respKeyName_1;
    ioProbeStruct.respKey_2 = ioStruct.respKey_2;
    ioProbeStruct.respKeyName_2 = ioStruct.respKeyName_2;
    
    % center the stimulus image
    sourceRect = ioStruct.rectImage(1,:);
    width = sourceRect(3) - sourceRect(1);
    height = sourceRect(4) - sourceRect(2);
    adjustX = ioProbeStruct.centerX - sourceRect(1) - round(width/2);
    adjustY = ioProbeStruct.centerY - sourceRect(2) - round(height/2);
    ioProbeStruct.rectImage = sourceRect + [adjustX, adjustY, adjustX, adjustY];
    
    % adjust slot machine rects
    sourceRect = ioStruct.rectMachine(1,:);
    ioProbeStruct.rectMachine = sourceRect + [adjustX, adjustY, adjustX, adjustY];
    
    % adjust feedback rect
    sourceRect = ioStruct.rectOutcome(1,:);
    ioProbeStruct.rectOutcome = sourceRect + [adjustX, adjustY, adjustX, adjustY];
    
    % old/new button rects
    ioProbeStruct.buttonRect = nan(2,4);
    width = 100; height = 50; 
    vGap = 40; hGap = 20;
    buttonRect = [0, 0, width, height];
    % set up the left button
    leftX = ioProbeStruct.centerX - width - round(hGap/2);
    topY = ioProbeStruct.rectMachine(4) + vGap;
    ioProbeStruct.buttonRect(1,:) = buttonRect + [leftX, topY, leftX, topY];
    % set up the right button
    leftX = ioProbeStruct.centerX + round(hGap/2);
    topY = ioProbeStruct.rectMachine(4) + vGap;
    ioProbeStruct.buttonRect(2,:) = buttonRect + [leftX, topY, leftX, topY];
    % text to show
    ioProbeStruct.oldButtonText = 'Old';
    ioProbeStruct.newButtonText = 'New';
    
    % identify familiar stimuli from the task
    familiarStimFiles = ioStruct.allImageFiles(any(taskStruct.allTrials.isTrialStim), :);
    newStimFiles = dir( fullfile(newStimDir, '*.bmp') );
    % append in path information
    [newStimFiles(:).folder] = deal(fullfile(newStimDir));
    % map familiar/novel stimuli to trials
    ioProbeStruct.trialStim(probeTaskStruct.allTrials.isFamiliar) = familiarStimFiles(randperm(length(familiarStimFiles)));
    ioProbeStruct.trialStim(~probeTaskStruct.allTrials.isFamiliar) = newStimFiles(randperm(length(newStimFiles), length(familiarStimFiles)));
    
    % load textures for each trial
    ioProbeStruct.trialTexture = nan( size(ioProbeStruct.trialStim) );
    for fI = 1 : length(ioProbeStruct.trialTexture)
        ioProbeStruct.trialTexture(fI) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(fullfile(ioProbeStruct.trialStim(fI).folder, ioProbeStruct.trialStim(fI).name)));
    end
    
    % the slot machine image
    ioProbeStruct.machine = Screen('MakeTexture', ioProbeStruct.wPtr, imread(fullfile('images', 'slotMachine.png')));
end