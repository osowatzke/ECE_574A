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
    We listed the paths in our circuit from input to register, register to register,
    and output to register. For each of these paths we notated the data components
    that the signal had to pass through. We only considered registers at the start
    of paths, not those at the end of paths. Then, using the critical paths of
    each of the datapath components we were able to estimate a latency for each
    path. Finally, we selected the path with the largest latency and estimated
    the critical path as its latency.