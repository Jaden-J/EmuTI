;** EMULib Emulation Library *********************************
;**                                                         **
;**                     LibARM-BPP16.asm                    **
;**                                                         **
;** This file contains optimized ARM assembler functions    **
;** used to copy and process 16bpp images on ARM-based      **
;** platforms such as Symbian/S60, Symbian/UIQ, and Maemo.  **
;**                                                         **
;** Copyright (C) Marat Fayzullin 2005-2009                 **
;**     You are not allowed to distribute this software     **
;**     commercially. Please, notify me, if you make any    **
;**     changes to this file.                               **
;*************************************************************

	AREA	LibARM,CODE,READONLY

rDST	RN	r0
rSRC	RN	r1
rCOUNT	RN	r2
rTMP	RN	r11
rC1	RN	r12
rC2	RN	r14

	EXPORT	TELEVIZE0_16
	EXPORT	TELEVIZE1_16
	EXPORT	C256T120_16
	EXPORT	C256T160_16
	EXPORT	C256T176_16
	EXPORT	C256T208_16
	EXPORT	C256T240_16
	EXPORT	C256T256_16
	EXPORT	C240T320_16
	EXPORT	C256T320_16
	EXPORT	C256T352_16
	EXPORT	C256T416_16
	EXPORT	C256T512_16
	EXPORT	C256T768_16

	;** M_LOADCONSTS16 ***********************************************
	;** Loads two constants used for pixel merging.                 **
	;** For 16BPP:       rC1=0x7BEF7BEF, rC2=0x42084208             **
	;*****************************************************************
	MACRO
	M_LOADCONSTS16
	mov rC1,#0x00EF
	orr rC1,rC1,#0x7B00
	orr rC1,rC1,rC1,lsl #16
	mov rC2,#0x0008
	orr rC2,rC2,#0x4200
	orr rC2,rC2,rC2,lsl #16
	MEND

	;** M_MERGE16 ****************************************************
	;** Merge two 16bpp pixels into one. Trashes $src.              **
	;*****************************************************************
	MACRO
	M_MERGE16 $dst,$src
	and $dst,$src,rC1
	add $dst,$dst,$dst,lsr #16
	and $src,rC2,$src,lsr #1
	and $dst,rC1,$dst,lsl #15
	add $src,$src,$src,lsr #16
	add $dst,$src,$dst,lsr #16
	MEND

