/*
 *	Generated .v file from Newton
 */

`timescale 1 ns/ 100 ps

module qmultSequential #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)
	(
	input 	[N-1:0] i_multiplicand,
	input 	[N-1:0]	i_multiplier,
	input 	i_start,
	input 	i_clk,
	output 	[N-1:0] o_result_out,
	output 	o_complete,
	output	o_overflow
	);

	reg [2*N-2:0]	reg_working_result;		//	a place to accumulate our result
	reg [2*N-2:0]	reg_multiplier_temp;		//	a working copy of the multiplier
	reg [N-1:0]	reg_multiplicand_temp;		//	a working copy of the umultiplicand
	reg [N-1:0]	reg_result_temp;
	wire [N-1:0] 	i_multiplicand_unsigned;
	wire [N-1:0] 	i_multiplier_unsigned;
	reg [N-1:0] 	reg_count; 			//	This is obviously a lot bigger than it needs to be, as we only need 
							//		count to N, but computing that number of bits requires a 
							//		logarithm (base 2), and I don't know how to do that in a 
							//		way that will work for every possibility						 
    reg reg_working;
	reg	reg_done;				//	Computation completed flag
	reg	reg_sign;				//	The result's sign bit
	reg	reg_overflow;				//	Overflow flag

    initial reg_working = 1'b0;		//	Initial state is to not be doing anything
	initial reg_done = 1'b0;		//	Initial state is to not be doing anything
	initial reg_overflow = 1'b0;		//		And there should be no woverflow present
	initial reg_sign = 1'b0;		//		And the sign should be positive

	assign o_result_out[N-1:0] = reg_result_temp[N-1:0];
	//reg_working_result[N-2+Q:Q];	//	The multiplication results
	assign i_multiplicand_unsigned = ~i_multiplicand[N-1:0] + 1;
	assign i_multiplier_unsigned = ~i_multiplier[N-1:0] + 1;
	assign o_complete = reg_done;					//	Done flag
	assign o_overflow = reg_overflow;				//	Overflow flag

	always @( posedge i_clk ) begin
		if( !reg_working && i_start ) begin				//	This is our startup condition
			reg_done <= 1'b0;				//	We're not done
			reg_working <= 1'b1;		//	Initial state is to not be doing anything			
			reg_count <= 0;					//	Reset the count
			reg_working_result <= 0;			//	Clear out the result register
			reg_overflow <= 1'b0;				//	Clear the overflow register

			reg_sign <= i_multiplicand[N-1] ^ i_multiplier[N-1];		//	Set the sign bit

			if (i_multiplicand[N-1] == 1) 
				reg_multiplicand_temp <= i_multiplicand_unsigned[N-1:0]; //~i_multiplicand[N-1:0] + 1;	//	Left-align the dividend in its working register
			else
				reg_multiplicand_temp <= i_multiplicand[N-1:0];		//	Left-align the dividend in its working register

			if (i_multiplier[N-1] == 1) 
				reg_multiplier_temp <= i_multiplier_unsigned[N-1:0]; //~i_multiplier[N-1:0] + 1;	//	Left-align the divisor into its working register
			else
				reg_multiplier_temp <= i_multiplier[N-1:0];		//	Left-align the divisor into its working register 

		end 
		else if (reg_working) begin
			if (reg_multiplicand_temp[reg_count] == 1'b1)				//	if the appropriate multiplicand bit is 1
				reg_working_result <= reg_working_result + reg_multiplier_temp;	//	then add the temp multiplier

			reg_multiplier_temp <= reg_multiplier_temp << 1;			//	Do a left-shift on the multiplier
			reg_count <= reg_count + 1;						//	Increment the count

			//stop condition
			if(reg_count == N) begin
				reg_done <= 1'b1;						//	If we're done, it's time to tell the calling process
				reg_working <= 1'b0;		//	Initial state is to not be doing anything

				if (reg_sign == 1)
					reg_result_temp[N-1:0] <= ~reg_working_result[N-2+Q:Q] + 1;
				else
					reg_result_temp[N-1:0] <= reg_working_result[N-2+Q:Q];

				if (reg_working_result[2*N-2:N-1+Q] > 0)			// Check for an overflow
					reg_overflow <= 1'b1;
												//	Increment the count
			end
		end
	end
    endmodule


module qdivSequential #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)
	(
	input 	[N-1:0] i_dividend,
	input 	[N-1:0] i_divisor,
	input 	i_start,
	input 	i_clk,
	output 	[N-1:0] o_quotient_out,
	output 	o_complete,
	output	o_overflow
	);

	wire [N-1:0] 	reg_dividend_unsigned;	//
	wire [N-1:0] 	reg_divisor_unsigned;	//
	wire [N-1:0] 	reg_quotient_signed;	//	

	reg [2*N+Q-3:0]	reg_working_quotient;	//	Our working copy of the quotient
	reg [N-1:0] 	reg_quotient_unsigned;	//	Final quotient
	reg [N-1:0] 	reg_quotient;		//	Final quotient
	reg [N-2+Q:0] 	reg_working_dividend;	//	Working copy of the dividend
	reg [2*N+Q-3:0]	reg_working_divisor;	// Working copy of the divisor

	reg [N-1:0] reg_count; 		//	This is obviously a lot bigger than it needs to be, as we only need 
					           //		count to N-1+Q but, computing that number of bits requires a 
					           //		logarithm (base 2), and I don't know how to do that in a 
					           //		way that will work for everyone

	reg reg_working;									 
	reg reg_done;		//	Computation completed flag
	reg	reg_sign;		//	The quotient's sign bit
	reg	reg_overflow;		//	Overflow flag

	initial reg_done = 1'b0;	//	Initial state is to not be doing anything
	initial reg_working = 1'b0;		//	Initial state is to not be doing anything
	initial reg_overflow = 1'b0;	//	And there should be no overflow present
	initial reg_sign = 1'b0;	//	And the sign should be positive

	initial reg_working_quotient = 0;	
	initial reg_quotient = 0;				
	initial reg_working_dividend = 0;	
	initial reg_working_divisor = 0;		
 	initial reg_count = 0;

	assign reg_dividend_unsigned = ~i_dividend + 1;
	assign reg_divisor_unsigned = ~i_divisor + 1;
	assign o_quotient_out[N-1:0] = reg_quotient[N-1:0];	//	The division results
	assign o_complete = reg_done;
	assign o_overflow = reg_overflow;

	always @( posedge i_clk ) begin
		if( !reg_working && i_start ) begin			//	This is our startup condition
			//  Need to check for a divide by zero right here, I think....
			reg_done <= 1'b0;			     //	We're not done
			reg_working <= 1'b1;		//				
			reg_count <= N+Q-1;			     //	Set the count
			reg_working_quotient <= 0;		//	Clear out the quotient register
			reg_working_dividend <= 0;		//	Clear out the dividend register 
			reg_working_divisor <= 0;		//	Clear out the divisor register 
			reg_overflow <= 1'b0;			//	Clear the overflow register

			if (i_dividend[N-1] == 1) 
				reg_working_dividend[N+Q-2:Q] <= reg_dividend_unsigned[N-2:0];		//	Left-align the dividend in its working register
			else
				reg_working_dividend[N+Q-2:Q] <= i_dividend[N-2:0];		           //	Left-align the dividend in its working register

			if (i_divisor[N-1] == 1) 
				reg_working_divisor[2*N+Q-3:N+Q-1] <= reg_divisor_unsigned[N-2:0];		//	Left-align the divisor into its working register
			else
				reg_working_divisor[2*N+Q-3:N+Q-1] <= i_divisor[N-2:0];		           //	Left-align the divisor into its working register 

			reg_sign <= i_dividend[N-1] ^ i_divisor[N-1];		//	Set the sign bit
		end 
		else if(reg_working) begin
			reg_working_divisor = reg_working_divisor >> 1;	//	Right shift the divisor (that is, divide it by two - aka reduce the divisor)
			reg_count = reg_count - 1;				//	Decrement the count

			//	If the dividend is greater than the divisor
			if(reg_working_dividend >= reg_working_divisor) begin
				reg_working_quotient[reg_count] = 1'b1;				//	Set the quotient bit
				reg_working_dividend = reg_working_dividend - reg_working_divisor;	//	and subtract the divisor from the dividend
			end

			//stop condition
			if(reg_count == 0) begin
				reg_done = 1'b1;				                        //	If we're done, it's time to tell the calling process
				reg_working = 1'b0;		                                 //	
				reg_quotient_unsigned = reg_working_quotient[N-1:0];	//	Move in our working copy to the outside world

				if (reg_sign == 1)
					reg_quotient = ~reg_quotient_unsigned + 1;
				else
					reg_quotient = reg_working_quotient[N-1:0];

				if (reg_working_quotient[2*N+Q-3:N]>0)
					reg_overflow = 1'b1;
			end
		end
	end
endmodule


module calcTempInvariantSerial #(
	//Parameterized values
	parameter Q = 15,
	parameter N = 32
	)
	(
	input	i_clk,
	input	[N-1:0] temp_adc_sig,
	input	[N-1:0] calib_par_t1_sig,
	input	[N-1:0] calib_par_t2_sig,
	input	[N-1:0] calib_par_t3_sig,
	input	[N-1:0] calc_temp_sig,
	output	[N-1:0] pi_0_calcSig,
	output	[N-1:0] pi_1_calcSig,
	output	[N-1:0] pi_2_calcSig
	);

	reg	i_st;
	reg	[N-1:0] pi_0_calcReg;
	reg	[N-1:0] pi_1_calcReg;
	reg	[N-1:0] pi_2_calcReg;
	wire	oc_Pi;
	initial i_st = 1'b0;

	/* ----- Original Pi values were ----- */
	/* ----- Pi 0 ----- 
	 * Param 0: 0.000000 
	 * Param 1: -1.000000 
	 * Param 2: 1.000000 
	 * Param 3: -1.000000 
	 * Param 4: 0.000000 
	 * fractionsLCM 1 
	 */

	/* ----- Calculations for Pi 0 ----- */
	wire [N-1:0] division_res_Pi_0;
	wire [N-1:0] dividend_Pi_0;
	wire [N-1:0] divisor_Pi_0;

	wire oc_Pi_0;
	wire of_Pi_0;
	wire i_st_ratio_Pi_0;
	reg oc_dividend_Pi_0;
	initial oc_dividend_Pi_0 = 1'b1;
	wire oc_divisor_Pi_0;

	/* ----- Dividend ----- */
	assign dividend_Pi_0 = calib_par_t2_sig;

	/* ----- Divisor ----- */
	qmultSequential mul_inst_divisor_Pi_0 (
		.i_multiplicand(calib_par_t1_sig),
		.i_multiplier(calib_par_t3_sig),
		.i_start(i_st),					
		.i_clk(i_clk),					
		.o_result_out(divisor_Pi_0),					
		.o_complete(oc_divisor_Pi_0),					
		.o_overflow(of_Pi_0)
	);


	/* ----- Division enabling ----- */
	assign i_st_ratio_Pi_0 = oc_dividend_Pi_0 & oc_divisor_Pi_0;

	/* ----- Division ----- */
	qdivSequential qdiv_inst_Pi_0 (				
		.i_dividend(dividend_Pi_0),				
		.i_divisor(divisor_Pi_0),				
		.i_start(i_st_ratio_Pi_0),				
		.i_clk(i_clk),				
		.o_quotient_out(division_res_Pi_0),				
		.o_complete(oc_Pi_0),				
		.o_overflow(of_Pi_0)
	);

	/* ----- Pi 1 ----- 
	 * Param 0: 0.000000 
	 * Param 1: -2.000000 
	 * Param 2: 0.000000 
	 * Param 3: -1.000000 
	 * Param 4: 1.000000 
	 * fractionsLCM 1 
	 */

	/* ----- Calculations for Pi 1 ----- */
	wire [N-1:0] division_res_Pi_1;
	wire [N-1:0] dividend_Pi_1;
	wire [N-1:0] divisor_Pi_1;

	wire oc_Pi_1;
	wire of_Pi_1;
	wire i_st_ratio_Pi_1;
	reg oc_dividend_Pi_1;
	initial oc_dividend_Pi_1 = 1'b1;
	wire oc_divisor_Pi_1;
	wire [N-1:0] mult_res_divisor_inter_Pi_1_1;
	wire oc_divisor_Pi_1_1;

	/* ----- Dividend ----- */
	assign dividend_Pi_1 = calc_temp_sig;

	/* ----- Divisor ----- */
	qmultSequential mul_inst_divisor_Pi_1_1 (
		.i_multiplicand(calib_par_t1_sig),
		.i_multiplier(calib_par_t1_sig),
		.i_start(i_st),
		.i_clk(i_clk),					
		.o_result_out(mult_res_divisor_inter_Pi_1_1),					
		.o_complete(oc_divisor_Pi_1_1),					
		.o_overflow(of_Pi_1)
	);

	qmultSequential mul_inst_divisor_Pi_1_2 (
		.i_multiplicand(mult_res_divisor_inter_Pi_1_1),
		.i_multiplier(calib_par_t3_sig),
		.i_start(oc_divisor_Pi_1_1),
		.i_clk(i_clk),					
		.o_result_out(divisor_Pi_1),					
		.o_complete(oc_divisor_Pi_1),					
		.o_overflow(of_Pi_1)
	);


	/* ----- Division enabling ----- */
	assign i_st_ratio_Pi_1 = oc_dividend_Pi_1 & oc_divisor_Pi_1;

	/* ----- Division ----- */
	qdivSequential qdiv_inst_Pi_1 (				
		.i_dividend(dividend_Pi_1),				
		.i_divisor(divisor_Pi_1),				
		.i_start(i_st_ratio_Pi_1),				
		.i_clk(i_clk),				
		.o_quotient_out(division_res_Pi_1),				
		.o_complete(oc_Pi_1),				
		.o_overflow(of_Pi_1)
	);

	/* ----- Pi 2 ----- 
	 * Param 0: 1.000000 
	 * Param 1: -1.000000 
	 * Param 2: 0.000000 
	 * Param 3: -0.000000 
	 * Param 4: 0.000000 
	 * fractionsLCM 1 
	 */

	/* ----- Calculations for Pi 2 ----- */
	wire [N-1:0] division_res_Pi_2;
	wire [N-1:0] dividend_Pi_2;
	wire [N-1:0] divisor_Pi_2;

	wire oc_Pi_2;
	wire of_Pi_2;
	wire i_st_ratio_Pi_2;
	reg oc_dividend_Pi_2;
	initial oc_dividend_Pi_2 = 1'b1;
	reg oc_divisor_Pi_2;

	initial oc_divisor_Pi_2 = 1'b1;

	/* ----- Dividend ----- */
	assign dividend_Pi_2 = temp_adc_sig;

	/* ----- Divisor ----- */
	assign divisor_Pi_2 = calib_par_t1_sig;

	/* ----- Division enabling ----- */
	assign i_st_ratio_Pi_2 = oc_dividend_Pi_2 & oc_divisor_Pi_2;

	/* ----- Division ----- */
	qdivSequential qdiv_inst_Pi_2 (				
		.i_dividend(dividend_Pi_2),				
		.i_divisor(divisor_Pi_2),				
		.i_start(i_st_ratio_Pi_2),				
		.i_clk(i_clk),				
		.o_quotient_out(division_res_Pi_2),				
		.o_complete(oc_Pi_2),				
		.o_overflow(of_Pi_2)
	);

	assign pi_0_calcSig = pi_0_calcReg;
	assign pi_1_calcSig = pi_1_calcReg;
	assign pi_2_calcSig = pi_2_calcReg;
	assign oc_Pi = oc_Pi_0 & oc_Pi_1 & oc_Pi_2;

	always @( posedge i_clk )
	begin

		if (~i_st) begin
			i_st = 1'b1;
		end
		else begin
			if (oc_Pi) begin
				pi_0_calcReg = division_res_Pi_0;
				pi_1_calcReg = division_res_Pi_1;
				pi_2_calcReg = division_res_Pi_2;
				i_st = 1'b0;
			end
		end
	end
	/* the "macro" to dump signals */
`ifdef COCOTB_SIM
	initial begin
		$dumpfile ("calcTempInvariantSerial.vcd");
		$dumpvars (0, calcTempInvariantSerial);
		#1;
	end
