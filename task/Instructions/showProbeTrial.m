function trialSpec = runProbeTrial(probeTaskStruct, ioProbeStruct, trialSpec)
    % only allow relevant keys
    RestrictKeysForKbCheck( [ioProbeStruct.respKey_1, ioProbeStruct.respKey_2] );
    
    % fixation to start trial
    Screen('TextSize', ioProbeStruct.wPtr, 40);
    Screen('TextColor', ioProbeStruct.wPtr, ioProbeStruct.textColor);
    DrawFormattedText(ioProbeStruct.wPtr, '+', 'center', 'center');
    Screen(ioProbeStruct.wPtr, 'Flip');
    WaitSecs(1);
    
    % show the machine
    Screen('DrawTexture', ioProbeStruct.wPtr, ioProbeStruct.machine, [], ioProbeStruct.rectMachine(1,:));
    % show the stimulus
    Screen('DrawTexture', ioProbeStruct.wPtr, ioProbeStruct.trialTexture(trialSpec.trialID), [], ioProbeStruct.rectImage(1,:));
    % show feedback
    tumbleText = '????';
    Screen('FillRect', ioProbeStruct.wPtr, [220 220 220], ioProbeStruct.rectOutcome(1,:));
    Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.rectOutcome(1,:), 5);
    Screen('TextSize', ioProbeStruct.wPtr, 30);
    DrawFormattedText(ioProbeStruct.wPtr, tumbleText, 'center', ioProbeStruct.rectOutcome(1,4)-20, [0, 0, 0], [], [], [], [], [], ioProbeStruct.rectOutcome(1,:) );
    % show the Old button
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(1,:));
    Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(1,:), 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.oldButtonText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(1,:) );
    % show the New button
    Screen('FillRect', ioProbeStruct.wPtr, [100 100 100], ioProbeStruct.buttonRect(2,:));
    Screen('FrameRect', ioProbeStruct.wPtr, [0 0 0], ioProbeStruct.buttonRect(2,:), 5);
    DrawFormattedText(ioProbeStruct.wPtr, ioProbeStruct.newButtonText, 'center', 'center', [255, 255, 255], [], [], [], [], [], ioProbeStruct.buttonRect(2,:) );
    % show the stimuli after all keys are released
    KbReleaseWait(-3);
    [~, tStimOn] = Screen(ioProbeStruct.wPtr, 'Flip', 0, 1);
    
    % wait for response
    [tRespOn, keyCode] = KbWait(-3, 2);
    trialSpec.RT = tRespOn - tStimOn;
    pressedKey = find(keyCode);
    
    % capture selected stimulus
    if ismember(pressedKey, ioProbeStruct.respKey_1)
        % left response
        trialSpec.respKey = ioProbeStruct.LEFT;
        trialSpec.resp = probeTaskStruct.OLD;
    elseif ismember(pressedKey, ioProbeStruct.respKey_2)
        % right response
        trialSpec.respKey = ioProbeStruct.RIGHT;
        trialSpec.resp = probeTaskStruct.NEW;
    end
    
    % frame the selected option
    Screen('FrameRect', ioProbeStruct.wPtr, [255 0 0], ioProbeStruct.buttonRect(trialSpec.respKey,:), 5);
    Screen(ioProbeStruct.wPtr, 'Flip');
    WaitSecs(1);
    % clear the screen
    Screen(ioProbeStruct.wPtr, 'Flip');
end % 