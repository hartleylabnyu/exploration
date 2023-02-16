function trialSpec = showCasinoTrial(ioStruct, taskStruct, trialSpec, blockID)
    % only allow relevant keys
    RestrictKeysForKbCheck( [ioStruct.respKey_1, ioStruct.respKey_2] );
    
    % jittered fixation to start trial
    startTime = GetSecs();
    Screen('TextSize', ioStruct.wPtr, 40);
    Screen('TextColor', ioStruct.wPtr, ioStruct.textColor);
    DrawFormattedText(ioStruct.wPtr, '+', 'center', 'center');
    Screen(ioStruct.wPtr, 'Flip', 0);
    % final duration we change color/size to cue trial start
    Screen('TextSize', ioStruct.wPtr, 60);
    Screen('TextColor', ioStruct.wPtr, [0 255 0]);
    DrawFormattedText(ioStruct.wPtr, '+', 'center', 'center');
    [~, trialSpec.tFixOn] = Screen(ioStruct.wPtr, 'Flip', startTime + trialSpec.itiJitter - ioStruct.FIX_DURATION);
    % clear fixation
    Screen(ioStruct.wPtr, 'Flip', startTime + trialSpec.itiJitter);
    
    % draw background location
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.casinoStim(blockID), [], ioStruct.casinoRect);
    
    % Show creatures in corner
    Screen('FillOval', ioStruct.wPtr, [255, 255, 255], [ioStruct.creatureX-85, ioStruct.creatureY-60, ioStruct.creatureX+85, ioStruct.creatureY+60]);
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.creatureStim(blockID), [], ioStruct.creatureTrialRect);

    % show the stimuli
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.stims(trialSpec.trialStimID(1)), [], ioStruct.rectImage(1,:));
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.stims(trialSpec.trialStimID(2)), [], ioStruct.rectImage(2,:));
    
    % outcome boxes
    tumbleText = '????';
    Screen('FillRect', ioStruct.wPtr, [220 220 220], ioStruct.rectOutcome(1,:), 5);
    Screen('FillRect', ioStruct.wPtr, [220 220 220], ioStruct.rectOutcome(2,:), 5);
    Screen('FillRect', ioStruct.wPtr, [255 255 255], ioStruct.rectOutcome(1,:), 5);
    Screen('FillRect', ioStruct.wPtr, [255 255 255], ioStruct.rectOutcome(2,:), 5);
    Screen('FrameRect', ioStruct.wPtr, [0 0 0], ioStruct.rectOutcome(1,:), 5);
    Screen('FrameRect', ioStruct.wPtr, [0 0 0], ioStruct.rectOutcome(2,:), 5);
    Screen('TextSize', ioStruct.wPtr, 30);
    DrawFormattedText(ioStruct.wPtr, tumbleText, 'center', ioStruct.rectOutcome(1,4)-20, [0, 0, 0], [], [], [], [], [], ioStruct.rectOutcome(1,:) );
    DrawFormattedText(ioStruct.wPtr, tumbleText, 'center', ioStruct.rectOutcome(2,4)-20, [0, 0, 0], [], [], [], [], [], ioStruct.rectOutcome(2,:) );
    
    % remove fixation after all keys are released
    KbReleaseWait(-3);
    [~, trialSpec.tStimOn] = Screen(ioStruct.wPtr, 'Flip', 0, 1);
    
    % wait for response and store RT
    [trialSpec.tRespOn, keyCode] = KbWait(-3, 2, GetSecs() + ioStruct.MAX_RT);
    trialSpec.RT = trialSpec.tRespOn - trialSpec.tStimOn;
    pressedKey = find(keyCode);
    
    % capture selected stimulus
    if ismember(pressedKey, ioStruct.respKey_1)
        % left response
        trialSpec.respKey = ioStruct.LEFT;
    elseif ismember(pressedKey, ioStruct.respKey_2)
        % right response
        trialSpec.respKey = ioStruct.RIGHT;
    end
    
    % was a valid response captured
    if ~isnan(trialSpec.respKey)
        % track response features
        trialSpec.selectedStimID = trialSpec.trialStimID(trialSpec.respKey);
        trialSpec.outcome = trialSpec.isWin(trialSpec.selectedStimID);
        trialSpec.isSelected(trialSpec.selectedStimID) = 1;
        trialSpec.isSelectedWin(trialSpec.selectedStimID) = trialSpec.isWin(trialSpec.selectedStimID);
        % show outcome
        trialSpec = showOutcome(ioStruct, trialSpec, tumbleText);
    else
        % no valid response - show too slow error
        trialSpec = showTooSlow(ioStruct, trialSpec);
    end
    
    % clear the screen of whatever was there
    Screen(ioStruct.wPtr, 'Flip', 0);
