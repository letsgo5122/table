extends Node

var SERVER_PORT = 8070
var MAX_PLAYERS = 10
# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Server", favorite_color = Color8(255, 0, 255) }
var peer = NetworkedMultiplayerENet.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	# Server signal 
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

#func _process(delta):
#	pass

func _player_connected(id):
	#print(id)
	#$"../VB/Msg".add_text("Receive_Id: "+str(id)+"\n")
# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info
	var pl_id = ""
	for pl in player_info.keys():
		pl_id += " id:"+ str(pl)
	$"../VB/Msg".add_text(pl_id+"\n")
	# Call function to update lobby UI here

func _on_Host_button_down():
	#var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	pass # Replace with function body.