C256T120_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L120
	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	M_MERGE16 rTMP,r3
	mov r3,rTMP,lsl #16
	M_MERGE16 rTMP,r4
	mov r3,r3,lsr #16
	orr r3,r3,rTMP,lsl #16
	M_MERGE16 rTMP,r5
	mov r4,rTMP,lsl #16
	M_MERGE16 rTMP,r6
	mov r4,r4,lsr #16
	orr r4,r4,rTMP,lsl #16
	M_MERGE16 rTMP,r7
	mov r5,rTMP,lsl #16
	M_MERGE16 rTMP,r8
	mov r5,r5,lsr #16
	orr r5,r5,rTMP,lsl #16
	M_MERGE16 rTMP,r9
	mov r6,rTMP,lsl #16
	M_MERGE16 rTMP,r10
	mov r6,r6,lsr #16
	orr r6,r6,rTMP,lsl #16
	stmia rDST!,{r3,r4,r5,r6}
	subs rCOUNT,rCOUNT,#16
	bhi L120
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T160_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L160	
	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[0]  = MERGE(SRC[0],SRC[1])
	strh r4,[rDST],#2		; DST[1]  = SRC[2]
	mov r3,r4,lsr #16
	orr r3,r3,r5,lsl #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[2]  = MERGE(SRC[3],SRC[4])
	mov rTMP,r5,lsr #16
	strh rTMP,[rDST],#2		; DST[3]  = SRC[5]
	M_MERGE16 rTMP,r6
	strh rTMP,[rDST],#2		; DST[4]  = MERGE(SRC[6],SRC[7])
	M_MERGE16 rTMP,r7
	strh rTMP,[rDST],#2		; DST[5]  = MERGE(SRC[8],SRC[9])
	strh r8,[rDST],#2		; DST[6]  = SRC[10]
	mov r3,r8,lsr #16
	orr r3,r3,r9,lsl #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[7]  = MERGE(SRC[11],SRC[12])
	mov rTMP,r9,lsr #16
	strh rTMP,[rDST],#2		; DST[8]  = SRC[13]
	M_MERGE16 rTMP,r10
	strh rTMP,[rDST],#2		; DST[9]  = MERGE(SRC[14],SRC[15])
	subs rCOUNT,rCOUNT,#16
	bhi L160
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T176_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L176	
	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[0]  = MERGE(SRC[0],SRC[1])
	mov rTMP,r4,lsr #16
	strh r4,[rDST],#2		; DST[1]  = SRC[2]
	strh rTMP,[rDST],#2		; DST[2]  = SRC[3]
	M_MERGE16 rTMP,r5
	strh rTMP,[rDST],#2		; DST[3]  = MERGE(SRC[4],SRC[5])
	mov rTMP,r6,lsr #16
	strh r6,[rDST],#2		; DST[4]  = SRC[6]
	strh rTMP,[rDST],#2		; DST[5]  = SRC[7]
	M_MERGE16 rTMP,r7
	strh rTMP,[rDST],#2		; DST[6]  = MERGE(SRC[8],SRC[9])
	strh r8,[rDST],#2		; DST[7]  = SRC[10]
	mov r3,r9,lsl #16
	orr r3,r3,r8,lsr #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[8]  = MERGE(SRC[11],SRC[12])
	mov rTMP,r9,lsr #16
	strh rTMP,[rDST],#2		; DST[9]  = SRC[13]
	M_MERGE16 rTMP,r10
	strh rTMP,[rDST],#2		; DST[10] = MERGE(SRC[14],SRC[15])
	subs rCOUNT,rCOUNT,#16
	bhi L176
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T208_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L208	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	mov rTMP,r3,lsr #16
	strh r3,[rDST],#2		; DST[0]  = SRC[0]
	strh rTMP,[rDST],#2		; DST[1]  = SRC[1]
	mov rTMP,r4,lsr #16
	strh r4,[rDST],#2		; DST[2]  = SRC[2]
	strh rTMP,[rDST],#2		; DST[3]  = SRC[3]
	M_MERGE16 rTMP,r5
	strh rTMP,[rDST],#2		; DST[4]  = MERGE(SRC[4],SRC[5])
	mov rTMP,r6,lsr #16
	strh r6,[rDST],#2		; DST[5]  = SRC[6]
	strh rTMP,[rDST],#2		; DST[6]  = SRC[7]
	strh r7,[rDST],#2		; DST[7]  = SRC[8]
	mov r3,r8,lsl #16
	orr r3,r3,r7,lsr #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[8]  = MERGE(SRC[9],SRC[10])
	mov rTMP,r8,lsr #16
	strh rTMP,[rDST],#2		; DST[9]  = SRC[11]
	mov rTMP,r9,lsr #16
	strh r9,[rDST],#2		; DST[10] = SRC[12]
	strh rTMP,[rDST],#2		; DST[11] = SRC[13]
	M_MERGE16 rTMP,r10
	strh rTMP,[rDST],#2		; DST[12] = MERGE(SRC[14],SRC[15])
	subs rCOUNT,rCOUNT,#16
	bhi L208
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T240_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L240	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	mov rTMP,r3,lsr #16
	strh r3,[rDST],#2
	strh rTMP,[rDST],#2
	mov rTMP,r4,lsr #16
	strh r4,[rDST],#2
	strh rTMP,[rDST],#2
	mov rTMP,r5,lsr #16
	strh r5,[rDST],#2
	strh rTMP,[rDST],#2
	mov rTMP,r6,lsr #16
	strh r6,[rDST],#2
	strh rTMP,[rDST],#2
	M_MERGE16 rTMP,r7
	strh rTMP,[rDST],#2
	mov rTMP,r8,lsr #16
	strh r8,[rDST],#2
	strh rTMP,[rDST],#2
	mov rTMP,r9,lsr #16
	strh r9,[rDST],#2
	strh rTMP,[rDST],#2
	mov rTMP,r10,lsr #16
	strh r10,[rDST],#2
	strh rTMP,[rDST],#2
	subs rCOUNT,rCOUNT,#16
	bhi L240
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T256_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10}
L256	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	stmia rDST!,{r3,r4,r5,r6,r7,r8,r9,r10}
	subs rCOUNT,rCOUNT,#16
	bhi L256
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10}
	mov r15,r14

