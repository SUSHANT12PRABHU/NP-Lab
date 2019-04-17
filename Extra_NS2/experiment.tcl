# simple-wireless.tcl# A simple example for wireless simulation
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL;# link layer type
set val(ant) Antenna/OmniAntenna;# antenna model
set val(ifqlen) 50;# max packet in ifq
set val(nn) 6;# number of mobilenodes
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
$node_(0) set X_ 100.0
$node_(0) set Y_ 0.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 0.0
$node_(1) set Y_ 100.0
$node_(1) set Z_ 0.0
$node_(2) set X_ 0.0
$node_(2) set Y_ 200.0
$node_(2) set Z_ 0.0
$node_(3) set X_ 100.0
$node_(3) set Y_ 300.0
$node_(3) set Z_ 0.0
$node_(4) set X_ 200.0
$node_(4) set Y_ 200.0
$node_(4) set Z_ 0.0
$node_(5) set X_ 200.0
$node_(5) set Y_ 100.0
$node_(5) set Z_ 0.0


$node_(0) radius 500.0
$node_(1) radius 500.0
$node_(2) radius 500.0
$node_(3) radius 500.0
$node_(4) radius 500.0
$node_(5) radius 500.0
# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)
#
$ns_ at 0.0 "$node_(1) setdest 5.0 105.0 25.0"
$ns_ at 0.0 "$node_(3) setdest 105.0 305.0 25.0"
$ns_ at 0.0 "$node_(5) setdest 205.0 105.0 25.0"
# Node_(1) then starts to move away from node_(0)
$ns_ at 0.0 "$node_(0) setdest 105.0 5.0 25.0"
$ns_ at 0.0 "$node_(2) setdest 5.0 205.0 25.0"
$ns_ at 0.0 "$node_(4) setdest 205.0 205.0 25.0"

#$ns_ at 10.0 "$node_(1) setdest 0.0 200.0 15.0"
#$ns_ at 10.0 "$node_(3) setdest 480.0 200.0 15.0"
#$ns_ at 10.0 "$node_(5) setdest 200.0 0.0 15.0"

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)
set tcp [new Agent/TCP]
$tcp set class_ 1
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp
$ns_ attach-agent $node_(0) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.0 "$ftp start"

  set udp [new Agent/UDP]
  $udp set class_ 1
  $ns_ attach-agent $node_(2) $udp
  set null [new Agent/Null]
  $ns_ attach-agent $node_(0) $null
  $ns_ connect $udp $null
  $udp set fid_ 1

  set cbr [new Application/Traffic/CBR]
  $cbr attach-agent $udp
  $cbr set type_ CBR
  $cbr set packet_size_ 1000
  $cbr set rate_ 1mb
  $cbr set random_ false
  #Schedule events for the CBR and FTP agents
  $ns_ at 0.2 "$cbr start"
  $ns_ at 4.5 "$cbr stop"

set tcp1 [new Agent/TCP]
$tcp1 set class_ 1
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $tcp1
$ns_ attach-agent $node_(0) $sink1
$ns_ connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 0.0 "$ftp1 start"


set tcp2 [new Agent/TCP]
$tcp2 set class_ 1
set sink2 [new Agent/TCPSink]
$ns_ attach-agent $node_(1) $tcp2
$ns_ attach-agent $node_(3) $sink2
$ns_ connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns_ at 0.0 "$ftp2 start"

set tcp3 [new Agent/TCP]
$tcp3 set class_ 1
set sink3 [new Agent/TCPSink]
$ns_ attach-agent $node_(5) $tcp3
$ns_ attach-agent $node_(3) $sink3
$ns_ connect $tcp3 $sink3
set ftp3 [new Application/FTP]
$ftp3 attach-agent $tcp3
$ns_ at 0.0 "$ftp3 start"

# node size
$ns_ initial_node_pos $node_(0) 50
$ns_ initial_node_pos $node_(1) 50
$ns_ initial_node_pos $node_(2) 50
$ns_ initial_node_pos $node_(3) 50
$ns_ initial_node_pos $node_(4) 50
$ns_ initial_node_pos $node_(5) 50


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
exit 0
}
puts "Starting Simulation..."
$ns_ run