local function RunMainOsFunction()
    
    Frame = require("libs/Frame")

    local ScreenWidth,  ScreenHight = term.getSize()
    local TaskBarOffset = 0
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
    local BackGroundTerm = Frame.new(term.current())
    BackGroundTerm.Initialize()
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
    local ToasterOsVerson = 0.1
    local ProgeamEventInput = {}
    local ToasterOSSettings = {}
    local BackGroundColor = colors.lightBlue
    local FunctionRefreshApps = true
    local SystemTaskBarApps = {}
    local WasProgeamSelected = false
    
    local function UpdateSettingValue(ValueName,DefaltValue)
        if settings.get(ValueName) == nil then
            settings.set(ValueName,DefaltValue)
            settings.save("UserData/" .. UserLogined .. "/Settings.toast")
        end
        return settings.get(ValueName)
    end 
    
    
    local function UpdateSettings()
        settings.load("UserData/" .. UserLogined .. "/Settings.toast")
        ToasterOSSettings.CenterTaskBar = UpdateSettingValue("center task bar",1)
    
    
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
    local function OpenNewApp(ProgeamLoc)
    
        --creates a coutine and window for it
        local NewWindow = window.create(BackGroundTerm, 2, 2, 15, 15, true)
        ProgeamToRun = ProgeamLoc
        local NewCoroutine = coroutine.create(CoroutineRunAppFunction)
    
        
        table.insert(windowsTerm, {NewWindow,NewCoroutine,{2,2,15,15},true,true,"Temp Nothing",ProgeamLoc,false})
    
    end
    
    --progeam calls command
    local function TestCoroutine(coroutineOutput)
        if coroutineOutput then
    
            --coroutine.yield({"RefeshSettings"})
            if coroutineOutput[1] == "RefeshSettings" then
                SudoRunFunction(UpdateSettings)
                return {"ToasterOSCommand","RefeshSettings","RefeshSettings"}
            end
            --coroutine.yield({"UserName"})
            if coroutineOutput[1] == "UserName" then
                return {"ToasterOSCommand","UserName",UserLogined}
            end
            --coroutine.yield({"verson"})
            if coroutineOutput[1] == "verson" then
                return {"ToasterOSCommand","verson",ToasterOsVerson}
            end
            if coroutineOutput[1] == "RunFile" then
                if coroutineOutput[2] then
                    OpenNewApp(coroutineOutput[2])
                    return {"ToasterOSCommand","RunFile","successfully",LocToOpen,PermLevelToload}
                end
            end
        
        end
        --returns nothing happened
        return nil
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
        if windowsTerm[Number][4] == true then
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
                --butten gui logic
    
                --if clicking on minazmze butten
                if EventInput[3] == windowsTerm[Number][3][3] + windowsTerm[Number][3][1] - 1 then
                if EventInput[4] == windowsTerm[Number][3][2] - 1 then
                    windowsTerm[Number][4] = false
                end
                end
                --if clicking on maxamize butten
                if EventInput[3] == windowsTerm[Number][3][3] + windowsTerm[Number][3][1] - 2 then
                if EventInput[4] == windowsTerm[Number][3][2] - 1 then
                    windowsTerm[Number][8] = not windowsTerm[Number][8]
                end
                end
                --if clicking on stop butten
                if EventInput[3] == windowsTerm[Number][3][3] + windowsTerm[Number][3][1] then
                if EventInput[4] == windowsTerm[Number][3][2] - 1 then
                    windowsTerm[Number] = nil
                    return
                end
                end
        
                --cheeks if its on the progeam
                if EventInput[3] + 2 > windowsTerm[Number][3][1] and EventInput[3] - 1 < windowsTerm[Number][3][3] + windowsTerm[Number][3][1] then
                if EventInput[4] + 2 > windowsTerm[Number][3][2] and EventInput[4] - 1 < windowsTerm[Number][3][4] + windowsTerm[Number][3][2] then
                    SelectedWindow = Number
                    WasProgeamSelected = true
                end
                end
                
                
            end
        end
    
            ProgeamEventInput = {}
            for k, v in pairs(EventInput) do
                ProgeamEventInput[k] = v
            end
            --moves mouse to fix bug with mouse clicks
            if ProgeamEventInput[1] == "mouse_click" or ProgeamEventInput[1] == "mouse_drag" or ProgeamEventInput[1] == "mouse_scroll" or ProgeamEventInput[1] == "mouse_up" then
                ProgeamEventInput[3] = ProgeamEventInput[3] - windowsTerm[Number][3][1] + 1
                ProgeamEventInput[4] =  ProgeamEventInput[4] - windowsTerm[Number][3][2] + 1
            end
                term.redirect(BackGroundTerm)
                if windowsTerm[Number] == nil then
                else
                    --cheeks if progream is not hidden
                    if windowsTerm[Number][4] == true then
                        --redraws window
                        windowsTerm[Number][1].redraw()
                        
                        paintutils.drawBox(windowsTerm[Number][3][1] - 1,windowsTerm[Number][3][2] - 1,windowsTerm[Number][3][3] + windowsTerm[Number][3][1],windowsTerm[Number][3][4] + windowsTerm[Number][3][2],colors.yellow)
                        term.setBackgroundColor(colors.yellow)
                        term.setTextColor(colors.gray)
                        if Number == SelectedWindow then
                            term.setTextColor(colors.black)
                        end
                        --draws text
                        local ProgeamName = fs.getName(windowsTerm[Number][7]) 
                        term.setCursorPos(windowsTerm[Number][3][1],windowsTerm[Number][3][2] - 1)
                        ProgeamName = string.sub(ProgeamName, 1,windowsTerm[Number][3][3] - 2)
                        term.write(ProgeamName)
        
                        --draws reshape and move buttens
                        paintutils.drawPixel(windowsTerm[Number][3][1] - 1,windowsTerm[Number][3][2] - 1, colors.orange) --move butten
                        paintutils.drawPixel(windowsTerm[Number][3][3] + windowsTerm[Number][3][1],windowsTerm[Number][3][4] + windowsTerm[Number][3][2],colors.green) --resize butten
                        --draws close and minamize and pause buttens
                        if windowsTerm[Number][5] == true then
                            paintutils.drawPixel(windowsTerm[Number][3][3] + windowsTerm[Number][3][1] - 2,windowsTerm[Number][3][2] - 1,colors.green) -- maxamize botten
                        else
                            paintutils.drawPixel(windowsTerm[Number][3][3] + windowsTerm[Number][3][1] - 2,windowsTerm[Number][3][2] - 1,colors.green) -- un maxamize botten
                        end
                        paintutils.drawPixel(windowsTerm[Number][3][3] + windowsTerm[Number][3][1] - 1,windowsTerm[Number][3][2] - 1,colors.orange) --minazmze butten
                        paintutils.drawPixel(windowsTerm[Number][3][3] + windowsTerm[Number][3][1],windowsTerm[Number][3][2] - 1,colors.red) --stop butten
                    end
                end

    
            --cheeks if progeam is running
            if windowsTerm[Number][5] == true and RunEvent then
                --redricts all new drawing to window
                term.redirect(windowsTerm[Number][1])
                --says not to close window
                CloseCoroutineWindow = false
    
                
                term.setCursorBlink(true)
                local coroutineOutput = {}
                local coroutineWorked = false
                coroutineWorked, coroutineOutput = coroutine.resume(windowsTerm[Number][2], unpack(ProgeamEventInput))
                local output = {}
    
                
                    output = TestCoroutine(coroutineOutput)
                    if CloseCoroutineWindow then
                        --delete window
                        windowsTerm[Number] = nil
                        windowsTerm = fixwindowsTerm(windowsTerm)
                    end
    
    
                    if output then
                        RunLoopForProgeam(Number,output,true)
                    end
    
                --stops blinking
                term.setCursorBlink(false)
                --tests if progeam has finished
    
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
        --toggles hide app
        if NewEventOutput[1] == "mouse_click" then
        if NewEventOutput[4] == ScreenHight then
            if windowsTerm[tonumber(NewEventOutput[3]) - TaskBarOffset] == nil then
            else
                windowsTerm[NewEventOutput[3] - TaskBarOffset][4] = not windowsTerm[NewEventOutput[3] - TaskBarOffset][4]
            end
    
        end
        end
        WasProgeamSelected = false
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
        if WasProgeamSelected == false then
            if NewEventOutput[1] == "mouse_click" then
                SelectedWindow = 0
    
    
            end
    
        end
    
    end
    
    
    local function DrawBackground()
        --  local ScreenCenterX = math.floor(ScreenWidth / 2)
        --  local ScreenCenterY = math.floor(ScreenWidth / 2)
        --  paintutils.drawFilledBox(ScreenCenterX - 3,ScreenCenterY - 1,ScreenCenterX + 3,ScreenCenterY + 3, colors.orange)

        
    end
    
    
    local function DrawOverApps()
        if ToasterOSSettings.CenterTaskBar == "3" then
            TaskBarOffset = ScreenWidth - (#windowsTerm + #SystemTaskBarApps)
        elseif ToasterOSSettings.CenterTaskBar == "2" then
            TaskBarOffset = math.floor(ScreenWidth / 2) - math.floor((#windowsTerm + # SystemTaskBarApps) / 2)
        else
            TaskBarOffset = 0
        end
    
        --SystemTaskBarApps
        paintutils.drawBox(1,ScreenHight,ScreenWidth,ScreenHight,colors.white )
        for i=1, #SystemTaskBarApps do
            term.setBackgroundColor(colors.blue)
            term.setTextColor(colors.black)
            term.write( )
    
        end
        
        for i=1, #windowsTerm do
            if windowsTerm[i] == nil then
            else
                term.setCursorPos(i + TaskBarOffset + #SystemTaskBarApps,ScreenHight)
                if windowsTerm[i][4] then
                    term.setBackgroundColor(colors.green)
                else
                    term.setBackgroundColor(colors.red)
                end
                term.setTextColor(colors.black)
                term.write(" ")
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
        ProgeamsFound = fs.list(UserFilesPath .. "ProgramShortcuts/")
        local AmtCanFitOnList = math.floor((ScreenWidth - 6) / 8)
        for i=1, #ProgeamsFound do
            local RowNumber = math.floor((i - 1) / AmtCanFitOnList)
            --gets postion of new shortcut
            offsetX = i - 1
            offsetX = offsetX * 8 + 3
            offsetY = 4 + (RowNumber * 6)
            offsetX = offsetX - (AmtCanFitOnList * 8 * RowNumber)
    
    
            
    
    
            --ScreenWidth
            --loads data for it
            settings.load(UserFilesPath .. "ProgramShortcuts/" .. ProgeamsFound[i])
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
            local AmtCanFitOnList = math.floor((ScreenWidth - 6) / 8)
            NewEventOutput = {os.pullEventRaw()}
            while NewEventOutput[1] == "setting_changed" do
                NewEventOutput = {os.pullEventRaw()}
            end 
            local Event = NewEventOutput[1]
            local ClickName = NewEventOutput[2]
            local ClickXPos = NewEventOutput[3]
            local ClickYPos = NewEventOutput[4]
    
            if Event == "mouse_click" then
                if ClickName == 1 then
                    --gets pos for number
                    ItemClickedOn = ClickXPos - 4
                    ItemClickedOn = ItemClickedOn / 8
                    ItemClickedOn = ItemClickedOn + 1
                    --adds stuff for diffent rows
                    ItemClickedOn = ItemClickedOn + (math.floor((ClickYPos - 5) / 6) * AmtCanFitOnList)
                    FlooredItemClickedOn = math.floor(ItemClickedOn)
    
                    --cheeks if item is not inbetween 2 items
                    if ItemClickedOn - FlooredItemClickedOn < 0.7 then
                        -- cheeks if the item is not out of bounds
                        if ItemClickedOn > 0 then
                            --gets data about shortcuts
                            ProgeamsFound = fs.list(UserFilesPath .. "ProgramShortcuts/")
                            if FlooredItemClickedOn > #ProgeamsFound then
                            else
                                if ProgeamsFound[FlooredItemClickedOn] == nil then
                                else

                                    --gets shortcut locastion
                                    settings.load(UserFilesPath .. "ProgramShortcuts/" .. ProgeamsFound[FlooredItemClickedOn])
                                    ShortcutName = settings.get("shortcut loc")
                                    --app open exzample ProgramData/AppMaker/core.lua > you user files program apps 
                                    if string.match(ShortcutName, "ProgramData/") then
                                        OpenNewApp(UserFilesPath .. ShortcutName)
                                    else
                                        OpenNewApp(ShortcutName)
                                    end
                                    FunctionRefreshApps = true
                                    return
                                end
                            end
                        end
                    end
                end
            elseif Event == "key" then
                if ClickName == keys.backspace or ClickName == keys.home then
                    FunctionRefreshApps = true
                    return
                end
            end
            RunProgeamLoops()
            DrawAppLuncher()
            BackGroundTerm.PushBuffer()
        end
    
    end
    
    
    
    UpdateSettings()
    
    
    if fs.exists(StartupPath) then
        local FilesToStartup = fs.list(StartupPath)
        for i=1, #FilesToStartup do
            OpenNewApp(StartupPath .. FilesToStartup[i],1)
        end
        
    else
        fs.makeDir(StartupPath)
    end
    
    if fs.exists(UserFilesPath) == false then
        fs.makeDir(UserFilesPath)
    end
    if fs.exists(UserFilesPath .. "ProgramData") == false then
        fs.makeDir(UserFilesPath)
    end
    
    while true do
        if NewEventOutput == nil then
        else    
        if NewEventOutput[1] == "mouse_click" or NewEventOutput[1] == "mouse_drag" or FunctionRefreshApps == true then
            term.setBackgroundColour(BackGroundColor)
            term.clear()
        end
        end
    
        DrawBackground()
        NewEventOutput = {os.pullEventRaw()}
        RunProgeamLoops()
        DrawOverApps()
        BackGroundTerm.PushBuffer()
    end
    
    end
    
    
    
    
    local HasError, ErrorMessage = pcall(RunMainOsFunction)
    term.setBackgroundColor(colors.red)
    term.clear()
    term.setCursorPos(1,1)
    print("Your PC has burnt the toast.")
    print("")
    print(ErrorMessage)
    print("")
    print("please report this to our github issues tab at : `https://github.com/Ai-Kiwi/ToasterOS3/issues/new`")
    settings.load("SystemFiles/ToasterOSbios")
    print("Make sure to include your toaster os verson : " .. settings.get("verson installed from cloud"))
    print("")
    print("enter to continue into installer")
    fs.delete("SystemFiles/CrashReport.txt")
    CrashReportFile = fs.open("SystemFiles/CrashReport.txt","w")
    CrashReportFile.writeLine("Verson : " .. settings.get("verson installed from cloud"))
    CrashReportFile.writeLine("CrashLevel : WindowManager.lua")
    CrashReportFile.writeLine("Crash : " .. ErrorMessage)
    CrashReportFile.close()
    read()
    shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/installer.lua")
    os.reboot()
    
    
    
    
    --todo:
    --add muapule desktop support
    --add taskbar for running apps
    --add task manger
    --add app store
    -- add files on desktop
    -- fix setting_changed broken while in app lunahcer
    --add windows butten. 
    --replace pause butten with minamize, 
    --make a better login system
