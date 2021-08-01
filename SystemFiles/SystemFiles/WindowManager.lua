local ScreenWidth,  ScreenHight = term.getSize()

if fs.exists("UserData") == false then
    fs.makeDir("UserData")
end

Accounts = fs.list("UserData")

term.setBackgroundColor(colors.black)

term.clear()
term.setCursorPos(1,1)
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
print(0 .. " : New User")
for i=1, #Accounts do
    print(i .. " : " .. Accounts[i])
    
end

print("")
print("account to login to?")
term.write("> ")



UserNumber = read()
UserNumber = tonumber(UserNumber)

if UserNumber == 0 then
    term.clear()
    term.setCursorPos(1,1)
    print("UserName? (no spaces)")
    term.write("> ")
    UserNumber = read()
    shell.run("SystemFiles/Usermaker.lua " .. UserNumber)
    os.reboot()
end


local UserLogined = Accounts[UserNumber]

if UserLogined == nil then
    printError("invaild user")
    os.sleep(2)
    os.reboot()
end

--SystemValues

local StartupPath = "UserData/" .. UserLogined .. "/UserFiles/OnStartup/"
local UserFilesPath = "UserData/" .. UserLogined .. "/"
local CommandNextTick = {}
local PermLevelColorCodes = {colors.white,colors.green,colors.orange,colors.red, colors.red}
local BackGroundTerm = term.current()
local WindowEventOutput = {}
local windowsTerm = {}

local WindowX = 0
local WindowY = 0
local WindowXScale = 0
local WindowYScal = 0
local SelectedWindow = 1
local WindowEventOutput = {}
local LastMouseClickX = 0
local LastMouseClickY = 0
local IsMoveingWindow = {}
local IsResizingWindow = {}
local CloseCoroutineWindow = false
local FsInVM = {}
local LocOFVMFiles = "UserData/" .. UserLogined .. "/"
local RomLoc = "rom/"
local LocToOpen = ""
local PermLevelToload = 0
local ToasterOsVerson = 0.1
local ProgeamEventInput = {}




local function commandHasBennRun()
    
end

--fixing windows term
local function fixwindowsTerm(input_windowsTerm)
    local NewTable = {}
    for i, v in pairs(input_windowsTerm) do
        table.insert(NewTable, v)
    end
    return NewTable
end


--script for opening files
local function OpenNewApp(ProgeamLoc,PermLevel)

    --creates a coutine and window for it
    local NewWindow = window.create(BackGroundTerm, 2, 2, 15, 15, true)
    ProgeamToRun = ProgeamLoc
    local NewCoroutine = coroutine.create(CoroutineRunAppFunction)
    --perm levels
    --1 nomeal progeam running in full on vm
    --2 higher level progeam can accses system calls like draw over apps
    --3 Full system perms can accses files and all
    --4 operating system perms its dumb to give something accses to this
    --5 rare for a app to need this more of a code thing i did that your not ment to use anyway its used for shell
    
    table.insert(windowsTerm, {NewWindow,NewCoroutine,{2,2,15,15},true,true,PermLevel,ProgeamLoc})

end

--progeam calls command
local function TestCoroutine(coroutineOutput,ProgeamPerms)
    if coroutineOutput then
        local ProgeamPermsLevel = tonumber(ProgeamPerms)


        --returns array saying if it complited sussesfully and command type as well as 

        if ProgeamPermsLevel > 3 then -- its operating system perms


        end
        if ProgeamPermsLevel > 2 then -- full level progeam


        end
        if ProgeamPermsLevel > 1 then -- higher system perm
            if coroutineOutput[1] == "UserName" then
                os.reboot()
                return {"ToasterOSCommand","UserName",UserLogined}
            end

        end
        if ProgeamPermsLevel > 0 then -- its a nomeal progeam
            --coroutine.yield({"restart"})
            if coroutineOutput[1] == "restart" then
                os.reboot()
                return {"ToasterOSCommand","restarted","successfully"}
            end

            --coroutine.yield({"verson"})
            if coroutineOutput[1] == "verson" then
                return {"ToasterOSCommand","verson",ToasterOsVerson}
            end

             --coroutine.yield({"PermLevel"})
             if coroutineOutput[1] == "PermLevel" then
                return {"ToasterOSCommand","PermLevel",ProgeamPermsLevel}
            end
            
            -- secand : loc thrid : is system app
            --coroutine.yield({"RunFile","FileExplorer.lua","true"})
            --coroutine.yield({"RunFile","rom/programs/fun/worm.lua","false"})
            if coroutineOutput[1] == "RunFile" then
                if coroutineOutput[2] then
                    if coroutineOutput[3] == "true" then
                        PermLevelToload = 5
                        LocToOpen = "SystemFiles/SystemPrograms/" .. coroutineOutput[2]
                    else
                        PermLevelToload = 1
                        LocToOpen = coroutineOutput[2]
                    end
                    OpenNewApp(LocToOpen,PermLevelToload)
                    return {"ToasterOSCommand","RunFile","successfully",LocToOpen,PermLevelToload}
                else
                    return {"ToasterOSCommand","RunFile","Failed"}
                end
            end
        end
    
    end
    --returns nothing happened
    return nil
