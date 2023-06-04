### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ORBITAL_INTEGRATION_PROGRAM.agc
## Purpose:	A section of Sunrise 45.
##		It is part of the reconstructed source code for the penultimate
##		release of the Block I Command Module system test software. No
##		original listings of this program are available; instead, this
##		file was created via disassembly of dumps of Sunrise core rope
##		memory modules and comparison with the later Block I program
##		Solarium 55.
## Assembler:	yaYUL --block1
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2022-12-09 MAS	Initial reconstructed source.
##		2023-06-03 MAS	Adopted many names and comments from Sunburst,
##				whose orbital integration section appears to
##				be a direct port of this code to Block II.

## This log section contains a significant amount of code not present in
## Solarium 55 or any other surviving program listing. Furthermore, we have
## essentially no surviving documentation (and it appears an AGC Information
## Series issue was never written for this section). As such, label names
## herein are mostly modern guesses, wherever they were unable to be taken
## from Solarium.

		BANK	22

#   *** SCALING FACTORS AND ARGUMENTS ***

DEL		=	1
DEL+E		=	1
2DEL		=	2
2DEL+E		=	3
E		=	0
XKEP		=	14D
RSCALE		=	14D
VSCALE		=	6
TSCALE		=	24D
4RSCALE		=	56D


FFINIT		CS	TWO
		AD	MPAC
		CCS	A
		TC	+2
		TC	+1
		CS	ONE
		TS	FDSPWAIT

		CAF	DEC200
FFZLOOP		TS	MPAC
		CAF	ZERO
		INDEX	MPAC
		TS	STEPEXIT
		CCS	MPAC
		TC	FFZLOOP

		TC	INTPRET
		AXT,1	1
		SXA,1	VMOVE
			EARTHTAB
			PBODY
			RINIT
		STORE	RRECT

		NOLOD	0
		STORE	RCV

		VMOVE	0
			VINIT
		STORE	VRECT

		NOLOD	4
		AXT,1	SXA,1
		AXT,1	SXA,1
		AXT,1	SXA,1
		AXT,1	SXA,1
			RSCALE
			SCALER		# SET SCALE OF POSITION.
			4
			SCALDELT	# ALSO DEVIATION.
			18D
			SCALEDT		# AND TIME STEP.
			FDISPLAY
			STEPEXIT
		STORE	VCV

		VMOVE	0
			FFZERO
		STORE	TDELTAV		# ZERO POSITION DEVIATION.

		NOLOD	0
		STORE	TNUV		# ALSO VELOCITY.

		DMOVE	0
			TETINIT
		STORE	TET
		
		DMOVE	0
			TETLIMIT
		STORE	ENDTET

		DMOVE	0
			TCINIT
		STORE	TC

		AXT,1	1
		RTB	AST,1
			72D
			ZEROVAC
			6D

INITWMAT	VMOVE*	0
			WINIT +72D,1
		STORE	W +72D,1
		
		TIX,1	0
			INITWMAT

		EXIT	0

		TC	PHASCHNG
		OCT	01401
		TC	FFEXIT

		TC	INTPRET
		ITC	0
			FDISPLAY

STARTFF2	TC	PHASCHNG
		OCT	01101
		TC	FFEXIT

		TC	FLSTCHK

FFENDCHK	TC	INTPRET
		DSU	4
		DSU	BMN
		DAD	DSU
		BPL	DAD
		DDV	TSLT
			ENDTET
			TETDISP
			STEPMIN
			FFEXIT -1
			STEPMIN	
			STEPMAX	
			USEMAXDT
			STEPMAX	
			EARTHTAB +9D
			9D
		STORE	DT/2

		ITC	0
			TIMESTEP

USEMAXDT	DMOVE	0
			DT/2MAX
		STORE	DT/2

		ITC	0
			TIMESTEP

		EXIT	0

FFEXIT		TC	MAJEXIT
		OCT	1

FDISPLAY	VSRT 1
		VAD
			TDELTAV
			RSCALE -4
			RCV
		STORE	RDISP

		VSRT	1
		VAD
			TNUV
			VSCALE -14D
			VCV
		STORE	VDISP
		
		EXIT	0

		TC	GRABDSP
		TC	FGBSY

FDSPLAY2	CAF	LTETDISP
		TS	MPAC +2

FPASTE		CAF	V07N01
		TC	NVSUB
		TC	FNVBSY

FDSPFREE	TC	FREEDSP
		TC	STARTFF2

