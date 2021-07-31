shell.run("wget run https://raw.githubusercontent.com/Ai-Kiwi/ToasterOS3/main/Updater.lua true false")
fs.delete("installer.lua")
os.reboot()
