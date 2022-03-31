//This Verilog module will take input form the Play Station 2 controller, and ouput a 4bit register with the first 2 bits being left motion and last 2 bits being right motion
//This verilog file is currently just basic explanation and logic
//Module will not compile
reg[3:2] = leftmotion // 2'b00, 01, 10
reg[1:0] = rightmotion // 2'b00, 01, 10

//00 -> down
//01 -> still
//00 -> up
