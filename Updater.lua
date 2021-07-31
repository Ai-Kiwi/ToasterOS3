fs.delete("ToasterOSUpdater")
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/Updater.lua ToasterOSUpdater")
--dowloads defalt user apps
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/UserData/ProgramShortcuts/Shell UserData/ProgramShortcuts/Shell")
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/UserData/ProgramShortcuts/Worm UserData/ProgramShortcuts/Worm")
--core system files
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/startup.lua startup.lua")
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/CreateAppShortcut.lua SystemFiles/CreateAppShortcut.lua")
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/Usermaker.lua SystemFiles/Usermaker.lua")
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/WindowManager.lua SystemFiles/WindowManager.lua")
--system apps
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/SystemFiles/SystemPrograms/FileExplorer.lua SystemFiles/SystemPrograms/FileExplorer.lua")
shell.run("pastebin get 6UV4qfNF SystemFiles/libs/sha256.lua")
os.reboot()
