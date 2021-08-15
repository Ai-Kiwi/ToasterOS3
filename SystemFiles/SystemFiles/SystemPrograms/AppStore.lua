local AppMarket = "https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3-AppStore/main/"
local NameOfProgramLists = "Programs.txt"
local FolderForApps = "ProgramFiles"
local moniterwidth, moniterhight = term.getSize()
local CenterScreenX = math.floor(moniterwidth / 2)
local CenterScreenY = math.floor(moniterhight / 2)
local AppsGotFromInternet = {}
local AppsToShow = {}
local ScrollY = 0
local Worded, Worded2, UserAccount = coroutine.yield({"UserName"})
local UserPath = "UserData/" .. UserAccount .. "/"

local function DrawAtCenterOfScreen(Text)
    local XPos = CenterScreenX - (string.len(Text) / 2)
    term.setCursorPos(XPos,CenterScreenY)
    term.write(Text)
end

local function GetFromInternet(Url)
    local UrlGetting = Url .. "?cb=" .. math.random(1,99999999)
    local Dowloadhandle = http.get(UrlGetting)
    if Dowloadhandle == nil then
        print(UrlGetting)
        os.sleep(1)
    end
    local Ouput = Dowloadhandle.readAll()
    Dowloadhandle.close()
    return Ouput
end



local function RefreshFiles()
    term.setBackgroundColor(colors.gray)
    term.setTextColor(colors.white)
    term.clear()
    DrawAtCenterOfScreen("Dowloading Programs") 
    --dowlaods programs
    AppsGotFromInternet = {}
    local handle = assert(http.get(AppMarket .. NameOfProgramLists .. "?cb=" .. math.random(1,99999999)))
    for line in handle.readLine do AppsGotFromInternet[#AppsGotFromInternet + 1] = line end
    handle.close()
    if AppsGotFromInternet == nil then
        DrawAtCenterOfScreen("Error")
        os.sleep(1) 
        RefreshFiles()
    end
end

local function SettingsLoadValue(UrlLookingAt,SettingLoading)
    fs.delete("SystemFiles/User/Temp/AppStore/AppLookingAt")
    local TempFileViewing = assert(fs.open("SystemFiles/User/Temp/AppStore/AppLookingAt","w"))
    TempFileViewing.write(GetFromInternet(UrlLookingAt))
    local OutPut = settings.load(SettingLoading)
    TempFileViewing.close()
end

local function RenderItems(offsetY)
    term.clear()
    for i=1, #AppsToShow do
        term.setCursorPos(1,i - offsetY + 1)
        term.write(AppsToShow[i])
    end
end

local function DowloadApp(AppName,CheekForUpdates,doDowload,doDelete)
    term.clear()
    term.setCursorPos(1,1)
    local DontDoUpdate = CheekForUpdates
    if DontDoUpdate == true then
        DoUpdate = (GetFromInternet(AppMarket .. FolderForApps .. "/" .. AppName .. "/verson") == settings.get(AppName))
    end
    --loads settings
    print("cheeking for update")
    settings.load(UserPath .. "AppsInstalledVerson")
    if DontDoUpdate then
        print("no updates todo")
        settings.clear()
    else
        if doDelete then
            fs.delete(UserPath .. "ProgramData/" .. AppName)
        end

        settings.clear()
        print("installing update")
        --dowloads files to install from internet
        local Dowloadhandle = assert(http.get((AppMarket .. FolderForApps .. "/" .. AppName .. "/FilesToInstall" .. "?cb=" .. math.random(1,99999999))))
        local PlaceInstallingFiles = UserPath .. "ProgramData/" .. AppName .. "/"
        --goes throw dowloading
        for line in Dowloadhandle.readLine do 
            if doDelete then
                print("deleting " .. line)
                fs.delete(PlaceInstallingFiles .. line)
            end
            if doDowload then
                print("instlling " .. line)
                local FileOpening = fs.open(PlaceInstallingFiles .. line,"w")
                FileOpening.write(GetFromInternet(AppMarket .. FolderForApps .. "/" .. AppName .. "/" .. line))
                FileOpening.close()
            end


        end
        Dowloadhandle.close()
        print("installing shortcut ")
        --dowload shortccut
        local handle = assert(http.get(AppMarket .. FolderForApps .. "/" .. AppName .. "/ProgramData" .. "?cb=" .. math.random(1,99999999)))
        if doDelete then
            fs.delete(UserPath .. "ProgramShortcuts/" .. AppName)
        end
        if doDowload then
            local FileOpening = assert(fs.open(UserPath .. "ProgramShortcuts/" .. AppName,"w"))
            FileOpening.write(GetFromInternet(AppMarket .. FolderForApps .. "/" .. AppName .. "/ProgramData"))
            FileOpening.close()
        end
        handle.close()

    end
    settings.clear()
    print("instlling verson update")
    settings.load(UserPath .. "AppsInstalledVerson")
    if doDowload then
        --update verson installed list
        settings.set(AppName,GetFromInternet(AppMarket .. FolderForApps .. "/" .. AppName .. "/verson"))
    else
        settings.set(AppName,nil)
    end
    --saves for new value
    settings.save(UserPath .. "AppsInstalledVerson")
    settings.clear()
    print("done")
    os.sleep(0.5)
end

local function OpenMenuForSetting(Item)
    term.clear()
    term.setCursorPos(1,1)
    print(AppsToShow[Item])
    print("")
    print(SettingsLoadValue(AppMarket .. "ProgramFiles/" .. AppsToShow[Item] .. "/ProgramData","Desc"))
    print("")
    print("Verson : " .. GetFromInternet(AppMarket .. FolderForApps .. "/" .. AppsToShow[Item] .. "/verson"))
    print("")
    print("optitions")
    print("install")
    print("uninstall")
    print("cheekforupdates")
    print("")
    term.write("> ")
    CommandUserEnterd = read()

    if CommandUserEnterd == "install" then
        DowloadApp(AppsToShow[Item],false,true,true)
    elseif CommandUserEnterd == "uninstall" then
        DowloadApp(AppsToShow[Item],false,false,true)
    elseif CommandUserEnterd == "cheekforupdates" then
        DowloadApp(AppsToShow[Item],true,true,true)
    end
end



RefreshFiles()
local ItemsToSeach = ""
AppsToShow = {}
for AppCheeking in pairs(AppsGotFromInternet) do 
    if string.match(AppCheeking, ItemsToSeach) then
        table.insert(AppsToShow, AppsGotFromInternet[AppCheeking])
    end 
end


-- coroutine.yield({"RunFile","SystemFiles/SystemPrograms/AppStore.lua"})




while true do
EventName, ev1, ev2, ev3 = os.pullEvent()
RenderItems(ScrollY)
term.setCursorPos(1,1)
term.clearLine()
term.write(ItemsToSeach)

if EventName == "mouse_scroll" then
    ScrollY = ScrollY + ev1
    if ScrollY < 0 then ScrollY = 0 end
elseif EventName == "mouse_click" then
    if AppsToShow[ev3 - 1 - ScrollY] == nil then
    else
        OpenMenuForSetting(ev3 - 1 - ScrollY)
    end
end

end
