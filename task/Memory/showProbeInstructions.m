function [] = showProbeInstructions(ioProbeStruct, instrDir)
    instrFiles = dir(fullfile(instrDir, '*.jpeg')); % change this to display new format of instructions

    % load task instruction images
    ioProbeStruct.instructions = nan(length(instrFiles),1);
    for iI = 1 : length(ioProbeStruct.instructions)
        ioProbeStruct.instructions(iI) = Screen('MakeTexture', ioProbeStruct.wPtr, imread(fullfile(instrDir, instrFiles(iI).name )));
    end
    
    % define forward/back keys for each screne (default to arrow keys)
    backKeys = repmat({KbName('leftarrow')}, length(ioProbeStruct.instructions), 1);
    nextKeys = repmat({KbName('rightarrow')}, length(ioProbeStruct.instructions), 1);
    % define response keys the move them forward
    %nextKeys{5} = ioProbeStruct.respKey_1; % change this if any slides requires a key press other than left or right arrow.
    nextKeys{7} = ioProbeStruct.respKey_4;
    nextKeys{end} = KbName('space');
    
    % initialize the instruction display; edit this to increase the size of
    % the instruction slides 
    instructionWidth = 1500 * 1;
    instructionHeight = 844 * 1;
    leftX = ioProbeStruct.centerX - (instructionWidth/2);
    topY = ioProbeStruct.centerY - (instructionHeight/2);
    ioProbeStruct.instructionRect = [leftX, topY, leftX+instructionWidth, topY+instructionHeight];
    
    % list of instructions to show
    instructions = 1:size(ioProbeStruct.instructions);
    % init the current instruction
    currentInst = 1;

    % loop until done signal
    doneInst = false;
    while ~doneInst
        % show instructions
        Screen('DrawTexture', ioProbeStruct.wPtr, ioProbeStruct.instructions(currentInst), [], ioProbeStruct.instructionRect );
        Screen(ioProbeStruct.wPtr, 'Flip');
        
        % wait for navigation input
        RestrictKeysForKbCheck( [backKeys{currentInst}, nextKeys{currentInst} ] );
        [~, keyCode] = KbWait(-3, 2);

        % update the current instructin according to key press
        respKey = find(keyCode);
        if ismember( respKey, nextKeys{currentInst} ) && currentInst == instructions(end)
            doneInst = true;
        elseif ismember( respKey, backKeys{currentInst} )
            % move back
            currentInst = max(1, currentInst-1);
        elseif ismember( respKey, nextKeys{currentInst} )
            % move forward
            currentInst = min(length(instructions), currentInst+1);
        end
    end
    
    RestrictKeysForKbCheck([]);
end