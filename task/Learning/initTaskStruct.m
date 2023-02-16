% Initialize the task structure (number of trials, familiar/novel stimuli entries, and reward probabilities)
function [taskStruct, probeStruct ]= initTaskStruct(numSessions, numBlocks, probeStruct)
    
    % define the block struture
    taskStruct = struct();
    % reward difficulty 
    taskStruct.EASY_REWARD = 0;
    taskStruct.HARD_REWARD = 1;
    % number of sessions to spead blocks across
    taskStruct.numSessions = numSessions;
    % number of trials in each block
    numTrialsPerBlock = zeros(numBlocks, 1) + 15;
    
    % set up novel/familiar stimuli in each block. 2 familiar, 1 novel
    numFamiliar = zeros(numBlocks, 1) + 2;
    numNovel = zeros(numBlocks, 1) + 1;
    % but only novel in the first block
    numFamiliar(1) = 0;
    numNovel(1) = 3;
    % default block difficulty to easy
    blockDifficulty = repmat(taskStruct.EASY_REWARD, numBlocks, 1);
    % spec the total number of stimuli required
    taskStruct.numStims = sum(numNovel);
    
    % hold a novel stimulus back for late insertion on half the blocks
    %
    % specify alternating blocks as having a novel holdout (except the first block where we introduce all stims to boost familiarity in block 2)
    numNovelHoldouts = zeros(numBlocks, 1); %specific for first block
    numNovelHoldouts(3:2:end) = 1;
    % which blocks include a novel holdout
    holdBlockID = find(numNovelHoldouts);
    % linear spacing of holdout trials to maximize variance; holdout sets in after trial 7
    minHoldAddinTrial = 7;
    holdoutTrials = round(linspace(minHoldAddinTrial, min(numTrialsPerBlock), length(holdBlockID)));
    % pseudo-randomize holdout trial to blocks with novel holdout stimulus; generates numbers 7 and above indicating when the holdhout sets in
    holdoutTrialOrder = zeros( size(holdBlockID) );
    holdoutTrialOrder(1:2:length(holdBlockID)) = 1:2:length(holdBlockID);
    holdoutTrialOrder(2:2:length(holdBlockID)) = fliplr(2:2:length(holdBlockID));
    novelHoldoutTrial = zeros( numBlocks, 1);
    novelHoldoutTrial(holdBlockID) = holdoutTrials(holdoutTrialOrder); %do we need this level of randomization?
    % make half the novel holdout trial hard
    blockDifficulty(holdBlockID(1:2:end)) = taskStruct.HARD_REWARD;
    
    % familiar holdout specification
    %
    % hold a single familiar stimulus holdout for blocks where we aren't already holding a novel stimulus out
    numFamiliarHoldouts = zeros(numBlocks, 1);
    numFamiliarHoldouts(2:2:end) = 1;
    holdBlockID = find(numFamiliarHoldouts);
    % linear spacing of holdout trials to maximize variance
    minHoldAddinTrial = 7;
    holdoutTrials = round(linspace(minHoldAddinTrial, min(numTrialsPerBlock), length(holdBlockID)));
    % pseudo-randomize holdout trial to blocks with novel holdout stimulus
    holdoutTrialOrder = zeros( size(holdBlockID) );
    holdoutTrialOrder(1:2:length(holdBlockID)) = 1:2:length(holdBlockID);
    holdoutTrialOrder(2:2:length(holdBlockID)) = fliplr(2:2:length(holdBlockID));
    familiarHoldoutTrial = zeros( numBlocks, 1);
    familiarHoldoutTrial(holdBlockID) = holdoutTrials(holdoutTrialOrder);
    % make half the familiar holdout trials hard
    blockDifficulty(holdBlockID(1:2:end)) = taskStruct.HARD_REWARD;
    
    % randomized feedback and ITI jitters for each session
    % we define this per session to ensure that all sessions are exactly the same time duration
    jitterIndex = 1;
    fbJitter = nan(sum(numTrialsPerBlock), 1 );
    itiJitter = nan(sum(numTrialsPerBlock), 1 );
    trialsPerSession = sum(numTrialsPerBlock(1:(numBlocks / taskStruct.numSessions)) );
    for sI = 1 : taskStruct.numSessions
        fbJitter(jitterIndex:jitterIndex+trialsPerSession-1) = randsample(linspace(1, 1, trialsPerSession), trialsPerSession);
        itiJitter(jitterIndex:jitterIndex+trialsPerSession-1) = randsample(linspace(1, 1, trialsPerSession), trialsPerSession);
        % move the index along
        jitterIndex = jitterIndex + trialsPerSession;
    end % for each session
    
    % collate block specs and build the trial structure wihtin each one
    blockSpecs = struct();
    blockSpecs.numTrialsPerBlock = numTrialsPerBlock;
    blockSpecs.numFamiliar = numFamiliar;
    blockSpecs.familiarHoldoutTrial = familiarHoldoutTrial;
    blockSpecs.numNovel = numNovel;
    blockSpecs.novelHoldoutTrial = novelHoldoutTrial;
    blockSpecs.blockDifficulty = blockDifficulty;
    taskStruct.blockSpecs = blockSpecs;
    

    % keep track of each stimulus exposure across trials
    numExpose = zeros(1, sum(blockSpecs.numNovel));
    jitterIndex = 1;
    allBlocks = [];
    for bI = 1 : numBlocks
        % get a new block, and updated stimulus exposure counts
        [currentBlock, probeStruct]= buildBlock(taskStruct, blockSpecs, numExpose, bI, probeStruct);
        % map in jitters to each trial
        currentBlock.fbJitter = fbJitter(jitterIndex:jitterIndex+blockSpecs.numTrialsPerBlock(bI)-1);
        currentBlock.itiJitter = itiJitter(jitterIndex:jitterIndex+blockSpecs.numTrialsPerBlock(bI)-1);
        % store the block of trials
        allBlocks = [allBlocks; currentBlock];
        
        % update the number of exposures
        numExpose = numExpose + sum(currentBlock.isTrialStim);
        % move the jitter index along
        jitterIndex = jitterIndex + blockSpecs.numTrialsPerBlock(bI);
    end % for each block
    
    taskStruct.allTrials = allBlocks;
end


