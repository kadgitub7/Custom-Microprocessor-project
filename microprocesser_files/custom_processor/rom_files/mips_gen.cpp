/*
  Simple MIPS Instruction Generator
  Converts basic MIPS mnemonics to hex machine code
  
  Usage: Generate MIPS instructions and write to program.mem
*/

#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <bitset>
#include <sstream>

using namespace std;

// MIPS register mapping
map<string, int> registers = {
    {"$zero", 0}, {"$0", 0},
    {"$at", 1}, {"$1", 1},
    {"$v0", 2}, {"$2", 2},
    {"$v1", 3}, {"$3", 3},
    {"$a0", 4}, {"$4", 4},
    {"$a1", 5}, {"$5", 5},
    {"$a2", 6}, {"$6", 6},
    {"$a3", 7}, {"$7", 7},
    {"$t0", 8}, {"$8", 8},
    {"$t1", 9}, {"$9", 9},
};

// Function to convert register name to number
int getReg(string regName) {
    return registers[regName];
}

// Generate R-type instruction: opcode rs rt rd shamt funct
uint32_t encodeR(int opcode, int rs, int rt, int rd, int shamt, int funct) {
    uint32_t instr = 0;
    instr |= ((opcode & 0x3F) << 26);
    instr |= ((rs & 0x1F) << 21);
    instr |= ((rt & 0x1F) << 16);
    instr |= ((rd & 0x1F) << 11);
    instr |= ((shamt & 0x1F) << 6);
    instr |= (funct & 0x3F);
    return instr;
}

// Generate I-type instruction: opcode rs rt immediate
uint32_t encodeI(int opcode, int rs, int rt, int imm) {
    uint32_t instr = 0;
    instr |= ((opcode & 0x3F) << 26);
    instr |= ((rs & 0x1F) << 21);
    instr |= ((rt & 0x1F) << 16);
    instr |= (imm & 0xFFFF);
    return instr;
}

int main() {
    ofstream outFile("program.mem");
    
    if (!outFile.is_open()) {
        cerr << "Error opening program.mem" << endl;
        return 1;
    }
    
    // Test program: Add two numbers and store result then multiply and store result
    vector<uint32_t> instructions;
    
    // addi $v0, $zero, 5    (Load 5 into $v0)
    instructions.push_back(encodeI(0x08, 0, 2, 5));
    
    // addi $v1, $zero, 6    (Load 6 into $v1)
    instructions.push_back(encodeI(0x08, 0, 3, 6));

    instructions.push_back(encodeI(0x08, 0, 4, 2)); // Load 2 into $a0 for multiplication
    
    // add $a0, $v0, $v1     (Add $v0 and $v1, store in $a0)
    instructions.push_back(encodeR(0, 2, 3, 4, 0, 0x20));
    
    // addi $a1, $zero, 10   (Load 10 into $a1 for comparison)
    instructions.push_back(encodeI(0x08, 0, 5, 10));

    instructions.push_back(encodeR(0, 4, 5, 2, 0, 0x24)); // multiply $a0 and $a1, store in $v0 (custom instruction)
    
    // Write instructions to file
    for (size_t i = 0; i < instructions.size(); i++) {
        outFile << hex << uppercase << instructions[i];
        outFile << "    // Line " << dec << i << " (Address " << (i * 4) << ")" << endl;
    }
    
    outFile.close();
    
    cout << "Generated " << instructions.size() << " instructions in program.mem" << endl;
    cout << "Instructions written:" << endl;
    for (size_t i = 0; i < instructions.size(); i++) {
        cout << "  [" << i << "] = 0x" << hex << uppercase << instructions[i] << endl;
    }
    
    return 0;
}
