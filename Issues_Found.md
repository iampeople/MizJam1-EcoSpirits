#Problems with Godot

##Problem: 
Textures are fuzzy

##Solution:
Godot - Disable Filter on Import tab of the image and reimport.


##Problem
Computer freezing randomly

##Solution
Godot - Changed from GLES3 to GLES2 (poor intel graphics card on this laptop)


##Problem
Don't know how to replace background with transparency 

##Research
https://www.guidingtech.com/image-background-transparent-gimp/

##Solution
GIMP - Right click the layer - add alpha channel
 - Use fuzzy selection tool to select background - delete


##Problem
GIMP not exporting transparency

##Solution
Export as 8bpc RBGA (not 8bpc RGB)