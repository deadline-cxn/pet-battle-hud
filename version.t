del pet-battle-hud.zip
dir
cd ..
dir
pwd
7z a -mx0 -xr!.git -xr!*.zip -xr!*.t -x!pet-battle-hud/copy-2-wow.bat -x!pet-battle-hud/Build.bat -x!pet-battle-hud/copy.bat -x!pet-battle-hud/update_revision.php -x!pet-battle-hud/petbattlehud.old.txt -tzip pet-battle-hud.zip -x!pet-battle-hud/.gitignore pet-battle-hud
copy pet-battle-hud.zip pet-battle-hud\pet-battle-hud-<VERSION>.zip
del pet-battle-hud.zip