end





--loads things for Vming apps
local function StartVm()
    --fs.list
    FsInVM.list = fs.list
    local function ListInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("ListInVM",path)
        return FsInVM.list(NewPath)
    end
    fs.list = ListInVM

    --fs.getname
    FsInVM.getName = fs.getName
    local function GetNameInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("GetNameInVM",path)
        return FsInVM.getName(NewPath)
    end
    fs.getName = GetNameInVM


    --fs.getDir
    FsInVM.getDir = fs.getDir
    local function GetDirInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("GetDirInVM",path)
        return FsInVM.getDir(NewPath)
    end
    fs.getDir = GetDirInVM

    FsInVM.getSize = fs.getSize
    local function getSizeInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("getSizeInVM",path)
        return FsInVM.getSize(NewPath)
    end
    fs.getSize = getSizeInVM

    FsInVM.exists = fs.exists
    local function existsInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("existsInVM",path)
        return FsInVM.exists(NewPath)
    end
    fs.exists = existsInVM

    FsInVM.isDir = fs.isDir
    local function isDirInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("isDirInVM",path)
        return FsInVM.isDir(NewPath)
    end
    fs.isDir = isDirInVM

    FsInVM.isReadOnly = fs.isReadOnly
    local function isReadOnlyInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("isReadOnlyInVM",path)
        return FsInVM.isReadOnly(NewPath)
    end
    fs.isReadOnly = isReadOnlyInVM


    FsInVM.makeDir = fs.makeDir
    local function makeDirInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("makeDirInVM",path)
        return FsInVM.makeDir(NewPath)
    end
    fs.makeDir = makeDirInVM

    FsInVM.getDrive = fs.getDrive
    local function getDriveInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("getDriveInVM",path)
        return FsInVM.getDrive(NewPath)
    end
    fs.getDrive = getDriveInVM

    FsInVM.getFreeSpace = fs.getFreeSpace
    local function getFreeSpaceInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("getFreeSpaceInVM",path)
        return FsInVM.getFreeSpace(NewPath)
    end
    fs.getFreeSpace = getFreeSpaceInVM

    FsInVM.delete = fs.delete
    local function deleteInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("deleteInVM",path)
        return FsInVM.delete(NewPath)
    end
    fs.delete = deleteInVM

    FsInVM.find = fs.find
    local function findInVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("findInVM",path)
        return FsInVM.find(NewPath)
    end
    fs.find = findInVM

    FsInVM.getCapacity = fs.getCapacity
    local function getCapacityINVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("getCapacityINVM",path)
        return FsInVM.find(NewPath)
    end
    fs.getCapacity = getCapacityINVM

    FsInVM.attributes = fs.attributes
    local function attributesINVM(path)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("attributesINVM",path)
        return FsInVM.find(NewPath)
    end
    fs.attributes = attributesINVM


    FsInVM.move = fs.move
    local function moveINVM(path, dest)
        newdest = LocOFVMFiles .. dest
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        INROM = string.find(dest, RomLoc )
        if INROM then
            newdest = dest
        end
        commandHasBennRun("moveINVM",path,dest)
        return FsInVM.find(NewPath, newdest)
    end
    fs.move = moveINVM

    FsInVM.copy = fs.copy
    local function copyINVM(path, dest)
        newdest = LocOFVMFiles .. dest
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        INROM = string.find(dest, RomLoc )
        if INROM then
            newdest = dest
        end
        commandHasBennRun("copyINVM",path,dest)
        return FsInVM.find(NewPath, newdest)
    end
    fs.copy = copyINVM


    FsInVM.open = fs.open
    local function openINVM(path, mode)
        NewPath = LocOFVMFiles .. path
        INROM = string.find(path, RomLoc )
        if INROM then
            NewPath = path
        end
        commandHasBennRun("openINVM",path,mode)
        return FsInVM.open(NewPath, mode)
    end
    fs.open = openINVM
