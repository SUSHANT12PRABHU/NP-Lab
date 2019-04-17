set val(channel) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netInterface) Phy/WirelessPhy
set val(mac) Mac/802_11
set val(IfQType) Queue/DropTail/PriQueue
set val(linkLayer) LL
set val(antennaModel) Antenna/OmniAntenna
set val(maxIfQ) 50
set val(numNodes) 6
set val(routingProtocol) AODV 
set val(x) 360
set val(y) 300
set val(stop) 25


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
$node(0) set X_ 15.0
$node(0) set Y_ 15.0
$node(0) set Z_ 0.0

$node(0) radius 100

$node(1) set X_ 75.0
$node(1) set Y_ 15.0
$node(1) set Z_ 0.0

$node(2) set X_ 120.0
$node(2) set Y_ 15.0
$node(2) set Z_ 0.0

$node(3) set X_ 15.0
$node(3) set Y_ 200.0
$node(3) set Z_ 0.0

$node(4) set X_ 130.0
$node(4) set Y_ 200.0
$node(4) set Z_ 0.0

$node(5) set X_ 87.0
$node(5) set Y_ 300.0
$node(5) set Z_ 0.0

$ns color 1 Red
$ns color 2 Blue

# FTP appilication connection 1
set tcp [new Agent/TCP/Newreno]
set sink [new Agent/TCPSink]

$ns attach-agent $node(0) $tcp
$ns attach-agent $node(5) $sink

$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 5.0 "$ftp start"

# FTP appilication connection 2
set tcp2 [new Agent/TCP/Newreno]
set sink2 [new Agent/TCPSink]

$ns attach-agent $node(2) $tcp2
$ns attach-agent $node(5) $sink2

$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 10.0 "$ftp2 start"





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
$ns initial_node_pos $node(0) 20
$ns initial_node_pos $node(1) 20
$ns initial_node_pos $node(2) 20
$ns initial_node_pos $node(3) 20
$ns initial_node_pos $node(4) 20
$ns initial_node_pos $node(5) 20


# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 25.01 "puts \"end simulation\"; $ns halt"


proc stop {} {
	global ns tracefd namtrace windowVsTime2
	$ns flush-trace
	close $tracefd
	close $namtrace
	#close $windowVsTime2
	exec nam namtrace.nam &
}

$ns run
