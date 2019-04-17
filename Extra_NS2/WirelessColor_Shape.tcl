# simple-wireless.tcl# A simple example for wireless simulation
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL;# link layer type
set val(ant) Antenna/OmniAntenna;# antenna model
set val(ifqlen) 50;# max packet in ifq
set val(nn) 8;# number of mobilenodes
set val(rp) DSDV;# routing protocol
#
#
# Initialize Global Variables
#
set ns_ [new Simulator]
set tracefd [open simple.tr w]
$ns_ trace-all $tracefd
set namtrace [open out.nam w]
$ns_ namtrace-all-wireless $namtrace 500 500
# set up topography object
set topo [new Topography]
$topo load_flatgrid 500 500
#
# Create God#
create-god $val(nn)
#
# Create the specified number of mobilenodes [$val(nn)] and "attach" them
# to the channel.
# Here two nodes are created : node(0) and node(1)
# configure node
$ns_ node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace OFF
for {set i 0} {$i < $val(nn) } {incr i} {
set node_($i) [$ns_ node]
$node_($i) random-motion 0
}
;# disable random motion
#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#

$ns_ color 1 yellow
$ns_ color 2 orange

$node_(0) set X_ 0.0
$node_(0) set Y_ 0.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 0.0
$node_(1) set Y_ 200.0
$node_(1) set Z_ 0.0
$node_(2) set X_ 200.0
$node_(2) set Y_ 200.0
$node_(2) set Z_ 0.0
$node_(3) set X_ 499.0
$node_(3) set Y_ 200.0
$node_(3) set Z_ 0.0
$node_(4) set X_ 400.0
$node_(4) set Y_ 0.0
$node_(4) set Z_ 0.0
$node_(5) set X_ 200.0
$node_(5) set Y_ 0.0
$node_(5) set Z_ 0.0

$node_(6) set X_ 100.0
$node_(6) set Y_ 0.0
$node_(6) set Z_ 0.0
$node_(7) set X_ 300.0
$node_(7) set Y_ 0.0
$node_(7) set Z_ 0.0
#--------------------------------------------------VIMPPPPPPPPPPPPPPPPPPPPPPPPPP-------------------------------


$ns_ at 0.0 "$node_(0) label \"Destination\""
$ns_ at 0.0 "$node_(2) label \"Source\""

#orange also available 
$ns_ at 0.0 "$node_(0) color blue "
$node_(0) color "blue" 
$ns_ at 0.0 "$node_(1) color red "
$node_(1) color "red" 
$ns_ at 0.0 "$node_(2) color green "
$ns_ at 0.0 "$node_(3) color red "
$ns_ at 0.0 "$node_(4) color blue "
$ns_ at 0.0 "$node_(5) color red "
$ns_ at 0.0 "$node_(6) color blue "
$ns_ at 0.0 "$node_(7) color blue "
$node_(2) color "green" 
$node_(3) color "red" 
$node_(4) color "blue" 
$node_(5) color "red" 
$node_(6) color "blue"
$node_(7) color "blue"


$ns_ at 0.0 "$node_(0) label-color dodgerblue "
$ns_ at 0.0 "$node_(2) label-color magenta "
$ns_ at 0.0 "$node_(2) label-at down "
$ns_ at 0.0 "$node_(0) label-at up "

#$ns_ at 0.0 "$node_(0) shape circle/box/square/hexagon"
$ns_ at 0.0 "$node_(0) add-mark n0 blue circle"
$ns_ at 100.0 "$node_(0) delete-mark n0"
$ns_ at 0.0 "$node_(1) add-mark n1 red square"
$ns_ at 100.0 "$node_(1) delete-mark n1"
$ns_ at 0.0 "$node_(2) add-mark n2 green hexagon"
$ns_ at 100.0 "$node_(2) delete-mark n2"
$ns_ at 0.0 "$node_(3) add-mark n3 red square"
$ns_ at 100.0 "$node_(3) delete-mark n3"
$ns_ at 0.0 "$node_(4) add-mark n4 blue circle"
$ns_ at 100.0 "$node_(4) delete-mark n4"
$ns_ at 0.0 "$node_(5) add-mark n5 red square"
$ns_ at 100.0 "$node_(5) delete-mark n5"
$ns_ at 0.0 "$node_(6) add-mark n6 blue circle"
$ns_ at 100.0 "$node_(6) delete-mark n6"
$ns_ at 0.0 "$node_(7) add-mark n7 blue circle"
$ns_ at 100.0 "$node_(7) delete-mark n7"

$ns_ at 2.0 "$node_(2) shape square"
$ns_ at 4.0 "$node_(3) shape hexagon"
$ns_ at 5.0 "$node_(4) shape circle"
$ns_ at 6.0 "$node_(5) shape hexagon"
$ns_ at 7.0 "$node_(6) shape circle"
$ns_ at 8.0 "$node_(7) shape circle"

$node_(0) shape circle
$node_(1) shape hexagon
$node_(2) shape square
$node_(3) shape hexagon
$node_(4) shape circle
$node_(5) shape hexagon
$node_(6) shape circle
$node_(7) shape circle

#--------------------------------------------------VIMPPPPPPPPPPPPPPPPPPPPPPPPPP-------------------------------  
#$ns_ duplex-link-op $node_(0) $node_(1) color Blue

# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)
#
$ns_ at 0.0 "$node_(1) setdest 100.0 100.0 25.0"
$ns_ at 0.0 "$node_(3) setdest 300.0 100.0 25.0"
$ns_ at 0.0 "$node_(5) setdest 200.0 100.0 25.0"
# Node_(1) then starts to move away from node_(0)
$ns_ at 0.0 "$node_(0) setdest 3.0 1.0 1.0"
$ns_ at 0.0 "$node_(2) setdest 205.0 205.0 1.0"
$ns_ at 0.0 "$node_(4) setdest 405.0 5.0 1.0"

$ns_ at 0.0 "$node_(6) setdest 105.0 5.0 1.0"
$ns_ at 0.0 "$node_(7) setdest 305.0 5.0 1.0"



# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)

#$ns_ at 10.0 "$node_(1) setdest 0.0 200.0 15.0"
#$ns_ at 10.0 "$node_(3) setdest 480.0 200.0 15.0"
#$ns_ at 10.0 "$node_(5) setdest 200.0 0.0 15.0"

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)

set udp [new Agent/UDP]
$ns_ attach-agent $node_(2) $udp
set null [new Agent/Null]
$ns_ attach-agent $node_(0) $null
$ns_ connect $udp $null
$udp set fid_ 2

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false
#Schedule events for the CBR and FTP agents
$ns_ at 0.2 "$cbr start"
$ns_ at 120.5 "$cbr stop"


set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp1
$ns_ attach-agent $node_(4) $sink1
$ns_ connect $tcp1 $sink1
$tcp1 set fid_ 1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$ns_ at 0.0 "$ftp1 start"
$ns_ at 120.5 "$ftp1 stop"

# node size
$ns_ initial_node_pos $node_(0) 50
$ns_ initial_node_pos $node_(1) 50
$ns_ initial_node_pos $node_(2) 50
$ns_ initial_node_pos $node_(3) 50
$ns_ initial_node_pos $node_(4) 50
$ns_ initial_node_pos $node_(5) 50
$ns_ initial_node_pos $node_(6) 50
$ns_ initial_node_pos $node_(7) 50


#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
$ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
global ns_ tracefd
$ns_ flush-trace
close $tracefd
exec nam out.nam &
}
puts "Starting Simulation..."
$ns_ run