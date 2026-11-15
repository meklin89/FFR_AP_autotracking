# FFR_AP_autotracking

Setting up a recieved item autotracker for FFR on Archipelago (https://github.com/ArchipelagoMW/Archipelago).

This is a pack for black-sliver's Poptracker (https://github.com/black-sliver/PopTracker/). 

Pretty simple to use, not 100% as fully functional as the EmoTracker pack, but works for Archipelago.


Auto settings are not a thing yet. Heavily recommended to set icons in the "Map Edits" and "Other Flags" for best experience

Known Issues:
	- <del> Map Logic is borked still. </del>
	- <del> Specifically, the northern continents show as available, even when they're not. </del>
	- *Fixed
	- Some icons are a placeholder until actual artwork is made

Known Limitations:
As the tracker doesn't read the rom's memory, it is only able to track the following things:
- AP Items recieved
- Chests opened which contained AP Items
- Shards recieved via AP (i.e. shards recieved by lighting the orbs don't show up).
It is unable to track the following:
- Orbs lit
- Items turned in (i.e. you won't get the checkmark on the item when you've turned it in)
- When the slab is translated vs when it's picked up. You'll have to manually click the slab to indicate you translated it.
- Non-AP items chests.
This is due to the fact that the tracker only interacts with the Archipelago server, and not with the Emulator's memory. I think this can be achieved eventually. Need to stare at more Tracker Packs.


Introducing:  Maps!
- This is in it's most basic form. These maps were mostly created and shared with the FFR community by DarkmoonEX.
- Some of the maps are placeholders for the moment.
	- <del> Hopefully with the next release maps with chest on them will have red/green tracker boxes on them. </del>
	- *Fixed, with lots of help from SunflashRune

Credits to @SunflashRune for adding location map points along with various other things that didnt get commited to the repo