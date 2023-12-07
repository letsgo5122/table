extends Node

var SERVER_IP = "127.0.0.1"
var SERVER_PORT = 8070

var player_info = {}
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }
var peer = NetworkedMultiplayerENet.new()

func ready():
	# Server signal 
	#get_tree().connect("network_peer_connected", self, "_player_connected")
	#get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# Client signal
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(id):
	#print(id)
	$"../VB/Msg".add_text("Id: "+str(id)+"\n")
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", my_info)
##
#func _player_disconnected(id):
#	player_info.erase(id) # Erase player from info.

func _connected_ok(id):
	print("_connected_ok")
	#$"../VB/Msg".add_text("Id: "+str(id)+"\n"+"_connected_ok")
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.
func _connected_fail():
	pass # Could not even connect to server; abort.

remotesync func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info
	var pl_id = ""
	for pl in player_info:
		pl_id += " id:"+ str(pl)
		$"../VB/Msg".add_text(pl_id+"\n")

	# Call function to update lobby UI here

func _on_Join_button_down():
	#var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

