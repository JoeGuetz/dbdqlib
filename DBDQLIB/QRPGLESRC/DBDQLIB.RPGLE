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
009000190919      ****************************************************************
009100190919      * Get DTAQ Info Export
009200190919      ****************************************************************
009300190919     P dbdqlib_getdqinfo...
009400190919     P                 B                   Export
009500190919     D dbdqlib_getdqinfo...
009600190919     D                 PI                  LikeDs(dbdqlib_dqinfo_T)
009700190919     D  dtaqName                     10    Varying Const
009800190919     D  dtaqLibn                     10    Varying Const
009900190919
010000190919     D getdqinfo       PR                  ExtPgm('QMHQRDQD')
010100190919     D  info                               LikeDs(dbdqlib_dqinfo_T)
010200190919     D  infoLength                   10I 0
010300190919     D  infoFormat                    8    Const
010400190919     D  infoDQName                   20    Const
010500190919
010600190919     D dqname          S             10
010700190919     D dqlibn          S             10
010800190919
010900190919     D infdq           S             20
011000190919     D inflen          S             10I 0
011100190919     D infformat       S              8
011200190919
011300190919     D retVal          DS                  LikeDs(dbdqlib_dqinfo_T)
011400190919
011500190919      /free
011600190919       dqname = dtaqName;
011700190919       dqlibn = dtaqLibn;
011800190919       infdq = dqname + dqlibn;
011900190919       infformat = 'RDQD0100';
012000190919       inflen = %size(retVal);
012100190919
012200190919       clear retVal;
012300190920       monitor;
012400190920         getdqinfo(retVal:inflen:infformat:infdq);
012500190920       on-error;
012600190920       endmon;
012700190919       return retVal;
012800190919      /end-free
012900190919
013000190919     P                 E
013100190920      ****************************************************************
013200190920      * Get DTAQ Info Export
013300190920      ****************************************************************
013400190920     P dbdqlib_getdqinfo_udtf...
013500190920     P                 B                   Export
013600190920     D dbdqlib_getdqinfo_udtf...
013700190920     D                 PI
013800190920     D  i_dtaqName                   10    Varying Const
013900190920     D  i_dtaqLibn                   10    Varying Const
014000190920     D  o_msgLength                  10I 0
014100190920     D  o_keyLength                  10I 0
014200190920     D  o_keySeq                      1    Varying
014300190920     D  o_inclSender                  1    Varying
014400190920     D  o_forceInd                    1    Varying
014500190920     D  o_description                50    Varying
014600190920     D  o_type                        1    Varying
014700190920     D  o_autoReclaim                 1    Varying
014800190920     D  o_enfrcLocks                  1    Varying
014900190920     D  o_msgInQ                     10I 0
015000190920     D  o_msgAlloc                   10I 0
015100190920     D  o_dqName                     10    Varying
015200190920     D  o_dqLibn                     10    Varying
015300190920     D  o_maxEntAlw                  10I 0
015400190920     D  o_initEnt                    10I 0
015500190920     D  o_maxEntSpec                 10    Varying
015600190920     D  o_lastRclmDat                 8    Varying
015700190920     D  n_dtaqName                    5I 0 Const
015800190920     D  n_dtaqLibn                    5I 0 Const
015900190920     D  n_msgLength                   5I 0 Const
016000190920     D  n_keyLength                   5I 0 Const
016100190920     D  n_keySeq                      5I 0 Const
016200190920     D  n_inclSender                  5I 0 Const
016300190920     D  n_forceInd                    5I 0 Const
016400190920     D  n_description                 5I 0 Const
016500190920     D  n_type                        5I 0 Const
016600190920     D  n_autoReclaim                 5I 0 Const
016700190920     D  n_enfrcLocks                  5I 0 Const
016800190920     D  n_msgInQ                      5I 0 Const
016900190920     D  n_msgAlloc                    5I 0 Const
017000190920     D  n_dqName                      5I 0 Const
017100190920     D  n_dqLibn                      5I 0 Const
017200190920     D  n_maxEntAlw                   5I 0 Const
017300190920     D  n_initEnt                     5I 0 Const
017400190920     D  n_maxEntSpec                  5I 0 Const
017500190920     D  n_lastRclmDat                 5I 0 Const
017600190920     D  SQLSTT                        5A
017700190920     D  function                    517A   Varying Const
017800190920     D  specific                    128A   Varying Const
017900190920     D  errorMsg                     70A   Varying
018000190920     D  callType                     10I 0 Const
018100190920
018200190920     D data            DS                  Static LikeDs(dbdqlib_dqinfo_T)
018300190920     D dataRead        S               N   Static
018400190920
018500190920      /free
018600190920       SQLSTT = '00000';
018700190920       select;
018800190920       when callType = udtf_call_open;
018900190920         exsr doOpen;
019000190920       when callType = udtf_call_fetch;
019100190920         exsr doFetch;
019200190920       when callType = udtf_call_close;
019300190920         exsr doClose;
019400190920       other;
019500190920       endsl;
019600190920       return;
019700190920
019800190920       begsr doOpen;
019900190920       clear data;
020000190920       if n_dtaqName = udtf_parm_null;
020100190920         SQLSTT = '38999';
020200190920         leavesr;
020300190920       endif;
020400190920       if n_dtaqLibn = udtf_parm_null;
020500190920         SQLSTT = '38999';
020600190920         leavesr;
020700190920       endif;
020800190920       data = dbdqlib_getdqinfo(i_dtaqName:i_dtaqLibn);
020900190920       dataRead = false;
021000190920       if data.bytesReturned = 0;
021100190920         dataRead = true;
021200190920       endif;
021300190920       endsr;
021400190920
021500190920       begsr doFetch;
021600190920       if dataRead;
021700190920         SQLSTT = '02000';
021800190920         leavesr;
021900190920       endif;
022000190920       o_msgLength = data.msgLength;
022100190920       o_keyLength = data.keyLength;
022200190920       o_keySeq = data.keySequence;
022300190920       o_inclSender = data.inclSender;
022400190920       o_forceInd = data.forceInd;
022500190920       o_description = data.description;
022600190920       o_type = data.type;
022700190920       o_autoReclaim = data.autoReclaim;
022800190920       o_enfrcLocks = data.enfrcDQLocks;
022900190920       o_msgInQ = data.numMsgsInQ;
023000190920       o_msgAlloc = data.numMsgsAlloc;
023100190920       o_dqName = data.name;
023200190920       o_dqLibn = data.library;
023300190920       o_maxEntAlw = data.maxEntriesAlw;
023400190920       o_initEnt = data.initEntries;
023500190920       if data.maxEntriesSpc = -1;
023600190920         o_maxEntSpec = '*MAX16MB';
023700190920       elseif data.maxEntriesSpc = -2;
023800190920         o_maxEntSpec = '*MAX2GB';
023900190920       else;
024000190920         o_maxEntSpec = '';
024100190920       endif;
024200190920       o_lastRclmDat = data.lastReclmDate;
024300190920       dataRead = true;
024400190920       endsr;
024500190920
024600190920       begsr doClose;
024700190920       clear data;
024800190920       endsr;
024900190920
025000190920      /end-free
025100190920
025200190920     P                 E