end

local function EndVm()
    fs.list = FsInVM.list 
    fs.getName = FsInVM.getName 
    fs.getDir = FsInVM.getDir 
    fs.getSize = FsInVM.getSize 
    fs.exists = FsInVM.exists 
    fs.isDir = FsInVM.isDir 
    fs.isReadOnly = FsInVM.isReadOnly 
    fs.makeDir = FsInVM.makeDir 
    fs.getDrive = FsInVM.getDrive 
    fs.getFreeSpace = FsInVM.getFreeSpace 
    fs.delete = FsInVM.delete 
    fs.find = FsInVM.find 
    fs.getCapacity = FsInVM.getCapacity 
    fs.attributes = FsInVM.attributes 
    fs.move = FsInVM.move 
    fs.copy = FsInVM.copy 
    fs.open = FsInVM.open 
end


function CoroutineRunAppFunction()
    shell.run(ProgeamToRun)
    os.sleep(1)
    --says progeam has ended
    CloseCoroutineWindow = true
end

local function RunLoopForProgeam(Number,Input,RunEvent)
    


    local EventInput = {}
    EventInput = Input
    --cheeks if progeam is not hidden
    if windowsTerm[Number] == nil then
    else
        --cheeks if mouse is down for moving window
        if EventInput[1] == "mouse_drag" then
            --cheeks if oyur mouse is over move butten
            if windowsTerm[Number][3][1] - 1 == LastMouseClickX then
            if windowsTerm[Number][3][2] - 1 == LastMouseClickY then
                --sets it so your moving window
                IsMoveingWindow[Number] = true
            end
            end
            --cheeks if your moving window
            if IsMoveingWindow[Number] then
                --moves window to mouse
                windowsTerm[Number][3][1] = EventInput[3] + 1
                windowsTerm[Number][3][2] = EventInput[4] + 1
            end
            --cheeks if your moving from reshape butten
            if windowsTerm[Number][3][3] + windowsTerm[Number][3][1] == LastMouseClickX then
            if windowsTerm[Number][3][4] + windowsTerm[Number][3][2] == LastMouseClickY then
                --sets to say your reshaping
                IsResizingWindow[Number] = true
            end
            end
            --cheeks if your reshaping
            if IsResizingWindow[Number] then
                --changes size
                windowsTerm[Number][3][3] =  EventInput[3] - windowsTerm[Number][3][1]
                windowsTerm[Number][3][4] =  EventInput[4] - windowsTerm[Number][3][2]
                if windowsTerm[Number][3][3] < 5 then windowsTerm[Number][3][3] = 5 end                
                if windowsTerm[Number][3][4] < 5 then windowsTerm[Number][3][4] = 5 end
            end
            windowsTerm[Number][1].reposition(windowsTerm[Number][3][1],windowsTerm[Number][3][2],windowsTerm[Number][3][3],windowsTerm[Number][3][4])
        else
            --resets values if not mouse drag
            IsMoveingWindow[Number] = false
            IsResizingWindow[Number] = false
        end
        --tests for click
        if EventInput[1] == "mouse_click" then
            --if clicking on pause butten
            if EventInput[3] == windowsTerm[Number][3][3] + windowsTerm[Number][3][1] then
            if EventInput[4] == windowsTerm[Number][3][2] - 1 then
                windowsTerm[Number][5] = not windowsTerm[Number][5]
            end
            end
            --if clicking on stop butten
            if EventInput[3] == windowsTerm[Number][3][3] + windowsTerm[Number][3][1] -1 then
            if EventInput[4] == windowsTerm[Number][3][2] - 1 then
                windowsTerm[Number] = nil
                windowsTerm = fixwindowsTerm(windowsTerm)
                return
            end
            end
            --cheeks if its on the progeam
            if EventInput[3] + 2 > windowsTerm[Number][3][1] and EventInput[3] - 1 < windowsTerm[Number][3][3] + windowsTerm[Number][3][1] then
            if EventInput[4] + 2 > windowsTerm[Number][3][2] and EventInput[4] - 1 < windowsTerm[Number][3][4] + windowsTerm[Number][3][2] then
                SelectedWindow = Number
            end
            end
        
        
        end
        
        ProgeamEventInput = {}
        for k, v in pairs(EventInput) do --Don't use ipairs here because that only works with numeric inexes
            ProgeamEventInput[k] = v --Here we copy the key and the value from the original table
        end
        
        --moves mouse to fix bug with mouse clicks
        if ProgeamEventInput[1] == "mouse_click" or ProgeamEventInput[1] == "mouse_drag" or ProgeamEventInput[1] == "mouse_scroll" or ProgeamEventInput[1] == "mouse_up" then
            ProgeamEventInput[3] = ProgeamEventInput[3] - windowsTerm[Number][3][1] + 1
            ProgeamEventInput[4] =  ProgeamEventInput[4] - windowsTerm[Number][3][2] + 1
        end



        --cheeks if progeam is running
        if windowsTerm[Number][5] == true and RunEvent then
            --redricts all new drawing to window
            term.redirect(windowsTerm[Number][1])
            --says not to close window
            CloseCoroutineWindow = false
            local OldLocOFVMFiles = LocOFVMFiles
            if (tonumber(windowsTerm[Number][6]) > 4) then
                LocOFVMFiles = ""

            end

            
            term.setCursorBlink(true)
            local coroutineOutput = {}
            local coroutineWorked = false
            coroutineWorked, coroutineOutput = coroutine.resume(windowsTerm[Number][2], unpack(ProgeamEventInput))
            local output = {}

            
                output = TestCoroutine(coroutineOutput,windowsTerm[Number][6])
                if CloseCoroutineWindow then
                    --delete window
                    windowsTerm[Number] = nil
                    windowsTerm = fixwindowsTerm(windowsTerm)
                end


                if output then
                    RunLoopForProgeam(Number,output,false)
                end
            

            LocOFVMFiles = OldLocOFVMFiles
            --stops blinking
            term.setCursorBlink(false)
            --tests if progeam has finished

        end
    end
