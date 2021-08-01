local moniterwidth, moniterhight = term.getSize()
local MiddleOfScreenX = math.floor(moniterwidth / 2)
local MiddleOfScreenY = math.floor(moniterhight / 2)

local function centreScreenWrite(text,offsetx,offsety)
    term.setCursorPos(MiddleOfScreenX - offsetx - math.floor(string.len(text) / 2),MiddleOfScreenY - offsety)
    term.write(text)


end
local function DrawMainMenu()
    --clears up screen
    term.setBackgroundColor(colors.lightBlue)
    term.setTextColor(colors.white)
    term.clear()
    --draws logo text
    centreScreenWrite("ToasterOS Installer",0,MiddleOfScreenY - 1)
    --draws buttens
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.black)
    centreScreenWrite("Install OS",0,1)
    centreScreenWrite("repair os files",0,-1)
    --draws back butten
    term.setCursorPos(1,moniterhight)
    term.write("back")
    term.setCursorPos(moniterwidth - 2,moniterhight)
    term.write("cmd")
end


while true do
    DrawMainMenu()
    local EventName, event1, event2, event3 = os.pullEvent()
    if EventName == "mouse_click" and event1 == 1 then
        --cheeks if its it back butten
        if event3 == moniterhight and event2 < 5 then
            return
        end
        if event3 == moniterhight and event2 > moniterwidth - 3 then
            shell.run("rom/programs/shell.lua")
        end
        if event3 == MiddleOfScreenY - 1 then
            --installer been pressed
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
            shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/Updater.lua true false")
            os.reboot()
            return
        end
        if event3 == MiddleOfScreenY + 1 then
            --repair been pressed
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
            shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/Updater.lua false false")
            return
        end

    end




end


term.setCursorPos(1,1)
term.clear()
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
