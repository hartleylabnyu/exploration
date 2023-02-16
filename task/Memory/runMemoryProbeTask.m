% Memory Task - adapted by MS & GS September 2019
% Initialization 
clear all;

% some initial global setup
RandStream.setGlobalStream(RandStream('mt19937ar','Seed','shuffle'));
RestrictKeysForKbCheck( [] );
Screen('Preference','VisualDebugLevel', 0); % this prevents the red (!) to appear
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');

% % this allows me to access the data from sub 301
% load('../data/301_Sub_ExpExpTask_08-19-2019_15-43-19.mat')

% prompt for data path if it's not already in the environment
if (~exist('taskStruct', 'var'))
    [file,path] = uigetfile;
    load( fullfile(path, file), 'probeStruct', 'taskStruct', 'ioStruct');
    %load( fullfile(path, file));
    clear file path;
end

memFileName = strcat(taskStruct.subID,'_memProbeOutput.mat');

taskProbeStruct = initProbeTaskStruct(taskStruct);
ioProbeStruct = initProbeIO(taskStruct, ioStruct, fullfile('.', 'images', 'memoryProbe', 'stimuli'), taskProbeStruct); % Build full file name from parts: . = where the script lives; images = folder; memoryProbe & stimuli = subfolder


firsthalforder=randperm(5);
secondhalforder = randperm(5);
secondhalforder = secondhalforder+5;
probeStruct.probeOrder = [];
count = 1;

for num = 1:5
   test = rand(1);
   if test > .5
       probeStruct.probeOrder(count) =  firsthalforder(num);       
       probeStruct.probeOrder(count+1) =  secondhalforder(num);
       count = count+2;
   else    
       probeStruct.probeOrder(count) =  secondhalforder(num);
       probeStruct.probeOrder(count+1) =  firsthalforder(num);  
       count = count+2;
   end
    
end

% 
% 
% % make a random memory trial order (added by GR & MS 9/19/19)
% probeStruct.probeOrder = randperm(10);



% define new images
oldImages = unique([probeStruct.highRewName probeStruct.lowRewName probeStruct.medRewName]);
allImages = dir(fullfile('.', 'pictures', 'task', 'stimuli', '1_*.jpeg'));
newImages = {};

for im = 1:size(allImages,1) % 1:all the images present in the folder

    if ~ismember(allImages(im).name,oldImages) % if the image presented is not an image previously presented then we label it as a newImage
        newImages = [newImages, allImages(im).name]; % all the images that were not presented are classified as newImages
    end

end

probeStruct.newImageOrder = randperm(15); % create a vector with 15 random numbers
probeStruct.newImageName = newImages(probeStruct.newImageOrder(1:10)); % this randomizes all 15 newImages and spits out the first 10 + loading new images into probeStruct (added by MS 9/26/19)

% find high reward stimuli from other block 
% list all high rewarding stimuli 
allhighRew = unique(probeStruct.highRewName);

for t = 1:size(probeStruct.highRewName,2) % this is defining the size of the for loop (10 images) 

    % identify all of the current trial images
    trialImages = [probeStruct.highRewName(t) probeStruct.lowRewName(t) probeStruct.medRewName(t)];
    possibleLureList = allhighRew(~ismember(allhighRew,trialImages)); % lurelist = high reward other block
    lurelistrand = possibleLureList(randperm(length(possibleLureList)));
    probeStruct.LureListName(t) = lurelistrand(1); % IS THIS THE CORRECT WAY TO PULL ONE STIMULUS OUT OF THE MATIRX?
%     probeStruct.LureListOrder = randperm(length(probeStruct.LureListName));
    
    % randomize the list of high rewarding images that are not presented in the current block
    %probeStruct.LureListOrder = randperm(length(possibleLureList));
    %probeStruct.LureListName = possibleLureList(probeStruct.LureListOrder);
   
    % Short cut: if I cannot print my LureListName in the loop --> lureimagelist(t) =  lureimage

end

% Short cut: if I cannot print my LureListName in the loop --> probeStruct.lureName = lureimagelist


% hide input to prevent participant from over-writing into the script
HideCursor(); ListenChar(2);

% open instructions
showProbeInstructions(ioProbeStruct, fullfile('.', 'images', 'memoryProbeInstructions'));

% loop through all trials
for tI = 1:10
    %tI = 1:size(taskProbeStruct.allTrials, 1)
    
    % record reaction times (added by MS 10/7/19)
    % record the beginning of the session
    probeStruct.tSessionStart(tI) = GetSecs();
    
    trialSpec = showProbeTrial(taskProbeStruct, ioProbeStruct, taskProbeStruct.allTrials(tI,:), probeStruct, tI);
    %taskProbeStruct.allTrials(tI,:) = showProbeTrial(taskProbeStruct, ioProbeStruct, taskProbeStruct.allTrials(tI,:), probeStruct, tI);
%     taskProbeStruct.allTrials(tI,:) = trialSpec;
    
    
    trialnum = probeStruct.probeOrder(tI);
    probeAnalysis.trialnum(tI) = trialnum;
    probeAnalysis.highRewImage(tI) = probeStruct.highRewName(trialnum);
    probeAnalysis.lowRewImage(tI) = probeStruct.lowRewName(trialnum);
    probeAnalysis.medRewImage(tI) = probeStruct.medRewName(trialnum);
    probeAnalysis.holdoutImage(tI) = probeStruct.holdout(trialnum);
    probeAnalysis.sceneNames(tI) = probeStruct.sceneNames(trialnum);
    probeAnalysis.creatureNames(tI) = probeStruct.creatureNames(trialnum);
    probeAnalysis.LureListName(tI) = probeStruct.LureListName(trialnum);
    probeAnalysis.newImageName(tI) = probeStruct.newImageName(trialnum);
    probeAnalysis.resp(tI) = trialSpec.resp;
    probeAnalysis.acc(tI) = trialSpec.acc;
    probeAnalysis.RT(tI) = trialSpec.RT;
    
    probeAnalysis.imageOrder(tI,:) = trialSpec.imageOrder;
    probeAnalysis.respKey(tI) = trialSpec.respKey;
    
    
    % save the data
    save(fullfile(taskStruct.outputFolder, memFileName), 'ioStruct', 'taskStruct', 'ioProbeStruct','probeAnalysis'); % 'taskProbeStruct',
    
    % track session duration
    probeStruct.tSessionEnd(tI) = GetSecs();
end


% show that we're done
% clear the screen
Screen(ioStruct.wPtr, 'Flip');
% show inter-block information
sessionEndText = 'You''re done!\n\n Please let the experimenter know that you''ve finished.';
Screen('TextSize', ioStruct.wPtr, 30);
Screen('TextColor', ioStruct.wPtr, [255 255 255]);
Screen('TextFont', ioStruct.wPtr, 'Helvetica');
DrawFormattedText(ioStruct.wPtr, sessionEndText, 'center', 'center');
% show feedback for prescribed time, then clear screen
Screen(ioStruct.wPtr, 'Flip');
RestrictKeysForKbCheck( KbName('space') );
KbWait(-3,2);

% clean up
ShowCursor();
ListenChar();
sca;