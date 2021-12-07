/*
* Custom Death Wish created by EpicYoshiMaster
* Combines Cruisin' for a Bruisin' with the walls mechanic introduced in Shifting Tides
*/
class Yoshi_SnatcherContract_DeathWish_ShipShapeEXPlus extends Hat_SnatcherContract_DeathWish
dependsOn(Yoshi_InterpActor_DoomBlockTaskmaster);

const ObjectiveTarget = 40;
const BonusNoMiss = 40;
const BonusTarget = 70;

const MaxBlockages = 10;

defaultproperties
{
	UI_PosX = -0.1;
	UI_PosY = 0.9;
	
	Objectives(0) = (Title = "Objective", MaxTriggerCount = ObjectiveTarget)
	Objectives(1) = (Title = "NoMiss", MaxTriggerCount = BonusNoMiss)
	Objectives(2) = (Title = "More", MaxTriggerCount = BonusTarget)
    Conditions = ("Condition")
	TipLocalizedMessage = "Tip0"

	AllowedMaps = ("ship_main")
	AllowedActs = (2)
	ParentDeathWishes.Add(class'Yoshi_SnatcherContract_DeathWish_MoreWalls_ShipShape');
    ParentDeathWishes.Add(class'Hat_SnatcherContract_DeathWish_EndlessTasks');

    RequiredStamps = 70;

	ActInfo = Hat_ChapterActInfo'hatintime_chapterinfo_dlc1.Cruise.Cruise_Working';

	HasEasyMode = false;
    NeverObscureObjectives = true;
}

