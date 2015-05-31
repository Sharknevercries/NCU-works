## Pipeline

### 前言
本作品完成於大二下學期(2015)，此為「計算機組織」課程的期末專題作業，以`C/C++`來撰寫。
本程式只模擬`lw`、`sw`、`add`、`sub`、`or`、`and`、`beq`、`slt`指令，並有處理`Data hazard`和`Branch hazard`。


### 程式碼說明
以`5-stage`來模擬`Pipeline`行為，分別是：
1. IF (Instruction Fetch)
2. ID (Instruction Decode And Register File)。
3. EX (Execution Or Address Calculation)。
4. MEM (Data Memory Access)。
5. WB (Write Back)。

我依序將`WB`、`MEM`、`EX`、`ID`、`ID`的結果傳到下個階段，之後再來偵測`Hazard`的發生與否。

此結構`Data hazard`發生於：
1. `前兩個指令`之`Rd`所使用的`暫存器`與當前指令的使用到的一樣，需要提前將運算的結果往前傳，以讀取暫存器正確的值。
2. 暫存器`$k`，`lw`後接一個`當前指令`讀取`$k`值，需要將`當前指令`暫停，即安插一個`NOP`於`lw`和`當前指令`之間。

對於`Branch`，採`Always not taken`處理，此結構`Branch hazard`發生於：
1. `Branch`真的發生了！`Branch`發生的判定於`MEM`階段，所以需要將`IF`、`ID`、`EX`的資料全部洗掉(Flush)，並跳到正確的`PC`。