000100190830      ****************************************************************
000200190830      *
000300190830      *    IBM i Open Source Collection
000400190830      *
000500190830      *    Copyright SNS GmbH, Bayreuth, Germany
000600190830      *    Published under GNU GPLv3 License
000700190830      *
000800190917      *    Author: Joe Guetzlaff, 09.19
000900190830      ****************************************************************
001000190830     H COPYRIGHT ('Copyright © by +
001100190903     H             SNS GmbH, Bayreuth, Germany +
001200190903     H             mindstream solutions llc, Cape Coral, FL, USA +
001300190830     H             Published under GNU GPLv3 License')
001400190830
001500190917     H BNDDIR    ('QC2LE')
001600190903     H ALWNULL   (*USRCTL)
001700190903     H FIXNBR    (*ZONED:*INPUTPACKED)
001800190903     H OPTION    (*NOXREF:*NODEBUGIO)
001900190830     H CCSID     (*CHAR:*JOBRUN)
002000190830     H CCSID     (*UCS2:1200   )
002100190830     H NOMAIN
002200140622
002300190830      ****************************************************************
002400140622
002500190920     D false           C                   *off
002600190920     D true            C                   *on
002700190920
002800190917      /copy ixpertoss/qincludele,dbdqlib
002900190917
003000190920     D udtf_call_open...
003100190920     D                 C                   -1
003200190920     D udtf_call_fetch...
003300190920     D                 C                   0
003400190920     D udtf_call_close...
003500190920     D                 C                   1
003600190920     D udtf_parm_null...
003700190920     D                 C                   -1
003800190920     D udtf_parm_notnull...
003900190920     D                 C                   0
004000190920
004100980226      ****************************************************************
004200190830      * Procedures
004300190830      ****************************************************************
004400190830      ****************************************************************
004500190917      * Read DTAQ Export
004600190830      ****************************************************************
004700190917     P dbdqlib_readdq...
004800190830     P                 B                   Export
004900190917     D dbdqlib_readdq...
005000190917     D                 PI         32704    Varying
005100190917     D  dtaqName                     10    Varying Const
005200190917     D  dtaqLibn                     10    Varying Const
005300190917     D  waitTime                      5  0 Const
005400190917     D  keyValue                    256    Varying Const
005500190828
005600190917     D rcvdq           PR                  ExtPgm('QRCVDTAQ')
005700190917     D  dqname                       10
005800190917     D  dqlibn                       10
005900190917     D  dqlen                         5  0
006000190917     D  dqdata                    64512
006100190917     D  dqwait                        5  0
006200190917
006300190917     D dqname          S             10
006400190917     D dqlibn          S             10
006500190917     D dqlen           S              5  0
006600190917     D dqdata          S          64512
006700190917     D dqwait          S              5  0
006800190917
006900190917     D retVal          S          32704    Varying
007000190828
007100190828      /free
007200190917       dqname = dtaqName;
007300190917       dqlibn = dtaqLibn;
007400190917       dqlen  = 64512;
007500190917       dqdata = *blanks;
007600190917       dqwait = waitTime;
007700190917       if dqlibn = *blanks;
007800190917         dqlibn = '*LIBL';
007900190917       endif;
008000190920       retVal = '';
008100190920       monitor;
008200190920         rcvdq(dqname:dqlibn:dqlen:dqdata:dqwait);
008300190920         retVal = %trimr(dqdata);
008400190920       on-error;
008500190920       endmon;
008600190917       return retVal;
008700190828      /end-free
008800190828
008900190828     P                 E
009000190922      ****************************************************************
009100190922      * Send DTAQ Export
009200190922      ****************************************************************
009300190922     P dbdqlib_senddq...
009400190922     P                 B                   Export
009500190922     D dbdqlib_senddq...
009600190922     D                 PI             1    Varying
009700190922     D  dtaqName                     10    Varying Const
009800190922     D  dtaqLibn                     10    Varying Const
009900190922     D  dtaqData                  32704    Varying Const
010000190922     D  dtaqKey                     256    Varying Const
010100190922
010200190922     D snddq           PR                  ExtPgm('QSNDDTAQ')
010300190922     D  dqname                       10
010400190922     D  dqlibn                       10
010500190922     D  dqdatalen                     5  0
010600190922     D  dqdata                    64512    Options(*varsize)
010700190922     D  dqkeylen                      3  0 Options(*nopass)
010800190922     D  dqkey                       256    Options(*nopass:*varsize)
010900190922
011000190922     D dqname          S             10
011100190922     D dqlibn          S             10
011200190922     D dqdatalen       S              5  0
011300190922     D dqdata          S          64512
011400190922     D dqkeylen        S              3  0
011500190922     D dqkey           S            256
011600190922
011700190922     D retVal          S              1    Varying
011800190922
011900190922      /free
012000190922       dqname = dtaqName;
012100190922       dqlibn = dtaqLibn;
012200190922       dqdata = %trimr(dtaqData);
012300190922       dqdatalen = %len(%trimr(dqdata));
012400190922       dqkey = %trimr(dtaqKey);
012500190922       dqkeylen = %len(%trimr(dqkey));
012600190922       if dqlibn = *blanks;
012700190922         dqlibn = '*LIBL';
012800190922       endif;
012900190922       retVal = '0';
013000190922       monitor;
013100190922         if dqkeylen > 0;
013200190922           snddq(dqname:dqlibn:dqdatalen:dqdata:dqkeylen:dqkey);
013300190922         else;
013400190922           snddq(dqname:dqlibn:dqdatalen:dqdata);
013500190922         endif;
013600190922         retVal = '1';
013700190922       on-error;
013800190922       endmon;
013900190922       return retVal;
014000190922      /end-free
014100190922
014200190922     P                 E
014300190919      ****************************************************************
014400190919      * Get DTAQ Info Export
014500190919      ****************************************************************
014600190919     P dbdqlib_getdqinfo...
014700190919     P                 B                   Export
014800190919     D dbdqlib_getdqinfo...
014900190919     D                 PI                  LikeDs(dbdqlib_dqinfo_T)
015000190919     D  dtaqName                     10    Varying Const
015100190919     D  dtaqLibn                     10    Varying Const
015200190919
015300190919     D getdqinfo       PR                  ExtPgm('QMHQRDQD')
015400190919     D  info                               LikeDs(dbdqlib_dqinfo_T)
015500190919     D  infoLength                   10I 0
015600190919     D  infoFormat                    8    Const
015700190919     D  infoDQName                   20    Const
015800190919
015900190919     D dqname          S             10
016000190919     D dqlibn          S             10
016100190919
016200190919     D infdq           S             20
016300190919     D inflen          S             10I 0
016400190919     D infformat       S              8
016500190919
016600190919     D retVal          DS                  LikeDs(dbdqlib_dqinfo_T)
016700190919
016800190919      /free
016900190919       dqname = dtaqName;
017000190919       dqlibn = dtaqLibn;
017100190919       infdq = dqname + dqlibn;
017200190919       infformat = 'RDQD0100';
017300190919       inflen = %size(retVal);
017400190919
017500190919       clear retVal;
017600190920       monitor;
017700190920         getdqinfo(retVal:inflen:infformat:infdq);
017800190920       on-error;
017900190920       endmon;
018000190919       return retVal;
018100190919      /end-free
018200190919
018300190919     P                 E
018400190920      ****************************************************************
018500190920      * Get DTAQ Info Export
018600190920      ****************************************************************
018700190920     P dbdqlib_getdqinfo_udtf...
018800190920     P                 B                   Export
018900190920     D dbdqlib_getdqinfo_udtf...
019000190920     D                 PI
019100190920     D  i_dtaqName                   10    Varying Const
019200190920     D  i_dtaqLibn                   10    Varying Const
019300190920     D  o_msgLength                  10I 0
019400190920     D  o_keyLength                  10I 0
019500190920     D  o_keySeq                      1    Varying
019600190920     D  o_inclSender                  1    Varying
019700190920     D  o_forceInd                    1    Varying
019800190920     D  o_description                50    Varying
019900190920     D  o_type                        1    Varying
020000190920     D  o_autoReclaim                 1    Varying
020100190920     D  o_enfrcLocks                  1    Varying
020200190920     D  o_msgInQ                     10I 0
020300190920     D  o_msgAlloc                   10I 0
020400190920     D  o_dqName                     10    Varying
020500190920     D  o_dqLibn                     10    Varying
020600190920     D  o_maxEntAlw                  10I 0
020700190920     D  o_initEnt                    10I 0
020800190920     D  o_maxEntSpec                 10    Varying
020900190920     D  o_lastRclmDat                 8    Varying
021000190920     D  n_dtaqName                    5I 0 Const
021100190920     D  n_dtaqLibn                    5I 0 Const
021200190920     D  n_msgLength                   5I 0 Const
021300190920     D  n_keyLength                   5I 0 Const
021400190920     D  n_keySeq                      5I 0 Const
021500190920     D  n_inclSender                  5I 0 Const
021600190920     D  n_forceInd                    5I 0 Const
021700190920     D  n_description                 5I 0 Const
021800190920     D  n_type                        5I 0 Const
021900190920     D  n_autoReclaim                 5I 0 Const
022000190920     D  n_enfrcLocks                  5I 0 Const
022100190920     D  n_msgInQ                      5I 0 Const
022200190920     D  n_msgAlloc                    5I 0 Const
022300190920     D  n_dqName                      5I 0 Const
022400190920     D  n_dqLibn                      5I 0 Const
022500190920     D  n_maxEntAlw                   5I 0 Const
022600190920     D  n_initEnt                     5I 0 Const
022700190920     D  n_maxEntSpec                  5I 0 Const
022800190920     D  n_lastRclmDat                 5I 0 Const
022900190920     D  SQLSTT                        5A
023000190920     D  function                    517A   Varying Const
023100190920     D  specific                    128A   Varying Const
023200190920     D  errorMsg                     70A   Varying
023300190920     D  callType                     10I 0 Const
023400190920
023500190920     D data            DS                  Static LikeDs(dbdqlib_dqinfo_T)
023600190920     D dataRead        S               N   Static
023700190920
023800190920      /free
023900190920       SQLSTT = '00000';
024000190920       select;
024100190920       when callType = udtf_call_open;
024200190920         exsr doOpen;
024300190920       when callType = udtf_call_fetch;
024400190920         exsr doFetch;
024500190920       when callType = udtf_call_close;
024600190920         exsr doClose;
024700190920       other;
024800190920       endsl;
024900190920       return;
025000190920
025100190920       begsr doOpen;
025200190920       clear data;
025300190920       if n_dtaqName = udtf_parm_null;
025400190920         SQLSTT = '38999';
025500190920         leavesr;
025600190920       endif;
025700190920       if n_dtaqLibn = udtf_parm_null;
025800190920         SQLSTT = '38999';
025900190920         leavesr;
026000190920       endif;
026100190920       data = dbdqlib_getdqinfo(i_dtaqName:i_dtaqLibn);
026200190920       dataRead = false;
026300190920       if data.bytesReturned = 0;
026400190920         dataRead = true;
026500190920       endif;
026600190920       endsr;
026700190920
026800190920       begsr doFetch;
026900190920       if dataRead;
027000190920         SQLSTT = '02000';
027100190920         leavesr;
027200190920       endif;
027300190920       o_msgLength = data.msgLength;
027400190920       o_keyLength = data.keyLength;
027500190920       o_keySeq = data.keySequence;
027600190920       o_inclSender = data.inclSender;
027700190920       o_forceInd = data.forceInd;
027800190920       o_description = data.description;
027900190920       o_type = data.type;
028000190920       o_autoReclaim = data.autoReclaim;
028100190920       o_enfrcLocks = data.enfrcDQLocks;
028200190920       o_msgInQ = data.numMsgsInQ;
028300190920       o_msgAlloc = data.numMsgsAlloc;
028400190920       o_dqName = data.name;
028500190920       o_dqLibn = data.library;
028600190920       o_maxEntAlw = data.maxEntriesAlw;
028700190920       o_initEnt = data.initEntries;
028800190920       if data.maxEntriesSpc = -1;
028900190920         o_maxEntSpec = '*MAX16MB';
029000190920       elseif data.maxEntriesSpc = -2;
029100190920         o_maxEntSpec = '*MAX2GB';
029200190920       else;
029300190920         o_maxEntSpec = '';
029400190920       endif;
029500190920       o_lastRclmDat = data.lastReclmDate;
029600190920       dataRead = true;
029700190920       endsr;
029800190920
029900190920       begsr doClose;
030000190920       clear data;
030100190920       endsr;
030200190920
030300190920      /end-free
030400190920
030500190920     P                 E
