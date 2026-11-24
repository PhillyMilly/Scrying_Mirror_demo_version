extends Node2D

var index:		int#randi_range(0, 2)
var words:		String = "words/numbers"
var sound:		String = "sound"
var see:		String = "see"
var other:		String = "other"

## NAMES ##
var client_names: Array[String] = [
	"Tutorialma",
	"Ms. Gillian",
	"To be done"
]
var ghost_names: Array[String] = [
	"Nelson",
	"Gilbert",
	"Enod eb ot"
]

## TUTORIALMA ######################################################################################
var tutorialma_questions: Array[String] = [
	"about [color=bb474f]The person driving the car[/color]",
	"about [color=bb474f]His Voice[/color]"
]
var tutorialma: Array[String] = [
	"???: \nHello my name is " + client_names[0] + ". I lost my cat recently...",
	"Tutorialma: \nHis name is Nelson. Someone ran him over with a car!",
	"Tutorialma: \nIf only I could [color=bb474f]find out who it was[/color]...Can you help me?",
	"Tutorialma: \nPleeeaaase!!!",
	"Turorialma: \nI know it won't bring him back, but maybe I will feel better afterwards.",
	"Tutorialma: \nI wish i could [color=bb474f]hear[/color] his [color=bb474f]sweet little voice[/color] again...",
	"You: \nI have some tools that would help to achieve that. We could certainly try it out.",
	"Tutorialma: \nWOOOOOOW !",
	"Tutorialma: \nYou can do that kind of stuff??? That's amazing! What else do you got?",
	"You: \nAll sorts of things. Some of these tools are for [color=bb474f]gathering Information[/color], like the one I just mentioned.",
	"You: \nThe other ones are for [color=bb474f]maintaining[/color] or [color=bb474f]establishing contact[/color].",
	"You: \nWe need those kind of tools to bridge the gap between the real and the " + '"' + "other" + '"' + " world.",
	"Tutorialma: \nOther world? Gosh, that sounds freightening!",
	"Tutorialma: \nDon't you get scared sometimes?",
	"You: \nDon't worry, most ghosts are pretty harmless. But yes, some tend to be a little more [color=bb474f]aggressive[/color] than others.",
	"You: \nFor those ones we need to be [color=bb474f]extra carefull[/color]. Waisting too much of their precious time will make them super angry!",
	"You: \nOnce you made contact with them you better be quick or else!",
	"You: \nWe also need to pay attention on [color=bb474f]what methods we are going to choose[/color].",
	"You: \nSome ghosts react really sensivite to certain procedures.",
	"Tutorialma: \nHmmmm...that still sounds pretty scary, but also super cool!",
	"Tutorialma: \nAnd how does this whole procedure-kinda-thing look like?",
	"You: \nIt's pretty straightforward actually.",
	"You: \nFirst we are going to make contact with the ghost. Once we have done that we could technically just ask him for Information.",
	"You: \nBut it wouldn't be the ideal way, because ghosts usually want to be left alone and therefore don't give you much time.",
	"You: \nIt would be wiser to do something first to maintain the contact before getting to close to them.",
	"You: \nMaintaining contact can also help in lowering their aggression, but you never know beforehand on what right tools to choose.",
	"You: \nThe best thing would be to just try things out.",
	"Tutorialma: \nUhuuuuum...*interesting* reaaaaaaaally interesting. Uhm anyways should we start?\n",
	"You: \nYes, of course"
]


var tutorialma_fail_reaction_sound: Array[String] = [
	"Tutorialma: \nThats nice and all, but i pictured this a little differently...",
	"Tutorialma: \nEhm...are you really suitable for this job?"
]
var tutorialma_fail_reaction_ouija: Array[String] = [
	""
]
var tutorialma_fail_reaction_crystal: Array[String] = [
	""
]
var tutorialma_fail_reactions: Array[Array] = [
	tutorialma_fail_reaction_sound,
	tutorialma_fail_reaction_ouija,
	tutorialma_fail_reaction_crystal
]


var tutorialma_solution1: Array[String] = [
	"Tutorialma: \nHis license plate is [color=bb474f]XYD98702[/color]?",
	"Tutorialma: \nThanks, that should help me narrowing it down quiet a bit."
]
var tutorialma_solution2: Array[String] = [
	"Tutorialma: \nAaaaaaaahww",
	"Tutorialma: \n[wave amp=4 freq=10]*sobbing*[/wave] You don't know how much this means to me. Thank you so much!"
]
var tutorialma_solutions: Array[Array] = [
	tutorialma_solution1,
	tutorialma_solution2
]


var tutorialma_finish: Array[String] = [
	"Tutorialma: \nPoor lil' boy, may you rest in peace.",
	"Tutorialma: \nHere is your reward! It aint much, but that's what you get for passing the tutorial i guess..."
]

## Tutorialmas Cat ##
var tutorialmas_cat: Array[String] = [
	"XY D987 02",
	"Meow"
]
var tutorialmas_cat_type: Array[String] = [
	see,
	sound
]
var tutorialma_ouija_fail: String = "Meow"
##/TUTORIALMA ######################################################################################