static function bool ActExcluded()
{
	return IsExcluded() || `GameManager.GetCurrentAct() != default.ActInfo.ActID;
}

function OnPostInitGame()
{
	Super.OnPostInitGame();
	if (IsExcluded()) return;
	PlaceProps(Hat_Player(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().Pawn));
}

function PlaceProps(Hat_Player ply) {
    local Rotator Rotation;
    local TargetPoint TP;
    //Lobby

    //LobbyBrown
    SpawnInterpActor(ply, Vect(1700, 1011, 5117), Rotation, Vect(1.25, 2.1, 1), CG_LobbyBrown);
    //LobbyHall - Left side
    SpawnInterpActor(ply, Vect(1288, 988, 4586), Rotation, Vect(1, 2.05, 1), CG_LobbyHall);
    //LobbyYellow - Right Lobby side
    SpawnInterpActor(ply, Vect(-1282, 1335, 5299), Rotation, Vect(0.5, 0.5, 0.5), CG_LobbyHall);
    //LobbyYellow - Hall side
    SpawnInterpActor(ply, Vect(-1278, 3116, 5127), Rotation, Vect(0.5, 0.5, 0.5), CG_LobbyHall);
    //LobbyEngine - Lobby side
    SpawnInterpActor(ply, Vect(1, 311, 4587), Rotation, Vect(0.5, 0.5, 1), CG_LobbyEngine);
    //LobbyEngine - Engine side
    SpawnInterpActor(ply, Vect(2, 1125, 4039), Rotation, Vect(0.5, 0.5, 1), CG_LobbyEngine);
    //LobbyGambling - Lobby side
    SpawnInterpActor(ply, Vect(8, -126, 5122), Rotation, Vect(1, 0.25, 1), CG_LobbyGambling);
    //LobbyGambling - Gambling side
    SpawnInterpActor(ply, Vect(5, 961, 5350), Rotation, Vect(1, 0.25, 1.5), CG_LobbyGambling);


    //Captain

    //CaptainBrown - Captain side
    SpawnInterpActor(ply, Vect(378, 4443, 6124), Rotation, Vect(0.4, 0.6, 1), CG_CaptainBrown);
    //CaptainBrown - Brown side
    SpawnInterpActor(ply, Vect(1462, 4516, 6119), Rotation, Vect(0.4, 0.6, 1), CG_CaptainBrown);
    //CaptainYellow - Captain side
    SpawnInterpActor(ply, Vect(-362, 4443, 6124), Rotation, Vect(0.4, 0.6, 1), CG_CaptainYellow);
    //CaptainYellow - Yellow side
    SpawnInterpActor(ply, Vect(-1524, 4515, 6148), Rotation, Vect(0.4, 0.6, 1), CG_CaptainYellow);
    //CaptainGambling - Captain side
    SpawnInterpActor(ply, Vect(2, 4211, 6158), Rotation, Vect(1.6, 0.5, 1.5), CG_CaptainGambling);
    //CaptainGambling - Gambling side
    SpawnInterpActor(ply, Vect(3, 2872, 6165), Rotation, Vect(1.6, 0.5, 1.5), CG_CaptainGambling);
    //CaptainDining
    SpawnInterpActor(ply, Vect(-3, 5703, 6031), Rotation, Vect(1.6, 1.4, 1.7), CG_CaptainDining);

    //Kitchen

    //KitchenDining
    SpawnInterpActor(ply, Vect(-5, 5826, 4628), Rotation, Vect(1.6, 0.72, 1.25), CG_KitchenDining);
    //KitchenLaundry - Yellow side
    SpawnInterpActor(ply, Vect(-773, 4684, 4370), Rotation, Vect(2, 7, 0.73), CG_KitchenLaundry);
    //KitchenLaundry - Brown side
    SpawnInterpActor(ply, Vect(574, 4977, 4370), Rotation, Vect(1.5, 7, 0.73), CG_KitchenLaundry);
    //KitchenBrown - Kitchen side
    SpawnInterpActor(ply, Vect(1252, 4075, 4740), Rotation, Vect(0.4, 0.6, 1), CG_KitchenBrown);
    //KitchenBrown - Brown side
    SpawnInterpActor(ply, Vect(1476, 4074, 5130), Rotation, Vect(0.4, 0.6, 1), CG_KitchenBrown);
    //KitchenHall
    SpawnInterpActor(ply, Vect(15, 3773, 4616), Rotation, Vect(1.6, 0.4, 1.3), CG_KitchenHall);

    //Engine

    //EngineYellow - Engine side
    SpawnInterpActor(ply, Vect(-488, 2039, 4605), Rotation, Vect(0.4, 0.6, 1), CG_EngineYellow);
    //EngineYellow - Yellow side
    SpawnInterpActor(ply, Vect(-1472, 1996, 4620), Rotation, Vect(0.4, 0.6, 1), CG_EngineYellow);
    //EngineLaundry
    SpawnInterpActor(ply, Vect(3, 3402, 3956), Rotation, Vect(0.5, 2.3, 0.5), CG_EngineLaundry);

    //Merseal
    
    //MersealPool - Merseal side
    SpawnInterpActor(ply, Vect(12, 923, 7760), Rotation, Vect(0.6, 0.4, 1), CG_MersealPool);
    //MersealPool - Pool side
    SpawnInterpActor(ply, Vect(5, 3159, 8344), Rotation, Vect(0.6, 0.4, 1), CG_MersealPool);
    //MersealGambling
    SpawnInterpActor(ply, Vect(-15, 1135, 6151), Rotation, Vect(1.6, 0.7, 1.5), CG_MersealGambling);
    //MersealYellow
    SpawnInterpActor(ply, Vect(-1248, 687, 6114), Rotation, Vect(1.75, 0.6, 1), CG_MersealYellow);

    //Pool

    //PoolYellow
    SpawnInterpActor(ply, Vect(-1458, 4413, 7681), Rotation, Vect(0.1, 0.6, 1), CG_PoolYellow);
    //PoolPlaypen - Pool side
    SpawnInterpActor(ply, Vect(4, 8152, 7681), Rotation, Vect(1.2, 0.15, 1), CG_PoolPlaypen);
    //PoolPlaypen - Pool Top side
    SpawnInterpActor(ply, Vect(4, 8335, 8544), Rotation, Vect(0.8, 0.8, 0.175), CG_PoolPlaypen);

    //Playpen

    //PlaypenDining - Playpen side
    SpawnInterpActor(ply, Vect(4, 10105, 8207), Rotation, Vect(1.2, 0.15, 1), CG_PlaypenDining);
    //PlaypenDining - Dining side
    SpawnInterpActor(ply, Vect(1, 10792, 4587), Rotation, Vect(1.2, 0.15, 1), CG_PlaypenDining);

    //HallYellow
    SpawnInterpActor(ply, Vect(-1464, 3443, 5147), Rotation, Vect(0.1, 1.6, 1.25), CG_HallYellow);
    //We need to move a target point as the player would possibly spawn directly in a wall
    foreach class'WorldInfo'.static.GetWorldInfo().DynamicActors(class'TargetPoint', TP) {
        if(TP.Name == 'TargetPoint_9') {
            TP.SetLocation(Vect(-1690, 3448, 5057));
        }
    }
}

function SpawnInterpActor(Hat_Player ply, Vector Position, Rotator Rotation, Vector DrawScale3D, CruiseGroup Group) {
	local Yoshi_InterpActor_DoomBlockTaskmaster IA;
	IA = ply.Spawn(class'Yoshi_InterpActor_DoomBlockTaskmaster',,,Position,Rotation,,);
	IA.SetDrawScale3D(DrawScale3D);
    IA.SetCruiseGroup(Group);
    IA.SetEnabled(false);
}

static function OnPlayerTouchesWall(Yoshi_InterpActor_DoomBlockTaskmaster InterpActor, Hat_PawnCombat Pawn) {
	if (ActExcluded()) return;
	if(InterpActor == None || Hat_Player(Pawn) == None) return;

	KillEveryone();
}

static function bool AreAnyVolumesTriggered() {
	local Yoshi_InterpActor_DoomBlockTaskmaster IA;
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Yoshi_InterpActor_DoomBlockTaskmaster', IA) {
		if(IA.Triggered) {
			return true;
		}
	}
	return false;
}

static function KillEveryone()
{
	local Player ply;
	local Array<Player> GamePlayers;

	GamePlayers = class'Engine'.static.GetEngine().GamePlayers;
	foreach GamePlayers(ply) {
		ply.Actor.Pawn.Died(None, None, ply.Actor.Pawn.Location);
	}
		
}

function OnMiniMissionBegin(Object MiniMission)
{
	if (IsExcluded()) return;
	if (Hat_MiniMissionTaskMaster(MiniMission) == None) return;

	ResetObjectiveProgress(0);
	ResetObjectiveProgress(1);
    ResetObjectiveProgress(2);
	SetObjectiveFailed(0, false);
	SetObjectiveFailed(1, false);
    SetObjectiveFailed(2, false);

    if (Hat_MiniMissionTaskMaster(MiniMission).MissionMode == MiniMissionTaskMaster_ScoreTarget)
	{
		Hat_MiniMissionTaskMaster(MiniMission).MissionMode = MiniMissionTaskMaster_Survival;
		Hat_MiniMissionTaskMaster(MiniMission).GlobalDifficultyMultiplier = 1.0;
    }


    Hat_MiniMissionTaskMaster(MiniMission).UseHelperLine = false;
    Hat_MiniMissionTaskMaster(MiniMission).EasyTime = 160; //From 120
    Hat_MiniMissionTaskMaster(MiniMission).HardTime = 240; //From 180
    Hat_MiniMissionTaskMaster(MiniMission).EasySpeed = 8; //From 10
    Hat_MiniMissionTaskMaster(MiniMission).HardSpeed = 26; //From 40
    Hat_MiniMissionTaskMaster(MiniMission).SucceedPressure = 0.17; //From 0.15
    Hat_MiniMissionTaskMaster(MiniMission).FailPressure = 0.06; //From 0.07
    Hat_MiniMissionTaskMaster(MiniMission).ScoreTarget = ObjectiveTarget; //Have fun Deathathon peeps

    class'Yoshi_DoomBlock_Randomizer'.static.SelectNewDoomBlocks(MaxBlockages);
}

function OnMiniMissionComplete(Object MiniMission)
{
	if (IsExcluded()) return;
	if (Hat_MiniMissionTaskMaster(MiniMission) == None) return;

    SetObjectiveFailed(0, true);
	SetObjectiveFailed(1, true);
    SetObjectiveFailed(2, true);

    SetHighScore(Hat_MiniMissionTaskMaster(MiniMission).Score);
}

function OnMiniMissionFail(Object MiniMission)
{
	if (IsExcluded()) return;
	if (Hat_MiniMissionTaskMaster(MiniMission) == None) return;

	SetObjectiveFailed(0, true);
	SetObjectiveFailed(1, true);
	SetObjectiveFailed(2, true);

    SetHighScore(Hat_MiniMissionTaskMaster(MiniMission).Score);
}

function OnMiniMissionGenericEvent(Object MiniMission, String id)
{
	if (IsExcluded()) return;
	if (Hat_MiniMissionTaskMaster(MiniMission) == None) return;

	if (id == "score")
	{
        TriggerObjective(0);
		TriggerObjective(1);
        TriggerObjective(2);
        class'Yoshi_DoomBlock_Randomizer'.static.SelectNewDoomBlocks(MaxBlockages);
	}
	else if (id == "miss")
	{
		SetObjectiveFailed(1, true);
	}
}

static function bool ShouldShowHighScore()
{
	return GetHighScore() > 0;
}