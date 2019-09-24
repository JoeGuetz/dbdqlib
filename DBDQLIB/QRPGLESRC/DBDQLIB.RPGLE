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
005500190924     D  keyOrder                      2    Varying Const
005600190828
005700190917     D rcvdq           PR                  ExtPgm('QRCVDTAQ')
005800190917     D  dqname                       10
005900190917     D  dqlibn                       10
006000190924     D  dqdatalen                     5  0
006100190917     D  dqdata                    64512
006200190917     D  dqwait                        5  0
006300190924     D  dqkeyorder                    2
006400190924     D  dqkeylen                      3  0
006500190924     D  dqkey                       256
006600190924     D  dqsenderlen                   3  0
006700190924     D  dqsender                     44
006800190917
006900190917     D dqname          S             10
007000190917     D dqlibn          S             10
007100190924     D dqdatalen       S              5  0
007200190917     D dqdata          S          64512
007300190917     D dqwait          S              5  0
007400190924     D dqkeyorder      S              2
007500190924     D dqkeylen        S              3  0
007600190924     D dqkey           S            256
007700190924     D dqsenderlen     S              3  0
007800190924     D dqsender        S             44
007900190917
008000190917     D retVal          S          32704    Varying
008100190828
008200190828      /free
008300190917       dqname = dtaqName;
008400190917       dqlibn = dtaqLibn;
008500190924       dqdatalen = 64512;
008600190917       dqdata = *blanks;
008700190917       dqwait = waitTime;
008800190924       dqkeyorder = *blanks;
008900190924       dqkeylen = 0;
009000190924       dqkey = *blanks;
009100190924       dqsenderlen = 0;
009200190924       dqsender = *blanks;
009300190924       if %len(%trim(keyValue)) <> 0;
009400190924         dqkey = keyValue;
009500190924         dqkeylen = %len(keyValue);
009600190924         dqkeyorder = keyOrder;
009700190924         if dqkeyorder = *blanks;
009800190924           dqkeyorder = 'GE';
009900190924         endif;
010000190924       endif;
010100190924
010200190924       if dqlibn = *blanks;
010300190924         dqlibn = '*LIBL';
010400190924       endif;
010500190920       retVal = '';
010600190920       monitor;
010700190924         rcvdq(dqname:dqlibn:dqdatalen:dqdata:dqwait:
010800190924               dqkeyorder:dqkeylen:dqkey:dqsenderlen:dqsender);
010900190924         if dqdatalen > 0;
011000190924           retVal = %subst(dqdata:1:dqdatalen);
011100190924         else;
011200190924           retVal = '';
011300190924         endif;
011400190920       on-error;
011500190920       endmon;
011600190917       return retVal;
011700190828      /end-free
011800190828
011900190828     P                 E
012000190922      ****************************************************************
012100190922      * Send DTAQ Export
012200190922      ****************************************************************
012300190922     P dbdqlib_senddq...
012400190922     P                 B                   Export
012500190922     D dbdqlib_senddq...
012600190922     D                 PI             1    Varying
012700190922     D  dtaqName                     10    Varying Const
012800190922     D  dtaqLibn                     10    Varying Const
012900190922     D  dtaqData                  32704    Varying Const
013000190922     D  dtaqKey                     256    Varying Const
013100190922
013200190922     D snddq           PR                  ExtPgm('QSNDDTAQ')
013300190922     D  dqname                       10
013400190922     D  dqlibn                       10
013500190922     D  dqdatalen                     5  0
013600190922     D  dqdata                    64512    Options(*varsize)
013700190922     D  dqkeylen                      3  0 Options(*nopass)
013800190922     D  dqkey                       256    Options(*nopass:*varsize)
013900190922
014000190922     D dqname          S             10
014100190922     D dqlibn          S             10
014200190922     D dqdatalen       S              5  0
014300190922     D dqdata          S          64512
014400190922     D dqkeylen        S              3  0
014500190922     D dqkey           S            256
014600190922
014700190922     D retVal          S              1    Varying
014800190922
014900190922      /free
015000190922       dqname = dtaqName;
015100190922       dqlibn = dtaqLibn;
015200190924       dqdata = dtaqData;
015300190924       dqdatalen = %len(dtaqData);
015400190924       dqkeylen = 0;
015500190924       dqkey = *blanks;
015600190924       if %len(%trimr(dtaqKey)) <> 0;
015700190924         dqkey = dtaqKey;
015800190924         dqkeylen = %len(dtaqKey);
015900190924       endif;
016000190922       if dqlibn = *blanks;
016100190922         dqlibn = '*LIBL';
016200190922       endif;
016300190922       retVal = '0';
016400190922       monitor;
016500190922         if dqkeylen > 0;
016600190922           snddq(dqname:dqlibn:dqdatalen:dqdata:dqkeylen:dqkey);
016700190922         else;
016800190922           snddq(dqname:dqlibn:dqdatalen:dqdata);
016900190922         endif;
017000190922         retVal = '1';
017100190922       on-error;
017200190922       endmon;
017300190922       return retVal;
017400190922      /end-free
017500190922
017600190922     P                 E
017700190919      ****************************************************************
017800190919      * Get DTAQ Info Export
017900190919      ****************************************************************
018000190919     P dbdqlib_getdqinfo...
018100190919     P                 B                   Export
018200190919     D dbdqlib_getdqinfo...
018300190919     D                 PI                  LikeDs(dbdqlib_dqinfo_T)
018400190919     D  dtaqName                     10    Varying Const
018500190919     D  dtaqLibn                     10    Varying Const
018600190919
018700190919     D getdqinfo       PR                  ExtPgm('QMHQRDQD')
018800190919     D  info                               LikeDs(dbdqlib_dqinfo_T)
018900190919     D  infoLength                   10I 0
019000190919     D  infoFormat                    8    Const
019100190919     D  infoDQName                   20    Const
019200190919
019300190919     D dqname          S             10
019400190919     D dqlibn          S             10
019500190919
019600190919     D infdq           S             20
019700190919     D inflen          S             10I 0
019800190919     D infformat       S              8
019900190919
020000190919     D retVal          DS                  LikeDs(dbdqlib_dqinfo_T)
020100190919
020200190919      /free
020300190919       dqname = dtaqName;
020400190919       dqlibn = dtaqLibn;
020500190919       infdq = dqname + dqlibn;
020600190919       infformat = 'RDQD0100';
020700190919       inflen = %size(retVal);
020800190919
020900190919       clear retVal;
021000190920       monitor;
021100190920         getdqinfo(retVal:inflen:infformat:infdq);
021200190920       on-error;
021300190920       endmon;
021400190919       return retVal;
021500190919      /end-free
021600190919
021700190919     P                 E
021800190920      ****************************************************************
021900190920      * Get DTAQ Info Export
022000190920      ****************************************************************
022100190920     P dbdqlib_getdqinfo_udtf...
022200190920     P                 B                   Export
022300190920     D dbdqlib_getdqinfo_udtf...
022400190920     D                 PI
022500190920     D  i_dtaqName                   10    Varying Const
022600190920     D  i_dtaqLibn                   10    Varying Const
022700190920     D  o_msgLength                  10I 0
022800190920     D  o_keyLength                  10I 0
022900190920     D  o_keySeq                      1    Varying
023000190920     D  o_inclSender                  1    Varying
023100190920     D  o_forceInd                    1    Varying
023200190920     D  o_description                50    Varying
023300190920     D  o_type                        1    Varying
023400190920     D  o_autoReclaim                 1    Varying
023500190920     D  o_enfrcLocks                  1    Varying
023600190920     D  o_msgInQ                     10I 0
023700190920     D  o_msgAlloc                   10I 0
023800190920     D  o_dqName                     10    Varying
023900190920     D  o_dqLibn                     10    Varying
024000190920     D  o_maxEntAlw                  10I 0
024100190920     D  o_initEnt                    10I 0
024200190920     D  o_maxEntSpec                 10    Varying
024300190920     D  o_lastRclmDat                 8    Varying
024400190920     D  n_dtaqName                    5I 0 Const
024500190920     D  n_dtaqLibn                    5I 0 Const
024600190920     D  n_msgLength                   5I 0 Const
024700190920     D  n_keyLength                   5I 0 Const
024800190920     D  n_keySeq                      5I 0 Const
024900190920     D  n_inclSender                  5I 0 Const
025000190920     D  n_forceInd                    5I 0 Const
025100190920     D  n_description                 5I 0 Const
025200190920     D  n_type                        5I 0 Const
025300190920     D  n_autoReclaim                 5I 0 Const
025400190920     D  n_enfrcLocks                  5I 0 Const
025500190920     D  n_msgInQ                      5I 0 Const
025600190920     D  n_msgAlloc                    5I 0 Const
025700190920     D  n_dqName                      5I 0 Const
025800190920     D  n_dqLibn                      5I 0 Const
025900190920     D  n_maxEntAlw                   5I 0 Const
026000190920     D  n_initEnt                     5I 0 Const
026100190920     D  n_maxEntSpec                  5I 0 Const
026200190920     D  n_lastRclmDat                 5I 0 Const
026300190920     D  SQLSTT                        5A
026400190920     D  function                    517A   Varying Const
026500190920     D  specific                    128A   Varying Const
026600190920     D  errorMsg                     70A   Varying
026700190920     D  callType                     10I 0 Const
026800190920
026900190920     D data            DS                  Static LikeDs(dbdqlib_dqinfo_T)
027000190920     D dataRead        S               N   Static
027100190920
027200190920      /free
027300190920       SQLSTT = '00000';
027400190920       select;
027500190920       when callType = udtf_call_open;
027600190920         exsr doOpen;
027700190920       when callType = udtf_call_fetch;
027800190920         exsr doFetch;
027900190920       when callType = udtf_call_close;
028000190920         exsr doClose;
028100190920       other;
028200190920       endsl;
028300190920       return;
028400190920
028500190920       begsr doOpen;
028600190920       clear data;
028700190920       if n_dtaqName = udtf_parm_null;
028800190920         SQLSTT = '38999';
028900190920         leavesr;
029000190920       endif;
029100190920       if n_dtaqLibn = udtf_parm_null;
029200190920         SQLSTT = '38999';
029300190920         leavesr;
029400190920       endif;
029500190920       data = dbdqlib_getdqinfo(i_dtaqName:i_dtaqLibn);
029600190920       dataRead = false;
029700190920       if data.bytesReturned = 0;
029800190920         dataRead = true;
029900190920       endif;
030000190920       endsr;
030100190920
030200190920       begsr doFetch;
030300190920       if dataRead;
030400190920         SQLSTT = '02000';
030500190920         leavesr;
030600190920       endif;
030700190920       o_msgLength = data.msgLength;
030800190920       o_keyLength = data.keyLength;
030900190920       o_keySeq = data.keySequence;
031000190920       o_inclSender = data.inclSender;
031100190920       o_forceInd = data.forceInd;
031200190920       o_description = data.description;
031300190920       o_type = data.type;
031400190920       o_autoReclaim = data.autoReclaim;
031500190920       o_enfrcLocks = data.enfrcDQLocks;
031600190920       o_msgInQ = data.numMsgsInQ;
031700190920       o_msgAlloc = data.numMsgsAlloc;
031800190920       o_dqName = data.name;
031900190920       o_dqLibn = data.library;
032000190920       o_maxEntAlw = data.maxEntriesAlw;
032100190920       o_initEnt = data.initEntries;
032200190920       if data.maxEntriesSpc = -1;
032300190920         o_maxEntSpec = '*MAX16MB';
032400190920       elseif data.maxEntriesSpc = -2;
032500190920         o_maxEntSpec = '*MAX2GB';
032600190920       else;
032700190920         o_maxEntSpec = '';
032800190920       endif;
032900190920       o_lastRclmDat = data.lastReclmDate;
033000190920       dataRead = true;
033100190920       endsr;
033200190920
033300190920       begsr doClose;
033400190920       clear data;
033500190920       endsr;
033600190920
033700190920      /end-free
033800190920
033900190920     P                 E
