1)  Name and NetIDs:
    Owen Sowatzke           - osowatzke
    Kazi Safkat             - safkat
    Matthew Nolan           - mdnolan
    Muhtasim Alam Chowdhury - mmc7

2)  Xilinx Synthesis Tool Version
    Vivado 2023.2

3)  Target FPGA and Speed Grade
    xc7a100tcsg324-1

4)  Method Used to Calculate Critical Path
    After the datapath components were instantiated to create the circuit module, we identified interdependencies between the
components by analyzing the port declarations of the instances. By doing so, we were able to infer all possible timing
paths(i.e., in-to-reg, reg-to-reg and reg-to-out paths) in our circuit. For each of the paths, we noted the type and datawidth
of the datapath components that the signal had to pass through. For reg-to-reg paths, we considered the launch register and any
combinational logic between the launch and capture registers but ignored the capture register itself. Next, we used relevant
data from part 2 to estimate a latency for each path. Finally, we compared the latency of each path and asserted the path with
largest latency as the critical path of the circuit.