C256T320_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L320
	ldmia rSRC!,{r3,r4,r5,r6}
	strh r3,[rDST],#2		; DST[0]  = SRC[0]
	mov r7,r3,lsr #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[1]  = MERGE(SRC[0],SRC[1])
	strh r7,[rDST],#2		; DST[2]  = SRC[1]
	mov rTMP,r4,lsr #16
	strh r4,[rDST],#2		; DST[3]  = SRC[2]
	strh rTMP,[rDST],#2		; DST[4]  = SRC[3]
	strh r5,[rDST],#2		; DST[5]  = SRC[4]
	mov r7,r5,lsr #16
	M_MERGE16 rTMP,r5
	strh rTMP,[rDST],#2		; DST[6]  = MERGE(SRC[4],SRC[5])
	strh r7,[rDST],#2		; DST[7]  = SRC[5]
	mov rTMP,r6,lsr #16
	strh r6,[rDST],#2		; DST[8]  = SRC[6]
	strh rTMP,[rDST],#2		; DST[9]  = SRC[7]
	subs rCOUNT,rCOUNT,#8
	bhi L320
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C240T320_16
	stmdb r13!,{r4,r5,r6,r7,r8,r12,r14}
	M_LOADCONSTS16
L240T320
	ldmia rSRC!,{r3,r5,r7}
	mov r8,r3,lsr #16
	orr r8,r8,r5,lsl #16
	M_MERGE16 r4,r8
	bic r4,r4,#0x00FF0000
	bic r4,r4,#0xFF000000
	orr r4,r4,r5,lsl #16		; R4 = MERGE(SRC[1],SRC[2]),SRC[2]
	mov r5,r5,lsr #16
	orr r5,r5,r7,lsl #16		; R5 = SRC[3],SRC[4]
	mov r8,r7,lsr #16
	M_MERGE16 r6,r7
	orr r8,r8,r6,lsl #16
	mov r6,r8,ror #16		; R6 = MERGE(SRC[4],SRC[5]),SRC[5]
	stmia rDST!,{r3,r4,r5,r6}
	subs rCOUNT,rCOUNT,#6
	bhi L240T320
	ldmia r13!,{r4,r5,r6,r7,r8,r12,r15}

C256T352_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L352
	ldmia rSRC!,{r3,r4,r5,r6}
	strh r3,[rDST],#2		; DST[0]  = SRC[0]
	mov r7,r3,lsr #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[1]  = MERGE(SRC[0],SRC[1])
	strh r7,[rDST],#2		; DST[2]  = SRC[1]
	mov rTMP,r4,lsr #16
	strh r4,[rDST],#2		; DST[3]  = SRC[2]
	strh rTMP,[rDST],#2		; DST[4]  = SRC[3]
	orr rTMP,rTMP,r5,lsl #16
	M_MERGE16 r3,rTMP
	strh r3,[rDST],#2		; DST[5]  = MERGE(SRC[3],SRC[4])
	mov rTMP,r5,lsr #16
	strh r5,[rDST],#2		; DST[6]  = SRC[4]
	strh rTMP,[rDST],#2		; DST[7]  = SRC[5]
	orr rTMP,rTMP,r6,lsl #16
	M_MERGE16 r3,rTMP
	strh r3,[rDST],#2		; DST[8]  = MERGE(SRC[5],SRC[6])
	mov rTMP,r6,lsr #16
	strh r6,[rDST],#2		; DST[9]  = SRC[6]
	strh rTMP,[rDST],#2		; DST[10] = SRC[7]
	subs rCOUNT,rCOUNT,#8
	bhi L352
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T416_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
	M_LOADCONSTS16
