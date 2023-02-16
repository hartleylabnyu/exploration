function [blockStruct, probeStruct] = buildBlock(taskStruct, blockSpec, numExpose, bI, probeStruct)
    numStims = sum(blockSpec.numNovel);
    
    blockStruct = [];
    blockStruct.sessionID = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.blockID = repmat(bI, blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.trialID = (1:blockSpec.numTrialsPerBlock(bI))';
    blockStruct.trialStimID = nan(blockSpec.numTrialsPerBlock(bI), 2);
    blockStruct.RT = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.respKey = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.selectedStimID = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.outcome = nan(blockSpec.numTrialsPerBlock(bI), 1);
    % event timing information
    blockStruct.tFixOn = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.tStimOn = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.tRespOn = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.tFBOn = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.tFBOff = nan(blockSpec.numTrialsPerBlock(bI), 1);
    % jitter durations
    blockStruct.fbJitter = nan(blockSpec.numTrialsPerBlock(bI), 1);
    blockStruct.itiJitter = nan(blockSpec.numTrialsPerBlock(bI), 1);
    % trial binary flags
    blockStruct.isTrialStim = false(blockSpec.numTrialsPerBlock(bI), numStims);
    blockStruct.isSelected = false(blockSpec.numTrialsPerBlock(bI), numStims);
    blockStruct.isSelectedWin = false(blockSpec.numTrialsPerBlock(bI), numStims);
    blockStruct.isWin = false(blockSpec.numTrialsPerBlock(bI), numStims);
    
    % trial at which holdout stimulus is added back in
    novelHoldoutStimID = [];
    familiarHoldoutStimID = [];
    
    
    % extract indices of novel stimuli, and randomly sample the number required to build the block
    novelStims = find(numExpose == 0);
    novelStims = novelStims( randsample(length(novelStims), blockSpec.numNovel(bI)) );
    
    % do the same for familiar stimuli
    familiarStims = find(numExpose > 3);
    familiarStims = familiarStims( randsample(length(familiarStims), blockSpec.numFamiliar(bI)) );
    
    % collate novel & familiar to form set of available stimuli
    blockStimID = [novelStims, familiarStims];
    
    
    % USE VARIABLES TO SPECIFY REWARD VALUES
    % assign reward probabilities to available options according to block difficulty
    if blockSpec.blockDifficulty(bI) == taskStruct.EASY_REWARD
        % more widely spaced reward probabilities
        easyRew = linspace(0.2, 0.8, length(blockStimID));
        pWin( blockStimID ) = randsample(easyRew, length(blockStimID), false); % pWin assigns reward probability to stimuli 
    else
        % make one bad, and the rest roughly equal
        hardRew = linspace(0.3, 0.7, length(blockStimID)); % hard reward propability has been changed to 70/30 to make it more appropriate to children
%         hardRew(1) = 0.2;
        pWin( blockStimID ) = randsample(hardRew, length(blockStimID), false);
    end
    

    
    % specify outcome for each option on each trial according to reward probabilty should it be selected (changed by MS 10/28/2019)
    for sI = 1 : length(blockStimID)
        numWins = round(blockSpec.numTrialsPerBlock(bI)*pWin(blockStimID(sI)));
        blockStruct.isWin(randsample(blockSpec.numTrialsPerBlock(bI), numWins), blockStimID(sI)) = 1;
        if pWin(blockStimID(sI)) >= .7
            probeStruct.highRew(bI)=blockStimID(sI);
        elseif pWin(blockStimID(sI)) == .5
            probeStruct.medRew(bI)=blockStimID(sI);
        elseif pWin(blockStimID(sI)) <= .3
             probeStruct.lowRew(bI)=blockStimID(sI);
        else
            error('issue with number of wins')
        end
    end
    
%         % specify outcome for each option on each trial according to reward probabilty should it be selected
%     for sI = 1 : length(blockStimID)
%         numWins = round(blockSpec.numTrialsPerBlock(bI)*pWin(blockStimID(sI)));
%         blockStruct.isWin(randsample(blockSpec.numTrialsPerBlock(bI), numWins), blockStimID(sI)) = 1;
%         if pWin(blockStimID(sI)) > .5
%             probeStruct.highRew(bI)=blockStimID(sI);
%         elseif pWin(blockStimID(sI)) == .5
%             probeStruct.holdoutRew(bI)=blockStimID(sI);
%         elseif pWin(blockStimID(sI)) < .5
%              probeStruct.lowRew(bI)=blockStimID(sI);
%         else
%             error('issue with number of wins')
%         end
%     end

% initializing holdout value for this trial
    probeStruct.holdout(bI) = 0; %added by GR

    % pick a holdout novel stimulus if we need one
    if blockSpec.novelHoldoutTrial(bI) > 0
        novelHoldoutStimID = novelStims(1);
        probeStruct.holdout(bI) = novelHoldoutStimID; %added by GR
    end
    % pick a holdout familiar stimulus if we need one
    if blockSpec.familiarHoldoutTrial(bI) > 0
        familiarHoldoutStimID = familiarStims(1);
        probeStruct.holdout(bI) = familiarHoldoutStimID; %added by GR
    end
    
    
    % loop through trials to specify options available on each trial
    isAvailableStim = false( size(numExpose) );
    isAvailableStim(setdiff(blockStimID, [novelHoldoutStimID, familiarHoldoutStimID])) = 1;    
    for tI = 1 : blockSpec.numTrialsPerBlock(bI)
        % flags noting which stimuli will be available on this trial
        isTrialStim = false( size(numExpose) );
        
        % is this a novel holdout introduction trial
        if tI == blockSpec.novelHoldoutTrial(bI)           
            isAvailableStim(novelHoldoutStimID) = 1;
            isTrialStim(novelHoldoutStimID) = 1;
        end

        % is this a familiar holdout introduction trial
        if tI == blockSpec.familiarHoldoutTrial(bI)
            isAvailableStim(familiarHoldoutStimID) = 1;
            isTrialStim(familiarHoldoutStimID) = 1;
        end
        
        % fill in trial stims with sampling from available options
        isTrialStim( randsample(find(isAvailableStim & ~isTrialStim), 2-sum(isTrialStim), false) ) = true;
        % randomize left/right ordering and store
        blockStruct.trialStimID(tI,:) = randsample(find(isTrialStim), 2);
        blockStruct.trialStimID(tI,:) = blockStruct.trialStimID(tI, randperm(2));
        blockStruct.isTrialStim(tI, blockStruct.trialStimID(tI,:)) = 1;
    end % for each trial
    
    % convert to table (named matrix)
    blockStruct = struct2table(blockStruct);
    
    % added to facilitate memory probe stim presentation by MS and GR on
    % 9/18/19
%     probeStruct.highRew(bI) = find(pWin(blockStimID(1)) > .5);
%     probeStruct.lowRew(bI) = find(pWin < .5 & pWin > 0);
%     probeStruct.holdoutRew(bI) = find(pWin == .5);

    
end