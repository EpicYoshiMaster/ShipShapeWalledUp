/*
* Created by EpicYoshiMaster
* Script for "Doom Blocks" or walls utilized in the level.
* If you're interested in using a concept like this for your level, please contact me first.
*
*/
class Yoshi_InterpActor_DoomBlockTaskmaster extends InterpActor
    placeable;

var() bool Enabled;
var() bool Triggered;
var(Collision) bool CanTakeDamage;
var ECollisionType InitialCollision;

//CruiseGroup refers to which exits a volume is covering. Since some exits require 2 or more volumes, they need to be toggled together.
enum CruiseGroup {
    CG_LobbyBrown,
    CG_LobbyHall,
    CG_LobbyEngine,
    CG_LobbyGambling,
    
    CG_CaptainBrown,
    CG_CaptainYellow,
    CG_CaptainGambling,
    CG_CaptainDining,

    CG_KitchenDining,
    CG_KitchenLaundry,
    CG_KitchenBrown,
    CG_KitchenHall,
    
    CG_EngineYellow,
    CG_EngineLaundry,

    CG_MersealPool,
    CG_MersealGambling,
    CG_MersealYellow,

    CG_PoolYellow,
    CG_PoolPlaypen,

    CG_PlaypenDining,
    
    CG_HallYellow,
};
var CruiseGroup Group;

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
    
	SetEnabled(Enabled);
}

simulated function SetCruiseGroup(CruiseGroup CG) {
    Group = CG;
}

simulated function SetEnabled(bool e)
{
	Enabled = e;
	if (!Enabled)
	{
		SetCollisionType(COLLIDE_NoCollision);
		SetHidden(true);
	}
	else
	{
		SetCollisionType(InitialCollision);
		SetHidden(false);
	}
}

simulated function OnToggle( SeqAct_Toggle Action )
{
	if( Action.InputLinks[0].bHasImpulse || ( Action.InputLinks[2].bHasImpulse && !Enabled ) )
	{
        SetEnabled(true);
	}
	else
	{
        SetEnabled(false);
	}
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{

    if (Enabled && Hat_PawnCombat(Other) != None && (class'Yoshi_SnatcherContract_DeathWish_MoreWalls_ShipShape'.static.IsActive() || class'Yoshi_SnatcherContract_DeathWish_ShipShapeEXPlus'.static.IsActive()))
    {
       class'Yoshi_SnatcherContract_DeathWish_MoreWalls_ShipShape'.static.OnPlayerTouchesWall(self, Hat_PawnCombat(Other));
       Triggered = true;
    }
    Super.Touch( Other, OtherComp, HitLocation, HitNormal );
}

defaultproperties
{
    Begin Object Name=StaticMeshComponent0
        StaticMesh = StaticMesh'EngineMeshes.Cube'
        Materials(0)= Material'Yoshi_SSDW_Content.Wall_Of_Death_Taskmaster'
        CanBlockCamera=true
		//HiddenGame=true
	End Object

    bNoEncroachCheck = true;
    bCollideWhenPlacing = false
    bStatic = false;
    bNoDelete = false;
    Enabled = true
    Triggered = false

    InitialCollision=COLLIDE_TouchAll
}