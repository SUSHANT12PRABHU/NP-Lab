set val(channel) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netInterface) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(IfQType) Queue/DropTail/PriQueue
set val(linkLayer) LL
set val(antennaModel) Antenna/OmniAntenna
set val(maxIfQ) 50
set val(numNodes) 3
set val(routingProtocol) AODV 
set val(x) 500
set val(y) 500
set val(stop) 110


set ns [new Simulator]

set tracefd [open tracefd.tr w]
set windowVsTime2 [open win.tr w]
set namtrace [open namtrace.nam w]

$ns trace-all $tracefd

$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(numNodes)
	$ns node-config -adhocRouting $val(routingProtocol) \
		-llType $val(linkLayer) \
		-macType $val(mac) \
		-ifqType $val(IfQType) \
		-ifqLen $val(maxIfQ) \
		-antType $val(antennaModel) \
		-propType $val(prop) \
		-phyType $val(netInterface) \
		-channelType $val(channel) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace OFF \
		-movementTrace ON

for {set i 0} {$i < $val(numNodes)} {incr i} {
	set node($i) [$ns node] }




# inital postion
$node(0) set X_ 5.0
$node(0) set Y_ 75.0
$node(0) set Z_ 0.0

$node(1) set X_ 460.0
$node(1) set Y_ 400.0
$node(1) set Z_ 0.0

$node(2) set X_ 250.0
$node(2) set Y_ 280.0
$node(2) set Z_ 0.0

# setting node destination
$ns at 10.0 "$node(0) setdest 450.0 100 10.0"
$ns at 15.0 "$node(1) setdest 40.0 350 5.0"

$ns color 1 Red
$ns color 2 Blue

# FTP appilication connection
set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]

$ns attach-agent $node(0) $tcp
$ns attach-agent $node(1) $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 2.0 "$ftp start"




# printing the window size (recursion)
proc plotWindow {tcpSource file} {

	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now + $time] "plotWindow $tcpSource $file"
}

$ns at 1.0 "plotWindow $tcp $windowVsTime2"


# node size
$ns initial_node_pos $node(0) 50
$ns initial_node_pos $node(1) 50
$ns initial_node_pos $node(2) 50

# radius
$node(0) radius 400.0
$node(1) radius 400.0
$node(2) radius 400.0

# telling nodes when sim ends
$ns at $val(stop) "$node(0) reset"
$ns at $val(stop) "$node(1) reset"
$ns at $val(stop) "$node(2) reset"

# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 110.01 "puts \"end simulation\"; $ns halt"


proc stop {} {
	global ns tracefd namtrace
	$ns flush-trace
	close $tracefd
	close $namtrace

	exec nam namtrace.nam &
}

$ns run