FGBSY		CCS	FDSPWAIT
		TC	STARTFF2
		TC	STARTFF2
		TC	PREGBSY	
		TC	FDSPLAY2

FNVBSY		CCS	FDSPWAIT
		TC	FPASTE	
		TC	FDSPFREE
		TC	PRENVBSY

RINIT		2DEC	6437.06189 B-14	# KILOMETERS.
		2DEC	0.0
		2DEC	0.0

VINIT		2DEC	0.0		# METERS PER SECOND SCALED SQRT(MU).
		2DEC	11.00502594 E-3 B6
		2DEC	5.85147616 E-3 B6

DT/2MAX		2DEC	.62421427 B-1	# .072 HOUR MAXIMUM TIME STEP

TETINIT		2DEC	0.0
TCINIT		2DEC	0.0
TETLIMIT	2DEC	0.009		# WEEKS

STEPMAX		2DEC	.000428572	# .072 HOUR MAXIMUM TIME STEP
STEPMIN		2DEC	.9983777999 E-6	# .6 SECOND MINIMUM TIME STEP

V07N01		OCT	00701
FFUNUSED	DEC	-1
LTETDISP	ADRES	TETDISP
DEC200		DEC	200

STARTFF		CAF	FFPRIO
		TC	FINDVAC
		CADR	STARTFF2
		TC	SWRETURN

FFPRIO		OCT	05000

FLSTCHK		CS	EIGHT
		AD	MPAC
		CCS	A
		TC	Q
		LOC	+1
		TC	FFINIT
		TC	FFINIT

FFGO		CAF	FFPRIO
		TC	FINDVAC
		CADR	FRESTART
		TC	SWRETURN

FRESTART	TC	GETPHASE
		OCT	1
		TC	FFEXIT

		TS	MPAC
		TC	FLSTCHK

		CS	MAXPHAS
		AD	MPAC
		CCS	A
		TC	FFEXIT2
MAXPHAS		DEC	12
		TC	+2
		TC	ENDSTEP

		INDEX	A
		TC	+1
		TC	SETWINT -1
		TC	FFEXIT2
		TC	FFENDCHK

FFEXIT2		CS	MPAC
		TS	FLSTPHAS
		TC	FFEXIT


#	FBR3 SETS UP A TIMESTEP CALL TO KEPLER.

FBR3		TSRT	1
		ROUND	DAD
			H
			TSCALE -18D
			TC
		STORE	TAU

		LXC,1	1
		LXC,2	DMOVE*
			PBODY
			SCALEDT
			8D,1
		STORE	S1

		XSU,2	2
		TSLT*	DMPR
		DAD
			S1
			9D,1
			1
			DT/2
			TET
		STORE	TET

		ITC	0
			KEPLER

#	THIS ORBITAL KEPLER SUBROUTINE FINDS THE POSITION AND VELOCITY OF THE VEHICLE AFTER TIME FOUND IN
# GIVENT  SINCE RECTIFICATION TO POSITION  RRECT  AND VELOCITY  VRECT  . THE RESULTING POSITION AND VELOCITY ARE
# LEFT IN  FOUNDR  AND  FOUNDV  , RESPECTIVELY.

KEPLER		LXA,1	1		# UNIT OF RECTIFICATION POSITION TO 0
		SXA,1	UNIT
			FIXLOC
			PUSHLOC
			RRECT

		TSLT	0		# AND LENGTH OF ORIGINAL IN 6.
			30D
			1

		VSQ	3		# A4 TO REGISTER 8.
		ROUND	DMP
		DSU	TSLT
		ROUND
			VRECT
			6		# LENGTH OF POSITION AT RECTIFICATION.
			DP1/4
			2DEL+E -1

		NOLOD	2		# ALPHA TO REGISTER 10.
		TSRT	COMP
		DAD	DDV
			2DEL+E -1
			DP1/4
			6

		DOT	1		# A1 TO REGISTER 12.
		ROUND
			RRECT
			VRECT

		SQRT	1
		BDDV
			10D
			DP2PI/16
		STORE	XKEPHI

		DMOVE	0
			DPZERO
		STORE	XKEPLO

		AXT,2	1
		AST,2	ITC
			28D
			1
			GETNEWX

DP2PI/16	2DEC	.39269908

# ITERATING EQUATIONS - GIVEN X IN MPAC AND 14D, FIND TIME OF FLIGHT.



