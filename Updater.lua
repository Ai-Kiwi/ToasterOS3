local args = {...}
--input 1 : clear pc frist 
--input 2 : cheek for update instead of just updating

local function UpdateComputer()
    local moniterwidth, moniterhight = term.getSize()
    local amttoinstall = 8
    local amtinstalled = 0
    local percentDone = 0
    local iconNumberPercentUpto = 0
    local OldCurserPosY = 2
    local OldCurserPosX = 1
    local RowsToTakeUp = math.floor(200 / moniterwidth) + 1
    local RowsPerPage = math.floor(moniterhight / RowsToTakeUp)
    if args[1] == "true" then
        shell.run("delete /*")
    end

    term.clear()
    term.setCursorPos(1,1)

    local function InstallFromInternet(URL,LOC)

        amtinstalled = amtinstalled + 1


        --shows install progress bar
        term.setCursorPos(2,1)
        percentDone = amtinstalled / amttoinstall
        term.setTextColor(colors.blue )

        for i=1, moniterwidth - 4 do

            iconNumberPercentUpto = i / (moniterwidth - 4)

            if percentDone > iconNumberPercentUpto  then
                term.write("#")
            else
                term.write("-")
            end


        end
        term.setCursorPos(moniterwidth - 4,1)
        term.write(percentDone * 100 .. "%   ")


        term.setTextColor(colors.white )
        term.setCursorPos(OldCurserPosX,OldCurserPosY)

        
        --installs
        fs.delete(LOC)
        
        print("installing " .. URL .. " from github")
        local GithubFileLink = http.get(URL)
        if GithubFileLink then
            github_file = GithubFileLink.readAll()
            GithubFileLink.close()
        else
            term.setTextColor(colors.red)
            print("error failed to dowload")
            os.sleep(5)
            
        end
        if github_file then
            term.setTextColor(colors.green)
            print("dowloaded now instlling")
            fs.delete(LOC)
            local f = io.open(LOC, "w")
            f:write(github_file)
            f:close()
        end


        

        if math.floor(amtinstalled / RowsPerPage) == amtinstalled / RowsPerPage then
            term.setCursorPos(1,2)
            term.clear()
        end

        OldCurserPosX, OldCurserPosY = term.getCursorPos()




    end



    fs.delete("ToasterOSUpdater")
    InstallFromInternet("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/Updater.lua","ToasterOSUpdater.lua")
    --core system files
    InstallFromInternet("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/startup.lua","startup.lua")
    InstallFromInternet("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/CreateAppShortcut.lua","SystemFiles/CreateAppShortcut.lua")
    InstallFromInternet("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/Usermaker.lua","SystemFiles/Usermaker.lua")
    InstallFromInternet("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/WindowManager.lua","SystemFiles/WindowManager.lua")
    --system apps
    InstallFromInternet("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/SystemPrograms/FileExplorer.lua","SystemFiles/SystemPrograms/FileExplorer.lua")

end

if args[2] == "true" then
    print("Cheeking for updates")
    local GithubFileLink = http.get("https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/verson")
    if GithubFileLink then
        github_file = GithubFileLink.readAll()
        GithubFileLink.close()
        if github_file == "0.11" then
            term.setTextColor(colors.green)
            print("upto date")
            term.setTextColor(colors.white)
        else
            UpdateComputer()
        end

    else
        term.setTextColor(colors.red)
        print("failed cheeking for updates")
        os.sleep(5)
        
    end


    --

else
    UpdateComputer()
end




