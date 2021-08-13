function RefreshUserSettings()
    coroutine.yield({"RefeshSettings"})
end

function StartNewApp(LOC)
    coroutine.yield({"RunFile",LOC})
end

function UserName()
    return coroutine.yield({"UserName"})
end

function verson()
    return coroutine.yield({"verson"})
end