end

function trialSpec = showOutcome(ioStruct, trialSpec, tumbleText)
    % show the 'selected' machine, and re-draw it's stimulus
    %Screen('DrawTexture', ioStruct.wPtr, ioStruct.machineSelected, [], ioStruct.rectMachine(trialSpec.respKey,:));
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.stims(trialSpec.trialStimID(trialSpec.respKey)), [], ioStruct.rectImage(trialSpec.respKey,:));

    % run the tumblers to implement the feedback jitter
    startTime = GetSecs();
    tumblerTicks = startTime : trialSpec.fbJitter / length(tumbleText) : startTime + trialSpec.fbJitter;
    for tickI = 1 : length(tumblerTicks)-1
        % re-draw the outcome textbox
        tumbleText((length(tumbleText)-tickI+1):end) = '*';
        %Screen('FillRect', ioStruct.wPtr, [220 220 220], ioStruct.rectOutcome(trialSpec.respKey,:), 5);
        Screen('FillRect', ioStruct.wPtr, [255 255 255], ioStruct.rectOutcome(trialSpec.respKey,:), 5);
        %Screen('FrameRect', ioStruct.wPtr, [0 0 0], ioStruct.rectOutcome(trialSpec.respKey,:), 5);
        DrawFormattedText(ioStruct.wPtr, tumbleText, 'center', ioStruct.rectOutcome(1,4)-20, [0, 0, 0], [], [], [], [], [], ioStruct.rectOutcome(trialSpec.respKey,:) );
        %Screen('FrameRect', ioStruct.wPtr, [0, 0, 255], ioStruct.rectOutcome(1,4)-20, 3);
        Screen(ioStruct.wPtr, 'Flip', tumblerTicks(tickI), 1);
    end
    % pause with final block of tumblers prior to showing outcome
    Screen(ioStruct.wPtr, 'Flip', tumblerTicks(end), 1);
    
    % show win or loss token
    if trialSpec.outcome > 0
        outcomeToken = ioStruct.tokenWin;
    else
        outcomeToken = ioStruct.tokenLoss;
    end
    
    % show the outcome
    Screen('FillRect', ioStruct.wPtr, [255 255 255], ioStruct.rectOutcome(trialSpec.respKey,:), 5);
    Screen('DrawTexture', ioStruct.wPtr, outcomeToken, [], ioStruct.rectToken(trialSpec.respKey,:));
    %Screen('FrameRect', ioStruct.wPtr, [0 0 0], ioStruct.rectOutcome(trialSpec.respKey,:), 5);
    
    % show feedback for prescribed time, then clear screen
    [~, trialSpec.tFBOn] = Screen(ioStruct.wPtr, 'Flip');
    [~, trialSpec.tFBOff] = Screen(ioStruct.wPtr, 'Flip', GetSecs() + ioStruct.REW_DURATION);
end

function trialSpec = showTooSlow(ioStruct, trialSpec)
    % clear the screen
    Screen(ioStruct.wPtr, 'Flip');
    % show error text
    slowText = ['Too Slow!\n\n Please make your choice within ' num2str(ioStruct.MAX_RT) ' seconds'];
    Screen('TextSize', ioStruct.wPtr, 30);
    Screen('TextColor', ioStruct.wPtr, [255 0 0]);
    Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    DrawFormattedText(ioStruct.wPtr, slowText, 'center', 'center');
    % show feedback for prescribed time, then clear screen
    [~, trialSpec.tFBOn] = Screen(ioStruct.wPtr, 'Flip');
    [~, trialSpec.tFBOff] = Screen(ioStruct.wPtr, 'Flip', GetSecs() + ioStruct.REW_DURATION);
end