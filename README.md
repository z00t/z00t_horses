# z00t_horses
A Stables Manager for RedEM

* Place in resources folder
* import stables.sql to your redem database
* add ensure z00t_horses to server.cfg

Requirements
-------------
* RedEM, https://github.com/kanersps/redem
* RedEM: RP, https://github.com/RedEM-RP/redem_roleplay
* MySQL-Async, https://github.com/amakuu/mysql-async-temporary
* esplugin_mysql, https://github.com/RedEM-RP/esplugin_mysql
* RedEM: RP Identity, https://github.com/RedEM-RP/redemrp_identity

Commands
----------

/reghorse [id] - Must be mounted. Copies the model hash of the mounted horse and allows you to name it. Adding an ID will let you save it to another user (Good for admins?)

/defaulthorse [name] - Set's the horse you want to be able to summon

/spawnhorse = Command version of whistle

/dh - Command version of "Flee"


Usage
--------
After registering and setting default horse, you can whistle to summon. Horse will spawn behind you some distance and run close to your position. Whistling while the horse is already summoned will have it follow you until it reaches you. You can despawn the horse by focus-targetting it (Hold right-click while facing it) and pressing "F".


Config
--------
Config.StableSlots - Sets the amount of stable slots per character.


Disclaimer
------------
This is very much a WIP, and more of a proof of concept/admin tool to get some code snippets out and available. The code atm is quite patchwork, and I thank all in the RedM and Redem_roleplay communities for their contributions and hard work. Merry Christmas all!


Known Issues
-------------
- While there is a ground elevation check, it's currently not perfect, and sometimes horses will spawn under the ground.


Features to come
-----------------
* Menu
* Stable Locations & Interaction
* Saddles, Accessories, and Horse Customization
* Saddles and Accessories as inventory items (using Redem_inventory) with weight value on both player and horse (affects speed)
* Transfer/Sell Horse
* Horse Experience/Bonding
* And more!
