@echo off
echo Build Script: Building %1
php update_revision.php
call copy.bat