`endif
endmodule

module calcTempInvariantTopLFSR #(parameter N = 32, W = 24, V = 18, g_type = 0, u_type = 1)
	(
		output	 pi_0_calcSig,
		output	 pi_1_calcSig,
		output	 pi_2_calcSig
	);

	wire	clk12;
	reg	ENCLKHF	= 1'b1;	// Plock enable
	reg	CLKHF_POWERUP	= 1'b1;	// Power up the HFOSC circuit
	reg	i_rst;
	initial i_rst = 1'b0;

	wire	[N-1:0] temp_adc_sigWire;
	wire	[N-1:0] calib_par_t1_sigWire;
	wire	[N-1:0] calib_par_t2_sigWire;
	wire	[N-1:0] calib_par_t3_sigWire;
	wire	[N-1:0] calc_temp_sigWire;
	wire	[N-1:0] pi_0_calcSigWire;
	wire	[N-1:0] pi_1_calcSigWire;
	wire	[N-1:0] pi_2_calcSigWire;

	wire [W-1 : 0] 	randG_out;
	wire [W-1 : 0] 	randU_out;

	/* 
	 *	Creates a 12MHz clock signal from
	 *	internal oscillator of the iCE40
	 */
	SB_HFOSC #(.CLKHF_DIV("0b10")) OSCInst0 (
		.CLKHFEN(ENCLKHF),
		.CLKHFPU(CLKHF_POWERUP),
		.CLKHF(clk12)
	);

	calcTempInvariantSerial calcTempInvariantRTL (
		.temp_adc_sig(temp_adc_sigWire),
		.calib_par_t1_sig(calib_par_t1_sigWire),
		.calib_par_t2_sig(calib_par_t2_sigWire),
		.calib_par_t3_sig(calib_par_t3_sigWire),
		.calc_temp_sig(calc_temp_sigWire),
		.pi_0_calcSig(pi_0_calcSigWire),
		.pi_1_calcSig(pi_1_calcSigWire),
		.pi_2_calcSig(pi_2_calcSigWire),
		.i_clk(clk12)
	);

	LFSR_Plus LFSR_PlusInt (
		.g_noise_out(randG_out),
		.u_noise_out(randU_out),
		.clk(clk12),
		.n_reset(i_rst),
		.enable(ENCLKHF)
	);

	assign	 pi_0_calcSig = pi_0_calcSigWire[31] | pi_0_calcSigWire[30] | pi_0_calcSigWire[29] | pi_0_calcSigWire[28] | pi_0_calcSigWire[27] | pi_0_calcSigWire[26] | pi_0_calcSigWire[25] | pi_0_calcSigWire[24] | 
		pi_0_calcSigWire[23] | pi_0_calcSigWire[22] | pi_0_calcSigWire[21] | pi_0_calcSigWire[20] | pi_0_calcSigWire[19] | pi_0_calcSigWire[18] | pi_0_calcSigWire[17] | pi_0_calcSigWire[16] | 
		pi_0_calcSigWire[15] | pi_0_calcSigWire[14] | pi_0_calcSigWire[13] | pi_0_calcSigWire[12] | pi_0_calcSigWire[11] | pi_0_calcSigWire[10] | pi_0_calcSigWire[9] | pi_0_calcSigWire[8] | 
		pi_0_calcSigWire[7] | pi_0_calcSigWire[6] | pi_0_calcSigWire[5] | pi_0_calcSigWire[4] | pi_0_calcSigWire[3] | pi_0_calcSigWire[2] | pi_0_calcSigWire[1] | pi_0_calcSigWire[0];

	assign	 pi_1_calcSig = pi_1_calcSigWire[31] | pi_1_calcSigWire[30] | pi_1_calcSigWire[29] | pi_1_calcSigWire[28] | pi_1_calcSigWire[27] | pi_1_calcSigWire[26] | pi_1_calcSigWire[25] | pi_1_calcSigWire[24] | 
		pi_1_calcSigWire[23] | pi_1_calcSigWire[22] | pi_1_calcSigWire[21] | pi_1_calcSigWire[20] | pi_1_calcSigWire[19] | pi_1_calcSigWire[18] | pi_1_calcSigWire[17] | pi_1_calcSigWire[16] | 
		pi_1_calcSigWire[15] | pi_1_calcSigWire[14] | pi_1_calcSigWire[13] | pi_1_calcSigWire[12] | pi_1_calcSigWire[11] | pi_1_calcSigWire[10] | pi_1_calcSigWire[9] | pi_1_calcSigWire[8] | 
		pi_1_calcSigWire[7] | pi_1_calcSigWire[6] | pi_1_calcSigWire[5] | pi_1_calcSigWire[4] | pi_1_calcSigWire[3] | pi_1_calcSigWire[2] | pi_1_calcSigWire[1] | pi_1_calcSigWire[0];

	assign	 pi_2_calcSig = pi_2_calcSigWire[31] | pi_2_calcSigWire[30] | pi_2_calcSigWire[29] | pi_2_calcSigWire[28] | pi_2_calcSigWire[27] | pi_2_calcSigWire[26] | pi_2_calcSigWire[25] | pi_2_calcSigWire[24] | 
		pi_2_calcSigWire[23] | pi_2_calcSigWire[22] | pi_2_calcSigWire[21] | pi_2_calcSigWire[20] | pi_2_calcSigWire[19] | pi_2_calcSigWire[18] | pi_2_calcSigWire[17] | pi_2_calcSigWire[16] | 
		pi_2_calcSigWire[15] | pi_2_calcSigWire[14] | pi_2_calcSigWire[13] | pi_2_calcSigWire[12] | pi_2_calcSigWire[11] | pi_2_calcSigWire[10] | pi_2_calcSigWire[9] | pi_2_calcSigWire[8] | 
		pi_2_calcSigWire[7] | pi_2_calcSigWire[6] | pi_2_calcSigWire[5] | pi_2_calcSigWire[4] | pi_2_calcSigWire[3] | pi_2_calcSigWire[2] | pi_2_calcSigWire[1] | pi_2_calcSigWire[0];

	assign temp_adc_sigWire = randG_out;

	assign calib_par_t1_sigWire = randG_out;

	assign calib_par_t2_sigWire = randG_out;

	assign calib_par_t3_sigWire = randG_out;

	assign calc_temp_sigWire = randG_out;


	always @( posedge clk12 )
	begin

		if (~i_rst) begin
			i_rst <= 1'b1;
		end
	end
endmodule

/*
 *	End of the generated .v file
 */
