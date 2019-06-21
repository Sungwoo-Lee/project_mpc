addpath(genpath(pwd));

device(1).product = 'Magic Keyboard'; 
device(1).vendorID= 1452;

device(2).product = 'Apple Internal Keyboard / Trackpad'; 
device(2).vendorID= 1452;

magic = IDkeyboards(device(1));
internal = IDkeyboards(device(2));

while true
    [~,~,keyCode] = KbCheck(magic);
    [~,~,keyCode2] = KbCheck(internal);
    
    if keyCode(KbName('s'))==1
        break
    elseif keyCode2(KbName('q'))==1
        break
    end
    
end