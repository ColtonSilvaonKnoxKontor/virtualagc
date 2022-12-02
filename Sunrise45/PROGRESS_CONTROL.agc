### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	RESTART_CONTROL.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## WEBSITE:	WWW.IBIBLIO.ORG/APOLLO/INDEX.HTML
## MOD HISTORY:	2009-09-21 JL	CREATED.
##		2016-08-22 RSB	TYPOS.
## 		2016-12-28 RSB	PROOFED COMMENT TEXT USING OCTOPUS/PROOFERCOMMENTS,
##				AND FIXED ERRORS FOUND.


		BANK	1
GETPHASE	XCH	Q
		TS	OVCTR
		TC	PHASCOM2
		TS	EXECTEM5

		TC	REPHASE2

		TC	ONSKIP
		TC	+3
		CCS	PHASE
		CAF	ONE
		AD	EXECTEM5
		TS	BANKREG
		MASK	LOW10
		TS	Q
		
		XCH	PHASE
		RELINT

		INDEX	Q
		TC	6000

		BANK	4
REPHASE2	XCH	Q
		TS	ITEMP2

PHASESUB	CAF	LOW5
		MASK	PHASDATA
		TS	PROG

		EXTEND
		MP	OCT12540
		TS	PHASEWD
		DOUBLE
		AD	PHASEWD
		COM
		AD	PROG
		TS	PHASEDIG

		INDEX	A
		CAF	PHASMASK
		INDEX	PHASEWD
		MASK	PHASETAB
		TS	PHASE

		INDEX	PHASEDIG
		TC	+1
		TC	ITEMP2
		TC	+3
		CAF	BIT5
		TC	+2
		CAF	BIT10
		EXTEND
		MP	PHASE
		MASK	LOW5
		TS	PHASE

		TC	ITEMP2

PHASMASK	OCT	00037
		OCT	01740
		OCT	76000

		BANK	1
PHASCHNG	XCH	Q
		TC	PHASECOM
		TC	PHASCH3

		BANK	4
PHASCH3		CCS	PHASE
		TC	INCET4

PHASCH4		CAF	BIT9
		EXTEND
		MP	PHASDATA

		TC	SETPHASE

		CS	PHASE
		COM
		TS	MPAC

		TC	ONSKIP
		TC	+2
		TC	PHASREL

		TC	DEMANDON
		INDEX	PROG
		CAF	PROGTAB
		TC	SWCALL

		RELINT
		TC	BANKCALL
		CADR	DSPMM
		TC	PHASEOUT

		BANK	1
PHASWAIT	XCH	Q
		TC	PHASECOM
		TC	PHASWT3

		BANK	4
PHASWT3		TC	ONSKIP
		TC	PHASOUT2

		CAF	ZERO
		TC	SETPHASE

		CAF	ONE
PHASWT5		TS	OVCTR
		INDEX	A
		CCS	PWTCADR
		TC	+2
		TC	PHASWT4

		CCS	OVCTR
		TC	PHASWT5

		TC	ABORT
		OCT	01205

PHASWT4		XCH	PROG
		INDEX	OVCTR
		TS	PWTPROG
		
		XCH	MPAC +1
		INDEX	OVCTR
		TS	PWTCADR
		TC	JOBSLEEP

		BANK	1
MAJEXIT		XCH	Q
		TC	PHASECOM
		TC	MAJEX3

		BANK	4
MAJEX3		CAF	LOW5
		TC	SETPHASE

		CAF	ONE
MAJEX4		TS	OVCTR
		CS	PROG
		INDEX	OVCTR
		AD	PWTPROG

		CCS	A
		TC	MAJEX5
OCT12540	OCT	12540
		TC	MAJEX5

		INDEX	OVCTR
		XCH	PWTCADR
		TC	JOBWAKE

		CAF	LOW5
		INDEX	OVCTR
		TS	PWTPROG

		TC	DEMOFF

MAJEX5		CCS	OVCTR
		TC	MAJEX4

DEMOFF		CS	PROG
		INDEX	A
		CS	BIT1
		MASK	MODREG
		TS	MODREG

		RELINT
		TC	BANKCALL
		CADR	DSPMM

DOEJ		TC	ENDOFJOB

SETPHASE	TS	OVCTR
		INDEX	PHASEDIG
		CAF	PHASESHL

		EXTEND
		MP	OVCTR
		TS	OVCTR

		INDEX	PHASEDIG
		CS	PHASMASK
		INDEX	PHASEWD
		MASK	PHASETAB
		AD	LP
		INDEX	OVCTR
		AD	B15FIX
		INDEX	PHASEWD
		TS	PHASETAB
		INDEX	PHASEWD
		TS	BACKPHAS
		COM
		INDEX	PHASEWD
		TS	PHASEBAR

		CAF	ONE
		EXTEND
		MP	PHASELP

		TC	Q

ONSKIP		CS	LOW5
		AD	PHASE
		CCS	A
B15FIX		OCT	00000
		OCT	40000
		INDEX	Q
		TC	Q

PHASESHL	OCT	00001
		OCT	00040
		OCT	02000

INCET4		CAF	ONE
		AD	MPAC +1
		TS	MPAC +1
		TC	Q

PROGTAB		CADR	STARTPL
		CADR	STARTFF
		CADR
		CADR
		CADR

MODROUT		TS	SR
		EXTEND
		MP	BIT7
		CS	SR
		CS	SR
		CAF	OCT700
		MASK	LP
		AD	SR
		INHINT
		TS	PHASDATA

		CAF	LDOEJ
		TS	MPAC +1
		TC	REPHASE2
		TC	PHASCH4

OCT700		OCT	700
LDOEJ		CADR	DOEJ

		BANK	1
PHASECOM	TS	OVCTR
		XCH	Q
		TC	PHASCOM2
		TS	MPAC +1
		TC	PHASESUB

PHASCOM2	INHINT
		TS	ITEMP2

		INDEX	OVCTR
		CAF	0
		TS	PHASDATA

		XCH	LP
		TS	PHASELP

		CAF	PHASBANK
		XCH	BANKREG
		AD	OVCTR
		AD	72K

		TC	Q

PHASBANK	EQUALS	EXECBANK

PHASOUT2	CAF	ONE
		EXTEND
		MP	PHASELP
PHASREL		RELINT
PHASEOUT	XCH	MPAC +1
		TC	BANKJUMP

72K		OCT	72000
