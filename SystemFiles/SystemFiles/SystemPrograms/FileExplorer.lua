local ScreenWidth, screenHight = term.getSize()


LookingIn = ""
local ScrollLevel = 1

FileList = {}

local function DrawItem(number, ScrollOffset)
    if (number + ScrollOffset > 1) then
        if fs.isDir(fs.combine(LookingIn, FileList[number])) then
            paintutils.drawLine(1,number + ScrollOffset,ScreenWidth,number + ScrollOffset, colors.lightGray)
            term.setBackgroundColor(colors.lightGray)
        else
            paintutils.drawLine(1,number + ScrollOffset,ScreenWidth,number + ScrollOffset, colors.gray)
            term.setBackgroundColor(colors.gray)
        end
        term.setTextColor(colors.black)
        term.setCursorPos(1,number + ScrollOffset)
        term.write(FileList[number])
    
    end
end




local function RenderFiles()
ScreenWidth, screenHight = term.getSize()
FileList = fs.list(LookingIn)
paintutils.drawFilledBox(1,1,ScreenWidth,screenHight, colors.white)
for i=1, #FileList do
    DrawItem(i,ScrollLevel)
end
term.setCursorPos(1,1)
term.write("<")


term.setCursorPos(3,1)
term.setBackgroundColor(colors.lightGray)
term.setTextColor(colors.black)
if LookingIn == "" then
    term.write("root/")
else    
    term.write(LookingIn .. "/")
end

term.setCursorPos(1,screenHight)
term.write(fs.getFreeSpace(LookingIn) .. " bytes free")
end


function MenuForItem(clickItemNum)
locastion = LookingIn .. "/" .. FileList[clickItemNum]
paintutils.drawFilledBox(1,1,ScreenWidth,screenHight, colors.gray)
term.setCursorPos(1,1)
term.setBackgroundColor(colors.lightGray)
term.setTextColor(colors.black)
print("name : " .. FileList[clickItemNum])
print("")
print("run")
print("edit")
print("delete")
print("back")
print("")
print("info")
print("size : " .. fs.getSize(locastion) .. " bytes")
print("locastion : " .. locastion)
while true do
local event, ClickSide, clickX, clickY = os.pullEvent("mouse_click")
clickItemNum = clickY
if clickItemNum == 4 then
    shell.run(locastion)
    return
elseif clickItemNum == 5 then
    shell.run("edit " .. locastion)
    return
elseif clickItemNum == 6 then
    fs.delete(locastion)
    return
elseif clickItemNum == 7 then
    return

end
end
end


while true do
RenderFiles()
local event, ClickSide, clickX, clickY = os.pullEvent("mouse_click")
--look idk why but sometimes things that arnt mouse click get throw
if event == "mouse_click" then
    clickItemNum = clickY  - ScrollLevel
    if clickY == 1 and clickX == 1 then
        LookingIn = ""
    else
        if (FileList[clickItemNum]) == nil then
        else
            if fs.isDir(fs.combine(LookingIn, FileList[clickItemNum])) then
                LookingIn = LookingIn .. "/" .. FileList[clickItemNum]
            else
                os.sleep(0.1)
                MenuForItem(clickItemNum)
            end
            os.sleep(0.1)
        end
    end
end
end



--TODO:
--fixup graphics abit
--add scrolling
-- add back butten to discs
-- stop from editing core files
-- add encrypt optiton

--add boot args so you can open folders of desktop and also have proatyes tab
--move and rename optitons
--add encrystion tab
--
