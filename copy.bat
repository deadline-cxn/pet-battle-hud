#//robocopy /MIR e:\dev\github\wow\pet-battle-hud\ "Q:\World of Warcraft\_retail_\Interface\AddOns\petbattlehud\\" /NDL 
del pet-battle-hud.zip
dir
cd ..
dir
pwd
7z a -mx0 -xr!.git -xr!*.zip -x!pet-battle-hud/Build.bat -x!pet-battle-hud/copy.bat -x!pet-battle-hud/update_revision.php -x!pet-battle-hud/version_t -x!pet-battle-hud/petbattlehud.old.txt -tzip pet-battle-hud.zip -x!pet-battle-hud/.gitignore pet-battle-hud
copy pet-battle-hud.zip pet-battle-hud\pet-battle-hud-22.12.29.12.37.zip
del pet-battle-hud.zip

