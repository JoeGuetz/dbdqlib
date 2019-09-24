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
004100190924     D g_smartkeylen   C                   *on
004200190924     D g_smartcase     C                   *on
004300190924
004400980226      ****************************************************************
004500190830      * Procedures
004600190830      ****************************************************************
004700190830      ****************************************************************
004800190917      * Read DTAQ Export
004900190830      ****************************************************************
005000190917     P dbdqlib_readdq...
005100190830     P                 B                   Export
005200190917     D dbdqlib_readdq...
005300190917     D                 PI         32704    Varying
005400190917     D  dtaqName                     10    Varying Const
005500190917     D  dtaqLibn                     10    Varying Const
005600190917     D  waitTime                      5  0 Const
005700190917     D  keyValue                    256    Varying Const
005800190924     D  keyOrder                      2    Varying Const
005900190828
006000190917     D rcvdq           PR                  ExtPgm('QRCVDTAQ')
006100190917     D  dqname                       10
006200190917     D  dqlibn                       10
006300190924     D  dqdatalen                     5  0
006400190917     D  dqdata                    64512
006500190917     D  dqwait                        5  0
006600190924     D  dqkeyorder                    2
006700190924     D  dqkeylen                      3  0
006800190924     D  dqkey                       256
006900190924     D  dqsenderlen                   3  0
007000190924     D  dqsender                     44
007100190917
007200190924     D dqinfo          DS                  LikeDs(dqdblib_dqinfo_T)
007300190924
007400190917     D dqname          S             10
007500190917     D dqlibn          S             10
007600190924     D dqdatalen       S              5  0
007700190917     D dqdata          S          64512
007800190917     D dqwait          S              5  0
007900190924     D dqkeyorder      S              2
008000190924     D dqkeylen        S              3  0
008100190924     D dqkey           S            256
008200190924     D dqsenderlen     S              3  0
008300190924     D dqsender        S             44
008400190917
008500190917     D retVal          S          32704    Varying
008600190828
008700190828      /free
008800190924       clear dqinfo;
008900190924
009000190917       dqname = dtaqName;
009100190917       dqlibn = dtaqLibn;
009200190924       dqdatalen = 64512;
009300190917       dqdata = *blanks;
009400190917       dqwait = waitTime;
009500190924       dqkeyorder = *blanks;
009600190924       dqkeylen = 0;
009700190924       dqkey = *blanks;
009800190924       dqsenderlen = 0;
009900190924       dqsender = *blanks;
010000190924       if %len(%trimr(keyValue)) <> 0;
010100190924         dqkey = keyValue;
010200190924         dqkeylen = %len(keyValue);
010300190924         dqkeyorder = keyOrder;
010400190924         if dqkeyorder = *blanks;
010500190924           dqkeyorder = 'GE';
010600190924         endif;
010700190924       endif;
010800190924
010900190924       if dqlibn = *blanks;
011000190924         dqlibn = '*LIBL';
011100190924       endif;
011200190920       retVal = '';
011300190920       monitor;
011400190924         rcvdq(dqname:dqlibn:dqdatalen:dqdata:dqwait:
011500190924               dqkeyorder:dqkeylen:dqkey:dqsenderlen:dqsender);
011600190924         if dqdatalen > 0;
011700190924           retVal = %subst(dqdata:1:dqdatalen);
011800190924         else;
011900190924           retVal = '';
012000190924         endif;
012100190920       on-error;
012200190920       endmon;
012300190917       return retVal;
012400190828      /end-free
012500190828
012600190828     P                 E
012700190922      ****************************************************************
012800190922      * Send DTAQ Export
012900190922      ****************************************************************
013000190922     P dbdqlib_senddq...
013100190922     P                 B                   Export
013200190922     D dbdqlib_senddq...
013300190922     D                 PI             1    Varying
013400190922     D  dtaqName                     10    Varying Const
013500190922     D  dtaqLibn                     10    Varying Const
013600190922     D  dtaqData                  32704    Varying Const
013700190922     D  dtaqKey                     256    Varying Const
013800190922
013900190922     D snddq           PR                  ExtPgm('QSNDDTAQ')
014000190922     D  dqname                       10
014100190922     D  dqlibn                       10
014200190922     D  dqdatalen                     5  0
014300190922     D  dqdata                    64512    Options(*varsize)
014400190922     D  dqkeylen                      3  0 Options(*nopass)
014500190922     D  dqkey                       256    Options(*nopass:*varsize)
014600190922
014700190924     D dqinfo          DS                  LikeDs(dqdblib_dqinfo_T)
014800190924
014900190922     D dqname          S             10
015000190922     D dqlibn          S             10
015100190922     D dqdatalen       S              5  0
015200190922     D dqdata          S          64512
015300190922     D dqkeylen        S              3  0
015400190922     D dqkey           S            256
015500190922
015600190922     D retVal          S              1    Varying
015700190922
015800190922      /free
015900190922       dqname = dtaqName;
016000190922       dqlibn = dtaqLibn;
016100190924       dqdata = dtaqData;
016200190924       dqdatalen = %len(dtaqData);
016300190924       dqkeylen = 0;
016400190924       dqkey = *blanks;
016500190924       if %len(%trimr(dtaqKey)) <> 0;
016600190924         dqkey = dtaqKey;
016700190924         dqkeylen = %len(dtaqKey);
016800190924       endif;
016900190922       if dqlibn = *blanks;
017000190922         dqlibn = '*LIBL';
017100190922       endif;
017200190922       retVal = '0';
017300190922       monitor;
017400190922         if dqkeylen > 0;
017500190922           snddq(dqname:dqlibn:dqdatalen:dqdata:dqkeylen:dqkey);
017600190922         else;
017700190922           snddq(dqname:dqlibn:dqdatalen:dqdata);
017800190922         endif;
017900190922         retVal = '1';
018000190922       on-error;
018100190922       endmon;
018200190922       return retVal;
018300190922      /end-free
018400190922
018500190922     P                 E
018600190919      ****************************************************************
018700190919      * Get DTAQ Info Export
018800190919      ****************************************************************
018900190919     P dbdqlib_getdqinfo...
019000190919     P                 B                   Export
019100190919     D dbdqlib_getdqinfo...
019200190919     D                 PI                  LikeDs(dbdqlib_dqinfo_T)
019300190919     D  dtaqName                     10    Varying Const
019400190919     D  dtaqLibn                     10    Varying Const
019500190919
019600190919     D getdqinfo       PR                  ExtPgm('QMHQRDQD')
019700190919     D  info                               LikeDs(dbdqlib_dqinfo_T)
019800190919     D  infoLength                   10I 0
019900190919     D  infoFormat                    8    Const
020000190919     D  infoDQName                   20    Const
020100190919
020200190919     D dqname          S             10
020300190919     D dqlibn          S             10
020400190919
020500190919     D infdq           S             20
020600190919     D inflen          S             10I 0
020700190919     D infformat       S              8
020800190919
020900190919     D retVal          DS                  LikeDs(dbdqlib_dqinfo_T)
021000190919
021100190919      /free
021200190919       dqname = dtaqName;
021300190919       dqlibn = dtaqLibn;
021400190919       infdq = dqname + dqlibn;
021500190919       infformat = 'RDQD0100';
021600190919       inflen = %size(retVal);
021700190919
021800190919       clear retVal;
021900190920       monitor;
022000190920         getdqinfo(retVal:inflen:infformat:infdq);
022100190920       on-error;
022200190920       endmon;
022300190919       return retVal;
022400190919      /end-free
022500190919
022600190919     P                 E
022700190920      ****************************************************************
022800190924      * Get DTAQ Info Export SQL Table Function
022900190920      ****************************************************************
023000190920     P dbdqlib_getdqinfo_udtf...
023100190920     P                 B                   Export
023200190920     D dbdqlib_getdqinfo_udtf...
023300190920     D                 PI
023400190920     D  i_dtaqName                   10    Varying Const
023500190920     D  i_dtaqLibn                   10    Varying Const
023600190920     D  o_msgLength                  10I 0
023700190920     D  o_keyLength                  10I 0
023800190920     D  o_keySeq                      1    Varying
023900190920     D  o_inclSender                  1    Varying
024000190920     D  o_forceInd                    1    Varying
024100190920     D  o_description                50    Varying
024200190920     D  o_type                        1    Varying
024300190920     D  o_autoReclaim                 1    Varying
024400190920     D  o_enfrcLocks                  1    Varying
024500190920     D  o_msgInQ                     10I 0
024600190920     D  o_msgAlloc                   10I 0
024700190920     D  o_dqName                     10    Varying
024800190920     D  o_dqLibn                     10    Varying
024900190920     D  o_maxEntAlw                  10I 0
025000190920     D  o_initEnt                    10I 0
025100190920     D  o_maxEntSpec                 10    Varying
025200190920     D  o_lastRclmDat                 8    Varying
025300190920     D  n_dtaqName                    5I 0 Const
025400190920     D  n_dtaqLibn                    5I 0 Const
025500190920     D  n_msgLength                   5I 0 Const
025600190920     D  n_keyLength                   5I 0 Const
025700190920     D  n_keySeq                      5I 0 Const
025800190920     D  n_inclSender                  5I 0 Const
025900190920     D  n_forceInd                    5I 0 Const
026000190920     D  n_description                 5I 0 Const
026100190920     D  n_type                        5I 0 Const
026200190920     D  n_autoReclaim                 5I 0 Const
026300190920     D  n_enfrcLocks                  5I 0 Const
026400190920     D  n_msgInQ                      5I 0 Const
026500190920     D  n_msgAlloc                    5I 0 Const
026600190920     D  n_dqName                      5I 0 Const
026700190920     D  n_dqLibn                      5I 0 Const
026800190920     D  n_maxEntAlw                   5I 0 Const
026900190920     D  n_initEnt                     5I 0 Const
027000190920     D  n_maxEntSpec                  5I 0 Const
027100190920     D  n_lastRclmDat                 5I 0 Const
027200190920     D  SQLSTT                        5A
027300190920     D  function                    517A   Varying Const
027400190920     D  specific                    128A   Varying Const
027500190920     D  errorMsg                     70A   Varying
027600190920     D  callType                     10I 0 Const
027700190920
027800190920     D data            DS                  Static LikeDs(dbdqlib_dqinfo_T)
027900190920     D dataRead        S               N   Static
028000190920
028100190920      /free
028200190920       SQLSTT = '00000';
028300190920       select;
028400190920       when callType = udtf_call_open;
028500190920         exsr doOpen;
028600190920       when callType = udtf_call_fetch;
028700190920         exsr doFetch;
028800190920       when callType = udtf_call_close;
028900190920         exsr doClose;
029000190920       other;
029100190920       endsl;
029200190920       return;
029300190920
029400190920       begsr doOpen;
029500190920       clear data;
029600190920       if n_dtaqName = udtf_parm_null;
029700190920         SQLSTT = '38999';
029800190920         leavesr;
029900190920       endif;
030000190920       if n_dtaqLibn = udtf_parm_null;
030100190920         SQLSTT = '38999';
030200190920         leavesr;
030300190920       endif;
030400190920       data = dbdqlib_getdqinfo(i_dtaqName:i_dtaqLibn);
030500190920       dataRead = false;
030600190920       if data.bytesReturned = 0;
030700190920         dataRead = true;
030800190920       endif;
030900190920       endsr;
031000190920
031100190920       begsr doFetch;
031200190920       if dataRead;
031300190920         SQLSTT = '02000';
031400190920         leavesr;
031500190920       endif;
031600190920       o_msgLength = data.msgLength;
031700190920       o_keyLength = data.keyLength;
031800190920       o_keySeq = data.keySequence;
031900190920       o_inclSender = data.inclSender;
032000190920       o_forceInd = data.forceInd;
032100190920       o_description = data.description;
032200190920       o_type = data.type;
032300190920       o_autoReclaim = data.autoReclaim;
032400190920       o_enfrcLocks = data.enfrcDQLocks;
032500190920       o_msgInQ = data.numMsgsInQ;
032600190920       o_msgAlloc = data.numMsgsAlloc;
032700190920       o_dqName = data.name;
032800190920       o_dqLibn = data.library;
032900190920       o_maxEntAlw = data.maxEntriesAlw;
033000190920       o_initEnt = data.initEntries;
033100190920       if data.maxEntriesSpc = -1;
033200190920         o_maxEntSpec = '*MAX16MB';
033300190920       elseif data.maxEntriesSpc = -2;
033400190920         o_maxEntSpec = '*MAX2GB';
033500190920       else;
033600190920         o_maxEntSpec = '';
033700190920       endif;
033800190920       o_lastRclmDat = data.lastReclmDate;
033900190920       dataRead = true;
034000190920       endsr;
034100190920
034200190920       begsr doClose;
034300190920       clear data;
034400190920       endsr;
034500190920
034600190920      /end-free
034700190920
034800190920     P                 E
