function dispStruct = initIOStruct(taskStruct, stimDir)
    % set up the screen
    dispStruct = struct();
    dispStruct.bgColor = [60 60 60];
    dispStruct.textColor = [200 200 200];
    %debugWinSize = [0,0,800,600];
    fullWinSize = [];
    % run full-screen task
    [dispStruct.wPtr, dispStruct.wPtrRect] = Screen('OpenWindow', 0, dispStruct.bgColor, fullWinSize);
    % Make images not have black backgrounds
    Screen('BlendFunction', dispStruct.wPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    % Measure the vertical refresh rate of the monitor
    dispStruct.centerX = round(dispStruct.wPtrRect(3)/2);
    dispStruct.centerY = round(dispStruct.wPtrRect(4)/2);
    
    % show loading prompt
    Screen('TextFont', dispStruct.wPtr, 'Courier');
    % show the loading screen
    Screen('TextSize', dispStruct.wPtr, 45);
    Screen('TextColor', dispStruct.wPtr, dispStruct.textColor);
    DrawFormattedText(dispStruct.wPtr, 'Loading...', 'center', 'center', [], 70, false, false, 1.1);
    Screen(dispStruct.wPtr, 'Flip');
    
    % stimulus durations
    dispStruct.SLOW = -1;
    %dispStruct.MAX_RT = 3;
    dispStruct.MAX_RT = 4; % made a little slower for kids
    dispStruct.FIX_DURATION = 0.5;
    dispStruct.REW_DURATION = 1.5;
    %dispStruct.BLOCK_START_WAIT = 3;
    %dispStruct.BLOCK_START_WAIT = 5;
    dispStruct.BLOCK_START_WAIT = 7;
    dispStruct.BLOCK_END_WAIT = 4;
    
    % response keys
    dispStruct.LEFT = 1;
    dispStruct.RIGHT = 2;
    dispStruct.respKey_1 = [ KbName('F'), KbName('1!') ];
    dispStruct.respKeyName_1 = '1';
    dispStruct.respKey_2 = [ KbName('J'), KbName('4$') ];
    dispStruct.respKeyName_2 = '2';
    
    % scanner keys
    dispStruct.respMRIPulse = [ KbName('5%'), KbName('5')];
    
    % task control keys
    dispStruct.respKey_Quit = KbName('Q');
    dispStruct.respKeyName_Quit = 'Q';
    dispStruct.respKey_Pause = KbName('P');
    dispStruct.respKeyName_Pause = 'P';
    
    %%%%%%%%%%%%%%%%%%%%%
    % slot machine rectangles
    dispStruct.rectMachine = nan(2,4);
    imageScaleFactor = 1;
    % width of the machine minus the handle (for centering purposes)
    %machineWidth = 250*imageScaleFactor;
    machineWidth = 400*imageScaleFactor;
    % size of the machine's full image
    %machineImageWidth = 325*imageScaleFactor;  
    machineImageWidth = 400*imageScaleFactor;  
    %machineImageHeight = 400*imageScaleFactor;
    machineImageHeight = 375*imageScaleFactor;
    machineGap = 100;
    machineRect = [0, 0, machineImageWidth, machineImageHeight];
    % left machine
    leftX = dispStruct.centerX - machineImageWidth - (machineGap/2);
    topY = dispStruct.centerY - (machineImageHeight/2);
    dispStruct.rectMachine(1,:) = machineRect + [leftX, topY, leftX, topY];
    % right machine
    leftX = dispStruct.centerX + (machineGap/2);
    topY = dispStruct.centerY - (machineImageHeight/2);
    dispStruct.rectMachine(2,:) = machineRect + [leftX, topY, leftX, topY];
    
    % reward feedback rect
    dispStruct.rectOutcome = nan(2,4);
    rewardHMargin = 15;
    %rewardHMargin = 20;
    rewardWidth = machineWidth - 2*rewardHMargin;
    %rewardHeight = machineImageHeight * 0.15;
    rewardHeight = machineImageHeight * 0.2; % I made this bigger so the pic wouldn't get cut-off. Not sure how to center letters though.
    rectReward = [0 0 rewardWidth rewardHeight];
    % place left-most outcome
    leftX = dispStruct.rectMachine(1,1) + rewardHMargin;
    topY = dispStruct.rectMachine(1,2) + rewardHMargin;
    dispStruct.rectOutcome(1,:) = rectReward + [leftX, topY, leftX, topY];
    % right-most outcome
    leftX = dispStruct.rectMachine(2,1) + rewardHMargin;
    topY = dispStruct.rectMachine(2,2) + rewardHMargin;
    dispStruct.rectOutcome(2,:) = rectReward + [leftX, topY, leftX, topY];
    
    % token rects
    dispStruct.rectToken = nan(2,4);
    width = rewardHeight; height = rewardHeight;
    rectToken = [0 0 width height];
    % left token
    leftX = dispStruct.rectOutcome(1,1) + round( (dispStruct.rectOutcome(1,3) - dispStruct.rectOutcome(1,1)) / 2 ) - round(width/2);
    topY = dispStruct.rectOutcome(1,2) + round( (dispStruct.rectOutcome(1,4) - dispStruct.rectOutcome(1,2)) / 2 ) - round(height/2);
    dispStruct.rectToken(1,:) = rectToken + [leftX, topY, leftX, topY];
    % right token
    leftX = dispStruct.rectOutcome(2,1) + round( (dispStruct.rectOutcome(2,3) - dispStruct.rectOutcome(2,1)) / 2 ) - round(width/2);
    topY = dispStruct.rectOutcome(2,2) + round( (dispStruct.rectOutcome(2,4) - dispStruct.rectOutcome(2,2)) / 2 ) - round(height/2);
    dispStruct.rectToken(2,:) = rectToken + [leftX, topY, leftX, topY];
    
    % slot machine image rects
    imageHMargin = 15;
    % fill the rest of the remaining space with the image
    leftX = dispStruct.rectMachine(1,1)+imageHMargin;
    rightX = dispStruct.rectMachine(1,1)+machineWidth-imageHMargin;
    topY = dispStruct.rectOutcome(1,4)+imageHMargin;
    bottomY = dispStruct.rectMachine(1,4) - imageHMargin;
    dispStruct.rectImage(1,:) = [leftX, topY, rightX, bottomY];
    % do the same for the right image
    leftX = dispStruct.rectMachine(2,1)+imageHMargin;
    rightX = dispStruct.rectMachine(2,1)+machineWidth-imageHMargin;
    topY = dispStruct.rectOutcome(2,4)+imageHMargin;
    bottomY = dispStruct.rectMachine(2,4) - imageHMargin;
    dispStruct.rectImage(2,:) = [leftX, topY, rightX, bottomY];
    
    % slot machine images to load
    dispStruct.stims = nan(1, taskStruct.numStims);
    % randomply sample number of required images
    dispStruct.allImageFiles = dir(fullfile(stimDir, 'stimuli', '1_*.jpeg'));
    dispStruct.allImageFiles = dispStruct.allImageFiles( randsample(length(dispStruct.allImageFiles), taskStruct.numStims) );
    % append in path information
    [dispStruct.allImageFiles(:).folder] = deal(fullfile(stimDir, 'stimuli'));
    % load images into memory
    for sI = 1 : taskStruct.numStims
        dispStruct.stims(sI) = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile(dispStruct.allImageFiles(sI).folder, dispStruct.allImageFiles(sI).name)));
    end
    
    % casinos
    dispStruct.casinoStim = nan(1, length(unique(taskStruct.allTrials.blockID)));
    allCasinoNameFiles = dir(fullfile(stimDir, 'regions', 'region_*.jpg'));
    allCasinoNameFiles = allCasinoNameFiles(randperm(length(allCasinoNameFiles)));
    % append in path information
    [allCasinoNameFiles(:).folder] = deal(fullfile(stimDir, 'regions'));
    % load images into memory
    for sI = 1 : taskStruct.numStims
        dispStruct.casinoStim(sI) = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile(allCasinoNameFiles(sI).folder, allCasinoNameFiles(sI).name)));
        % Have casino stim numbers also correspond to names
        dispStruct.casinoNames{sI} = allCasinoNameFiles(sI).name;
    end

    % casino image rect
    width = 400; height = 200;
    %width = 800; height = 400;
    leftX = dispStruct.centerX - (width/2);
    topY = dispStruct.centerY - (height/2);
    %dispStruct.casinoRect = [leftX, topY, leftX+width, topY+height];
    dispStruct.casinoRect = dispStruct.wPtrRect;
    
    % Creatures
    %dispStruct.creatureStim = nan(1, length(unique(taskStruct.allTrials.creatureID)));
    allCreatureNameFiles = dir(fullfile(stimDir, 'creatures', 'creature_*.jpeg'));
    allCreatureNameFiles = allCreatureNameFiles(randperm(length(allCreatureNameFiles)));
    % append in path information
    [allCreatureNameFiles(:).folder] = deal(fullfile(stimDir, 'creatures'));
    % load images into memory
    for sI = 1 : taskStruct.numStims
        dispStruct.creatureStim(sI) = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile(allCreatureNameFiles(sI).folder, allCreatureNameFiles(sI).name)));
        % Have creature stim numbers also correspond to names
        dispStruct.creatureNames{sI} = allCreatureNameFiles(sI).name;
    end
    
    % creature block start image rect
    width = 300; height = 225;
    %width = 800; height = 400;
    leftX = dispStruct.centerX - (width/2);
    topY = dispStruct.centerY - (height/2);
    dispStruct.creatureBlockRect = [leftX, topY, leftX+width, topY+height];
    
    % creature trial image rect
    % Set location for creatures in trial
    dispStruct.creatureX = round(dispStruct.wPtrRect(3)*.9);
    dispStruct.creatureY = round(dispStruct.wPtrRect(4)*.9);
    width = 300; height = 225;
    %width = 300; height = 225;
    leftX = dispStruct.creatureX - (width/2);
    topY = dispStruct.creatureY - (height/2);
    dispStruct.creatureTrialRect = [leftX, topY, leftX+width, topY+height];
           
    % slot machine images
    dispStruct.machine = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile('images', 'slotMachine.png')));
    dispStruct.machineSelected = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile('images', 'slotMachine_selected.png')));
    %dispStruct.machineSelected = Screen('FrameRect', dispStruct.wPtr, [0,
    %0, 255], dispStruct.rectMachine, [3]); % I can't get this to work....
    % token images
        %dispStruct.tokenWin = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile('pictures', 'COIN.png')));
    [winImg, ~, alpha] = imread(fullfile('pictures', 'COIN.png')); 
    winImg(:,:,4) = alpha;
    dispStruct.tokenWin = Screen('MakeTexture', dispStruct.wPtr, winImg);
        %dispStruct.tokenLoss = Screen('MakeTexture', dispStruct.wPtr, imread(fullfile('pictures', 'REDX.png')));
    [lossImg, ~, alpha] = imread(fullfile('pictures', 'REDX.png')); 
    lossImg(:,:,4) = alpha;
    dispStruct.tokenLoss = Screen('MakeTexture', dispStruct.wPtr, lossImg);
    
    % show loading completed prompt
    WaitSecs(2);
    Screen('TextFont', dispStruct.wPtr, 'Courier');
    % show the loading screen
    Screen('TextSize', dispStruct.wPtr, 45);
    Screen('TextColor', dispStruct.wPtr, dispStruct.textColor);
    DrawFormattedText(dispStruct.wPtr, 'Loading Completed', 'center', 'center', [], 70, false, false, 1.1);
    Screen(dispStruct.wPtr, 'Flip');
end