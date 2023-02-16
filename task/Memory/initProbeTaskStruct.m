function probeTaskStruct = initProbeTaskStruct(taskStruct)
    % define the block struture
    probeTaskStruct = struct();
    
    % reward difficult; the idea is to have fixed keys that go with the
    % image and indicate what was pressed
    probeTaskStruct.OLDh = 1; % old image with high value
    probeTaskStruct.OLDl = 2; % old image with low value
    probeTaskStruct.OLDn = 3; % old novel/holdout image
    probeTaskStruct.OLDo = 4; % old image from different block
    probeTaskStruct.NEW = 5; % new image 
    
%     % reward difficulty 
%     probeTaskStruct.OLD = 1;
%     probeTaskStruct.NEW = 0;
    
    isFamiliar = any(taskStruct.allTrials.isTrialStim, 1)'; % in here 0 = old image; 1 = new image
    isFamiliar = [isFamiliar; false(size(isFamiliar))];
    isFamiliar = isFamiliar(randperm(length(isFamiliar)));
    respKey = nan(size(isFamiliar));
    resp = nan(size(isFamiliar));
    RT = nan(size(isFamiliar));
    trialID = (1:length(isFamiliar))';
    probeTaskStruct.allTrials = table(trialID, isFamiliar, respKey, resp, RT);    
end