
extends Node2D

var server
var client

func _ready():
	server = PacketPeerUDP.new()
	server.listen(4666)
	client = PacketPeerUDP.new()
	client.set_send_address("127.0.0.1", 4666)
	client.put_var("Hello world!")
	set_process(true)

func _process(delta):
	if server.get_available_packet_count() > 0:
		var data = server.get_var()
		print_server("SERVER RECEIVE: " + str(data))
		var reply = "Hello " + server.get_packet_ip() + ":" + str(server.get_packet_port())
		print_server("SERVER SEND: " + reply)
		server.set_send_address(server.get_packet_ip(), server.get_packet_port())
		server.put_var(reply)
	if client.get_available_packet_count() > 0:
		var data = client.get_var()
		if data == null:
			print_client("CLIENT RECEIVED NULL VARIANT")
			#client.put_var("Hello world")
		else:
			print_client("CLIENT RECEIVED: ", data)

func print_server(msg):
	get_node("server").add_text( msg + "\n" )

func print_client(msg):
	get_node("client").add_text( msg + "\n" )