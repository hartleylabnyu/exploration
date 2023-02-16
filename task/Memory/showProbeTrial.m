function trialSpec = runProbeTrial(probeTaskStruct, ioProbeStruct, trialSpec, probeStruct, tI) %, bI) % MS added probe struct, tI and bI to this function to get it into the workspace
    % only allow relevant keys - MS modified to allow more keys 9/19/19
    RestrictKeysForKbCheck( [ioProbeStruct.respKey_1, ioProbeStruct.respKey_2, ioProbeStruct.respKey_3, ioProbeStruct.respKey_4, ioProbeStruct.respKey_5] );
    
    % MS & GS added to upload stimuli, regions, and creatures from Part 1
    % 9/19/19
    stimDir = ('pictures/task/stimuli/');
    regionDir = ('pictures/task/regions/'); 
    creaturesDir = ('pictures/task/creatures/');
    newstimDir = ('images/memoryProbe/stimuli/');
    
    % fixation to start trial
    Screen('TextSize', ioProbeStruct.wPtr, 40);
    Screen('TextColor', ioProbeStruct.wPtr, ioProbeStruct.textColor);
    DrawFormattedText(ioProbeStruct.wPtr, '+', 'center', 'center');
    Screen(ioProbeStruct.wPtr, 'Flip');
    WaitSecs(1);
    
    % MS & GS added to upload images into memory 9/19/19
    currentImages(1) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(stimDir, probeStruct.highRewName(probeStruct.probeOrder(tI))))));
    currentImages(2) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(stimDir, probeStruct.lowRewName(probeStruct.probeOrder(tI))))));
    currentImages(3) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(stimDir, probeStruct.medRewName(probeStruct.probeOrder(tI))))));
    % high reward from other block
    currentImages(4) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(stimDir, probeStruct.LureListName(probeStruct.probeOrder(tI))))));
    % new image
    currentImages(5) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(stimDir, probeStruct.newImageName(probeStruct.probeOrder(tI))))));
    % upload the regions
    currentImages(6) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(regionDir, probeStruct.sceneNames(probeStruct.probeOrder(tI))))));
    % upload the creatures
    currentImages(7) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(char(fullfile(creaturesDir, probeStruct.creatureNames(probeStruct.probeOrder(tI))))));
   
    % Randomize the order of the new images (MS & GS 9/26/19)
    trialSpec.imageOrder = randperm(5); % creates vector with numbers 1:5 in random order
    
