local function BackGroundFlash(ColorID,waittime)
    term.setBackgroundColor(ColorID)
    term.clear()
    os.sleep(waittime)
end


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

shell.run("SystemFiles/WindowManager.lua")
