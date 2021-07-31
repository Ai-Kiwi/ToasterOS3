local args = {...}

NewUserName = "admin"
NewUserName = args[1]

shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/UserTemplate/ProgramShortcuts/Shell UserData/" .. NewUserName .. "/ProgramShortcuts/Shell")
shell.run("wget https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/SystemFiles/UserTemplate/ProgramShortcuts/Worm UserData/" .. NewUserName .. "/ProgramShortcuts/Worm")
