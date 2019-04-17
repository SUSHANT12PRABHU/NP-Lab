 # Define options
#===================================================================
set val(chan) Channel/WirelessChannel;# channel type
set val(prop) Propagation/TwoRayGround;# radio-propagation model
set val(netif) Phy/WirelessPhy;# network interface type
set val(mac) Mac/802_11;# MAC type
set val(ifq) Queue/DropTail/PriQueue;# interface queue type
set val(ll) LL;# link layer type
set val(ant) Antenna/OmniAntenna;# antenna model
set val(ifqlen) 5;# max packet in ifq
set val(nn) 6;# number of mobilenodes
set val(rp) DSDV;# routing protocol
#====================================================================

# Initialize Global Variables
set ns_ [new Simulator]
set tracefd [open simple.tr w]
$ns_ trace-all $tracefd
set namtrace [open out.nam w]
$ns_ namtrace-all-wireless $namtrace 500 500

# set up topography object

set topo [new Topography]
$topo load_flatgrid 500 500


# Create God
create-god $val(nn)

# Create the specified number of mobilenodes [$val(nn)] and "attach" them to the channel.

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

$node_(0) set X_ 250.0
$node_(0) set Y_ 490.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 235.0
$node_(1) set Y_ 450.0
$node_(1) set Z_ 0.0
$node_(2) set X_ 265.0
$node_(2) set Y_ 450.0
$node_(2) set Z_ 0.0
$node_(3) set X_ 220.0
$node_(3) set Y_ 410.0
$node_(3) set Z_ 0.0
$node_(4) set X_ 280.0
$node_(4) set Y_ 410.0
$node_(4) set Z_ 0.0
$node_(5) set X_ 250.0
$node_(5) set Y_ 410.0
$node_(5) set Z_ 0.0


$ns_ at 1.0 "$node_(5) setdest 250.0 450.0 15.0"
$ns_ at 1.0 "$node_(0) setdest 250.0 450.0 0.1"
$ns_ at 1.0 "$node_(1) setdest 250.0 450.0 0.1"
$ns_ at 1.0 "$node_(2) setdest 250.0 450.0 0.1"
$ns_ at 1.0 "$node_(3) setdest 250.0 450.0 0.1"
$ns_ at 1.0 "$node_(4) setdest 250.0 450.0 0.1"



set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp1
$ns_ attach-agent $node_(2) $sink1
$ns_ connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 10.0 "$ftp1 start"


set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(2) $sink
$ns_ connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 10.0 "$ftp start"


for {set i 0} {$i < $val(nn) } {incr i} {
$ns_ at 30.0 "$node_($i) reset";
}
$ns_ at 30.0 "stop"
$ns_ at 30.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
global ns_ tracefd
$ns_ flush-trace
close $tracefd
exec nam out.nam &
}
puts "Starting Simulation..."
$ns_ run