KTIMEN+1	NOLOD	5		# FORM ALPHA X-SQUARED AND CALL S AND C.
		DSQ	ROUND
		DMP	TSLT
		ROUND	LXA,1		# AND SET PD INDICATOR TO 16 AS WELL.
		INCR,1	SXA,1
		ITC
			10D		# ALPHA
			2DEL
			FIXLOC
			16D
			PUSHLOC
			S(X)C(X)

		NOLOD	4		# S RETURNS IN MPAC, C ON TOP OF PDL.
		DMP	TSLT
		DMP	TSLT
		DMP	TSLT
		ROUND
			XKEP
			4
			XKEP
			E +1
			XKEP
			1
		STORE	23D		# A3.

		NOLOD	1
		DMPR
			8D

		DMP	2
		TSLT	DMP
		TSLT	ROUND
			XKEP
			16D		# VALUE OF C.
			5
			XKEP
			E +2
		STORE	21D		# A2.

		NOLOD	2
		DMP	TSRT
		ROUND	DAD
			12D		# A1.
			1
		DMPR	1
		DAD
			6
			XKEP		# COMPUTED TIME TO PD+18.

KEPLER3		NOLOD	1		# COMPARE COMPUTED TIME WITH GIVEN TIME.
		DSU
			TAU
		STORE	16D		# DIFFERENCE TO REGISTER 16.

		NOLOD	2
		ABS	DSU
		BMN	
			KEPSILON
			GETRANDV
		
		BMN	1
		ITC
			16D
			DIFFNEG
			DIFFPOS

# CONSTANTS.

KEPSILON	OCT	00000
		OCT	00000
THREE/8		2DEC	.375
DP1/4		2DEC	.25
DQUARTER	EQUALS	DP1/4
POS1/16		2DEC	.0625
POS1/4		EQUALS	DP1/4
3/8		EQUALS	THREE/8


#	SUBROUTINE FOR COMPUTING THE UNIVERSAL CONIC FUNCTIONS S(X) AND C(X). THE ACTUAL OUTPUT OF THIS ROUTINE
# CONSISTS OF SCALED VERSIONS DEFINED AS FOLLOWS:
#
#			S (X) = S(64X)			C (X) = C(64X)/4
#			 S				 S
#
#	IT IS ASSUMED THAT THE INPUT ARRIVES IN MPAC,MPAC+1, AND THAT IT LIES BETWEEN -30/64 AND 40/64. UPON
# EXIT, S(X) WILL BE LEFT IN MPAC,MPAC+1 AND C(X) ON TOP OF THE PUSHDOWN LIST.



S(X)C(X)	NOLOD	0		# SAVE ARGUMENT
		STORE	XSTOREX

		NOLOD	2		#          2
		RTB	DSQ		# COMPUTE A (X)
		ROUND
			A(X)
		STORE	ASQ

		NOLOD	3		#        2          2
		DMP	TSLT		# C (X)=A (.25 - 2XA ) TO PUSHDOWN LIST
		ROUND	BDSU		#  S
		DMPR
			XSTOREX
			1
			POS1/4
			ASQ

		TSRT	1		#  2
		ROUND			# A /4 TO PUSHDOWN LIST
			ASQ
			2

		DMOVE	2		#  2
		RTB	DSQ		# B  TO PUSHDOWN LIST
		ROUND
			XSTOREX
			B(X)

		DMPR	2		#              2        2    2
		BDSU	DMPR		# LEAVE S (X)=B (.0625-A X)+A /4 IN MPAC
		DAD	ITCQ		#        S
			XSTOREX
			ASQ
			POS1/16

		OCT	70707		# THIS HAS TO BE NEGATIVE TO TERMINATE EQN


A(X)		TC	POLY			# A AND B POLYNOMIALS WHOSE COEFFICI-

		DEC	10			#   ENTS WERE OBTAINED WITH THE *AUTO-

		2DEC	 7.071067810 E-1	#   CURVEFIT* PROGRAM
		2DEC	-4.714045180 E-1
		2DEC	 9.42808914  E-2
		2DEC	-8.9791893   E-3
		2DEC	 4.989987    E-4
		2DEC	-1.79357     E-5

		TC	DANZIG		# RE-ENTER INTERPRETER



B(X)		TC	POLY

		DEC	10

		2DEC	 8.164965793 E-1
		2DEC	-3.265986572 E-1
		2DEC	 5.90988980  E-2
		2DEC	-4.0085592   E-3
		2DEC	 2.781528    E-4
		2DEC	-1.25610     E-5

		TC	DANZIG		# RETURN AS BEFORE