%     loc{1} = ioProbeStruct.rectImage(1,:)+[-650, +150, -750, +150]; % mapping loc{x} to screen position; ioProbeStruct.rectImage(1,:)+[-1000, 0, -1000, 0]
%     loc{2} = ioProbeStruct.rectImage(1,:)+[-280, +150, -380, +150]; %ioProbeStruct.rectImage(1,:)+[-500, 0, -500, 0]
%     loc{3} = ioProbeStruct.rectImage(1,:)+[90, +150, -10, +150]; %ioProbeStruct.rectImage(1,:)
%     loc{4} = ioProbeStruct.rectImage(1,:)+[490, +150, 390, +150]; %ioProbeStruct.rectImage(1,:)+[500, 0, 500, 0]
%     loc{5} = ioProbeStruct.rectImage(1,:)+[910, +150, 810, +150]; %ioProbeStruct.rectImage(1,:)+[1000, 0, 1000, 0]
    
   spacer = ioProbeStruct.halfXimage/2;
    
   loc{1} = [ioProbeStruct.centerX-(5*ioProbeStruct.halfXimage) - (2*spacer),...
             ioProbeStruct.Ypresentcenter-spacer,... 
             ioProbeStruct.centerX-(3*ioProbeStruct.halfXimage) - (2*spacer),...
             ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage-(2*spacer)];

   loc{2} = [ioProbeStruct.centerX-(3*ioProbeStruct.halfXimage) - spacer,...
             ioProbeStruct.Ypresentcenter-spacer,... 
             ioProbeStruct.centerX-ioProbeStruct.halfXimage - spacer,...
             ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage-(2*spacer)];

   loc{3} = [ioProbeStruct.centerX-ioProbeStruct.halfXimage,...
             ioProbeStruct.Ypresentcenter-spacer,... 
             ioProbeStruct.centerX+ioProbeStruct.halfXimage,...
             ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage-(2*spacer)];

   loc{4} = [ioProbeStruct.centerX+ioProbeStruct.halfXimage + spacer,...
             ioProbeStruct.Ypresentcenter-spacer,... 
             ioProbeStruct.centerX+(3*ioProbeStruct.halfXimage) + spacer,...
             ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage-(2*spacer)];

    
   loc{5} = [ioProbeStruct.centerX+(3*ioProbeStruct.halfXimage) + (2*spacer),...
             ioProbeStruct.Ypresentcenter-spacer,... 
             ioProbeStruct.centerX+(5*ioProbeStruct.halfXimage) + (2*spacer),...
             ioProbeStruct.Ypresentcenter+ioProbeStruct.halfYimage-(2*spacer)];
         
   
   locregion = [ioProbeStruct.centerX-(3*ioProbeStruct.halfXimage) - spacer,...
             ioProbeStruct.Ypresentcenter-spacer-(2*ioProbeStruct.halfYimage)-spacer+(ioProbeStruct.halfYimage/2)-spacer-(ioProbeStruct.halfYimage/3),... 
             ioProbeStruct.centerX+(3*ioProbeStruct.halfXimage) + spacer,...
             ioProbeStruct.Ypresentcenter-spacer-ioProbeStruct.halfYimage+spacer+(ioProbeStruct.halfYimage/2)+spacer-(ioProbeStruct.halfYimage/3)];
         
   
   loccreature = [ioProbeStruct.centerX-ioProbeStruct.halfXimage,...
             ioProbeStruct.Ypresentcenter-spacer-(2*ioProbeStruct.halfYimage)+(ioProbeStruct.halfYimage/2),... 
             ioProbeStruct.centerX+ioProbeStruct.halfXimage,...
             ioProbeStruct.Ypresentcenter-ioProbeStruct.halfYimage-(2*spacer)+(ioProbeStruct.halfYimage/2)];
    
    
    % Present images (added by MS 9/19/19)
    % Screen('DrawTexture', window, image, [], position on the screen)
    Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(1), [], loc{trialSpec.imageOrder(1)}); % high value
    Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(2), [], loc{trialSpec.imageOrder(2)}); % low value
    Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(3), [], loc{trialSpec.imageOrder(3)}); % holdout
    Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(4), [], loc{trialSpec.imageOrder(4)}); % high value other block
    Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(5), [], loc{trialSpec.imageOrder(5)}); % new stimulus
    
    
     Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(6), [], locregion); % region
     Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(7), [], loccreature); % creature
%     
%    Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(6), [], ioProbeStruct.rectImage(1,:)+[-500, -550, 500, -450]); % region
%     Screen('DrawTexture', ioProbeStruct.wPtr, currentImages(7), [], ioProbeStruct.rectImage(1,:)+[0, -475, 0, -525]); % creature
    
    % TO DO 
    % draw region and creatures!! 
    
    % show buttons
    % 1 (high value)
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(1,:));
    %Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(1,:) + [-1000, 0, -1000, 0]);
    %Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:) + [-600, 0, -600, 0], 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.oneText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(1,:));
    % 2 (low value)
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(2,:));
    %Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:) + [-300, 0, -300, 0], 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.twoText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(2,:));
    % 3 (holdout)
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(3,:));
    %Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:), 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.threeText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(3,:));
    % 4 (high value other block)
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(4,:));
    %Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:) + [300, 0, 300, 0], 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.fourText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(4,:));
    % 5 (new)
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(5,:));
    %Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:) + [600, 0, 600, 0], 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.fiveText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(5,:));
    
