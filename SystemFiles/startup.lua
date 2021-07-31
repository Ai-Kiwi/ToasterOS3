local function BackGroundFlash(ColorID,waittime)
    term.setBackgroundColor(ColorID)
    term.clear()
    os.sleep(waittime)
end

os.pullEvent = os.pullEventRaw

--PrintNumber(3)
--PrintNumber(2)
--PrintNumber(1)

shell.run("ToasterOSUpdater.lua false true")

BackGroundFlash(colors.black,0.05)
BackGroundFlash(colors.gray,0.05)
BackGroundFlash(colors.lightGray,0.05)
BackGroundFlash(colors.white,0.05)
BackGroundFlash(colors.lightBlue,0.05)
BackGroundFlash(colors.blue,0.05)

while true do
    shell.run("SystemFiles/WindowManager.lua")
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.red)
    term.setBackgroundColor(colors.black)
    term.write("a big error has happen we will now boot you into toaster os installer soo you cna fix it")
    term.write("enter to continue")
    read()
    shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/installer.lua")
end