DIFFPOS		DMOVE	0
			XKEP
		STORE	XKEPHI
		ITC	0
			GETNEWX

DIFFNEG		DMOVE	0
			XKEP
		STORE	XKEPLO

GETNEWX		DSU	2
		TSRT	ROUND
		DAD
			XKEPHI
			XKEPLO
			1
			XKEPLO
		STORE	XKEP
		
		TIX,2	0
			KTIMEN+1


# ROUTINE FOR OBTAINING R AND V, NOW THAT THE PROPER X HAS BEEN FOUND.



GETRANDV	LXA,1	2
		INCR,1	SXA,1
		COMP	VXSC
			FIXLOC
			25D
			PUSHLOC
			21D		# AZ FROM LAST ITERATION.
			0		# UNIT OF GIVEN POSITION VECTOR.

		DSU	2
		TSLT	VXSC
		VAD	VSLT
			18D		# LAST VALUE OF T.
			23D		# LAST VALUE OF A3.
			DEL +1
			VRECT
			-
			1

		NOLOD	1		# ADDITION MUST BE DONE IN THIS ORDER.
		VAD	VAD
			RRECT
		STORE	FOUNDR		# RESULTING CONIC POSITION.

		NOLOD	1		# LENGTH OF ABOVE TO PD+16.
		ABVAL	TSLT
			1
		STORE	16D

		DMP	3
		TSLT	ROUND
		DSU	DDV
		VXSC	VSLT
			10D		# ALPHA.
			23D		# A3
			2DEL+E -1
			XKEP
			16D		# LENGTH OF FOUND POSITION.
			0		# UNIT OF RECTIFICATION POSITION.
			2
		TSRT	3
		DSU	DDV
		VXSC	VAD
		VSLT
			16D
			1
			21D
			16D
			VRECT
			-
			1
		STORE	FOUNDV		# THIS COMPLETES THE CALCULATION.

		ITCI	0
			HBRANCH


#	THE POSTRUE ROUTINES SET UP THE BETA VECTOR AND OTHER INITIAL CONDITIONS FOR THE NEXT ACCOMP.

POSTRUE2	DMOVE	0
			TETDISP
		STORE	TET

POSTRUE		LXA,1	3
		SXA,1	XSU,1
		VMOVE	VSRT*
		VAD	LXA,2
			SCALDELT	# SETS UP SCALE A.
			SCALEA
			SCALER
			ALPHAV
			0,1
			RCV		# POSITION OUTPUT OF KEPLER.
			DIFEQCNT
		STORE	VECTAB,2	# SAVE R/PV IN VECTAB FOR W MATRIX UPDATE.

		NOLOD	2
		LXA,1	SXA,1
		AXT,1	SXA,1
			SCALER
			SCALEB
			2
			GMODE
		STORE	BETAV


# AGC ROUTINE TO COMPUTE ACCELERATION COMPONENTS.



ACCOMP		UNIT	0		# UNITIZE ALPHA VECTOR
			ALPHAV
		STORE	ALPHAV

		DMOVE	0		# SAVE LENGTH OF ALPHA VECTOR
			30D
		STORE	ALPHAM

