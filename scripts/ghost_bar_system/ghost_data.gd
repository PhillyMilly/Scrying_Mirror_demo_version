class_name GhostData extends Resource

enum GhostType {
	SHY,
	NORMAL,
	AGGRESSIVE,
}

enum GhostPhase {
	CONTACT,
	MAINTAIN,
	COMMUNICATION,
}

enum ContactItem {
	PENDULUM = 0,
	CANDLE = 1,
	GLASS = 2,
}

enum MaintainItem {
	BOWL = 3,
	RADIO = 4,
	SALTCIRCLE = 5,
}

enum CommunicateItem {
	OUIJA = 6,
	PENDULUM = 7,
	CRYSTALORB = 8,
}

@export var ghost_type:				GhostType
@export var maintain_multiplier:	float
@export var aggression_multiplier:	float
@export var contact_values:			Dictionary = {
	ContactItem.PENDULUM: 0.0,
	ContactItem.CANDLE: 0.0,
	ContactItem.GLASS: 0.0,
}
@export var maintain_values:		Dictionary = {
	MaintainItem.BOWL: 0.0,
	MaintainItem.RADIO: 0.0,
	MaintainItem.SALTCIRCLE: 0.0,
}
@export var aggression_values:		Dictionary = {
	ContactItem.PENDULUM: 0.0,
	ContactItem.CANDLE: 0.0,
	ContactItem.GLASS: 0.0,
	MaintainItem.BOWL: 0.0,
	MaintainItem.RADIO: 0.0,
	MaintainItem.SALTCIRCLE: 0.0,
}
