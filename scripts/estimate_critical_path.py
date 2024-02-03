import re
from enum import Enum
import copy
import os
import sys

class CriticalPaths:
    def __init__(self):
        path_this_file = os.path.dirname(os.path.abspath(__file__))
        critical_path_file = os.path.join(path_this_file,'..','outputs','DPCL_LAT.txt')
        f = open(critical_path_file,'r')
        lines = f.readlines()
        f.close()
        self.time_ns = dict()
        for line in lines:
            x = re.search(r'^(\w+)\s+:\s+([0-9.]+)\s+([0-9.]+)\s+([0-9.]+)\s+([0-9.]+)\s+([0-9.]+)\s*$',line)
            if x is not None:
                self.time_ns[x.group(1)] = [];
                for i in range(2,7):
                    self.time_ns[x.group(1)].append(float(x.group(i)))
        
class Component:
    def __init__(self, name=None, width=None, inputs=[], outputs=[]):
        self.name = name
        self.width = width
        self.inputs = copy.deepcopy(inputs)
        self.outputs = copy.deepcopy(outputs)
        
class Wire:
    def __init__(self, name=None, width=None, inputs=[], outputs=[]):
        self.name = name
        self.width = width
        self.inputs = copy.deepcopy(inputs)
        self.outputs = copy.deepcopy(outputs)
        
