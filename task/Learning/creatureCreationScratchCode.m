
% put trial creature 9/10 of the way across the screen and 9/10 of the way
% down the screen
dispStruct.creatureX = round(dispStruct.wPtrRect(3)*.9);
dispStruct.creatureY = round(dispStruct.wPtrRect(4)*.9);

% Get center point so can put the circle there
dispStruct.centerCreatureX = round(dispStruct.creatureX / 2);
dispStruct.centerCreatureY = round(dispStruct.creatureY / 2);

% Creatures


% Draw circle for trial
Screen('FillOval', ioStruct.wPtr, [255, 255, 255], [ioStruct.centerCreatureX-75, ioStruct.centerCreatureY-75, ioStruct.centerCreatureX+75, ioStruct.centerCreatureY+75]);

% Block start code for creature
creatureName = ioStruct.casinoNames{blockID}; 
creatureName = creatureName(8:end-4); % fix the numbers here
creatureName(findstr(creatureName, '_'))=' '; 


   