%     % show the machine - no need
%     Screen('DrawTexture', ioProbeStruct.wPtr, ioProbeStruct.machine, [], ioProbeStruct.rectMachine(1,:));
%     % show the stimulus - no need
%     Screen('DrawTexture', ioProbeStruct.wPtr, ioProbeStruct.trialTexture(trialSpec.trialID), [], ioProbeStruct.rectImage(1,:));
%     % show feedback - no need
%     tumbleText = '????';
%     Screen('FillRect', ioProbeStruct.wPtr, [220 220 220], ioProbeStruct.rectOutcome(1,:));
%     Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.rectOutcome(1,:), 5);
%     Screen('TextSize', ioProbeStruct.wPtr, 30);
%     DrawFormattedText(ioProbeStruct.wPtr, tumbleText, 'center', ioProbeStruct.rectOutcome(1,4)-20, [0, 0, 0], [], [], [], [], [], ioProbeStruct.rectOutcome(1,:) );
%     % show the Old button - no need
%     Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(1,:));
%     Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:), 5);
%     DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.oldButtonText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(1,:) );
%     % show the New button - no need
%     Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(2,:));
%     Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(2,:), 5);
%     DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.newButtonText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(2,:) );
    
    % show the stimuli after all keys are released
    KbReleaseWait(-3);
    [~, tStimOn] = Screen(ioProbeStruct.wPtr, 'Flip', 0, 1);
    
%     Gail debugging
%     probeStruct.probeOrder(tI)
%     trialSpec.imageOrder
    
    % wait for response
    [tRespOn, keyCode] = KbWait(-3, 2);
    trialSpec.RT = tRespOn - tStimOn;
    pressedKey = find(keyCode);
    
%     % capture selected stimulus
%     if ismember(pressedKey, ioProbeStruct.respKey_1)
%         % left response
%         trialSpec.respKey = ioProbeStruct.LEFT;
%         trialSpec.resp = probeTaskStruct.OLD;
%     elseif ismember(pressedKey, ioProbeStruct.respKey_2)
%         % right response
%         trialSpec.respKey = ioProbeStruct.RIGHT;
%         trialSpec.resp = probeTaskStruct.NEW;
%     end
    

    % capture selected stimulus
    if ismember(pressedKey, ioProbeStruct.respKey_1)
        % one response
        trialSpec.respKey = 1; % ioProbeStruct.ONE;
%         trialSpec.resp = probeTaskStruct.OLDh;
%         
%         probeTaskStruct.OLDh = trialSpec.imageOrder(1); % does this now change when going through different trials?
        
        
    elseif ismember(pressedKey, ioProbeStruct.respKey_2)
        % two response
        trialSpec.respKey = 2; %ioProbeStruct.TWO;
%         trialSpec.resp = probeTaskStruct.OLDl;
%         
%         probeTaskStruct.OLDl = trialSpec.imageOrder(2); % modify this to make it fit to the current key press; make sure that the key press maps with the picture 
        
    elseif ismember(pressedKey, ioProbeStruct.respKey_3)
        % three response
        trialSpec.respKey = 3; %ioProbeStruct.THREE;
%         trialSpec.resp = probeTaskStruct.OLDn;
%         
%         probeTaskStruct.OLDn = trialSpec.imageOrder(3);
        
    elseif ismember(pressedKey, ioProbeStruct.respKey_4)
        % four response
        trialSpec.respKey = 4; %ioProbeStruct.FOUR;
%         trialSpec.resp = probeTaskStruct.OLDo;
%         
%         probeTaskStruct.OLDo = trialSpec.imageOrder(4);
        
    else ismember(pressedKey, ioProbeStruct.respKey_5)
        % five response
        trialSpec.respKey = 5; % ioProbeStruct.FIVE;
%         trialSpec.resp = probeTaskStruct.NEW;
%         
%         probeTaskStruct.NEW = trialSpec.imageOrder(5);
        
    end
    
    
    trialSpec.resp = find(trialSpec.imageOrder == trialSpec.respKey);
    trialSpec.acc = trialSpec.resp == 1;
    
    % frame the selected option
    Screen('FrameRect', ioProbeStruct.wPtr, [255 0 0], ioProbeStruct.buttonRect(trialSpec.respKey,:), 5);
    Screen(ioProbeStruct.wPtr, 'Flip');
    
    WaitSecs(1);
    % clear the screen
    Screen(ioProbeStruct.wPtr, 'Flip');
end % 