L416
	ldmia rSRC!,{r3,r4,r5,r6}
	strh r3,[rDST],#2		; DST[0]  = SRC[0]
	mov r7,r3,lsr #16
	M_MERGE16 rTMP,r3
	strh rTMP,[rDST],#2		; DST[1]  = MERGE(SRC[0],SRC[1])
	strh r7,[rDST],#2		; DST[2]  = SRC[1]
	orr rTMP,r7,r4,lsl #16
	M_MERGE16 r3,rTMP
	strh r3,[rDST],#2		; DST[3]  = MERGE(SRC[1],SRC[2])
	strh r4,[rDST],#2		; DST[4]  = SRC[2]
	mov rTMP,r4,lsr #16
	strh rTMP,[rDST],#2		; DST[5]  = SRC[3]
	orr rTMP,rTMP,r5,lsl #16
	M_MERGE16 r3,rTMP
	strh r3,[rDST],#2		; DST[6]  = MERGE(SRC[3],SRC[4])
	strh r5,[rDST],#2		; DST[7]  = SRC[4]
	mov rTMP,r5
	M_MERGE16 r3,rTMP
	strh r3,[rDST],#2		; DST[8]  = MERGE(SRC[4],SRC[5])
	mov rTMP,r5,lsr #16
	strh rTMP,[rDST],#2		; DST[9]  = SRC[5]
	strh r6,[rDST],#2		; DST[10] = SRC[6]
	mov rTMP,r6,lsr #16
	M_MERGE16 r3,r6
	strh r3,[rDST],#2		; DST[11] = MERGE(SRC[6],SRC[7])
	strh rTMP,[rDST],#2		; DST[12] = SRC[7]
	subs rCOUNT,rCOUNT,#8
	bhi L416
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T512_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
L512	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	mov r14,r5,lsr #16
	mov r12,r5,lsl #16
	orr r14,r14,r14,lsl #16
	orr r12,r12,r12,lsr #16
	mov r11,r4,lsr #16
	mov r5,r4,lsl #16
	orr r11,r11,r11,lsl #16
	orr r5,r5,r5,lsr #16
	mov r4,r3,lsr #16
	mov r3,r3,lsl #16
	orr r4,r4,r4,lsl #16
	orr r3,r3,r3,lsr #16
	stmia rDST!,{r3,r4,r5,r11,r12,r14}
	mov r3,r6,lsl #16
	mov r4,r6,lsr #16
	orr r3,r3,r3,lsr #16
	orr r4,r4,r4,lsl #16
	mov r5,r7,lsl #16
	mov r6,r7,lsr #16
	orr r5,r5,r5,lsr #16
	orr r6,r6,r6,lsl #16
	mov r7,r8,lsl #16
	mov r8,r8,lsr #16
	orr r7,r7,r7,lsr #16
	orr r8,r8,r8,lsl #16
	mov r12,r10,lsr #16
	mov r11,r10,lsl #16
	orr r12,r12,r12,lsl #16
	orr r11,r11,r11,lsr #16
	mov r10,r9,lsr #16
	mov r9,r9,lsl #16
	orr r10,r10,r10,lsl #16
	orr r9,r9,r9,lsr #16
	stmia rDST!,{r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	subs rCOUNT,rCOUNT,#16
	bhi L512
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

C256T768_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
L768	ldmia rSRC!,{r3,r4,r5,r6,r7,r8,r9,r10}
	mov r11,r3,lsl #16
	mov r14,r3,lsr #16
	mov r12,r14,lsl #16
	orr r12,r12,r11,lsr #16
	orr r11,r11,r11,lsr #16
	orr r14,r14,r14,lsl #16
	stmia rDST!,{r11,r12,r14}
	mov r11,r4,lsl #16
	mov r14,r4,lsr #16
	mov r12,r14,lsl #16
	orr r12,r12,r11,lsr #16
	orr r11,r11,r11,lsr #16
	orr r14,r14,r14,lsl #16
	stmia rDST!,{r11,r12,r14}
	mov r3,r5,lsl #16
	mov r5,r5,lsr #16
	mov r4,r5,lsl #16
	orr r4,r4,r3,lsr #16
	orr r3,r3,r3,lsr #16
	orr r5,r5,r5,lsl #16
	mov r11,r6,lsl #16
	mov r14,r6,lsr #16
	mov r12,r14,lsl #16
	orr r12,r12,r11,lsr #16
	orr r11,r11,r11,lsr #16
	orr r14,r14,r14,lsl #16
	stmia rDST!,{r3,r4,r5,r11,r12,r14}
	mov r3,r7,lsl #16
	mov r5,r7,lsr #16
	mov r4,r5,lsl #16
	orr r4,r4,r3,lsr #16
	orr r3,r3,r3,lsr #16
	orr r5,r5,r5,lsl #16
	mov r11,r8,lsl #16
	mov r14,r8,lsr #16
	mov r12,r14,lsl #16
	orr r12,r12,r11,lsr #16
	orr r11,r11,r11,lsr #16
	orr r14,r14,r14,lsl #16
	stmia rDST!,{r3,r4,r5,r11,r12,r14}
	mov r3,r9,lsl #16
	mov r5,r9,lsr #16
	mov r4,r5,lsl #16
	orr r4,r4,r3,lsr #16
	orr r3,r3,r3,lsr #16
	orr r5,r5,r5,lsl #16
	mov r11,r10,lsl #16
	mov r14,r10,lsr #16
	mov r12,r14,lsl #16
	orr r12,r12,r11,lsr #16
	orr r11,r11,r11,lsr #16
	orr r14,r14,r14,lsl #16
	stmia rDST!,{r3,r4,r5,r11,r12,r14}
	subs rCOUNT,rCOUNT,#16
	bhi L768
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r15}

