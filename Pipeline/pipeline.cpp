/*

Author: 

	102502012 資工二A 李政遠, or
	Sharknevercries

Description: 

	This is for simulating CPU pipeline with five stages.
	Flush the IF, ID, EX to solve branch hazard.
	To do this, just flush ifid, idex and exmem.
	Rs, Rt, Rd need to read carefully.

Date:

	2015/5/30

*/

// C++
#include<iostream>
#include<stack>
#include<vector>
#include<queue>
#include<map>
#include<set>
#include<bitset>
#include<algorithm>
#include<functional>
#include<deque>
// C
#include<cstdio>
#include<cstring>
#include<ctime>
#include<cctype>
#include<cmath>
using namespace std;
int n;
string instructions[10];
int mem[5] = { 9, 6, 4, 2, 5 };
int reg[9] = { 0, 5, 8, 6, 7, 5, 1, 2, 4 };
int getDecimal(string str, bool sign){
	bool flag = false;
	int res = 0;
	for (int i = 0; i < str.length(); i++){
		res = res * 2 + str[i] - '0';
		if (i == 0 && str[i] == '1')
			flag = true;
	}
	if (flag && sign)	res = -res;
	return res;
}
struct IF_ID{
	bool in;
	int pc;
	string instruction;
	IF_ID(){
		in = false;
		pc = 4;
		instruction = "00000000000000000000000000000000";
	}
	void instructionFetch(){
		instruction = instructions[pc / 4];
		pc += 4;
		in = true;
		if (instruction == "")
			instruction = "00000000000000000000000000000000", in = false;
	}
	void print(){
		puts("IF/ID :");
		printf("PC		%d\n", pc - 4);
		printf("Instruction	%s\n", instruction.c_str());
	}
	void flush(){
		in = true;
		instruction = "00000000000000000000000000000000";
		pc -= 4;
	}
};
struct ID_EX{
	bool in;
	int readData1;
	int readData2;
	int sign_ext;
	int rs, rt, rd;
	int pc;
	string func;
	string opcode;
	string controlSignals;
	ID_EX(){
		in = false;
		readData1 = readData2 = 0;
		sign_ext = 0;
		rs = rt = rd = pc = 0;
		controlSignals = "000000000";
	}
	void instructionDecode(IF_ID ifid){
		opcode = ifid.instruction.substr(0, 6);
		in = ifid.in;
		func = ifid.instruction.substr(26, 6);
		rs = getDecimal(ifid.instruction.substr(6, 5), false);
		rt = getDecimal(ifid.instruction.substr(11, 5), false);
		pc = ifid.pc;
		readData1 = reg[rs];
		readData2 = reg[rt];
		if (opcode == "000000"){			// R type
			rd = getDecimal(ifid.instruction.substr(16, 5), false);
			sign_ext = 0;
			if (ifid.instruction == "00000000000000000000000000000000"){	// NOP
				controlSignals = "000000000";
			}
			else{
				controlSignals = "110000010";
			}
		}
		else{								// I type
			rd = 0;
			sign_ext = getDecimal(ifid.instruction.substr(16), true);
			if (opcode == "100011"){		// lw
				controlSignals = "000101011";
			}
			else if (opcode == "101011"){	// sw
				controlSignals = "000100100";
			}
			else if (opcode == "000100"){	// beq
				controlSignals = "001010000";
			}
			else{
				puts("[BUG] Out of command!!!");
			}								// no J Type
		}									
	}
	void print(){
		puts("ID/EX :");
		printf("ReadData1	%d\n", readData1);
		printf("ReadData2	%d\n", readData2);
		printf("sign_ext	%d\n", sign_ext);
		printf("Rs		%d\n", rs);
		printf("Rt		%d\n", rt);
		printf("Rd		%d\n", rd);
		printf("Control signals	%s\n", controlSignals.c_str());
	}
	void flush(){
		in = true;
		readData1 = readData2 = 0;
		sign_ext = 0;
		rs = rt = rd = pc = 0;
		controlSignals = "000000000";
	}
};
struct EX_MEM{
	bool in;
	int ALUout;
	int writeData;
	int rt;
	int pc;
	string controlSignals;
	EX_MEM(){
		in = false;
		ALUout = 0;
		writeData = 0;
		rt = pc = 0;
		controlSignals = "00000";
	}
	void calculateAddress(ID_EX idex){
		in = idex.in;
		writeData = idex.readData2;
		rt = idex.controlSignals[0] == '1' ? idex.rd : idex.rt;
		controlSignals = idex.controlSignals.substr(4);
		int a = idex.readData1;
		int b = idex.controlSignals[3] == '0' ? idex.readData2 : idex.sign_ext;
		string ALUop = idex.controlSignals.substr(1, 2);
		if (ALUop == "10"){
			if (idex.func == "100000")		// add
				ALUout = a + b;
			else if (idex.func == "100010")	// sub
				ALUout = a - b;
			else if (idex.func == "100100")	// and
				ALUout = a & b;
			else if (idex.func == "100101")	// or
				ALUout = a | b;
			else if (idex.func == "101010")	// slt
				ALUout = a < b;
			else if (idex.func == "000000")	// NOP in R type
				ALUout = 0;
			else
				puts("[BUG] func out of range!!!");
		}
		else if (ALUop == "00"){			// lw, sw
			ALUout = a + b;
		}
		else if (ALUop == "01"){			// beq
			ALUout = a - b;
		}
		else
			puts("[BUG] ALUop undefiine!");
		// pc
		pc = idex.pc + (idex.sign_ext << 2);
	}
	void print(){
		puts("EX/MEM :");
		printf("ALUout		%d\n", ALUout);
		printf("WriteData	%d\n", writeData);
		printf("Rt		%d\n", rt);
		printf("Control signals	%s\n", controlSignals.c_str());
	}
	void flush(){
		in = true;
		ALUout = 0;
		writeData = 0;
		rt = pc = 0;
		controlSignals = "00000";
	}
};
struct MEM_WB{
	bool in;
	bool branch;
	int readData;
	int ALUout;
	int rt;		// rd
	string controlSignals;
	MEM_WB(){
		readData = 0;
		ALUout = 0;
		rt = 0;
		in = branch = false;
		controlSignals = "00";
	}
	void readFromMemory(EX_MEM exmem, IF_ID &ifid){
		branch = false;
		in = exmem.in;
		rt = exmem.rt;
		controlSignals = exmem.controlSignals.substr(3);
		ALUout = exmem.ALUout;
		// branch
		if (exmem.controlSignals[0] == '1' && ALUout == 0){
			branch = true;
			ifid.pc = exmem.pc;
		}
		// lw
		readData = exmem.controlSignals[1] == '1' ? mem[ALUout / 4] : 0;
		// sw
		if (exmem.controlSignals[2] == '1')
			mem[ALUout / 4] = exmem.writeData;
	}
	void print(){
		puts("MEM/WB :");
		printf("ReadData	%d\n", readData);
		printf("ALUout		%d\n", ALUout);
		printf("Control signals	%s\n", controlSignals.c_str());
	}
};
struct Pipeline{
	IF_ID ifid;
	ID_EX idex;
	EX_MEM exmem;
	MEM_WB memwb;
	int cc;
	Pipeline(){	cc = 0;	}
	void writeReg(MEM_WB memwb){
		if (memwb.controlSignals[0] == '1'){
			if (memwb.rt == 0)	return;
			reg[memwb.rt] = memwb.controlSignals[1] == '1' ? memwb.readData : memwb.ALUout;
		}
	}
	void checkHazard(){
		// data hazard
		if (memwb.controlSignals[0] == '1' && memwb.rt != 0){
			if (memwb.rt == idex.rs)
				idex.readData1 = memwb.controlSignals[1] == '1' ? memwb.readData : memwb.ALUout;
			if (memwb.rt == idex.rt)
				idex.readData2 = memwb.controlSignals[1] == '1' ? memwb.readData : memwb.ALUout;
		}
		if (exmem.controlSignals[3] == '1' && exmem.rt != 0){
			if (exmem.rt == idex.rs)
				idex.readData1 = exmem.controlSignals[4] == '0' ? exmem.ALUout : idex.readData1;
			if (exmem.rt == idex.rt)
				idex.readData2 = exmem.controlSignals[4] == '0' ? exmem.ALUout : idex.readData2;
		}
		if (idex.controlSignals[5] == '1'
			&& (idex.rt == getDecimal(ifid.instruction.substr(6, 5), false)
			|| idex.rt == getDecimal(ifid.instruction.substr(11, 5), false))){
			// set NOP
			ifid.instruction = "00000000000000000000000000000000";
			ifid.pc -= 4;
			ifid.in = true;
		}
		// branch hazard
		if (memwb.branch){
			ifid.flush();
			idex.flush();
			exmem.flush();
		}
	}
	bool nextStep(){
		writeReg(memwb);
		memwb.readFromMemory(exmem, ifid);
		exmem.calculateAddress(idex);
		idex.instructionDecode(ifid);
		ifid.instructionFetch();
		checkHazard();
		cc++;
		print();
		if (!ifid.in && !idex.in && !exmem.in && !memwb.in)
			return false;
		else
			return true;
	}
	void print(){
		printf("CC %d:\n", cc);
		puts("\nRegisters:");
		for (int i = 0; i < 9; i++){
			printf("$%d: %d	  ", i, reg[i]);
			if ((i + 1) % 3 == 0)
				putchar('\n');
		}
		puts("\nData memory:");
		for (int i = 0; i < 5; i++)
			printf("%0d:	%d\n", i * 4, mem[i]);
		puts("");
		ifid.print();
		puts("");
		idex.print();
		puts("");
		exmem.print();
		puts("");
		memwb.print();
		puts("======================================");
	}
};
Pipeline pipe;
int main(){
	freopen("input.txt", "r", stdin);
	freopen("output.txt", "w", stdout);
	n = 1;
	while (cin >> instructions[n])	n++;
	while (pipe.nextStep());
	return 0;
}