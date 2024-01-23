import re

class FileParser:
    def __init__(self, filepath):
    
        # Create class properties with relevant information
        self.inputs     = None
        self.outputs    = None
        self.wires      = None
        self.components = None
        
        # Read lines from input file
        f = open(filepath, "r")
        self.lines = f.readlines()
        f.close()
        
        # Parse file
        self.strip_comments()
        self.parse_inputs()
        self.parse_outputs()
        self.parse_wires()
        self.parse_components()
        
    def strip_comments(self):
        for i in range(len(self.lines)):
            self.lines[i] = re.sub(r'//.*','',self.lines[i]);
            
    def parse_inputs(self):
        self.inputs = []
        for line in self.lines:
            x = re.search(r'input\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                width = int(x.group(1).replace("Int",""))
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.inputs.append({'width': width, 'name': name})
     
    def parse_outputs(self):
        self.outputs = []
        for line in self.lines:
            x = re.search(r'output\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                width = int(x.group(1).replace("Int",""))
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.outputs.append({'width': width, 'name': name})
        
    def parse_wires(self):
        self.wires = []
        for line in self.lines:
            x = re.search(r'wire\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                width = int(x.group(1).replace("Int",""))
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.wires.append({'width': width, 'name': name})
    
    def parse_components(self):
        self.components = []
        for line in self.lines:
            self.parse_component(line)
            
    def parse_component(self, line):
        if self.parse_inc(line):
            return
        if self.parse_dec(line):
            return
        if self.parse_reg(line):
            return
        if self.parse_add(line):
            return
        if self.parse_sub(line):
            return
        if self.parse_mult(line):
            return
        if self.parse_comp(line):
            return
        if self.parse_mux(line):
            return
        if self.parse_shr(line):
            return
        if self.parse_shl(line):
            return
        if self.parse_div(line):
            return
        if self.parse_mod(line):
            return
        
    def parse_reg(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            d = x.group(2)
            q = x.group(1)
            width = self.get_width(d)
            self.components.append({'name': 'REG', 'width': width, 'ports': {'d': d, 'q': q}})
            return True
                
    def parse_add(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*\+\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a = x.group(2)
            b = x.group(3)
            s = x.group(1)
            width = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'ADD', 'width': width, 'ports': {'a': a, 'b': b, 'sum': s}})
            return True
            
    def parse_sub(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*-\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a = x.group(2)
            b = x.group(3)
            d = x.group(1)
            width = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'SUB', 'width': width, 'ports': {'a': a, 'b': b, 'diff' : d}})
            return True
            
    def parse_mult(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*\*\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a = x.group(2)
            b = x.group(3)
            p = x.group(1)
            width = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'MUL', 'width': width, 'ports': {'a': a, 'b': b, 'prod': p}})
            return True
            
    def parse_comp(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*(>|<|==)\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            gt = None
            lt = None
            eq = None
            if x.group(3) == ">":
                gt = x.group(1)
            elif x.group(3) == "<":
                lt = x.group(1)
            else:
                eq = x.group(1)
            a = x.group(2)
            b = x.group(4)
            width = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'COMP', 'width': width, 'ports': {'a': a, 'b': b, 'gt' : gt, 'lt': lt, 'eq': eq}})
            return True
            
    def parse_mux(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*\?\s*(\w+)\s*:\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a   = x.group(3)
            b   = x.group(4)
            sel = x.group(2)
            d   = x.group(1)
            width = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'MUX2x1', 'width': width, 'ports': {'a': a, 'b': b, 'sel': sel, 'd': d}})
            return True

    def parse_shr(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*>>\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a      = x.group(2)
            sh_amt = x.group(3)
            d      = x.group(1)
            width  = self.get_width(a)
            self.components.append({'name': 'SHR', 'width': width, 'ports': {'a': a, 'sh_amt': sh_amt, 'd': d}})
            return True
            
    def parse_shl(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*<<\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a      = x.group(2)
            sh_amt = x.group(3)
            d      = x.group(1)
            width  = self.get_width(a)
            self.components.append({'name': 'SHL', 'width': width, 'ports': {'a': a, 'sh_amt': sh_amt, 'd': d}})
            return True

    def parse_div(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*/\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a      = x.group(2)
            b      = x.group(3)
            qout   = x.group(1)
            width  = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'DIV', 'width': width, 'ports': {'a': a, 'b': b, 'qout': qout}})
            return True
            
    def parse_mod(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*%\s*(\w+)\s*$',line)
        if x is None:
            return False
        else:
            a      = x.group(2)
            b      = x.group(3)
            rem    = x.group(1)
            width  = max(self.get_width(a), self.get_width(b))
            self.components.append({'name': 'MOD', 'ports': {'a': a, 'b': b, 'rem': rem}})
            return True
            
    def parse_inc(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*\+\s*1\s*$',line)
        if x is None:
            return False
        else:
            a      = x.group(2)
            d      = x.group(1)
            width  = self.get_width(a)
            self.components.append({'name': 'INC', 'width': width, 'ports': {'a': a, 'd': d}})
            return True
            
    def parse_dec(self, line):
        x = re.search(r'(\w+)\s*=\s*(\w+)\s*-\s*1\s*$',line)
        if x is None:
            return False
        else:
            a      = x.group(2)
            d      = x.group(1)
            width  = self.get_width(a)
            self.components.append({'name': 'DEC', 'width': width, 'ports': {'a': a, 'd': d}})
            return True

    def get_width(self, name):
        input_width  = self.get_input_width(name)
        if input_width is not None:
            return input_width
        output_width = self.get_output_width(name)
        if output_width is not None:
            return output_width
        wire_width   = self.get_wire_width(name)
        if wire_width is not None:
            return wire_width
        return None
        
    def get_input_width(self, name):
        for i in range(len(self.inputs)):
            if (self.inputs[i]['name'] == name):
                return self.inputs[i]['width']
        return None

    def get_output_width(self, name):
        for i in range(len(self.outputs)):
            if (self.outputs[i]['name'] == name):
                return self.outputs[i]['width']
        return None
        
    def get_wire_width(self, name):
        for i in range(len(self.wires)):
            if (self.wires[i]['name'] == name):
                return self.wires[i]['width']
        return None
    
class FileWriter:
    def __init__(self, filepath, module_name, parser):
        self.file = open(filepath, "w")
        self.module_name = module_name
        self.parser = parser
        self.write_header()
        self.write_inputs()
        self.write_outputs()
        self.file.close()
        
    def write_header(self):
        self.file.write(f'module {self.module_name}(')
        for i in range(len(self.parser.inputs)):
            self.file.write(f'{self.parser.inputs[i]['name']}')
            if i < (len(self.parser.inputs)-1):
                self.file.write(', ')
        self.file.write(');\n\n')
        
    def write_inputs(self):
        for i in range(len(self.parser.inputs)):
            self.file.write(f'    input [{self.parser.inputs[i]['width']-1}:0] {self.parser.inputs[i]['name']};\n')
        self.file.write('\n');
        
    def write_outputs(self):
        for i in range(len(self.parser.outputs)):
            self.file.write(f'    output [{self.parser.outputs[i]['width']-1}:0] {self.parser.outputs[i]['name']};\n')
        self.file.write('\n');
        
if __name__ == "__main__":
    f = FileParser("../circuits/474a_circuit1.txt")
    FileWriter("temp.v", "temp", f)
    
    print("Inputs:")
    print(f.inputs)
    print("Outputs:")
    print(f.outputs)
    print("Wires:")
    print(f.wires)
    print("Components:")
    print(f.components)
    
    # print("Regs:")
    # print(f.regs)
    # print("Adds:")
    # print(f.adds)
    # print("Subs:")
    # print(f.subs)
    # print("Mults:")
    # print(f.mults)
    # print("Comps:")
    # print(f.comps)
    # print("Muxes:")
    # print(f.muxes)
    # print("Shrs:")
    # print(f.shrs)
    # print("Shls:")
    # print(f.shls)
    # print("Divs:")
    # print(f.divs)
    # print("Mods:")
    # print(f.mods)
    # print("Incs:")
    # print(f.incs)
    # print("Decs:")
    # print(f.decs)