ACCOMP2		VSRT	3		#         2
		VSQ	LXA,1		# NORMED B  TO PD.
		SXA,1	TSLC
		ROUND
			BETAV
			1
			FIXLOC
			PUSHLOC
			S1

		TSLC	1		# NORMALIZE (LESS ONE) LENGTH OF ALPHA
		TSRT			#   SAVING NORM. SCALE FACTOR IN X1
			ALPHAM
			X1
			1		#  C(PDL+2)= ALMOST NORMED ALPHAM

		UNIT	0		# SAME PROCEDURE FOR BETA VECTOR
			BETAV
		STORE	BETAV

		DMOVE	0
			30D
		STORE	BETAM

		NOLOD	2
		TSLC	BDDV		# FORM NORMALIZED QUOTIENT ALPHAM/BETAM
		TSRT	ROUND
			X2
			-
			1		# C(PDL +2) = ALMOST NORMALIZED RHO.
		LXC,2	3		# C(X2) = -SCALE(RHO) + 1.
		XAD,2	XAD,2		#       = -S(B)-N(B)+S(A)+N(A)+1
		XSU,2	INCR,2
		NOLOD	TSRT*
			X2
			SCALEA
			X1
			SCALEB
			2
			0,2

		NOLOD	1		# RHO/4 PD +6
		TSRT	ROUND
			2

		DOT	2
		TSLT	ROUND		#  (RHO/4)- 2 (ALPHAV/2.BETAV/2)
		BDSU			#              TO PDL +6
			ALPHAV
			BETAV
			1

		NOLOD	1		# Q/4 = RHO(C(PDL +4)) TO PD +8D
		DMPR
			4

		NOLOD	1		# (Q + 1)/4 TO PD +10D.
		DAD
			DQUARTER

		NOLOD	1		#            3/2
		SQRT	DMPR		# ((Q + 1)/4)    TO PD +12D.
			10D

		NOLOD	1		#                     3/2
		TSLT	DAD		# (1/4) + 2((Q + 1)/4)    TO PD +14D.
			1
			DQUARTER
		DAD	3		#                -
		DMPR	TSLT		# (G/2)(C(PD +4))B/2 TO PD +16D.
		DAD	DDV
		DMPR	VXSC
			10D
			DP1/2
			8D
			1
			THREE/8
			14D
			6
			BETAV

		VSRT	1		# A12 + C(PD +16D) TO PD +16D.
		VAD
			ALPHAV
			3

		DMP	5		# -
		TSLC	ROUND		# GAMMA TO PD +22D, -SCALE(GAMMA)-1 TO
		BDDV	LXC,1		# X1.
		XAD,1	XAD,1
		XAD,1	XAD,1
		COMP	VXSC
			0
			12D
			S2
			2
			X2		# C(X2) = SCALE (RHO).
			S2		# C(S2) = N((B.B/4)(...)3/2)
			S1		# C(S1) = N(B.B/4)
			SCALEB
			SCALEB
			16D		# RESULT OF PRECEDING EQUATION.

		EXIT	0

		CCS	GMODE
		XCH	GMODE
		INDEX	A
		TC	+1
		TC	GMODE10
		TC	GMODE11
		
# THE GMODE12 ROUTINE SETS UP THE SECONDARY BODY DISTURBING ACCELERATION FOR ACCOMP.
GMODE12		TC	INTPRET
		NOLOD	1		# -SCALE(GAMMA)-1 IS LEFT IN X1.
		VSLT*			# ADJUST GAMMA TO SCALE OF -32.
			31D,1
		STORE	FV

		VMOVE	0
			BETAV
		STORE	ALPHAV		# BETA VECTOR INTO ALPHA FOR NEXT ACCOMP.

		ITC	0
			MOONPOS

		NOLOD	1
		LXA,1
			DIFEQCNT
		STORE	VECTAB +6,1

		NOLOD	1
		AXT,2	SXA,2
			FBR3
			FBRANCH
		STORE	BETAV		# MOON(EARTH) POSITION WILL BE BETA NEXT

		AXT,2	2		# SETUP ALPHAM AND SCALEA
		XCHX,2	SXA,2
		DMOVE
			19D		# SCALE FOR R/QV
			SCALEB		# SWAP SCALEB AND X2
			SCALEA
			BETAM
		STORE	ALPHAM

		AXT,1	1
		SXA,1	ITC
			FBR3
			FBRANCH
			ACCOMP2		# ENTRY IF UNIT(ALPHAV) AVAILABLE

# THE GMODE11 ROUTINE SETS UP THE SUNS DISTURBING ACCELERATION.

GMODE11		TC	INTPRET
		LXC,2	1		# SET X2 TO TABLE OF PROPER CONSTANTS
		ITC
			PBODY
			ADDTOFV

		ITC	0		# BARICENTER-TO-SUN POSITION VECTOR.
			SUNPOS		# LEAVES VECTOR IN PDL

		LXA,1	1		# COMPUTE R/PS USING CORRECT TABLE FOR
		VXSC*	VAD		# MASS RATIO, ETC.
			DIFEQCNT
			VECTAB +6,1	# USE SCALAR AT ENTRY 6 IN THE TABLE
			13D
		STORE	BETAV

		AXT,1	1
		SXA,1	ITC
			28D
			SCALEB		# SET SCALEB AND RETURN TO ACCOMP
			ACCOMP2

# THE GMODE10 ROUTINE ADDS IN THE SUNS PERTURBING ACCELERATION AND COMPUTES THE OBLATENESS CONTRIBUTION
GMODE10		TC	INTPRET
		LXC,2	1
		INCR,2	ITC
			PBODY
			-3
			ADDTOFV