class NetlistParser:

    class PortType(Enum):
        IN_DATA = 0
        IN_CTRL = 1
        OUT_DATA = 2
        OUT_CTRL = 3
        
    __REGEX = {
        'REG': [r'^\s*(\w+)\s*=\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA]], 
        'ADD': [r'^\s*(\w+)\s*=\s*(\w+)\s*\+\s*(?!1)(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'SUB': [r'^\s*(\w+)\s*=\s*(\w+)\s*-\s*(?!1)(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'MUL': [r'^\s*(\w+)\s*=\s*(\w+)\s*\*\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'COMP':[ r'^\s*(\w+)\s*=\s*(\w+)\s*(?:(?:[><])|(?:==))\s*(\w+)\s*$', [PortType.OUT_CTRL, PortType.IN_DATA, PortType.IN_DATA]],
        'MUX2x1':[ r'^\s*(\w+)\s*=\s*(\w+)\s*\?\s*(\w+)\s*:\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_CTRL, PortType.IN_DATA, PortType.IN_DATA]],
        'SHR': [r'^\s*(\w+)\s*=\s*(\w+)\s*>>\s*(\w+)\s*$', [PortType.OUT_CTRL, PortType.IN_DATA, PortType.IN_DATA]],
        'SHL': [r'^\s*(\w+)\s*=\s*(\w+)\s*<<\s*(\w+)\s*$', [PortType.OUT_CTRL, PortType.IN_DATA, PortType.IN_DATA]],
        'DIV': [r'^\s*(\w+)\s*=\s*(\w+)\s*/\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'MOD': [r'^\s*(\w+)\s*=\s*(\w+)\s*%\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'INC': [r'^\s*(\w+)\s*=\s*(\w+)\s*+\s*1\s*$', [PortType.OUT_CTRL, PortType.IN_DATA]],
        'DEC': [r'^\s*(\w+)\s*=\s*(\w+)\s*-\s*1\s*$', [PortType.OUT_CTRL, PortType.IN_DATA]]}
        
    def __init__(self, netlist):
        self.wires = None
        self.components = None
        self.paths = None
        self.critical_path = None
        self.critical_path_ns = None
        f = open(netlist,"r")
        self.lines = f.readlines()
        f.close()
        self.parse_wires()
        self.parse_components()
        self.add_implicit_output_registers()
        self.get_paths()
        self.divide_paths()
        self.get_critical_path()
                
    def parse_wires(self):
        self.wires = []
        for line in self.lines:
            x = re.search(r'\s*(?:input|output|wire|register)\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                width = int(x.group(1).replace("Int",""))
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.wires.append(Wire(name=name, width=width))
     
    def find_wire(self, name):
        for wire in self.wires:
            if wire.name == name:
                return wire
        return None
        
    def parse_components(self):
        self.components = []
        for line in self.lines:
            for name in self.__REGEX.keys():
                x = re.search(self.__REGEX[name][0],line)
                if x is not None:
                    inputs = []
                    width = 0
                    out_width = 0
                    component = Component(name=name)
                    for (idx, port) in enumerate(self.__REGEX[name][1]):
                        wire = self.find_wire(x.group(idx + 1))
                        if wire is None:
                            print(x.group(idx+1))
                        if (port == self.PortType.IN_DATA):
                            width = max(width, wire.width)
                            component.inputs.append(wire)
                            wire.outputs.append(component)
                        elif (port == self.PortType.IN_CTRL):
                            component.inputs.append(wire)
                            wire.outputs.append(component)
                        elif (port == self.PortType.OUT_DATA):
                            out_width = max(out_width, wire.width)
                            component.outputs.append(wire)
                            wire.inputs.append(component)
                        elif (port == self.PortType.OUT_CTRL):
                            component.outputs.append(wire)
                            wire.inputs.append(component)
                    if (component.name == "MUL") and (out_width > width):
                        print(f"\nResizing MUL component to match width of output {component.outputs[0].name}")
                        width = out_width
                    component.width = width
                    self.components.append(component)
    
    def add_implicit_output_registers(self):
        new_wires = []
        for wire in self.wires:
            if (len(wire.outputs) == 0) and (len(wire.inputs) != 0) and (wire.inputs[0].name != "REG"):
                print(f"\nAdding implicit register for output {wire.name}")
                new_wire = Wire(name=wire.name, width=wire.width)
                wire.name = wire.name + "wire"
                component = Component(name="REG")
                component.inputs.append(wire)
                component.outputs.append(new_wire)
                wire.outputs.append(component)
                self.components.append(component)
                new_wire.inputs.append(component)
                new_wires.append(new_wire)
        self.wires.extend(new_wires)

    def get_inputs(self):
        inputs = []
        for wire in self.wires:
            if len(wire.inputs) == 0:
                inputs.append(wire)
        return inputs
        
    def get_paths(self, wire=None):
        if wire is None:
            self.paths = []
            wires = self.get_inputs()
            for wire in wires:
                self.paths.extend(self.get_paths(wire))
            return self.paths
        elif len(wire.outputs) == 0:
            return [[wire]]
        else:
            paths = []
            for output in wire.outputs:
                next_wire = output.outputs[0]
                next_wire_paths = self.get_paths(next_wire)
                for idx in range(len(next_wire_paths)):
                    next_wire_paths[idx].insert(0,output)
                    next_wire_paths[idx].insert(0,wire)
                paths.extend(next_wire_paths)
            return paths

    def divide_paths(self):
        num_paths = len(self.paths)
        for i in range(num_paths):
            new_path = []
            for item in self.paths[i]:
                new_path.append(item)
                if item.name == "REG":
                    self.paths.append(new_path)
                    new_path = [item]
            self.paths[i] = new_path        
        num_paths = len(self.paths)
        for i in range(num_paths-1,-1,-1):
            for j in range(i):
                if len(self.paths[i]) == len(self.paths[j]):
                    match = True
                    for k in range(len(self.paths[i])):
                        if self.paths[i][k] != self.paths[j][k]:
                            match = False
                            break
                    if match:
                        self.paths.pop(i)
                    break                    

    def get_critical_path(self):
        self.critical_path = None
        self.critical_path_ns = 0
        component_critical_paths_ns = CriticalPaths().time_ns;
        for path in self.paths:
            path_latency = 0
            for (idx,item) in enumerate(path):
                if (item.name in component_critical_paths_ns.keys()) and (idx < (len(path) - 1)):
                    if item.width == 2:
                        path_latency = path_latency + component_critical_paths_ns[item.name][0]
                    elif item.width == 8:
                        path_latency = path_latency + component_critical_paths_ns[item.name][1]
                    elif item.width == 16:
                        path_latency = path_latency + component_critical_paths_ns[item.name][2]
                    elif item.width == 32:
                        path_latency = path_latency + component_critical_paths_ns[item.name][3]
                    elif item.width == 64:
                        path_latency = path_latency + component_critical_paths_ns[item.name][4]
            if path_latency > self.critical_path_ns:
                self.critical_path_ns = path_latency
                self.critical_path = path                

    def display_critical_path(self):
        for (idx,item) in enumerate(self.critical_path):
            print(item.name, end = '')
            if idx < (len(self.critical_path)-1):
                print(' -> ', end = '')
            else:
                print()

if __name__ == "__main__":
    parser = NetlistParser(sys.argv[1])
    print('\nCritical Path (ns): %.3f\n' % parser.critical_path_ns)
    print('Critical Path: ',end='')
    parser.display_critical_path()