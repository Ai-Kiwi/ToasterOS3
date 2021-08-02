--coroutine.yield({"RunFile","settings.lua",5,"true"})
local ToasterOSSettingsTabs = {}
local ToasterOSSettingsTabsDesc = {}
ToasterOSSettingsTabs = {"center task bar"}
ToasterOSSettingsTabsDesc = {"Where to center the task bar icons \n 1 : Left \n 2 : Middle \n 3 : Right"}
local ScrollY = 0
local RandomCrap, MoreRandomCrap, Username = coroutine.yield({"UserName"})
if MoreRandomCrap == "UserName" then
else
    --oh no
    while true do print("error bad username or perms") end
end

local function RenderItems(offsetY)
    term.clear()
    for i=1, #ToasterOSSettingsTabs do
        term.setCursorPos(1,i - offsetY + 1)
        term.write(ToasterOSSettingsTabs[i])
    end


end

local function OpenMenuForSetting(Item)
term.clear()
term.setCursorPos(1,1)
print(ToasterOSSettingsTabs[Item])
print("")
print(ToasterOSSettingsTabsDesc[Item])
print("")
print("current value : " .. settings.get(ToasterOSSettingsTabs[Item]))
print("setting under user : " .. Username)
print("")

term.write("> ")
NewSettingValue = read()
settings.load("UserData/" .. Username .. "/Settings.toast")
settings.set(ToasterOSSettingsTabs[Item],NewSettingValue)
settings.save("UserData/" .. Username .. "/Settings.toast")
coroutine.yield({"RefeshSettings"})
end


settings.load("UserData/" .. Username .. "/Settings.toast")







while true do
EventName, ev1, ev2, ev3 = os.pullEvent()
RenderItems(ScrollY)
term.setCursorPos(1,1)
term.clearLine()
term.write("Settings")

if EventName == "mouse_scroll" then
    ScrollY = ScrollY + ev1
    if ScrollY < 0 then ScrollY = 0 end
elseif EventName == "mouse_click" then
    if ToasterOSSettingsTabs[ev3 - 1 - ScrollY] == nil then
    else
        OpenMenuForSetting(ev3 - 1 - ScrollY)
    end
end

end
