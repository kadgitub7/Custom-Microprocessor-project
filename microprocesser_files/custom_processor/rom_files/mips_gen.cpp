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
#include <vector>

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
    
    instructions.push_back(encodeI(0x08,0,2,5));   // addi $v0,$zero,5
    instructions.push_back(encodeI(0x08,0,3,7));   // addi $v1,$zero,7
    instructions.push_back(encodeR(0,2,3,4,0,0x20)); // add $a0,$v0,$v1

    instructions.push_back(encodeR(0,3,2,5,0,0x22)); // sub $a1,$v1,$v0

    instructions.push_back(encodeI(0x08,0,2,12)); // 1100
    instructions.push_back(encodeI(0x08,0,3,10)); // 1010
    instructions.push_back(encodeR(0,2,3,4,0,0x24)); // and

    instructions.push_back(encodeR(0,2,3,5,0,0x25)); // or

    instructions.push_back(encodeI(0x08,0,2,3));
    instructions.push_back(encodeI(0x08,0,3,5));
    instructions.push_back(encodeR(0,2,3,4,0,0x2A)); // slt

    // addi $v0,$zero,25
    instructions.push_back(encodeI(0x08,0,2,25));
    // sw $v0,0($zero)
    instructions.push_back(encodeI(0x2B,0,2,0));
    // lw $v1,0($zero)
    instructions.push_back(encodeI(0x23,0,3,0));

    

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
