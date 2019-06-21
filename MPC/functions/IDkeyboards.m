function deviceIndex = IDkeyboards (kbStruct)
devices = PsychHID('Devices');
kbs = find ([devices(:).usageValue] == 6); %value of keyboard

deviceIndex = [];
for mm =1:length(kbs)
    if strcmp(devices(kbs(mm)).product, kbStruct.product) && ...
            ismember(devices(kbs(mm)).vendorID, kbStruct.vendorID)
        deviceIndex = kbs(mm);
    end
    
end
if isempty(deviceIndex)
    error('No %s detected on the system', kbStruct.product);   
end


return