end

--for rendering a hadling each window
local function RunProgeamLoops()

    --cheeks for key clicks

    if NewEventOutput[1] == "key" then
        if NewEventOutput[2] == keys.home then
            AppLuncher()
            return
        end
    elseif NewEventOutput[1] == "mouse_click" then
        LastMouseClickX = NewEventOutput[3]
        LastMouseClickY = NewEventOutput[4]
    elseif NewEventOutput[1] == "terminate" then
        windowsTerm[SelectedWindow] = nil
        windowsTerm = fixwindowsTerm(windowsTerm)
    end
    local EventOnlyForScreenMouseOver = false
    if NewEventOutput[1] == "key" or NewEventOutput[1] == "key_up" or NewEventOutput[1] == "paste" or NewEventOutput[1] == "mouse_click" or NewEventOutput[1] == "mouse_drag" or NewEventOutput[1] == "mouse_scroll" or NewEventOutput[1] == "mouse_up" or NewEventOutput[1] == "char" then
        EventOnlyForScreenMouseOver = true

    else
        EventOnlyForScreenMouseOver = false
    end

    --for each window
    for i=1, #windowsTerm do
        if windowsTerm[i] == nil then
        else
            if EventOnlyForScreenMouseOver then
            --fixs up stuff for moniter mouse
                local ShouldRun = i == SelectedWindow
                RunLoopForProgeam(i,NewEventOutput,ShouldRun)
            else
                RunLoopForProgeam(i,NewEventOutput,true)
            end

        end
    end

    term.redirect(BackGroundTerm)
    --BackGroundTerm.restoreCursor()
end


local function DrawBackground()
    term.setBackgroundColour(colors.lightBlue)
    term.clear()
    --paintutils.drawFilledBox(1,1,ScreenWidth,ScreenHight, colors.lightBlue)
    --redraw Windows
    for i=1, #windowsTerm do
        if windowsTerm[i] == nil then
        else
            --cheeks if progream is not hidden
            if windowsTerm[i][4] == true then
                --redraws window
                windowsTerm[i][1].redraw()
                paintutils.drawBox(windowsTerm[i][3][1] - 1,windowsTerm[i][3][2] - 1,windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][4] + windowsTerm[i][3][2],colors.yellow)
                if i == SelectedWindow then
                    paintutils.drawLine(windowsTerm[i][3][1] - 1,windowsTerm[i][3][2] - 1,windowsTerm[i][3][1] + windowsTerm[i][3][3] - 1, windowsTerm[i][3][2] - 1,colors.green )
                end
                --draws reshape and move buttens
                paintutils.drawPixel(windowsTerm[i][3][1] - 1,windowsTerm[i][3][2] - 1, colors.orange) --move butten
                paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][4] + windowsTerm[i][3][2],colors.green) --resize butten
                --draws close and minamize and pause buttens
                if windowsTerm[i][5] == true then
                    paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][2] - 1,colors.purple) -- stop botten
                else
                    paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][2] - 1,colors.green) -- resume botten
                end
                paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1] - 1,windowsTerm[i][3][2] - 1,colors.red) --quit app butten
            end
        end
    end
