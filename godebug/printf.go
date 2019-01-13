// go tool compile -S printf.go
// go tool compile -N -S printf.go - Without optimization

package main

import (
	"fmt"
	"os"
)

const value = 42

func Printf() {
	fmt.Printf("%d\n", value)
}

func FPrintf() {
	fmt.Fprintf(os.Stdout, "%d\n", value)
}

func main() {
	Printf()
	FPrintf()
	return
}

/*
"".Printf STEXT size=134 args=0x0 locals=0x58                                               "".FPrintf STEXT size=162 args=0x0 locals=0x68
	0x0000 00000 (printf.go:13)	TEXT	"".Printf(SB), $88-0                                    	0x0000 00000 (printf.go:17)	TEXT	"".FPrintf(SB), $104-0
	0x0000 00000 (printf.go:13)	MOVQ	(TLS), CX                                               	0x0000 00000 (printf.go:17)	MOVQ	(TLS), CX
	0x0009 00009 (printf.go:13)	CMPQ	SP, 16(CX)                                              	0x0009 00009 (printf.go:17)	CMPQ	SP, 16(CX)
	0x000d 00013 (printf.go:13)	JLS	124                                                       	0x000d 00013 (printf.go:17)	JLS	152
	0x000f 00015 (printf.go:13)	SUBQ	$88, SP                                                 	0x0013 00019 (printf.go:17)	SUBQ	$104, SP
	0x0013 00019 (printf.go:13)	MOVQ	BP, 80(SP)                                              	0x0017 00023 (printf.go:17)	MOVQ	BP, 96(SP)
	0x0018 00024 (printf.go:13)	LEAQ	80(SP), BP                                              	0x001c 00028 (printf.go:17)	LEAQ	96(SP), BP
	0x001d 00029 (printf.go:13)	FUNCDATA	$0, gclocals·69c1753bd5f81501d95132d08af04464(SB)   	0x0021 00033 (printf.go:17)	FUNCDATA	$0, gclocals·69c1753bd5f81501d95132d08af04464(SB)
	0x001d 00029 (printf.go:13)	FUNCDATA	$1, gclocals·568470801006e5c0dc3947ea998fe279(SB)   	0x0021 00033 (printf.go:17)	FUNCDATA	$1, gclocals·568470801006e5c0dc3947ea998fe279(SB)
	0x001d 00029 (printf.go:13)	FUNCDATA	$3, gclocals·9fb7f0986f647f17cb53dda1484e0f7a(SB)   	0x0021 00033 (printf.go:17)	FUNCDATA	$3, gclocals·bfec7e55b3f043d1941c093912808913(SB)
	0x001d 00029 (printf.go:14)	PCDATA	$2, $0                                                	0x0021 00033 (printf.go:18)	PCDATA	$2, $0
	0x001d 00029 (printf.go:14)	PCDATA	$0, $1                                                	0x0021 00033 (printf.go:18)	PCDATA	$0, $1
	0x001d 00029 (printf.go:14)	XORPS	X0, X0                                                  	0x0021 00033 (printf.go:18)	XORPS	X0, X0
	0x0020 00032 (printf.go:14)	MOVUPS	X0, ""..autotmp_0+64(SP)                              	0x0024 00036 (printf.go:18)	MOVUPS	X0, ""..autotmp_0+80(SP)
	0x0025 00037 (printf.go:14)	PCDATA	$2, $1                                                	0x0029 00041 (printf.go:18)	PCDATA	$2, $1
	0x0025 00037 (printf.go:14)	LEAQ	type.int(SB), AX                                        	0x0029 00041 (printf.go:18)	LEAQ	type.int(SB), AX
	0x002c 00044 (printf.go:14)	PCDATA	$2, $0                                                	0x0030 00048 (printf.go:18)	PCDATA	$2, $0
	0x002c 00044 (printf.go:14)	MOVQ	AX, ""..autotmp_0+64(SP)                                	0x0030 00048 (printf.go:18)	MOVQ	AX, ""..autotmp_0+80(SP)
	0x0031 00049 (printf.go:14)	PCDATA	$2, $1                                                	0x0035 00053 (printf.go:18)	PCDATA	$2, $1
	0x0031 00049 (printf.go:14)	LEAQ	"".statictmp_0(SB), AX                                  	0x0035 00053 (printf.go:18)	LEAQ	"".statictmp_1(SB), AX
	0x0038 00056 (printf.go:14)	PCDATA	$2, $0                                                	0x003c 00060 (printf.go:18)	PCDATA	$2, $0
	0x0038 00056 (printf.go:14)	MOVQ	AX, ""..autotmp_0+72(SP)                                	0x003c 00060 (printf.go:18)	MOVQ	AX, ""..autotmp_0+88(SP)
	0x003d 00061 (printf.go:14)	PCDATA	$2, $1                                                	0x0041 00065 (printf.go:18)	PCDATA	$2, $1
	0x003d 00061 (printf.go:14)	LEAQ	go.string."%d\n"(SB), AX                                	0x0041 00065 (printf.go:18)	MOVQ	os.Stdout(SB), AX
	0x0044 00068 (printf.go:14)	PCDATA	$2, $0                                                	0x0048 00072 (printf.go:18)	PCDATA	$2, $2
	0x0044 00068 (printf.go:14)	MOVQ	AX, (SP)                                                	0x0048 00072 (printf.go:18)	LEAQ	go.itab.*os.File,io.Writer(SB), CX
	0x0048 00072 (printf.go:14)	MOVQ	$3, 8(SP)                                               	0x004f 00079 (printf.go:18)	PCDATA	$2, $1
	0x0051 00081 (printf.go:14)	PCDATA	$2, $1                                                	0x004f 00079 (printf.go:18)	MOVQ	CX, (SP)
	0x0051 00081 (printf.go:14)	LEAQ	""..autotmp_0+64(SP), AX                                	0x0053 00083 (printf.go:18)	PCDATA	$2, $0
	0x0056 00086 (printf.go:14)	PCDATA	$2, $0                                                	0x0053 00083 (printf.go:18)	MOVQ	AX, 8(SP)
	0x0056 00086 (printf.go:14)	MOVQ	AX, 16(SP)                                              	0x0058 00088 (printf.go:18)	PCDATA	$2, $1
	0x005b 00091 (printf.go:14)	MOVQ	$1, 24(SP)                                              	0x0058 00088 (printf.go:18)	LEAQ	go.string."%d\n"(SB), AX
	0x0064 00100 (printf.go:14)	MOVQ	$1, 32(SP)                                              	0x005f 00095 (printf.go:18)	PCDATA	$2, $0
	0x006d 00109 (printf.go:14)	CALL	fmt.Printf(SB)                                          	0x005f 00095 (printf.go:18)	MOVQ	AX, 16(SP)
	0x0072 00114 (printf.go:15)	PCDATA	$0, $0                                                	0x0064 00100 (printf.go:18)	MOVQ	$3, 24(SP)
	0x0072 00114 (printf.go:15)	MOVQ	80(SP), BP                                              	0x006d 00109 (printf.go:18)	PCDATA	$2, $1
	0x0077 00119 (printf.go:15)	ADDQ	$88, SP                                                 	0x006d 00109 (printf.go:18)	LEAQ	""..autotmp_0+80(SP), AX
	0x007b 00123 (printf.go:15)	RET                                                           	0x0072 00114 (printf.go:18)	PCDATA	$2, $0
	0x007c 00124 (printf.go:15)	NOP                                                           	0x0072 00114 (printf.go:18)	MOVQ	AX, 32(SP)
	0x007c 00124 (printf.go:13)	PCDATA	$0, $-1                                               	0x0077 00119 (printf.go:18)	MOVQ	$1, 40(SP)
	0x007c 00124 (printf.go:13)	PCDATA	$2, $-1                                               	0x0080 00128 (printf.go:18)	MOVQ	$1, 48(SP)
	0x007c 00124 (printf.go:13)	CALL	runtime.morestack_noctxt(SB)                            	0x0089 00137 (printf.go:18)	CALL	fmt.Fprintf(SB)
	0x0081 00129 (printf.go:13)	JMP	0                                                         	0x008e 00142 (printf.go:19)	PCDATA	$0, $0
	0x0000 65 48 8b 0c 25 00 00 00 00 48 3b 61 10 76 6d 48  eH..%....H;a.vmH                  	0x008e 00142 (printf.go:19)	MOVQ	96(SP), BP
	0x0010 83 ec 58 48 89 6c 24 50 48 8d 6c 24 50 0f 57 c0  ..XH.l$PH.l$P.W.                  	0x0093 00147 (printf.go:19)	ADDQ	$104, SP
	0x0020 0f 11 44 24 40 48 8d 05 00 00 00 00 48 89 44 24  ..D$@H......H.D$                  	0x0097 00151 (printf.go:19)	RET
	0x0030 40 48 8d 05 00 00 00 00 48 89 44 24 48 48 8d 05  @H......H.D$HH..                  	0x0098 00152 (printf.go:19)	NOP
	0x0040 00 00 00 00 48 89 04 24 48 c7 44 24 08 03 00 00  ....H..$H.D$....                  	0x0098 00152 (printf.go:17)	PCDATA	$0, $-1
	0x0050 00 48 8d 44 24 40 48 89 44 24 10 48 c7 44 24 18  .H.D$@H.D$.H.D$.                  	0x0098 00152 (printf.go:17)	PCDATA	$2, $-1
	0x0060 01 00 00 00 48 c7 44 24 20 01 00 00 00 e8 00 00  ....H.D$ .......                  	0x0098 00152 (printf.go:17)	CALL	runtime.morestack_noctxt(SB)
	0x0070 00 00 48 8b 6c 24 50 48 83 c4 58 c3 e8 00 00 00  ..H.l$PH..X.....                  	0x009d 00157 (printf.go:17)	JMP	0
	0x0080 00 e9 7a ff ff ff                                ..z...                            	0x0000 65 48 8b 0c 25 00 00 00 00 48 3b 61 10 0f 86 85  eH..%....H;a....
	rel 5+4 t=16 TLS+0                                                                        	0x0010 00 00 00 48 83 ec 68 48 89 6c 24 60 48 8d 6c 24  ...H..hH.l$`H.l$
	rel 40+4 t=15 type.int+0                                                                  	0x0020 60 0f 57 c0 0f 11 44 24 50 48 8d 05 00 00 00 00  `.W...D$PH......
	rel 52+4 t=15 "".statictmp_0+0                                                            	0x0030 48 89 44 24 50 48 8d 05 00 00 00 00 48 89 44 24  H.D$PH......H.D$
	rel 64+4 t=15 go.string."%d\n"+0                                                          	0x0040 58 48 8b 05 00 00 00 00 48 8d 0d 00 00 00 00 48  XH......H......H
	rel 110+4 t=8 fmt.Printf+0                                                                	0x0050 89 0c 24 48 89 44 24 08 48 8d 05 00 00 00 00 48  ..$H.D$.H......H
	rel 125+4 t=8 runtime.morestack_noctxt+0                                                  	0x0060 89 44 24 10 48 c7 44 24 18 03 00 00 00 48 8d 44  .D$.H.D$.....H.D
                                                                                            	0x0070 24 50 48 89 44 24 20 48 c7 44 24 28 01 00 00 00  $PH.D$ H.D$(....
                                                                                            	0x0080 48 c7 44 24 30 01 00 00 00 e8 00 00 00 00 48 8b  H.D$0.........H.
                                                                                            	0x0090 6c 24 60 48 83 c4 68 c3 e8 00 00 00 00 e9 5e ff  l$`H..h.......^.
                                                                                            	0x00a0 ff ff                                            ..
                                                                                            	rel 5+4 t=16 TLS+0
                                                                                            	rel 44+4 t=15 type.int+0
                                                                                            	rel 56+4 t=15 "".statictmp_1+0
                                                                                            	rel 68+4 t=15 os.Stdout+0
                                                                                            	rel 75+4 t=15 go.itab.*os.File,io.Writer+0
                                                                                            	rel 91+4 t=15 go.string."%d\n"+0
                                                                                            	rel 138+4 t=8 fmt.Fprintf+0
                                                                                              rel 153+4 t=8 runtime.morestack_noctxt+0
*/