#	THE  OBLATE  ROUTINE COMPUTES THE ACCELERATION DUE THE THE EARTHS OBLATENESS. IT USES THE UNIT OF THE
# VEHICLE POSITION VECTOR FOUND IN ALPHAV AND THE DISTANCE TO THE CENTER OF THE EARTH IN ALPHAM. THIS IS ADDED TO
# THE SUM OF THE DISTURBING ACCELERATIONS IN FV AND THE PROPER DIFEQ STAGE IS CALLED VIA X1.



OBLATE		LXA,1	1
		SXA,1	TSLT
			FIXLOC		# SET PUSH-DOWN COUNTER TO ZERO.
			PUSHLOC
			ALPHAM
			1
		STORE	ALPHAM

		DMPR	0		# P2'/8 TO REGISTER 0.
			ALPHAV +4	# Z COMPONENT OF POSITION IS COS PHI.
			3/4

		DSQ	2		# P3'/4 TO REGISTER 2.
		TSLT	DMPR
		DSU
			ALPHAV +4
			3
			15/16
			3/8

		NOLOD	2		# P4'/16 TO REGISTER 4.
		DMPR	DMPR
		TSLT
			ALPHAV +4
			7/12
			1		# TO STACK.

		DMPR	1		# FINISH P4'/16.
		BDSU
			P2'/8
			2/3

		NOLOD	1		# BEGIN COMPUTING P5'/128.
		DMPR	DMPR
			ALPHAV +4
			9/16
		DMPR	5		# FINISH P5'/128 AND TERM USING UNIT
		BDSU	DMP		# POSITION VECTOR AT ALPHA.
		TSLT	DDV
		DAD	DMPR
		DDV	DAD
		VXSC
			P3'/4
			5/128
			-
			J4REQ/J3
			RSCALE -12D
			ALPHAM
			P4'/16
			2J3RE/J2
			ALPHAM
			P3'/4
			ALPHAV
		STORE	ALPHAV

		DMP	2		# COMPUTE TERM USING IZ.
		TSLT	DDV
		DAD
			J4REQ/J3
			-
			1
			ALPHAM
		TSRT	2
		DMPR	DDV
		DAD	BDSU
			2J3RE/J2
			RSCALE -11D
			-
			ALPHAM
			-
			ALPHAV +4
		STORE	ALPHAV +4

		DSQ	4
		DSQ	TSLC
		BDDV	VXSC
		INCR,1	VSLT*		# SHIFTS LEFT ON+, RIGHT ON -.
		VAD
			ALPHAM
			X1
			J2REQSQ
			ALPHAV
			4RSCALE -52D
			0,1
			FV
		STORE	FV

NBRANCH		LXA,1	1
		ITC*
			DIFEQCNT
			DIFEQ,1

ADDTOFV		DMOVE*	0		# SETS UP S1 AND S2 PER PRIMARY BODY TABLE
			0,2
		STORE	S1
		
		XAD,1	2
		VMOVE	VXSC*
		VSLT*	VAD
			S1
			22D
			1,2
			31D,1
			FV
		STORE	FV

		ITCQ	0



#	BEGIN INTEGRATION STEP WITH RECTIFICATION TEST.



TIMESTEP	ABVAL	2		# RECTIFICATION REQUIRED IF THE LENGTH OF
		DSU	BMN		# DELTA IS GREATER THAN .5 (8 KM).
		ITC
			TDELTAV
			DP1/4
			INTGRATE
			RECTIFY		# CALL RECTIFICATION SUBROUTINE.

INTGRATE	AXT,1	3		# INITIALIZE INDEXES AND SWITCHES.
		SXA,1	AXT,1
		SXA,1	TEST
		SWITCH
			POSTRUE2
			FBRANCH		# EXIT FROM DIFEQCOM
			POSTRUE
			HBRANCH		# EXIT FROM KEPLER.
			JSWITCH		# 0 FOR STATE VECTOR, 1 FOR W MATRIX.
			+2		# TURN IT OFF HERE.
			JSWITCH

		VMOVE	0
			TDELTAV
		STORE	YV

		VMOVE	0
			TNUV
		STORE	ZV

DIFEQ0		VMOVE	0		# POSITION DEVIATION INTO ALPHA.
			YV
		STORE	ALPHAV

		DMOVE	0		# START H AT 0.
			DPZERO
		STORE	H		# GOES 0(DELT/2)DELT.

		NOLOD	0		# ZERO DIFEQCNT AND REGISTER FOLLOWING.
		STORE	DIFEQCNT	# GOES 0(-12D)(-24D).

		ITCI	0		# BEGIN AT ADDRESS IN FBRANCH.
			FBRANCH


