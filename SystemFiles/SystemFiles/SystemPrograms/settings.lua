--coroutine.yield({"RunFile","settings.lua","true"})
local ToasterOSSettingsTabs = {}
ToasterOSSettingsTabs = {"Time before booting","verson installed from cloud"}
local ScrollY = 0
local RandomCrap, MoreRandomCrap, Username = coroutine.yield({"ToasterOSCommand","UserName"})
if not MoreRandomCrap == "UserName" then
    --oh no
    return "look idk even know what to say "
end

local function RenderItems(offsetY)
    term.clear()
    for i=1, #ToasterOSSettingsTabs do
        term.setCursorPos(1,i - offsetY + 1)
        term.write(ToasterOSSettingsTabs[i])
    end


end




settings.load("ToasterOSSettings")








while true do
EventName, ev1, ev2, ev3 = os.pullEvent()
RenderItems(ScrollY)
if EventName == "mouse_scroll" then
    ScrollY = ScrollY + ev1
    if ScrollY < 0 then ScrollY = 0 end
end

end
