all:
	iverilog -o sim counter.v tb.v
	vvp sim
	gtkwave counter.vcd
