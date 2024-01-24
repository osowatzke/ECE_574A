import re
from enum import Enum

class Component:
    def __init__(self, name=None, width=None, inputs=None, outputs=None):
        self.name = name
        self.width = width
        self.inputs = inputs
        self.outputs = outputs
        
class Wire:
    def __init__(self, name=None, width=None, inputs=None, outputs=None):
        self.name = name
        self.width = width
        self.inputs = inputs
        self.outputs = outputs
        
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
        'COMP':[ r'^\s*(\w+)\s*=\s*(\w+)\s*[>=<]\s*(\w+)\s*$', [PortType.OUT_CTRL, PortType.IN_DATA, PortType.IN_DATA]],
        'MUX2x1':[ r'^\s*(\w+)\s*=\s*(\w+)\s*\?\s*(\w+)\s*:\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_CTRL, PortType.IN_DATA, PortType.IN_DATA]],
        'SHR': [r'^\s*(\w+)\s*=\s*(\w+)\s*>>\s*(\w+)\s*$', [PortType.OUT_CTRL, PortType.IN_DATA, PortType.IN_CTRL]],
        'SHL': [r'^\s*(\w+)\s*=\s*(\w+)\s*<<\s*(\w+)\s*$', [PortType.OUT_CTRL, PortType.IN_DATA, PortType.IN_CTRL]],
        'DIV': [r'^\s*(\w+)\s*=\s*(\w+)\s*/\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'MOD': [r'^\s*(\w+)\s*=\s*(\w+)\s*%\s*(\w+)\s*$', [PortType.OUT_DATA, PortType.IN_DATA, PortType.IN_DATA]],
        'INC': [r'^\s*(\w+)\s*=\s*(\w+)\s*+\s*1\s*$', [PortType.OUT_CTRL, PortType.IN_DATA]],
        'DEC': [r'^\s*(\w+)\s*=\s*(\w+)\s*-\s*1\s*$', [PortType.OUT_CTRL, PortType.IN_DATA]]}
        
    def __init__(self, netlist):
        self.wires = None
        self.components = None
        f = open(netlist,"r")
        self.lines = f.readlines()
        f.close()
        self.parse_wires()
        self.parse_components()
        for component in self.components:
            print(component.name)
                
    def parse_wires(self):
        self.wires = []
        for line in self.lines:
            x = re.search(r'\s*(?:input|output|wire)\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
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
                    component = Component(name=name, inputs=[], outputs=[])
                    for (idx, port) in enumerate(self.__REGEX[name][1]):
                        wire = self.find_wire(x.group(idx + 1))
                        if (port == self.PortType.IN_DATA):
                            width = max(width, wire.width)
                            component.inputs.append(wire)
                            wire.outputs = component
                        elif (port == self.PortType.IN_CTRL):
                            component.inputs.append(wire)
                            wire.outputs = component
                        elif (port == self.PortType.OUT_DATA):
                            component.outputs.append(wire)
                            wire.inputs = component
                        elif (port == self.PortType.OUT_CTRL):
                            component.outputs.append(wire)
                            wire.inputs = component
                    component.width = width
                    self.components.append(component)
                    
# def get_inputs(lines):
    # inputs 
    # input_lines = re.findall(r'(?:^|\s)input([^;]+);', file_data);
    # inputs = []
    # for line in input_lines:
        # inputs.extend(re.findall(r'(?:\s*(\w+)\s*(?:,|$))',line))
    # return inputs
    
# def get_outputs(file_data):
    # output_lines = re.findall(r'(?:^|\s)output([^;]+);', file_data);
    # outputs = []
    # for line in output_lines:
        # outputs.extend(re.findall(r'(?:\s*(\w+)\s*(?:,|$))',line))
    # return outputs
    
# def get_component(file_data, name):
    # component_lines = re.findall(rf'(?:^|\s){name}([^;]+);', file_data);
    # print(component_lines)
    # components = []
    # for line in component_lines:
        # match = re.match(r'\s*#\((.*)\)\s+\w+\s*\((.*)\)',line)
        # print(match.groups())
# def get_wires(file_data):
    # output_lines = re.findall(r'(?:^|\s)output([^;]+);', file_data);
    # outputs = []
    # for line in output_lines:
        # outputs.extend(re.findall(r'(?:\s*(\w+)\s*(?:,|$))',line))
    # return outputs
    
# def strip_comments(lines):
    # for line in lines:
        # line = re.findall(r'')
        
if __name__ == "__main__":
    f = NetlistParser("../circuits/474a_circuit1.txt")
    # lines = f.readlines()
    # f.close()
    # print(get_inputs(file_data))
    # get_component(file_data,'ADD')
    #get_inputs("input a, b, c;");