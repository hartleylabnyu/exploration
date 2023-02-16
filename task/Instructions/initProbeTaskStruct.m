function probeTaskStruct = initProbeTaskStruct(taskStruct)
    % define the block struture
    probeTaskStruct = struct();
    % reward difficulty 
    probeTaskStruct.OLD = 1;
    probeTaskStruct.NEW = 0;
    
    isFamiliar = any(taskStruct.allTrials.isTrialStim, 1)';
    isFamiliar = [isFamiliar; false(size(isFamiliar))];
    isFamiliar = isFamiliar(randperm(length(isFamiliar)));
    respKey = nan(size(isFamiliar));
    resp = nan(size(isFamiliar));
    RT = nan(size(isFamiliar));
    trialID = (1:length(isFamiliar))';
    probeTaskStruct.allTrials = table(trialID, isFamiliar, respKey, resp, RT);    
end