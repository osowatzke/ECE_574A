import re

class FileParser:
    def __init__(self, filepath):
    
        # Create class properties with relevant information
        self.inputs  = None
        self.outputs = None
        self.wires   = None
        self.regs    = None
        self.adds    = None
        self.subs    = None
        self.mults   = None
        self.muxes   = None
        self.shrs    = None
        self.shls    = None
        self.divs    = None
        self.mods    = None
        self.incs    = None
        self.decs    = None
        
        # Read lines from input file
        f = open(filepath, "r")
        self.lines = f.readlines()
        f.close()
        
        # Parse file
        self.strip_comments()
        self.get_inputs()
        self.get_outputs()
        self.get_wires()
        self.get_wires()
        self.get_regs()
        self.get_adds()
        self.get_subs()
        self.get_mults()
        self.get_comps()
        self.get_muxes()
        self.get_shrs()
        self.get_shls()
        self.get_divs()
        self.get_mods()
        self.get_incs()
        self.get_decs()
        
    def strip_comments(self):
        for i in range(len(self.lines)):
            self.lines[i] = re.sub(r'//.*','',self.lines[i]);
            
    def get_inputs(self):
        self.inputs = []
        for line in self.lines:
            x = re.search(r'input\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                width = int(x.group(1).replace("Int",""))
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.inputs.append({'width': width, 'name': name})
     
    def get_outputs(self):
        self.outputs = []
        for line in self.lines:
            x = re.search(r'output\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                width = int(x.group(1).replace("Int",""))
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.outputs.append({'width': width, 'name': name})
        
    def get_wires(self):
        self.wires = []
        for line in self.lines:
            x = re.search(r'wire\s+(\w+)\s+((?:\s*(?:\w+)\s*(?:$|,))+)',line)
            if x is not None:
                dtype  = x.group(1)
                names = re.findall(r'(\w+)\s*(?:$|,)',x.group(2))
                for name in names:
                    self.wires.append({'dtype': dtype, 'name': name})
        
    def get_regs(self):
        self.regs = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*$',line)
            if x is not None:
                self.regs.append({'d': x.group(2), 'q': x.group(1)})
                
    def get_adds(self):
        self.adds = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*\+\s*(\w+)\s*$',line)
            if x is not None:
                self.adds.append({'a': x.group(2), 'b': x.group(3), 'sum': x.group(1)})
        
    def get_subs(self):
        self.subs = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*-\s*(\w+)\s*$',line)
            if x is not None:
                self.subs.append({'a': x.group(2), 'b': x.group(3), 'diff': x.group(1)})
        
    def get_mults(self):
        self.mults = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*\*\s*(\w+)\s*$',line)
            if x is not None:
                self.mults.append({'a': x.group(2), 'b': x.group(3), 'prod': x.group(1)})
        
    def get_comps(self):
        self.comps = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*(>|<|==)\s*(\w+)\s*$',line)
            if x is not None:
                gt = None
                lt = None
                eq = None
                if x.group(3) == ">":
                    gt = x.group(1)
                elif x.group(3) == "<":
                    lt = x.group(1)
                else:
                    eq = x.group(1)
                self.comps.append({'a': x.group(2), 'b': x.group(4), 'gt': gt, 'lt': lt, 'eq': eq})
         
    def get_muxes(self):
        self.muxes = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*\?\s*(\w+)\s*:\s*(\w+)\s*$',line)
            if x is not None:
                self.muxes.append({'a': x.group(3), 'b': x.group(4), 'sel': x.group(2), 'd': x.group(1)})
      
    def get_shrs(self):
        self.shrs = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*>>\s*(\w+)\s*$',line)
            if x is not None:
                self.shrs.append({'a': x.group(2), 'sh_amt' : x.group(3), 'd': x.group(1)})
        
    def get_shls(self):
        self.shls = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*<<\s*(\w+)\s*$',line)
            if x is not None:
                self.shls.append({'a': x.group(2), 'sh_amt' : x.group(3), 'd': x.group(1)})
        
    def get_divs(self):
        self.divs = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*/\s*(\w+)\s*$',line)
            if x is not None:
                self.divs.append({'a': x.group(2), 'b' : x.group(3), 'd': x.group(1)})
       
    def get_mods(self):
        self.mods = []
        for line in self.lines:
            x = re.search(r'(\w+)\s*=\s*(\w+)\s*%\s*(\w+)\s*$',line)
            if x is not None:
                self.mods.append({'a': x.group(2), 'b' : x.group(3), 'd': x.group(1)})
        
    def get_incs(self):
        self.incs = []
        adds_new = []
        for add in self.adds:
            if add['b'] == "1":
                self.incs.append({'a': add['a'], 'd': add['b']})
            else:
                adds_new.append(add)
        self.adds = adds_new
        
    def get_decs(self):
        self.decs = []
        subs_new = []
        for sub in self.subs:
            if sub['b'] == "1":
                self.decs.append({'a': sub['a'], 'd': sub['b']})
            else:
                subs_new.append(sub)
        self.subs = subs_new
  
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
    print("Regs:")
    print(f.regs)
    print("Adds:")
    print(f.adds)
    print("Subs:")
    print(f.subs)
    print("Mults:")
    print(f.mults)
    print("Comps:")
    print(f.comps)
    print("Muxes:")
    print(f.muxes)
    print("Shrs:")
    print(f.shrs)
    print("Shls:")
    print(f.shls)
    print("Divs:")
    print(f.divs)
    print("Mods:")
    print(f.mods)
    print("Incs:")
    print(f.incs)
    print("Decs:")
    print(f.decs)