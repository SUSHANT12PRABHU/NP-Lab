set ns [new Simulator] 
$ns color 1 Blue
set f [open out.tr w]
$ns trace-all $f
set nf [open out.nam w]
$ns namtrace-all $nf


set n0 [$ns node]
$n0 color green
set n1 [$ns node]
$n1 color red
$ns duplex-link $n0 $n1 10Mb 10ms DropTail

set udp0 [new Agent/UDP]
set null0 [new Agent/Null]
$ns attach-agent $n0 $udp0
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0


set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

$udp0 set fid_ 1


proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf
	exec nam out.nam &
	exit

}

$ns at 0.5 "$cbr0 start"
$ns at 3.5 "$cbr0 stop"
$ns at 5.0 "finish" 
$ns run
