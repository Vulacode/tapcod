10 CLEAR:DEFINT A-Z
20 INK=15:PAPER=0:INKH=0:PAPERH=15:COLOR INK,PAPER
30 SER=1:POSCUR=1:FD1=0:DS$="DS":DOS$="C:\MS_DOS\"
40 KEY OFF:X$="":FOR N=1 TO 10:KEY N,X$:NEXT N
50 DIM ALPH$(100,1),DALPH$(100),SN$(20),RN$(20)
60 :
70 REM **** Main Menu ****
80 M=0
90 WHILE M=0
100   BF=0:XESC=0
110   FLP1$="C:\CODA\":FLP2$="A:":RAM$="D:":DRIVE$="A:"
120   ON ERROR GOTO ERMESG
130   GOSUB BORDER:LOCATE 2,34:COLOR INKH,PAPERH:PRINT" TAPE  CODER ":COLOR INK,PAPER
140   LOCATE 4,34:PRINT"Version  4.30"
150   LOCATE 6,35:COLOR INKH,PAPERH:PRINT" MAIN MENU ":COLOR INK,PAPER
160   LOCATE 8,24:PRINT"F1  : Load messages from disk"
170   LOCATE 9,24:PRINT"F2  : Save messages onto disk"
180   LOCATE 10,24:PRINT"F3  : Delete messages on disk"
190   LOCATE 12,24:PRINT"F4  : Encipher a message in memory"
200   LOCATE 13,24:PRINT"F5  : Decipher a message in memory"
210   LOCATE 15,24:PRINT"F6  : Type a new message"
220   LOCATE 16,24:PRINT"F7  : Edit/read a message in memory"
230   LOCATE 17,24:PRINT"F8  : Print messages"
240   LOCATE 18,24:PRINT"F9  : Send & Receive"
250   LOCATE 20,24:PRINT"F10 : Quit"
260   WHILE LEN(CH$)<>2
270     CH$=INKEY$
280   WEND
290   CH$=RIGHT$(CH$,1)
300   M=ASC(CH$)-58
310 :
320 REM **** Load a message ****
330   WHILE M=1
340     DSK$="MESSAGE":GOSUB WARNDISK
350     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"LOAD MESSAGES FROM DISK INTO MEMORY":COLOR INK,PAPER
360     PRINT:FILES FLP2$+"*.*"
370     PRINT:PRINT CHR$(186);" Type in name of message to load"
380     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
390     PRINT:PRINT CHR$(186);:PRINT " Message name: ":NM$="�@]":UP=0
400     WHILE NM$<>""
410       V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$
420       IF NM$="" THEN 70
430       IF INSTR(NM$,"*") THEN 450
440       OPEN FLP2$+NM$ FOR INPUT AS #1:CLOSE
450       SHELL "COPY "+FLP2$+NM$+" "+RAM$:V=SCREEN(POS(0),CSRLIN)
460       UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
470     WEND
480   WEND
490 :
500 REM **** Save a message ****
510   WHILE M=2
520     DSK$="MESSAGE":GOSUB WARNDISK
530     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"SAVE MESSAGES IN MEMORY ONTO DISK":COLOR INK,PAPER
540     PRINT:FILES RAM$+"*.*"
550     PRINT:PRINT CHR$(186);" Type in name of message to save"
560     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
570     PRINT:PRINT CHR$(186);:PRINT " Message name: ":NM$="+=_":UP=0
580     WHILE NM$<>""
590       V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$
600       IF NM$="" THEN 70
610       IF INSTR(NM$,"*") THEN 630
620       OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
630       SHELL "COPY "+RAM$+NM$+" "+FLP2$
640       UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
650     WEND
660   WEND
670 :
680 REM **** Delete a message ****
690   WHILE M=3
700     DSK$="MESSAGE":GOSUB WARNDISK
710     NM$="*7%"
720     DO WHILE NM$<>""
730       GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"DELETE MESSAGES ON DISK":COLOR INK,PAPER
740       PRINT:FILES FLP2$+"*.*"
750       PRINT:PRINT CHR$(186);" Type in name of message to delete"
760       PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
770       PRINT:PRINT CHR$(186);:INPUT " Message name: ",NM$
780       IF NM$="" THEN 70
790       IF INSTR(NM$,"*") THEN 810
800       OPEN FLP2$+NM$ FOR INPUT AS #1:CLOSE
810       KILL FLP2$+NM$
820     LOOP
830   WEND
840 :
850 REM **** Encipher ****
860   WHILE M=4
870     XESC=1:DSK$="DATA":GOSUB WARNDISK
880     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "ENCIPHER A MESSAGE":COLOR INK,PAPER
890     PRINT:FILES RAM$+"*"
900     PRINT:PRINT CHR$(186);" Type in name of message to encipher"
910     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
920     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
930     IF NM$="" THEN 70
940     OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
950     GOSUB BORDER:LOCATE 6,3:PRINT"Enciphering '";NM$;"'. Please wait...":COLOR INK,PAPER
960     OPEN "I",1,FLP2$+"SETNUM":INPUT#1,GETNUM:CLOSE
970     IF GETNUM>99 THEN BF=5:GOTO ERRA
980     LOCATE 18,2:PRINT 99-GETNUM;" sets of data left after this message"
990     OPEN FLP2$+"SDNO" AS #1 LEN=200
1000     FIELD#1,200 AS SDNO$
1010     GET#1,1:CLOSE
1020     DNO=VAL(MID$(SDNO$,GETNUM*2+1,2))
1030     OPEN "O",1,RAM$+"ALFA.TMP"
1040     OPEN FLP2$+"SALFJOIN" AS #2 LEN=200
1050     FIELD#2,200 AS FSA$
1060     GET#2,GETNUM+1
1070     PRINT#1,FSA$:CLOSE
1080     OPEN "O",1,RAM$+"NUMS.TMP"
1090     OPEN FLP2$+"SNUMJOIN" AS #2 LEN=130
1100     FIELD#2,130 AS FSN$
1110     FOR N=1 TO 20:GET#2,(GETNUM*20)+N:SN$(N)=FSN$:NEXT N
1120     FOR P=1 TO 20:PRINT#1,SN$(P);:NEXT P
1130     CLOSE
1140     OPEN "I",1,RAM$+"ALFA.TMP"
1150     FOR BET = 0 TO 99
1160       ALPH$(BET,0)=CHR$(BET+32)
1170       ALPH$(BET,1)=INPUT$(2,#1)
1180     NEXT BET
1190     CLOSE
1200     OPEN "O",1,RAM$+NM$+".ENC"
1210     OPEN "I",2,RAM$+NM$
1220     OPEN "I",3,RAM$+"NUMS.TMP"
1230     DNO$=ALPH$(DNO,0)
1240     FOR N=1 TO 4:PRINT#1,CHR$(132);:NEXT N:PRINT#1,DNO$;
1250     LOCATE 18,3:PRINT"Character number: ";SPC(25)
1260     LENGTH=0:COUNT=0:BM=133
1270     DO UNTIL LENGTH=LOF(2)
1280       AX=ASC(INPUT$(1,#2))
1290       IF AX<32 OR AX>131 THEN AX=32
1300       INCR LENGTH
1310       LV$=ALPH$(AX-32,1)
1320       RN$=INPUT$(2,#3):INCR COUNT,2
1330       IF COUNT MOD 2600=0 THEN CLOSE 3:OPEN "I",3,RAM$+"NUMS.TMP":COUNT=0
1340       CD1=(VAL(LEFT$(LV$,1))+VAL(LEFT$(RN$,1))) MOD 10
1350       CD2=(VAL(RIGHT$(LV$,1))+VAL(RIGHT$(RN$,1))) MOD 10
1360       CD=CD2*10+CD1
1370       SLET$=ALPH$(CD,0)
1380       IF LENGTH MOD 5=0 THEN SLET$=SLET$+CHR$(BM):INCR BM
1390       IF BM=138 THEN BM=133
1400       PRINT#1,SLET$;
1410       LOCATE 18,21:PRINT LENGTH
1420     LOOP
1430     FOR N=1 TO 5:PRINT#1,CHR$(138);:NEXT N
1440     PRINT#1,CHR$(26):CLOSE
1450     GOSUB BORDER:LOCATE 6,3:PRINT"Enciphering finished. Flushing disk..."
1460     LOCATE 18,3:PRINT"Message length: ";LENGTH;" characters"
1470     OPEN FLP2$+"SALFJOIN" FOR INPUT AS #1:CLOSE
1480     OPEN FLP2$+"SALFJOIN" AS #1 LEN=200
1490     FIELD#1,200 AS DSA$
1500     LSET DSA$=STRING$(200,0):PUT#1,GETNUM+1
1510     CLOSE
1520     OPEN FLP2$+"SNUMJOIN" AS #1 LEN=130
1530     FIELD#1,130 AS DSN$
1540     FOR N=1 TO 20:LSET DSN$=STRING$(130,0):PUT#1,(GETNUM*20)+N:NEXT N
1550     CLOSE
1560     INCR GETNUM
1570     OPEN "O",1,FLP2$+"SETNUM":PRINT#1,GETNUM:CLOSE
1580     KILL RAM$+"*.TMP"
1590     M=0
1600   WEND
1610 :
1620 REM **** Decipher ****
1630   WHILE M=5
1640     XESC=1:DSK$="DATA":GOSUB WARNDISK
1650     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "DECIPHER A MESSAGE":COLOR INK,PAPER
1660     PRINT:FILES RAM$+"*"
1670     PRINT:PRINT CHR$(186);" Type in name of message to decipher"
1680     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
1690     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
1700     IF NM$="" THEN 70
1710     OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
1720     GOSUB BORDER:LOCATE 6,3:PRINT"Deciphering '";NM$;"'. Please wait...":COLOR INK,PAPER
1730     SC=0:N=0
1740     OPEN "I",1,RAM$+NM$
1750     S=ASC(INPUT$(1,#1))
1760     IF SC=0 AND S<>132 THEN 1750
1770     IF S<32 OR S>132 THEN 1750
1780     IF S=132 THEN INCR SC:GOTO 1750
1790     IF S>31 AND S<132 AND SC>=2 THEN DNO=S-32
1800     CLOSE
1810     OPEN FLP2$+"RDNO" FOR INPUT AS #1:CLOSE
1820     OPEN FLP2$+"RDNO" AS #2 LEN=200
1830     FIELD#2,200 AS RDNO$
1840     GET#2,1:CLOSE
1850     DO
1860       INCR N
1870     LOOP UNTIL VAL(MID$(RDNO$,N*2-1,2))=DNO
1880     DNO=N
1890     IF DNO=100 THEN BF=6:GOTO ERRA
1900     LOCATE 18,2:PRINT 100-DNO;" sets of data left after this message"
1910     OPEN "O",1,RAM$+"DALFA.TMP"
1920     OPEN FLP2$+"RALFJOIN" AS #2 LEN=100
1930     FIELD#2,100 AS FRA$
1940     GET#2,DNO
1950     PRINT#1,FRA$:CLOSE
1960     OPEN "O",1,RAM$+"DNUMS.TMP"
1970     OPEN FLP2$+"RNUMJOIN" AS #2 LEN=130
1980     FIELD#2,130 AS FRN$
1990     FOR N=1 TO 20:GET#2,((DNO-1)*20)+N:RN$(N)=FRN$:NEXT N
2000     FOR P=1 TO 20:PRINT#1,RN$(P);:NEXT P
2010     CLOSE
2020     OPEN "I",1,RAM$+"DALFA.TMP"
2030     FOR DBET=0 TO 99
2040       DALPH$(DBET)=INPUT$(1,#1)
2050     NEXT DBET
2060     CLOSE
2070     OPEN "I",1,RAM$+NM$
2080     IF INSTR(NM$,".ENC") THEN NM$=LEFT$(NM$,LEN(NM$)-4)
2090     OPEN "O",2,RAM$+NM$+".DEC"
2100     OPEN "I",3,RAM$+"DNUMS.TMP"
2110     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"Message '";NM$;"' reads (ESCape to quit):":COLOR INK,PAPER
2120     SC=0:CH=0:EC=0:R=4:C=3:CT=0:CK=0:BX=1
2130     IP=ASC(INPUT$(1,#1))
2140     IF SC=0 AND IP<>132 THEN 2130
2150     IF IP=132 THEN INCR SC:GOTO 2130
2160     DO
2170       IF BX=6 THEN BX=1
2180       D=ASC(INPUT$(1,#1))-32
2190       SELECT CASE D
2200         CASE <0, >106
2210           D=0
2220         CASE 106
2230           INCR EC:GOTO 2530
2240         CASE >100 AND D<106
2250           BM=D-100:CK=1
2260         CASE <100 AND CH=5
2270           BM=BX:CK=1
2280       END SELECT
2290       WHILE CK
2300         IF CH=5 AND BM=BX THEN INCR BX:CH=0:CK=0:GOTO 2170
2310         IF CH=5 AND BM<>BX THEN INCR BX:CH=0
2320         IF BX=6 THEN BX=1:BM=BX
2330         IF CH<5 THEN D=99:GOTO 2350
2340       WEND
2350       DNR$=STR$(D):IF D<10 THEN DNR$="0"+DNR$
2360       D2$=MID$(DNR$,2,1):D1$=RIGHT$(DNR$,1)
2370       SUBT1$=INPUT$(1,#3)
2380       IF VAL(D1$)<VAL(SUBT1$) THEN D1$=STR$(VAL(D1$)+10)
2390       DNUM1$=STR$(VAL(D1$)-VAL(SUBT1$))
2400       SUBT2$=INPUT$(1,#3):INCR CT,2
2410       IF CT MOD 2600=0 THEN CLOSE 3:OPEN "I",3,RAM$+"DNUMS.TMP":CT=0
2420       IF VAL(D2$)<VAL(SUBT2$) THEN D2$=STR$(VAL(D2$)+10)
2430       DNUM2$=RIGHT$(STR$(VAL(D2$)-VAL(SUBT2$)),1)
2440       DNUM$=DNUM1$+DNUM2$
2450       DNUM=VAL(DNUM$)
2460       PLAIN$=DALPH$(DNUM)
2470       IF CK THEN PLAIN$="?"
2480       LOCATE R,C:PRINT PLAIN$;:PRINT#2,PLAIN$;
2490       INCR C:INCR CH
2500       IF C=79 THEN C=3:INCR R
2510       IF R=19 THEN R=4
2520       IF CK THEN 2290
2530     LOOP UNTIL INSTAT OR EC=3
2540     CLOSE
2550     IF INSTAT THEN 2710
2560     LOCATE 19,1:PRINT CHR$(204):LOCATE 19,2:PRINT BDR$:LOCATE 19,80:PRINT CHR$(185)
2570     LOCATE 20,3:PRINT"This message is in memory. It can be read in the editor, printed and saved"
2580     LOCATE 21,3:PRINT"Press ESCape to redo or any other key to clear screen and flush disk"
2590     CNT$=INPUT$(1)
2600     IF ASC(CNT$)=27 THEN 70
2610     GOSUB BORDER:LOCATE 6,3:PRINT"Flushing disk..."
2620     OPEN FLP2$+"RALFJOIN" FOR INPUT AS #1:CLOSE
2630     OPEN FLP2$+"RALFJOIN" AS #1 LEN=100
2640     FIELD#1,100 AS DRA$
2650     LSET DRA$=STRING$(100,0):PUT#1,DNO
2660     CLOSE
2670     OPEN FLP2$+"RNUMJOIN" AS #1 LEN=130
2680     FIELD#1,130 AS DRN$
2690     FOR N=1 TO 20:LSET DRN$=STRING$(130,0):PUT#1,((DNO-1)*20)+N:NEXT N
2700     CLOSE
2710     KILL RAM$+"*.TMP"
2720     M=0
2730   WEND
2740 :
2750 REM **** Type a new message ****
2760   WHILE M=6
2770     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"TYPE A NEW MESSAGE":COLOR INK,PAPER
2780     LOCATE 4,3:PRINT"Give a name to the message you are about to type"
2790     LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
2800     LOCATE 7,3:PRINT"The name you give must:"
2810     LOCATE 9,3:PRINT"- only contain alphabet keys"
2820     LOCATE 10,3:PRINT"- not be longer than 8 characters"
2830     LOCATE 11,3:PRINT"- not contain spaces"
2840     LOCATE 12,3:PRINT"- not have an extension"
2850     LOCATE 14,3:INPUT "Message name: ",NM$
2860     IF NM$="" THEN 70
2870     IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=4:GOTO ERRA
2880     IF INSTR(NM$," ") THEN BF=1:GOTO ERRA
2890     IF INSTR(NM$,".") THEN BF=2:GOTO ERRA
2900     IF LEN(NM$)>8 THEN BF=3:GOTO ERRA
2910     M=20
2920   WEND
2930 :
2940 REM **** Edit a message in memory ****
2950   WHILE M=7
2960     GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"EDIT/READ A MESSAGE IN MEMORY":COLOR INK,PAPER
2970     PRINT:FILES RAM$+"*.*"
2980     PRINT:PRINT CHR$(186);" Type in name of message to edit or read"
2990     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3000     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
3010     IF NM$="" THEN 70
3020     OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
3030     M=20
3040   WEND
3050 :
3060 REM **** Message editor ****
3070   WHILE M=20
3080     IF FD1 THEN DSK$="PROGRAM":GOSUB WARNDISK
3090     IF SER THEN GOSUB SETBAUD
3100     OPEN FLP1$+"EDIT.EXE" FOR INPUT AS #1:CLOSE
3110     SHELL FLP1$+"EDIT "+RAM$+NM$
3120     M=0
3130   WEND
3140 :
3150 REM **** Print message ****
3160   WHILE M=8
3170     GOSUB BORDER:WIDTH "LPT1:",79:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"PRINT A MESSAGE":COLOR INK,PAPER
3180     PRINT:FILES RAM$+"*.*"
3190     PRINT:PRINT CHR$(186);" Type in name of message to print"
3200     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3210     PRINT:PRINT CHR$(186);:PRINT" Message name: ":NM$="!?>":UP=0
3220     WHILE NM$<>""
3230       V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$
3240       IF NM$="" THEN 70
3250       OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
3260       IF SER THEN GOSUB SETBAUD
3270       LPRINT CHR$(27);CHR$(64);CHR$(27);CHR$(82);CHR$(3)
3280       SHELL "TYPE "+RAM$+NM$+" > PRN"
3290       LPRINT CHR$(12)
3300       UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
3310     WEND
3320   WEND
3330 :
3340 REM **** Tape ****
3350   WHILE M=9
3360     GOSUB BORDER:LOCATE 5,35:COLOR INKH,PAPERH:PRINT"TRANSFER MENU":COLOR INK,PAPER
3370     LOCATE 10,29:PRINT"S   : Send/Save on tape"
3380     LOCATE 12,29:PRINT"R   : Receive from tape"
3390     LOCATE 14,29:PRINT"ESC : Return to Main Menu"
3400     ESAU$=UCASE$(INPUT$(1))
3410     IF ASC(ESAU$)=27 THEN 70
3420     IF ESAU$<>"R" AND ESAU$<>"S" THEN 3400
3430     WHILE ESAU$="S"
3440       GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"SEND/SAVE ENCIPHERED MESSAGES":COLOR INK,PAPER
3450       PRINT:FILES RAM$+"*.ENC"
3460       PRINT:PRINT CHR$(186);" Type in name of enciphered message to send/save"
3470       PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3480       PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
3490       IF NM$="" THEN 70
3500       OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
3510       IF INSTR(NM$,".ENC")=0 THEN BF=11:GOTO ERRA
3520       GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure modem is on and connected properly **":COLOR INK,PAPER
3530       LOCATE 4,3:PRINT"(Press RECORD on tape recorder to save '";NM$;"')"
3540       LOCATE 20,3:PRINT"Press any key to send/save '";NM$;"'. ESCape to return to Main Menu"
3550       CNT$=INPUT$(1)
3560       IF ASC(CNT$)=27 THEN 70
3570       GOSUB BORDER:LOCATE 6,3:PRINT"Sending/saving '";NM$;"'...":COLOR INK,PAPER
3580       LATER#=TIMER+5
3590       WHILE TIMER<LATER#
3600       WEND
3610       OPEN "COM1:300,N,8,1,CS,DS" AS #1
3620       OPEN "I",2,RAM$+NM$
3630       EC=0
3640       DO UNTIL EC=5 OR INSTAT
3650         TAPNM$=INPUT$(1,#2)
3660         IF ASC(TAPNM$)=138 THEN INCR EC
3670         PRINT#1,TAPNM$;
3680       LOOP
3690       CLOSE
3700       IF INSTAT THEN 70
3710     WEND
3720     IF ESAU$="R" THEN
3730       GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"RECEIVE AN ENCIPHERED MESSAGE FROM TAPE":COLOR INK,PAPER
3740       LOCATE 4,3:PRINT"Give a name to the message to be received from tape"
3750       LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
3760       LOCATE 7,3:PRINT"The name you give must:"
3770       LOCATE 9,3:PRINT"- only contain alphabet keys"
3780       LOCATE 10,3:PRINT"- not be longer than 8 characters"
3790       LOCATE 11,3:PRINT"- not contain spaces"
3800       LOCATE 12,3:PRINT"- not have an extension"
3810       LOCATE 14,3:INPUT"Message name: ",NM$:NM$=UCASE$(NM$)
3820       IF NM$="" THEN 70
3830       IF INSTR(NM$," ") THEN BF=7:GOTO ERRA
3840       IF INSTR(NM$,".") THEN BF=8:GOTO ERRA
3850       IF LEN(NM$)>8 THEN BF=9:GOTO ERRA
3860       IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=10:GOTO ERRA
3870       GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure modem is on and connected to recorder properly **":COLOR INK,PAPER
3880       LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
3890       CNT$=INPUT$(1)
3900       IF ASC(CNT$)=27 THEN 70
3910       GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"Press PLAY on recorder to transfer '";NM$;"' (ESCape to quit)":COLOR INK,PAPER
3920       CALL GETTA
3930       PRINT#2,CHR$(26):CLOSE
3940       IF INSTAT THEN 70
3950       LOCATE 19,1:PRINT CHR$(204):LOCATE 19,2:PRINT BDR$:LOCATE 19,80:PRINT CHR$(185)
3960       LOCATE 20,3:PRINT"This message is in memory. It can now be deciphered"
3970       LOCATE 21,3:PRINT"Press ESCape to redo or any other key for Main Menu"
3980       CNT$=INKEY$:IF CNT$="" THEN 3980
3990       IF ASC(CNT$)=27 THEN 3910
4000     END IF
4010     M=0
4020   WEND
4030 :
4040 REM **** Quit ****
4050   WHILE M=10
4060     GOSUB BORDER:LOCATE 6,23:BEEP:COLOR INKH,PAPERH:PRINT"** Are you sure you want to quit? **":COLOR INK,PAPER
4070     LOCATE 8,20:PRINT"Type Y to quit or N to return to Main Menu"
4080     QUIT$=UCASE$(INPUT$(1))
4090     IF QUIT$<>"Y" THEN 70
4100     IF FD1 THEN DSK$="PROGRAM":GOSUB WARNDISK
4110     IF QUIT$="Y" THEN CLS:END
4120   WEND
4130 :
4140 WEND
4150 :
4160 SUB GETTA
4170   SHARED NM$,RAM$,DS$
4180   OPEN "COM1:300,N,8,1,CS,"+DS$ AS #1
4190   OPEN "O",2,RAM$+NM$
4200   EC=0:C=3:R=4:ESC$=CHR$(27)
4210   ON ERROR GOTO 0:ON ERROR GOTO 4240
4220   DO
4230     B$=INPUT$(1,#1)
4240     IF ERR=57 THEN RESUME 4230
4250     IF ASC(B$)=138 THEN INCR EC
4260     LOCATE R,C:PRINT B$;:PRINT#2,B$;:INCR C
4270     IF C=79 THEN C=3:INCR R
4280     IF R=19 THEN R=4
4290   LOOP UNTIL EC=3 OR INSTAT
4300   ON ERROR GOTO 0:ON ERROR GOTO 4610
4310 END SUB
4320 :
4330 ERRA:
4340 GOSUB BORDER:SOUND 88,8:LOCATE 2,3:COLOR 0,1
4350 IF BF=0 THEN PRINT"** You pressed the wrong key **"
4360 IF BF=1 OR BF=7 THEN PRINT"** No spaces allowed in name **"
4370 IF BF=2 OR BF=8 THEN PRINT"** No extensions allowed in name **"
4380 IF BF=3 OR BF=9 THEN PRINT"** Name too long **"
4390 IF BF=4 OR BF=10 THEN PRINT"** Numbers not allowed in name **"
4400 IF BF=5 THEN PRINT"** All data on this disk used. Start a new 'DATA' disk **"
4410 IF BF=6 THEN PRINT"** Last set of data. Start a new 'DATA' disk next time"
4420 IF BF=11 THEN PRINT"** '";UCASE$(NM$);"' is not enciphered. It may not be saved on tape **"
4430 COLOR INK,PAPER
4440 LOCATE 4,3:PRINT"Try again"
4450 LOCATE 20,3:PRINT"Press a key to continue. ESCape to return to Main Menu"
4460 CNT$=INPUT$(1)
4470 IF ASC(CNT$)=27 THEN 70
4480 IF BF=0 THEN 70
4490 IF BF=1 THEN 2770
4500 IF BF=2 THEN 2770
4510 IF BF=3 THEN 2770
4520 IF BF=4 THEN 2770
4530 IF BF=5 THEN 70
4540 IF BF=6 THEN 1900
4550 IF BF=7 THEN 3730
4560 IF BF=8 THEN 3730
4570 IF BF=9 THEN 3730
4580 IF BF=10 THEN 3730
4590 IF BF=11 THEN 3440
4600 :
4610 ERMESG:
4620 GOSUB BORDER:SOUND 88,8:LOCATE 2,3:COLOR INKH,PAPERH:NM$=UCASE$(NM$)
4630 IF ERR=70 THEN PRINT"** Disk write protected. Shift tab to continue **":GOTO 4910
4640 IF ERR=71 THEN PRINT"** Disk not in drive or door open **":GOTO 4910
4650 IF ERR=72 THEN PRINT"** Disk corrupted **":GOTO 4910
4660 IF ERR=53 AND ERL=360 THEN PRINT"** There are no messages on this disk to load **"
4670 IF ERR=53 AND ERL=440 THEN PRINT"** There is no message '";NM$;"' to load from this disk **"
4680 IF ERR=53 AND ERL=540 THEN PRINT"** There are no messages in memory to save **"
4690 IF ERR=53 AND ERL=620 THEN PRINT"** There is no message '";NM$;"' in memory to save **"
4700 IF ERR=53 AND ERL=740 THEN PRINT"** There are no files on this disk to delete **"
4710 IF ERR=53 AND ERL=800 THEN PRINT"** There is no file '";NM$;"' on this disk to delete **"
4720 IF ERR=53 AND ERL=890 THEN PRINT"** There are no messages in memory to encipher **"
4730 IF ERR=53 AND ERL=940 THEN PRINT"** There is no message '";NM$;"' in memory to encipher **"
4740 IF ERR=53 AND ERL=960 THEN PRINT"** Wrong disk. Place 'DATA' disk in drive ";DRIVE$;" **"
4750 IF ERR=62 AND ERL=1170 THEN PRINT"** All data on this disk used. Start a new 'DATA' disk **"
4760 IF ERR=53 AND ERL=1470 THEN PRINT"** Wrong disk. Place 'DATA' disk in drive ";DRIVE$;" **"
4770 IF ERR=53 AND ERL=1660 THEN PRINT"** There are no messages in memory to decipher **"
4780 IF ERR=53 AND ERL=1710 THEN PRINT"** There is no message '";NM$;"' in memory to decipher **"
4790 IF ERR=5 AND ERL=1750 OR ERR=62 AND ERL=1750 THEN PRINT"** You've tried to decipher an un-enciphered message **"
4800 IF ERR=62 AND ERL=2180 THEN PRINT"** Ending missing. Read in editor or print out **"
4810 IF ERR=53 AND ERL=1810 THEN PRINT"** Wrong disk. Place 'DATA' disk in drive ";DRIVE$;" **"
4820 IF ERR=53 AND ERL=2620 THEN PRINT"** Wrong disk. Place 'DATA' disk in drive ";DRIVE$;" **"
4830 IF ERR=53 AND ERL=3020 THEN PRINT"** There is no message '";NM$;"' in memory to edit/read **"
4840 IF ERR=53 AND ERL=2970 THEN PRINT"** There are no messages in memory to edit/read **"
4850 IF ERR=53 AND ERL=3100 THEN PRINT"** Program disk not in drive **"
4860 IF ERR=53 AND ERL=3180 THEN PRINT"** There are no messages in memory to print out **"
4870 IF ERR=53 AND ERL=3250 THEN PRINT"** There is no message '";NM$;"' in memory to print out **"
4880 IF ERR=24 OR ERR=25 OR ERR=27 THEN PRINT"** Printer off line, not connected or out of paper **":GOTO 4910
4890 IF ERR=53 AND ERL=3450 THEN PRINT"** There are no messages in memory to save on tape **"
4900 IF ERR=53 AND ERL=3500 THEN PRINT"** There is no message '";NM$;"' in memory to save on tape **"
4910 COLOR INK,PAPER
4920 LOCATE 4,3:PRINT"Try again"
4930 LOCATE 6,3:PRINT ERR,ERL,ERADR
4940 LOCATE 20,3:PRINT"Press a key to continue. ESCape to return to Main Menu"
4950 CLOSE
4960 CNT$=INPUT$(1)
4970 IF ASC(CNT$)=27 THEN
4973   IF XESC THEN 1580 ELSE GOTO 70
4976 END IF
4980 IF ERL=360 THEN RESUME 70                    'load 1
4990 IF ERL=440 THEN RESUME 350                   'load 2
5000 IF ERL=540 THEN RESUME 70                    'save 1
5010 IF ERL=620 OR ERL=630 THEN RESUME 530        'save 2
5020 IF ERL=740 THEN RESUME 70                    'delete 1
5030 IF ERL=800 OR ERL=810 THEN RESUME 730        'delete 2
5040 IF ERL=890 THEN RESUME 70                   'encipher 1
5050 IF ERL=940 THEN RESUME 880                 'encipher 2
5060 IF ERL=960 THEN RESUME 950                 'encipher 3
5070 IF ERL=1470 THEN RESUME 1450                 'encipher 4
5080 IF ERL=1500 THEN RESUME 1450                 'encipher 5
5090 IF ERL=1660 THEN RESUME 70                   'decipher 1
5100 IF ERL=1710 OR ERL=1750 THEN RESUME 1650     'decipher 2
5110 IF ERL=1810 THEN RESUME 1720                 'decipher 3
5120 IF ERL=2180 THEN RESUME 70                   'decipher 4
5130 IF ERL=2620 THEN RESUME 2610                 'decipher 5
5140 IF ERL=2650 OR ERL=2690 THEN RESUME 2610     'decipher 6
5150 IF ERL=2970 THEN RESUME 70                   'edit/read 1
5160 IF ERL=3020 THEN RESUME 2960                 'edit/read 2
5170 IF ERL=3100 THEN RESUME NEXT                 'editor
5180 IF ERL=3180 THEN RESUME 70                   'print 1
5190 IF ERL=3250 THEN RESUME 3170                 'print 2
5200 IF ERL=3260 THEN RESUME NEXT                 'print 3
5210 IF ERL=3450 THEN RESUME 70                   'stape 1
5220 IF ERL=3500 THEN RESUME 3440                 'stape 2
5230 IF ERL=4180 THEN RESUME 3910                 'rtape 1
5240 CLOSE:RESUME 70
5250 :
5260 BORDER:
5270   CLS:LOCATE 1,1:PRINT CHR$(201)
5280   BDR$=STRING$(78,205):LOCATE 1,2:PRINT BDR$
5290   LOCATE 1,80:PRINT CHR$(187)
5300   FOR V=2 TO 21:LOCATE V,1:PRINT CHR$(186):LOCATE V,80:PRINT CHR$(186):NEXT V
5310   LOCATE 22,1:PRINT CHR$(200)
5320   LOCATE 22,2:PRINT BDR$
5330   LOCATE 22,80:PRINT CHR$(188)
5340 RETURN
5350 :
5360 SETBAUD:
5370   SHELL DOS$+"MODE COM1:9600,N,8,1,P"
5380 RETURN
5390 :
5400 WARNDISK:
5410   GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure ";DSK$;" disk is in drive **":COLOR INK,PAPER
5420   LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
5430   CNT$=INPUT$(1)
5440   IF ASC(CNT$)=27 THEN 70
5450 RETURN
