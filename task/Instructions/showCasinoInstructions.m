function [] = showCasinoInstructions(ioStruct, instrDir)
    %instrFiles = dir(fullfile(instrDir, '*.png'));
    instrFiles = dir(fullfile(instrDir, '*.jpeg'));

    % load task instruction images
    ioStruct.instructions = nan(length(instrFiles),1);
    for iI = 1 : length(ioStruct.instructions)
        ioStruct.instructions(iI) = Screen('MakeTexture', ioStruct.wPtr, imread(fullfile(instrDir, instrFiles(iI).name )));
    end
    
    % define forward/back keys for each screne (default to arrow keys)
    backKeys = repmat({KbName('leftarrow')}, length(ioStruct.instructions), 1);
    nextKeys = repmat({KbName('rightarrow')}, length(ioStruct.instructions), 1);
    % define response keys the move them forward
%     nextKeys{7} = ioStruct.respKey_1;
%     nextKeys{10} = ioStruct.respKey_2;
%     nextKeys{17} = KbName('K');
%     nextKeys{19} = KbName('F');
%     nextKeys{21} = KbName('J');
%     nextKeys{23} = KbName('J');
%     nextKeys{25} = ioStruct.respKey_1;
%     nextKeys{27} = ioStruct.respKey_2;
%     nextKeys{29} = KbName('space');

    nextKeys{9} = ioStruct.respKey_1;
    nextKeys{11} = ioStruct.respKey_2;
    nextKeys{19} = KbName('K');
    nextKeys{21} = KbName('F');
    nextKeys{23} = KbName('J');
    %nextKeys{25} = KbName('F');
    nextKeys{25} = KbName('space');
    
    % initialize the instruction display
    instructionWidth = 1440 * 1 %960 * 1;
    instructionHeight = 810 * 1 %540 * 1;
    leftX = ioStruct.centerX - (instructionWidth/2);
    topY = ioStruct.centerY - (instructionHeight/2);
    ioStruct.instructionRect = [leftX, topY, leftX+instructionWidth, topY+instructionHeight];
    
    % list of instructions to show
    instructions = 1:size(ioStruct.instructions);
    % init the current instruction
    currentInst = 1;

    % loop until done signal
    doneInst = false;
    while ~doneInst
        % show instructions
        Screen('DrawTexture', ioStruct.wPtr, ioStruct.instructions(currentInst), [], ioStruct.instructionRect );
        Screen(ioStruct.wPtr, 'Flip');
        
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