/*
* Code by EpicYoshiMaster
* System for arranging the "Doom Blocks" or walls in Ship Shape
* Utilizes an algorithm to ensure that every room is possible to reach when placing a new wall.
*
*/
class Yoshi_DoomBlock_Randomizer extends Object
    dependsOn(Yoshi_InterpActor_DoomBlockTaskmaster);

struct CruiseRoom {
    var string Name;
    var array<CruiseGroup> Exits;
    var bool Valid;
    structdefaultproperties {
        Valid = false;
    }
};

//Sets the state of every Doom Block
static function SetAllDoomBlocks(bool BlockState) {
    local Yoshi_InterpActor_DoomBlockTaskmaster IA;
    foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'Yoshi_InterpActor_DoomBlockTaskmaster', IA) {
        IA.SetEnabled(BlockState);
    }
}

//Sets the state of every Doom Block in a certain group
static function SetDoomBlockGroup(bool BlockState, CruiseGroup CG) {
    local Yoshi_InterpActor_DoomBlockTaskmaster IA;
    foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'Yoshi_InterpActor_DoomBlockTaskmaster', IA) {
        if(IA.Group == CG) {
            IA.SetEnabled(BlockState);
        }
    }   
}

//Gets the number of Doom Blocks in a certain state
static function int GetNumBlockages(bool BlockState) {
    local Yoshi_InterpActor_DoomBlockTaskmaster IA;
    local array<CruiseGroup> Blockages;
    local CruiseGroup CG;
    local bool isNew;
    foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'Yoshi_InterpActor_DoomBlockTaskmaster', IA) {
        isNew = true;
        foreach Blockages(CG) {
            if(IA.Group == CG) {
                isNew = false;
                break;
            }
        }
        if(isNew && IA.Enabled == BlockState) {
            Blockages.AddItem(IA.Group);
        }
    }
    return Blockages.Length;
}

//Gets the actual groups of Doom Blocks in a certain state
static function array<CruiseGroup> GetBlockages(bool BlockState) {
    local Yoshi_InterpActor_DoomBlockTaskmaster IA;
    local array<CruiseGroup> Blockages;
    local CruiseGroup CG;
    local bool isNew;
    Blockages.Length = 0;
    foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'Yoshi_InterpActor_DoomBlockTaskmaster', IA) {
        isNew = true;
        if(Blockages.Length > 0) {
            foreach Blockages(CG) {
                if(IA.Group == CG) {
                  isNew = false;
                  break;
                }
            }
        }
        
        if(isNew && IA.Enabled == BlockState) {
            Blockages.AddItem(IA.Group);
        }
    }
    return Blockages;    
}

//Grabs all Doom Block groups
static function array<CruiseGroup> GetAllBlockages() {
    local Yoshi_InterpActor_DoomBlockTaskmaster IA;
    local array<CruiseGroup> Blockages;
    local CruiseGroup CG;
    local bool isNew;
    Blockages.Length = 0;
    foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'Yoshi_InterpActor_DoomBlockTaskmaster', IA) {
        isNew = true;
        if(Blockages.Length > 0) {
            foreach Blockages(CG) {
                if(IA.Group == CG) {
                  isNew = false;
                  break;
                }
            }
        }
        
        if(isNew) {
            Blockages.AddItem(IA.Group);
        }
    }
    return Blockages;  
}

//Function to place new Doom Blocks, MaxBlockages is configured within the Death Wishes (usually the maximum placed is 9 but I put 10)
static function SelectNewDoomBlocks(int MaxBlockages) {
    local int i;
    local int PossBlockage;
    //local string EnumString;
    local array<CruiseGroup> RemainingBlockages;

    SetAllDoomBlocks(false);
    RemainingBlockages = GetBlockages(false);

    while(RemainingBlockages.Length > 0 && i < MaxBlockages) {
        PossBlockage = Rand(RemainingBlockages.Length);

        SetDoomBlockGroup(true, RemainingBlockages[PossBlockage]);
        //Print("[Attempt]: " $ String(GetEnum(Enum'CruiseGroup', int(RemainingBlockages[PossBlockage]))));
        if(isValidMap(GetBlockages(false))) {
            //EnumString = String(GetEnum(Enum'CruiseGroup', int(RemainingBlockages[PossBlockage])));
            //Print("[Success]: " $ EnumString);
            RemainingBlockages.RemoveItem(RemainingBlockages[PossBlockage]);
            i++;
        }
        else {
            //EnumString = String(GetEnum(Enum'CruiseGroup', int(RemainingBlockages[PossBlockage])));
            //Print("[Failure]: " $ EnumString);
            SetDoomBlockGroup(false, RemainingBlockages[PossBlockage]);
            RemainingBlockages.RemoveItem(RemainingBlockages[PossBlockage]);
        }
    }
    //Print("Map Generated with " $ GetNumBlockages(true) $ " walls up.");
}