TELEVIZE0_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r14}
	mov r14,#0x00E3
	orr r14,r14,#0x1800
	orr r14,r14,r14,lsl #16
LTV0	ldmia r0,{r3,r4,r5,r6,r7,r8,r9,r10}
	and r2,r14,r3,lsr #3
	sub r3,r3,r2
	and r2,r14,r4,lsr #3
	sub r4,r4,r2
	and r2,r14,r5,lsr #3
	sub r5,r5,r2
	and r2,r14,r6,lsr #3
	sub r6,r6,r2
	and r2,r14,r7,lsr #3
	sub r7,r7,r2
	and r2,r14,r8,lsr #3
	sub r8,r8,r2
	and r2,r14,r9,lsr #3
	sub r9,r9,r2
	and r2,r14,r10,lsr #3
	sub r10,r10,r2
	subs r1,r1,#16
	stmia r0!,{r3,r4,r5,r6,r7,r8,r9,r10}
	bhi LTV0
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r15}

TELEVIZE1_16
	stmdb r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r14}
	mov r14,#0x00E3
	orr r14,r14,#0x1800
	orr r14,r14,r14,lsl #16
	mvn r11,#1
LTV1	ldmia r0,{r3,r4,r5,r6,r7,r8,r9,r10}
	eor r2,r3,r11
	and r2,r14,r2,lsr #3
	add r3,r3,r2
	eor r2,r4,r11
	and r2,r14,r2,lsr #3
	add r4,r4,r2
	eor r2,r5,r11
	and r2,r14,r2,lsr #3
	add r5,r5,r2
	eor r2,r6,r11
	and r2,r14,r2,lsr #3
	add r6,r6,r2
	eor r2,r7,r11
	and r2,r14,r2,lsr #3
	add r7,r7,r2
	eor r2,r8,r11
	and r2,r14,r2,lsr #3
	add r8,r8,r2
	eor r2,r9,r11
	and r2,r14,r2,lsr #3
	add r9,r9,r2
	eor r2,r10,r11
	and r2,r14,r2,lsr #3
	add r10,r10,r2
	subs r1,r1,#16
	stmia r0!,{r3,r4,r5,r6,r7,r8,r9,r10}
	bhi LTV1
	ldmia r13!,{r4,r5,r6,r7,r8,r9,r10,r11,r15}

	END
