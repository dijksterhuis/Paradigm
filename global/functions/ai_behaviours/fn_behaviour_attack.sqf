/*
	File: fn_behaviour_attack.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		'Attack' behaviour. Calling this on a group has them attack a location.
	
	Parameter(s):
	   _group - Group to run the behaviour on. Needs 'attackPos' set in AGL format.
	   _attackPos - Position to attack
	
	Returns:
		Attack is ongoing. True if attacking, False if at attack destination. [BOOL]
	
	Example(s):
		[_group, getPos (allPlayers # 0)] call para_g_fnc_behaviour_attack
 */

params ["_group", "_attackPos"];

scopeName "behaviour";

if (!isNil "para_l_behaviour_debug") then {
	["VN AI Behaviour[%1]: Attack Behaviour Execution - %2", _group getVariable "behaviourId", _this] call BIS_fnc_logFormat;
};

if (leader _group distance2D _attackPos < 20) exitWith {
	false
};

if (speedMode _group != "FULL") then {
	_group setSpeedMode "FULL";
};

//Use combat mode red if they're in engagement range, and white otherwise to stop them shooting from far out.
if (leader _group distance2D _attackPos <= 150) then {
	if (combatMode _group != "RED") then {
		_group setCombatMode "RED";
	};
} else {
	if (combatMode _group != "WHITE") then {
		_group setCombatMode "WHITE";
	};
};

if (behaviour leader _group != "AWARE") then {
	_group setBehaviour "AWARE";
};

// @dijksterhuis: The original SGD code allows AI to lay down, crawl, kneel, crouch etc.
// When 'attacking' in Mike Force, the AI are usually supposed to be running at a bluefor FOB.
// So going prone doesn't make much sense.
// How are they going to get to the FOB if they're crawling all the way there!

// [_group, "AUTO"] call para_g_fnc_behaviour_set_group_stance;
[_group, "UP"] call para_g_fnc_behaviour_set_group_stance;


//TODO - Make them flank when attacking
[_group, _attackPos, "FULL"] call para_g_fnc_behaviour_move_to;

true