## Ms. Gillian #####################################################################################
var Ms_Gillian_questions: Array[String] = [
	"about [color=bb474f]the first day they met[/color]",
	"[color=bb474f]if he still loves her[/color]",
	"about [color=bb474f]Ms. Gillians memories[/color]"
]
var Ms_Gillian: Array[String] = [
	"Ms. Gillian: \nMy husband Gilbert died 5 years ago.",
	"Ms. Gillian: \nToday would be the day of our 50th anniversary.",
	"Ms. Gillian: \nOh deer, what a long and wonderfull life we had...yet it felt so short.",
	"Ms. Gillian: \nHoney, could you be so kind to tell me if he still remembers [color=bb474f]the day we first met[/color]?",
	"Ms. Gillian: \nOh what I would give to relive that [color=bb474f]memory[/color] and [color=bb474f]see[/color] it all again with my very own eyes.",
	"Ms. Gillian: \nLet me tell you, if you have gone into the years, you don't realize how fast life passes you by.",
	"Ms. Gillian: \nI hope it is not too much to ask of you, i just want a sign, [color=bb474f]if he still loves me[/color] and watches me from heaven."
]


var Ms_Gillian_fail_reaction_sound: Array[String] = [
	"Ms. Gillian: \nOh deer, I don't know what it is...",
	"Ms. Gillian: \nbut this is NOT my husband!",
]
var Ms_Gillian_fail_reaction_ouija: Array[String] = [
	""
]
var Ms_Gillian_fail_reaction_crystal: Array[String] = [
	""
]
var Ms_Gillian_fail_reactions: Array[Array] = [
	Ms_Gillian_fail_reaction_sound,
	Ms_Gillian_fail_reaction_ouija,
	Ms_Gillian_fail_reaction_crystal
]


var Ms_Gillian_solution1: Array[String] = [
	"Ms. Gillian: \nI still remember it quiet vividly. It was a very beautifull day.",
	"Ms. Gillian: \nNot even a cloud in sight!",
	"Ms. Gillian: \nI still hold it very close to my heart as one of my fondest memories."
]
var Ms_Gillian_solution2: Array[String] = [
	"Ms. Gillian: \nI know, how I could I ever doubted you.",
	"Ms. Gillian: \nI miss you too my deer. Not a day passes by without me thinking of you.",
	"Ms. Gillian: \nBut you don't have to wait much longer.",
	"Ms. Gillian: \nWe will meet soon my love.",
	"Ms. Gillian: \nUntil we meet in heaven, I love you too!"
]
var Ms_Gillian_solution3: Array[String] = [
	"Ms. Gillian: \n*sobs* That's even more beautifull than I remembered."
]
var Ms_Gillian_solutions: Array[Array] = [
	Ms_Gillian_solution1,
	Ms_Gillian_solution2,
	Ms_Gillian_solution3
]


var Ms_Gillian_finish: Array[String] = [
	"Thank you so much honey!",
	"It meant the world to me, may god bless you on your way.",
	"Money isn't enough to reward the kindness of your heart,",
	"but it's all an old woman can do for you."
]

## Gilbert ##
var Gilbert: Array[String] = [
	"20.05.1947",
	"Yes. I miss you",
	"Memory of first day met"
]
var Gilbert_type: Array[String] = [
	words,
	words,
	see
]
var Gilbert_ouija_fail: String = "I miss you"
##/test ############################################################################################


## LISTS ###########################################################################################
var requests: Array[Array] = [
	tutorialma,
	Ms_Gillian
]
var questions: Array[Array] = [
	tutorialma_questions,
	Ms_Gillian_questions
]
var fail_reactions: = [
	tutorialma_fail_reactions,
	Ms_Gillian_fail_reactions
]
var success_reactions: = [
	tutorialma_solutions,
	Ms_Gillian_solutions
]
var end: Array[Array] = [
	tutorialma_finish,
	Ms_Gillian_finish
]
var answers: Array[Array] = [
	tutorialmas_cat,
	Gilbert
]
var types: Array[Array] = [
	tutorialmas_cat_type,
	Gilbert_type
]
var ouija_fails: Array[String] = [
	tutorialma_ouija_fail,
	Gilbert_ouija_fail
]
##/LISTS ###########################################################################################

#DICTONARY
var job:	Dictionary = {
	"client":	{ "name": client_names[index],	"request": requests[index],	"questions": questions[index], "on_fail": fail_reactions[index], "on_solved": success_reactions[index], "finish": end[index] },
	"ghost":	{ "name": ghost_names[index],	"answers": answers[index],	"types": types[index], "ouija": ouija_fails[index] },
}

var client:				String = job["client"]["name"]
var ghost:				String = job["ghost"]["name"]
var ouija_fail:			String = job["ghost"]["ouija"]
var request:			Array[String] = job["client"]["request"]
var question:			Array[String] = job["client"]["questions"]
var fail_reaction:		Array[Array] = job["client"]["on_fail"]
var solved_reaction:	Array[Array] = job["client"]["on_solved"]
var finish:				Array[String] = job["client"]["finish"]
var solved:				Array[String]
var unsolved:			Array[String] = job["ghost"]["answers"]
var unsolved_types:		Array[String] = job["ghost"]["types"]
var after_minigame:		Array[String]

func truncate(input: String) -> String:
	var regex := RegEx.new()
	regex.compile("[^a-zA-Z0-9]")
	input = regex.sub(input, "", true)
	return (input.to_lower())


func _ready() -> void:
	print(index)
	print("REQUEST:")
	for line in requests:
		print(line)
	print("\nANSWERS:")
	for answer in unsolved:
		print(answer)
	print("\nFOUND:")