end

local function DrawOverApps()

    for i=1, #windowsTerm do
        if windowsTerm[i] == nil then
        else
            term.setCursorPos(i,1)
            term.setBackgroundColor(PermLevelColorCodes[tonumber(windowsTerm[i][6])])
            term.setTextColor(colors.black)
            term.write(windowsTerm[i][6])
        end
    end
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)


end

function DrawAppLuncher()
    --draws background and app launahcer icon
    term.setBackgroundColour(colors.lightGray)
    term.clear()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(ScreenWidth / 2 - 6, 2)
    term.write("app launcher")
    --looks for Shortcuts
    ProgeamsFound = fs.list("ProgramShortcuts/")
    for i=1, #ProgeamsFound do
        --gets postion of new shortcut
        offsetX = i - 1
        offsetX = offsetX * 8 + 3
        offsetY = 4
        --loads data for it
        settings.load("ProgramShortcuts/" .. ProgeamsFound[i])
        --loads icon data
        IconData = settings.get("Icon")
        for IconX=1, 6 do 
            for IconY=1, 4 do 
                --goes to pixels place on icon
                term.setCursorPos(IconX + offsetX,IconY + offsetY)
                --finds spot for pixel
                WhereToLook = IconY * 6
                WhereToLook = WhereToLook - 6
                WhereToLook = WhereToLook + IconX
                WhereToLook = WhereToLook * 3
                --draws pixel
                term.setTextColour(IconData[WhereToLook - 2])
                term.setBackgroundColour(IconData[WhereToLook - 1])
                term.write(IconData[WhereToLook])
                
            end
        end
        term.setTextColor(colors.black)
        term.setBackgroundColor(colors.lightGray)
        term.setCursorPos(offsetX + 1,offsetY + 5)
        term.write(ProgeamsFound[i])
    end
end
function AppLuncher()
    while true do
        
        NewEventOutput = {os.pullEventRaw()}
        while NewEventOutput[1] == "setting_changed" do
            NewEventOutput = {os.pullEventRaw()}
        end 
        local Event = NewEventOutput[1]
        local ClickName = NewEventOutput[2]
        local ClickXPos = NewEventOutput[3]
        local ClickUPos = NewEventOutput[4]

        if Event == "mouse_click" then
            if ClickName == 1 then
                --gets pos for number
                ItemClickedOn = ClickXPos - 4
                ItemClickedOn = ItemClickedOn / 8
                ItemClickedOn = ItemClickedOn + 1
                FlooredItemClickedOn = math.floor(ItemClickedOn)
                --cheeks if item is not inbetween 2 items
                if ItemClickedOn - FlooredItemClickedOn < 0.7 then
                    -- cheeks if the item is not out of bounds
                    if ItemClickedOn > 0 then
                        --gets data about shortcuts
                        ProgeamsFound = fs.list("ProgramShortcuts/")
                        if FlooredItemClickedOn > #ProgeamsFound then
                        else
                            --gets shortcut locastion
                            settings.load("ProgramShortcuts/" .. ProgeamsFound[FlooredItemClickedOn])
                            ShortcutName = settings.get("shortcut loc")
                            	
                            local PermLevelToLoad = settings.get("boot perm level")
                            OpenNewApp(ShortcutName,PermLevelToLoad)
                            return
                        end
                    end
                end
            end
        elseif Event == "key" then
            if ClickName == keys.backspace or ClickName == keys.home then
                return
            end
        end
        RunProgeamLoops()
        DrawAppLuncher()
    end
end





--starts vm so user can only edit there files
StartVm()


if FsInVM.exists(StartupPath) then
    local FilesToStartup = FsInVM.list(StartupPath)
    for i=1, #FilesToStartup do
        OpenNewApp(StartupPath .. FilesToStartup[i],1)
    end
    
else
    FsInVM.makeDir(StartupPath)
end

if FsInVM.exists(UserFilesPath) == false then
    FsInVM.makeDir(UserFilesPath)
end
if FsInVM.exists(UserFilesPath .. "ProgramData") == false then
    FsInVM.makeDir(UserFilesPath)
end

while true do
    
    DrawBackground()
    DrawOverApps()
    NewEventOutput = {os.pullEventRaw()}
    RunProgeamLoops()
    
end



--todo:
--add muapule desktop support
--add taskbar for running apps
--add task manger
--add app store
-- add files on desktop
-- fix setting_changed broken while in app lunahcer
