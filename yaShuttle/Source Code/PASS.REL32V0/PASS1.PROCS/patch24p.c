{
  // File:    patch24p.c
  // For:     ZERO_256.c
  // Notes:   1. Page references are from IBM "ESA/390 Principles of
  //             Operation", SA22-7201-08, Ninth Edition, June 2003.
  //          2. Labels are of the form p%d_%d, where the 1st number
  //             indicates the leading patch number of the block, and
  //             the 2nd is the byte offset of the instruction within
  //             within the block.
  //          3. Known-problematic translations are marked with the
  //             string  "* * * F I X M E * * *" (without spaces).
  // History: 2024-06-25 RSB  Auto-generated by XCOM-I --guess-inlines.
  //                          Checked and changed from "guess" to "patch"
  //
  // This inline is the target of an EX instruction, I think, and therefore
  // not reachable from the C translation.

p24_0: ;
  // (24)       CALL INLINE("D2", 0, 0, 1, 1, 1, 0);    /* MVC 1(0,1),0(1)              */
  address360A = GR[1] + 1;
  address360B = GR[1] + 0;
  // Type SS, p. 7-83:		MVC	1(0,1),0(1)
  memmove(&memory[address360A & 0xFFFFFF], &memory[address360B & 0xFFFFFF], 1);

p24_6: ;
}