#	THE RECTIFY SUBROUTINE IS CALLED BY THE INTEGRATION PROGRAM (AND OCCASIONALLY BY THE MEASUREMENT
# INCORPORATION ROUTINES) TO ESTABLISH A NEW CONIC. 



RECTIFY		VSRT	1		# RECTIFY - FORM TOTAL POSITION AND VEL.
		VAD			# ADJUST SCALE DIFFERENCE (ASSUMED
			TDELTAV
			RSCALE -4
			RCV
		STORE	RRECT

		NOLOD	0		# SET UP CONIC 'ANSWER' FOR TIMESTEP.
		STORE	RCV

		VSRT	1
		VAD
			TNUV
			VSCALE -14D
			VCV
		STORE	VRECT

		AXT,1	1		# ZERO DELTA, NU, AND TIME SINCE RECTIFI-
		AST,1	DMOVE
			12D
			2
			DPZERO
		STORE	TC

ZEROLOOP	NOLOD	0		# INDEXES CAUSE LOOP TO ZERO 6 CONSECUTIVE
		STORE	YV,1		# DP NUMBERS (DELTA AND NU ARE ADJACENT).

		TIX,1	1		# LOOP OR START INTEGRATION STEP IF DONE.
		STZ	ITCQ
			ZEROLOOP
			DIFEQCNT


#	THE THREE DIFEQ ROUTINES - DIFEQ+0, DIFEQ+12, AND DIFEQ+24 - ARE ENTERED TO PROCESS THE CONTRIBUTIONS
# AT THE BEGINNING, MIDDLE, AND END OF THE TIME STEP, RESPECTIVELY. THE UPDATING IS DONE BY THE NYSTROM METHOD.



DIFEQ+0		VSRT	0
			FV
			3
		STORE	PHIV

		ITC	0
			DIFEQCOM

		LOC	+6		# ENTRIES MUST BE 12 WORDS APART

DIFEQ+12	VSRT	1
		VAD
			FV
			1
			PHIV
		STORE	PSIV

		ITC	0
			DIFEQCOM -6

DPZERO		2DEC	0.0

DP2/3		2DEC	.6666666667

DIFEQ+24	VXSC	3		# DO FINAL CALCULATION FOR Y AND Z.
		VXSC	VSLT
		VAD	VXSC
		VAD
			PHIV
			H
			DP2/3
			1
			ZV
			H
			YV
		STORE	YV
		VSRT	4
		VAD	VXSC
		VXSC	VSLT
		VAD	TEST		# SEE IF THIS IS STATE VECTOR OR W COLUMN.
		AXT,1
			FV
			3
			PSIV
			H
			DP2/3
			1
			ZV
			JSWITCH
			ENDSTATE
			0
		STORE	W +72D,2	# VELOCITY COLUMN VECTOR.

		VMOVE	0
			YV
		STORE	W +36D,2	# POSITION COLUMN VECTOR.

		TIX,2	1
		EXIT
			NEXTCOL

		TC	PHASCHNG
		OCT	01401
		TC	FFEXIT

		TC	FLSTCHK

ENDSTEP		TC	INTPRET
		ITCI	0
			STEPEXIT

NEXTCOL		VMOVE*	0		# SET UP NEXT COLUMNS OF W MATRIX.
			W +36D,2
		STORE	YV

		VMOVE*	0
			W +72D,2
		STORE	ZV

		ITC	0
			DIFEQ0

ENDSTATE	EXIT	0

		TC	PHASCHNG
		OCT	01201
		TC	FFEXIT

		TC	FLSTCHK

		TC	INTPRET
		NOLOD	0
		STORE	TNUV
		VMOVE	0
			YV
		STORE	TDELTAV
		TSRT	1		# UPDATE TIME SINCE RECTIFICATION.
		ROUND	DAD
			H
			TSCALE -18D
			TC
		STORE	TC

		DMOVE	0
			TET
		STORE	TETDISP

		EXIT	0

		TC	PHASCHNG
		OCT	01301
		TC	FFEXIT

		TC	FLSTCHK

		TC	INTPRET