static function bool isValidMap(array<CruiseGroup> Disabled) {
    local array<CruiseRoom> Rooms;
    local int i;
    Rooms = RoomList(Disabled);
    Rooms = TestRoom(Rooms, Disabled, 0);
    for(i = 0; i < Rooms.Length; i++) {
        if(!Rooms[i].Valid) {
            return false;
        }
    }
    return true;
}

/*
* Algorithm to determine if each room can be entered
* Follows each exit a room has to the next room, removes that exit, then tries the next room's exits etc.
* 
* Ends when all exits are used, then is tested in isValidMap for having visited every room
*/
static function array<CruiseRoom> TestRoom(array<CruiseRoom> Rooms, array<CruiseGroup> Disabled, int RoomNum, optional CruiseGroup LastExit) {
    local int i;
    local int k;
    local int NextRoom;
    local array<CruiseRoom> ResultRooms;

    if(String(LastExit) != "") {
        Rooms[RoomNum].Exits.RemoveItem(LastExit);
    }
    Rooms[RoomNum].Valid = true;

    for(i = 0; i < Rooms[RoomNum].Exits.Length; i++) {
        NextRoom = RoomConnection(Rooms, RoomNum, Rooms[RoomNum].Exits[i]);
        if(!Rooms[NextRoom].Valid) {
            ResultRooms = TestRoom(Rooms, Disabled, NextRoom, Rooms[RoomNum].Exits[i]);
            for(k = 0; k < ResultRooms.Length; k++) {
                if(ResultRooms[k].Valid) {
                    Rooms[k].Valid = true;
                }
            }
        }
    }

    return Rooms;
}

//Grabs the room which shares the same exit as another room
static function int RoomConnection(array<CruiseRoom> Rooms, int OriginalRoom, CruiseGroup ExitName) {
    local int i;
    local int k;
    for(i = 0; i < Rooms.Length; i++) {
        for(k = 0; k < Rooms[i].Exits.Length; k++) {
            if(Rooms[i].Exits[k] == ExitName && i != OriginalRoom) {
                return i;
            }
        }
    }
    return -1;
}

//Pulls all Rooms and sets up their exits
//the enum CruiseGroup contains room names specifically so that their exits are clear
static function array<CruiseRoom> RoomList(array<CruiseGroup> Disabled) {
    local int i;
    local int k;
    local array<CruiseGroup> AllBlockages;
    local array<CruiseRoom> Rooms;
    local string EnumString;
    Rooms.Add(13);

    Rooms[0].Name = "Playpen";
    Rooms[1].Name = "Pool";
    Rooms[2].Name = "Merseal";
    Rooms[3].Name = "Kitchen";
    Rooms[4].Name = "Dining";
    Rooms[5].Name = "Captain";
    Rooms[6].Name = "Yellow";
    Rooms[7].Name = "Brown";
    Rooms[8].Name = "Gambling";
    Rooms[9].Name = "Lobby";
    Rooms[10].Name = "Engine";
    Rooms[11].Name = "Laundry";
    Rooms[12].Name = "Hall";

    AllBlockages = GetAllBlockages();
    for(i = 0; i < Rooms.Length; i++) {
        for(k = 0; k < AllBlockages.Length; k++) {
            EnumString = String(GetEnum(Enum'CruiseGroup', int(AllBlockages[k])));
            if(Instr(EnumString, Rooms[i].Name) > -1 && Disabled.Find(AllBlockages[k]) > -1) {
                Rooms[i].Exits.AddItem(AllBlockages[k]);
            }
        }
    }
    return Rooms;
}

//debug to print
static function Print(string s)
{
    class'WorldInfo'.static.GetWorldInfo().Game.Broadcast(class'WorldInfo'.static.GetWorldInfo(), s);
}