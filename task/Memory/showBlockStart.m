function tBlockStart = showBlockStart(ioStruct, blockID)
    % clear screen show the casino name
    Screen('TextSize', ioStruct.wPtr, 30);
    Screen('TextColor', ioStruct.wPtr, [0 0 0]);
    Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    Screen(ioStruct.wPtr, 'Flip');
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.casinoStim(blockID), [], ioStruct.casinoRect);
    blockName = ioStruct.casinoNames{blockID}; 
    blockName = blockName(8:end-4);
    blockName(findstr(blockName, '_'))=' '; 
    creatureName = ioStruct.creatureNames{blockID}; 
    creatureName = creatureName(10:end-5);
    creatureName(findstr(creatureName, '_'))=' ';
    Screen('FillRect', ioStruct.wPtr, [255, 255, 255], [ioStruct.centerX-300, ioStruct.centerY-260, ioStruct.centerX+300, ioStruct.centerY-180]);
    DrawFormattedText(ioStruct.wPtr, ['Welcome to the ' blockName '\nThis region is owned by the ' creatureName], 'center', ioStruct.centerY - 225, [75 0 130]);
    Screen('FillOval', ioStruct.wPtr, [255, 255, 255], [ioStruct.centerX-200, ioStruct.centerY-175, ioStruct.centerX+200, ioStruct.centerY+175]);
    Screen('DrawTexture', ioStruct.wPtr, ioStruct.creatureStim(blockID), [], ioStruct.creatureBlockRect);
    %DrawFormattedText(ioStruct.wPtr, 'Welcome to...', 'center', ioStruct.casinoRect(2) - 100, [255 255 255]); 
    [~, tBlockStart] = Screen(ioStruct.wPtr, 'Flip');
    WaitSecs(ioStruct.BLOCK_START_WAIT);
    Screen(ioStruct.wPtr, 'Flip');
end % function waitForPulse