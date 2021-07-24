--SystemValues
local StartupPath = "UserData/UserFiles/OnStartup/"


local BackGroundTerm = term.current()
local WindowEventOutput = {}
local windowsTerm = {}
local ScreenWidth,  ScreenHight = term.getSize()
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
--script for opening files
local function OpenNewApp(ProgeamLoc)
    --creates a coutine and window for it
    local NewWindow = window.create(BackGroundTerm, 2, 2, 15, 15, true)
    ProgeamToRun = ProgeamLoc
    local NewCoroutine = coroutine.create(CoroutineRunAppFunction)
    table.insert(windowsTerm, {NewWindow,NewCoroutine,{2,2,15,15},true,true})
end

function CoroutineRunAppFunction()
    shell.run(ProgeamToRun)
    --says progeam has ended
    CloseCoroutineWindow = true
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
        
        
    end

    --for each window
    for i=1, #windowsTerm do
        --fixs up stuff for moniter mouse

        

        --cheeks if progeam is not hidden
        if windowsTerm[i] == nil then
        else
            --cheeks if mouse is down for moving window
            if NewEventOutput[1] == "mouse_drag" then
                --cheeks if oyur mouse is over move butten
                if windowsTerm[i][3][1] - 1 == LastMouseClickX then
                if windowsTerm[i][3][2] - 1 == LastMouseClickY then
                    --sets it so your moving window
                    IsMoveingWindow[i] = true
                end
                end
                --cheeks if your moving window
                if IsMoveingWindow[i] then
                    --moves window to mouse
                    windowsTerm[i][3][1] = NewEventOutput[3] + 1
                    windowsTerm[i][3][2] = NewEventOutput[4] + 1
                end

                --cheeks if your moving from reshape butten
                if windowsTerm[i][3][3] + windowsTerm[i][3][1] == LastMouseClickX then
                if windowsTerm[i][3][4] + windowsTerm[i][3][2] == LastMouseClickY then
                    --sets to say your reshaping
                    IsResizingWindow[i] = true
                end
                end

                --cheeks if your reshaping
                if IsResizingWindow[i] then
                    --changes size
                    windowsTerm[i][3][3] =  NewEventOutput[3] - windowsTerm[i][3][1]
                    windowsTerm[i][3][4] =  NewEventOutput[4] - windowsTerm[i][3][2]
                end

                windowsTerm[i][1].reposition(windowsTerm[i][3][1],windowsTerm[i][3][2],windowsTerm[i][3][3],windowsTerm[i][3][4])
            else
                --resets values if not mouse drag
                IsMoveingWindow[i] = false
                IsResizingWindow[i] = false
            end
            --tests for click
            if NewEventOutput[1] == "mouse_click" then
                --if clicking on stop butten
                if NewEventOutput[3] == windowsTerm[i][3][3] + windowsTerm[i][3][1] then
                if NewEventOutput[4] == windowsTerm[i][3][2] - 1 then
                    windowsTerm[i][5] = not windowsTerm[i][5]
                end
                end
            end
            --cheeks if progeam is running
            if windowsTerm[i][5] == true then
                --redricts all new drawing to window
                term.redirect(windowsTerm[i][1])
                --says not to close window
                CloseCoroutineWindow = false
                coroutine.resume(windowsTerm[i][2], unpack(NewEventOutput))
                --stops blinking
                term.setCursorBlink(false)
                --tests if progeam has finished
                if CloseCoroutineWindow then
                    --delete window
                    windowsTerm[i] = nil
                end
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
        --cheeks if progream is not hidden
        if windowsTerm[i][4] == true then
            --redraws window
            windowsTerm[i][1].redraw()
            paintutils.drawBox(windowsTerm[i][3][1] - 1,windowsTerm[i][3][2] - 1,windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][4] + windowsTerm[i][3][2],colors.yellow)
            --draws reshape and move buttens
            paintutils.drawPixel(windowsTerm[i][3][1] - 1,windowsTerm[i][3][2] - 1, colors.orange) --move butten
            paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][4] + windowsTerm[i][3][2],colors.green) --resize butten
            --draws close and minamize and pause buttens
            if windowsTerm[i][5] == true then
                paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][2] - 1,colors.red) -- stop botten
            else
                paintutils.drawPixel(windowsTerm[i][3][3] + windowsTerm[i][3][1],windowsTerm[i][3][2] - 1,colors.green) -- resume botten
            end
        end
    end
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
    ProgeamsFound = fs.list("/UserData/ProgramShortcuts/")
    for i=1, #ProgeamsFound do
        --gets postion of new shortcut
        offsetX = i - 1
        offsetX = offsetX * 8 + 3
        offsetY = 4
        --loads data for it
        settings.load("/UserData/ProgramShortcuts/" .. ProgeamsFound[i])
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
        print(NewEventOutput[1])
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
                        ProgeamsFound = fs.list("/UserData/ProgramShortcuts/")
                        if FlooredItemClickedOn > #ProgeamsFound then
                        else
                            --gets shortcut locastion
                            settings.load("/UserData/ProgramShortcuts/" .. ProgeamsFound[FlooredItemClickedOn])
                            ShortcutName = settings.get("shortcut loc")
                            OpenNewApp(ShortcutName)
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



if fs.exists(StartupPath) then
    local FilesToStartup = fs.list(StartupPath)
    for i=1, #FilesToStartup do
        OpenNewApp(StartupPath .. FilesToStartup[i])
    end
    
else
    fs.makeDir(StartupPath)
    os.reboot()
end



while true do
    DrawBackground()
    NewEventOutput = {os.pullEventRaw()}
    RunProgeamLoops()
    
    --os.sleep(0.01)
end



--TODO: fix when open app luancher apps with os.sleep just break
--todo:
--add muapule desktop support
--add taskbar for running apps
--add task amnger
--add app store
-- add files on desktop
-- fix setting_changed broken while in app lunahcer