SETWINT		AXT,2	3		# SET UP W MATRIX EXTRAPOLATION ROUTINES.
		AST,2	AXT,1		# PROGRAM DESCRIPTION IS AT  DOW..  .
		SXA,1	SWITCH
		AXT,1	ITC
			36D
			6
			DOW..
			FBRANCH
			JSWITCH
			0
			NEXTCOL


#	COMES HERE TO FINISH FIRST TWO DIFEQ COMPUTATIONS.



 -6		VSRT	1		# ENTERS HERE FROM DIFEQ+12 MIDPOINT
		VAD			# COMPUTATION.
			FV
			2
			PHIV
		STORE	PHIV

DIFEQCOM	DAD	1		# INCREMENT H AND DIFEQCNT.
		INCR,1	SXA,1
			DT/2
			H
			-12D
			DIFEQCNT	# DIFEQCNT SET FOR NEXT ENTRY.
		STORE	H

		VXSC	2
		VSRT	VAD
		VXSC	VAD
			FV
			H
			1
			ZV
			H
			YV
		STORE	ALPHAV

		ITCI	0		# EXIT VIA FBRANCH.
			FBRANCH

DIFEQ		EQUALS	DIFEQ+0


#	ORBITAL ROUTINE FOR EXTRAPOLATING THE W MATRIX. IT COMPUTES THE
# SECOND DERIVATIVE OF EACH COLUMN POSITION VECTOR OF THE MATRIX AND CALLS
# THE NYSTOM INTEGRATION ROUTINES TO SOLVE THE DIFFERENTIAL EQUATIONS. THE
# PROGRAM USES A TABLE OF VEHICLE POSITION VECTORS COMPUTED DURING THE
# INTEGRATION OF THE VEHICLES POSITION AND VELOCITY. 

DOW..		VSRT	0
			ALPHAV
			4

		UNIT*	2		# X1 REFERENCES THE TABLE OF POSITION
		VPROJ	VXSC		# VECTORS AND CALLS THE CORRECT DIFEQ PROG
		VSU
			VECTAB,1
			ALPHAV
			3/4

		DMP	4		# CUBE OF LENGTH OF POSITION VECTOR
		TSLC	ROUND		# DIVIDES VECTOR IN PUSH-DOWN LIST TO
		BDDV	VXSC		# FORM FINAL RESULT.
		XCHX,2	INCR,2		# INCREMENT COMPENSATES FOR .5 R IN 30D.
		VSLT*	LXA,2
			28D
			30D
			S1
			DP1/4
			-
			S1
			3
			0,2
			S1
		STORE	FV

		ITC*	0		# CALL NYSTROM ROUTINES ACCORDING TO X1.
			DIFEQ,1

# DUMMYMOON POSITION ROUTINE, SUN POSITION ROUTINE, AND PBODY TABLE FOR CHECKOUT OF EARTH-ORBITAL ONLY.
MOONPOS		VMOVE	1		# LOAD CONSTANT VECTOR INTO A AND EXIT.
		ITCQ
			MOONVEC

SUNPOS		LXA,1	1		# RETURNS WITH VECTOR IN VAC AND IN PDL.
		SXA,1	VMOVE
			FIXLOC
			PUSHLOC
			SUNVEC
		ITCQ	0

EARTHTAB	DEC	6
		2DEC	0.0
		DEC	10
		2DEC	0.0
		2DEC	0.0
		DEC	-28
		2DEC	.70305529	# 443.87417 / SQRT(MU).

MOONVEC		EQUALS	EARTHTAB
SUNVEC		EQUALS	EARTHTAB +3




15/16		2DEC	15. B-4
3/4		2DEC	3.0 B-2
J2REQSQ		2DEC	.33587616
7/12		2DEC	.5833333333
9/16		2DEC	9 B-4
5/128		2DEC	5 B-7
2J3RE/J2	2DEC	-.0033090338
J4REQ/J3	2DEC	.71761542
2/3		2DEC	.6666666667
P2'/8		EQUALS	0
P3'/4		EQUALS	2
P4'/16		EQUALS	4

DP1/2		2DEC	.5

		BANK	23

# INITIAL W-MATRIX FOR ORBITAL INTEGRATION.

WINIT		2DEC	0.20115818
FFZERO		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.20115818
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.20115818

		2DEC	0.0
		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.0

		2DEC	0.02320259
		2DEC	0.0
		2DEC	0.0

		2DEC	0.0
		2DEC	0.02320259
		2DEC	0.0

		2DEC	0.0
		2DEC	0.0
		2DEC	0.02320259
