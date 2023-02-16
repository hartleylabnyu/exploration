function tBlockEnd = showBlockEnd(ioStruct, blockScore)
    % list of play initials
%     playerInitials = 'ABCDEFGHIJKLMNOPRSTVW';
%     numHighScores = 4;
%     firstInitials = randsample(playerInitials, numHighScores, true);
%     secondInitials = randsample(playerInitials, numHighScores, true);
%     points = sort( randi(10, numHighScores, 1), 'descend' );
%     % construct the high-score string
%     highScores = cell(numHighScores,1);
%     for hI = 1 : numHighScores
%         highScores{hI} = [num2str(hI) ': ' firstInitials(hI) '. ' secondInitials(hI) '\n' num2str(points(hI)) ' tokens\n\n'];
%     end % for each
    % show inter-block information
    %scoreText = ['You won: ' num2str(blockScore) ' tokens \n\n\nLeader Board\n\n', strjoin(highScores)];
    scoreText = ['You won: ' num2str(blockScore) ' tokens'];
    
    %Screen('TextSize', ioStruct.wPtr, 30);
    Screen('TextSize', ioStruct.wPtr, 45);
    Screen('TextColor', ioStruct.wPtr, [255 255 255]);
    Screen('TextFont', ioStruct.wPtr, 'Helvetica');
    % clear the screen, then show tet
    Screen(ioStruct.wPtr, 'Flip');
    DrawFormattedText(ioStruct.wPtr, scoreText, 'center', 'center');
    [~, tBlockEnd] = Screen(ioStruct.wPtr, 'Flip');
    WaitSecs(ioStruct.BLOCK_END_WAIT);
    Screen(ioStruct.wPtr, 'Flip');
end