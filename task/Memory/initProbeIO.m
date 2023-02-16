function ioProbeStruct = initProbeIO(taskStruct, ioStruct, newStimDir, probeTaskStruct)
    % screen for debugging
    ioProbeStruct = struct();
    ioProbeStruct.bgColor = [60 60 60];
    ioProbeStruct.textColor = [200 200 200];
    %debugWinSize = [0,0,800,600];
    fullWinSize = [];    
    [ioProbeStruct.wPtr, ioProbeStruct.wPtrRect] = Screen('OpenWindow', 0, ioProbeStruct.bgColor, fullWinSize);
    %[ioProbeStruct.wPtr, ioProbeStruct.wPtrRect] = Screen('OpenWindow', 0, ioProbeStruct.bgColor, debugWinSize);
    ioProbeStruct.centerX = round(ioProbeStruct.wPtrRect(3)/2);
    ioProbeStruct.centerY = round(ioProbeStruct.wPtrRect(4)/2);
    
     
    
    % Measure the vertical refresh rate of the monitor
    Screen('TextFont', ioProbeStruct.wPtr, 'Courier');
    % sho`w the loading screen
    Screen('TextSize', ioProbeStruct.wPtr, 45);
    Screen('TextColor', ioProbeStruct.wPtr, ioProbeStruct.textColor);
    DrawFormattedText(ioProbeStruct.wPtr, 'Loading...', 'center', 'center');
    Screen(ioProbeStruct.wPtr, 'Flip');
    
%     % response keys
%     ioProbeStruct.LEFT = 1;
%     ioProbeStruct.RIGHT = 2;
%     ioProbeStruct.respKey_1 = ioStruct.respKey_1;
%     ioProbeStruct.respKeyName_1 = ioStruct.respKeyName_1;
%     ioProbeStruct.respKey_2 = ioStruct.respKey_2;
%     ioProbeStruct.respKeyName_2 = ioStruct.respKeyName_2;
    
    % response keys
%     ioProbeStruct.ONE = 1;
%     ioProbeStruct.TWO = 2;
%     ioProbeStruct.THREE = 3;
%     ioProbeStruct.FOUR = 4;
%     ioProbeStruct.FIVE = 5;

    ioProbeStruct.respKey_1 = KbName('1!');
    ioProbeStruct.respKeyName_1 = '1';
    ioProbeStruct.respKey_2 = KbName('2@');
    ioProbeStruct.respKeyName_2 = '2';
    ioProbeStruct.respKey_3 = KbName('3#');
    ioProbeStruct.respKeyName_3 = '3';
    ioProbeStruct.respKey_4 = KbName('4$');
    ioProbeStruct.respKeyName_4 = '4';
    ioProbeStruct.respKey_5 = KbName('5%');
    ioProbeStruct.respKeyName_5 = '5';
    
    % GS & MS added this to scale the images to the screen size; below defines the coordinates of x and y
    ioProbeStruct.rewimagex = round(0.2109*ioProbeStruct.centerX);
    ioProbeStruct.rewimagey = round(0.2109*2*ioProbeStruct.centerX);
    ioProbeStruct.halfXimage = ioProbeStruct.rewimagex/2;
    ioProbeStruct.halfYimage = ioProbeStruct.rewimagey/2;
    
    % center the stimulus image
    sourceRect = ioStruct.rectImage(1,:);
    width = sourceRect(3) - sourceRect(1);
    height = sourceRect(4) - sourceRect(2);
    adjustX = ioProbeStruct.centerX - sourceRect(1) - round(width/2);
    adjustY = ioProbeStruct.centerY - sourceRect(2) - round(height/2);
    ioProbeStruct.rectImage = sourceRect + [adjustX, adjustY, adjustX, adjustY];
%     ioProbeStruct.adjustX = adjustX;
%     ioProbeStruct.adjustY = adjustY;
    
    ioProbeStruct.Ypresentcenter = round(.1444*ioProbeStruct.centerY)+ioProbeStruct.centerY;

    spacer = ioProbeStruct.halfXimage/2;

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
    
%     % set up buttons
%     leftX = ioProbeStruct.centerX - width - round(hGap/2);
%     topY = ioProbeStruct.rectMachine(4) + vGap;
%    ioProbeStruct.buttonRect(1,:) = buttonRect + [leftX, topY, leftX, topY]; % this is the important line
    
    % set up button 1
%     leftX = ioProbeStruct.centerX - width - round(hGap/2);
%     topY = ioProbeStruct.rectMachine(4) + vGap;
%     ioProbeStruct.buttonRect(1,:) = buttonRect + [170, 902, 270, 952];
    ioProbeStruct.buttonRect(1,:) = [ioProbeStruct.centerX-(5*ioProbeStruct.halfXimage) - (2*spacer)+spacer,...
                                        ioProbeStruct.Ypresentcenter-spacer+ioProbeStruct.halfYimage,... 
                                        ioProbeStruct.centerX-(3*ioProbeStruct.halfXimage) - (2*spacer)-spacer,...
                                        ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage + (spacer/2)];
                         
      %ioProbeStruct.buttonRect(1,:) = buttonRect + [1170, 902, 1270, 952];
      %ioProbeStruct.buttonRect(1,:) = ioProbeStruct.rectImage(1,:) + [0, +200, 0, +200];
      %ioProbeStruct.buttonRect(1,:) = buttonRect + [-1000, 0, -1000, 0];
    
    % set up button 2
%     leftX = ioProbeStruct.centerX + round(hGap/2);
%     topY = ioProbeStruct.rectMachine(4) + vGap;
%     ioProbeStruct.buttonRect(2,:) = buttonRect + [670, 902, 770, 952];
    
    ioProbeStruct.buttonRect(2,:) = [ioProbeStruct.centerX-(3*ioProbeStruct.halfXimage) - spacer+spacer,...
                                    ioProbeStruct.Ypresentcenter-spacer+ioProbeStruct.halfYimage,... 
                                    ioProbeStruct.centerX-ioProbeStruct.halfXimage - spacer-spacer,...
                                    ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage + (spacer/2)];



    % set up button 3
%     leftX = ioProbeStruct.centerX - width - round(hGap/2);
%     topY = ioProbeStruct.rectMachine(4) + vGap;
%     ioProbeStruct.buttonRect(3,:) = buttonRect + [1170, 902, 1270, 952];
    
     ioProbeStruct.buttonRect(3,:) = [ioProbeStruct.centerX-ioProbeStruct.halfXimage+spacer,...
                                      ioProbeStruct.Ypresentcenter-spacer+ioProbeStruct.halfYimage,...
                                      ioProbeStruct.centerX+ioProbeStruct.halfXimage-spacer,...
                                      ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage + (spacer/2)];
    
    % set up button 4
%     leftX = ioProbeStruct.centerX + round(hGap/2);
%     topY = ioProbeStruct.rectMachine(4) + vGap;
%     ioProbeStruct.buttonRect(4,:) = buttonRect + [1670, 902, 1770, 952];
    
     ioProbeStruct.buttonRect(4,:) = [ioProbeStruct.centerX+ioProbeStruct.halfXimage + spacer+spacer,...
                                      ioProbeStruct.Ypresentcenter-spacer+ioProbeStruct.halfYimage,...
                                      ioProbeStruct.centerX+(3*ioProbeStruct.halfXimage) + spacer-spacer,...
                                      ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage + (spacer/2)];
    
    % set up button 5
%     leftX = ioProbeStruct.centerX + round(hGap/2);
%     topY = ioProbeStruct.rectMachine(4) + vGap;
%     ioProbeStruct.buttonRect(5,:) = buttonRect + [2170, 902, 2270, 952];
    
     ioProbeStruct.buttonRect(5,:) = [ioProbeStruct.centerX+(3*ioProbeStruct.halfXimage) + (2*spacer)+spacer,...
                                      ioProbeStruct.Ypresentcenter-spacer+ioProbeStruct.halfYimage,... 
                                      ioProbeStruct.centerX+(5*ioProbeStruct.halfXimage) + (2*spacer)-spacer,...
                                      ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage + (spacer/2)];
    
%     % text to show
%     ioProbeStruct.oldButtonText = 'Old';
%     ioProbeStruct.newButtonText = 'New';
    
    % text to show
    ioProbeStruct.oneText = '1';
    ioProbeStruct.twoText = '2';
    ioProbeStruct.threeText = '3';
    ioProbeStruct.fourText = '4';
    ioProbeStruct.fiveText = '5';
    
    
    % here I might have to add how to map high value images to trials! 
    % identify familiar stimuli from the task
    familiarStimFiles = ioStruct.allImageFiles(any(taskStruct.allTrials.isTrialStim), :);
    newStimFiles = dir( fullfile(newStimDir, '2_*.jpeg')); % save newStim in Explo2_Rebecca > pilotTask_MS > images > memoryProbe

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