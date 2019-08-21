addpath(genpath(pwd));

PsychHID('Devices')

device(1).product = 'Apple Keyboard'; 
device(1).vendorID= 1452;

device(2).product = 'KeyWarrior8 Flex'; 
device(2).vendorID= 1984;

apple = IDkeyboards(device(1));
sync_box = IDkeyboards(device(2));

while true
    [~,~,keyCode] = KbCheck(sync_box);
    [~,~,keyCode2] = KbCheck(apple);
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode2(KbName('q'))==1
        break
    end
    
end