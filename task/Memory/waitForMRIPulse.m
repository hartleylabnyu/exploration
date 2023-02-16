function pulseTime = waitForMRIPulse(ioStruct)
    % wait for echo pulse
    Screen('TextSize', ioStruct.wPtr, 30);
    DrawFormattedText(ioStruct.wPtr, 'Paused for sync with MRI\n\n The game will begin shortly', 'center', 'center', [255 255 255]);
    Screen(ioStruct.wPtr, 'Flip');
    RestrictKeysForKbCheck(ioStruct.respMRIPulse);
    pulseTime = KbWait(-3,2);
    RestrictKeysForKbCheck([]);
    disp(['Pulse detected at ', num2str(pulseTime)]);
    Screen(ioStruct.wPtr, 'Flip');
end % function waitForPulse