{
  // File:      patch8p.c
  // For:       MOVE.c
  // Notes:     1. Page references are from IBM "ESA/390 Principles of
  //               Operation", SA22-7201-08, Ninth Edition, June 2003.
  //            2. Labels are of the form p%d_%d, where the 1st number
  //               indicates the leading patch number of the block, and
  //               the 2nd is the byte offset of the instruction within
  //               within the block.
  //            3. Known-problematic translations are marked with the
  //               string  "* * * F I X M E * * *" (without spaces).
  // History:   2024-06-30 RSB  Auto-generated by XCOM-I --guess-inlines.
  //                            Fixed EX, checked in other respects,
  //                            renamed "guess" to "patch".

p8_0: ;
  // (8)             CALL INLINE("18",0,4);           /* LR 0,4                        */
  // Type RR, p. 7-77:		LR	0,4
  detailedInlineBefore(8, "LR	0,4");
  GR[0] = GR[4];
  detailedInlineAfter();

p8_2: ;
  // (9)             CALL INLINE("58",2,0,INTO);      /* L  2,INTO                     */
  address360B = (26280) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	2,26280(0,0)
  detailedInlineBefore(9, "L	2,26280(0,0)");
  GR[2] = COREWORD(address360B);
  detailedInlineAfter();

p8_6: ;
  // (10)             CALL INLINE("58",3,0,FROM);      /* L   3,FROM                    */
  address360B = (26276) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	3,26276(0,0)
  detailedInlineBefore(10, "L	3,26276(0,0)");
  GR[3] = COREWORD(address360B);
  detailedInlineAfter();

p8_10: ;
  // (11)             CALL INLINE("48",1,0,LEGNTH);    /* LH 1,LEGNTH                   */
  address360B = (26288) & 0xFFFFFF;
  // Type RX, p. 7-80:		LH	1,26288(0,0)
  detailedInlineBefore(11, "LH	1,26288(0,0)");
  GR[1] = COREHALFWORD(address360B);
  detailedInlineAfter();

p8_14: ;
  // (12)             CALL INLINE("06",1,0);           /* BCTR 1,0                      */
  // Type RR, p. 7-18:		BCTR	1,0
  detailedInlineBefore(12, "BCTR	1,0");
  GR[1] = GR[1] - 1;
  detailedInlineAfter();

p8_16: ;
  // (13)             CALL INLINE("58",4,0,ADDRTEMP);  /* L 4,ADDRTEMP                  */
  address360B = (26284) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	4,26284(0,0)
  detailedInlineBefore(13, "L	4,26284(0,0)");
  GR[4] = COREWORD(address360B);
  detailedInlineAfter();

p8_20: ;
  // (14)             CALL INLINE("44",1,0,4,0);       /* EX 1,0(0,4)                   */
  address360B = (GR[4] + 0) & 0xFFFFFF;
  // Type RX, p. 7-74:		EX	1,0(0,4)
  detailedInlineBefore(14, "EX	1,0(0,4)");
  // Here's the translation of the targeted MVC instruction:
  mvc(GR[2], GR[3], GR[1]);
  detailedInlineAfter();

p8_24: ;
  // (15)             CALL INLINE("18",4,0);           /* LR 4,0                        */
  // Type RR, p. 7-77:		LR	4,0
  detailedInlineBefore(15, "LR	4,0");
  GR[4] = GR[0];
  detailedInlineAfter();

p8_26: ;
}
