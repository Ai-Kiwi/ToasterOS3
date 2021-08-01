local moniterwidth, moniterhight = term.getSize()
local LoopsNeededToBoot = 3
local function BackGroundFlash(ColorID,waittime)
    term.setBackgroundColor(ColorID)
    term.clear()
    os.sleep(waittime)
end

local function LoadIntoOS()
    shell.run("ToasterOSUpdater.lua false true")
    
    
    BackGroundFlash(colors.black,0.05)
    BackGroundFlash(colors.gray,0.05)
    BackGroundFlash(colors.lightGray,0.05)
    BackGroundFlash(colors.white,0.05)
    BackGroundFlash(colors.lightBlue,0.05)
    BackGroundFlash(colors.blue,0.05)
    
    while true do
        shell.run("SystemFiles/WindowManager.lua")
        os.sleep(5)
        term.clear()
        term.setCursorPos(1,1)
        term.setTextColor(colors.red)
        term.setBackgroundColor(colors.black)
        print("a big error has happen we will now boot you into toaster os installer soo you cna fix it")
        print("enter to continue")
        read()
        shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/installer.lua")
    end
end
term.clear()
term.setCursorPos(1,1)

os.pullEvent = os.pullEventRaw

--loads in bios settings
settings.load("ToasterOSbios")
LoopsNeededToBoot = settings.get("Time before booting")
if LoopsNeededToBoot == nil then LoopsNeededToBoot = 3 settings.set("Time before booting",LoopsNeededToBoot) end
settings.save("ToasterOSbios")





--boots into os
print("press F6 for bios, booting in " .. LoopsNeededToBoot .. "s")
while true do

    local TimeID = os.startTimer(1)
    EventName, Event1, Event2 = os.pullEvent()
    if EventName == "key" then
        if Event1 == keys.f6 then

        end

    elseif EventName == "timer" then
        LoopsNeededToBoot = LoopsNeededToBoot - 1
        print("press F6 for bios, booting in " .. LoopsNeededToBoot .. "s")
        if LoopsNeededToBoot < 1 then
            LoadIntoOS()
            printError("loading into os failed")
            os.sleep(2)
            shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/installer.lua")
        end
        
    end
    os.cancelTimer(TimeID)
end










