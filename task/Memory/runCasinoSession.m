function taskStruct = runCasinoSession(taskStruct, ioStruct, sessionTrials)

    % loop through all trials
    for tI = 1:length(sessionTrials)
        % pull out block and trial IDs
        currentBlockID = taskStruct.allTrials.blockID(sessionTrials(tI));
        currentTrialID = taskStruct.allTrials.trialID(sessionTrials(tI));
        disp(['block: ' num2str(currentBlockID), '; trial: ' num2str(currentTrialID)]);
        
        % is this the first trial in the block?
        if currentTrialID == 1
            taskStruct.tBlockStart(currentBlockID) = showBlockStart(ioStruct, currentBlockID);
        end
        
        % run the trial and save the data
        taskStruct.allTrials(sessionTrials(tI),:) = showCasinoTrial(ioStruct, taskStruct, taskStruct.allTrials(sessionTrials(tI),:), currentBlockID);
        save(fullfile(taskStruct.outputFolder, taskStruct.fileName), 'ioStruct', 'taskStruct');
        
        % is this the last trial in the block
        isLastBlockTrial = currentTrialID == max(taskStruct.allTrials.trialID( taskStruct.allTrials.blockID == currentBlockID ));
        
        if isLastBlockTrial
            % show block complete
            blockTrials = taskStruct.allTrials.blockID == currentBlockID;
            blockScore = nansum(taskStruct.allTrials.outcome( blockTrials ));
            taskStruct.tBlockEnd(currentBlockID) = showBlockEnd(ioStruct, blockScore);
        end        
    end % for each trial
end % casino session function


