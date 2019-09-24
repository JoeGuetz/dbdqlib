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
002500190924      /free
002600190924       exec sql set option commit = *none, naming = *sql;
002700190924      /end-free
002800190924
002900190920     D false           C                   *off
003000190920     D true            C                   *on
003100190920
003200190917      /copy ixpertoss/qincludele,dbdqlib
003300190917
003400190920     D udtf_call_open...
003500190920     D                 C                   -1
003600190920     D udtf_call_fetch...
003700190920     D                 C                   0
003800190920     D udtf_call_close...
003900190920     D                 C                   1
004000190920     D udtf_parm_null...
004100190920     D                 C                   -1
004200190920     D udtf_parm_notnull...
004300190920     D                 C                   0
004400190920
004500190924     D g_smartcase     S               N   inz(*on)
004600190924
004700980226      ****************************************************************
004800190830      * Procedures
004900190830      ****************************************************************
005000190830      ****************************************************************
005100190917      * Read DTAQ Export
005200190830      ****************************************************************
005300190917     P dbdqlib_readdq...
005400190830     P                 B                   Export
005500190917     D dbdqlib_readdq...
005600190917     D                 PI         32704    Varying
005700190917     D  dtaqName                     10    Varying Const
005800190917     D  dtaqLibn                     10    Varying Const
005900190917     D  waitTime                      5  0 Const
006000190917     D  keyValue                    256    Varying Const
006100190924     D  keyOrder                      2    Varying Const
006200190828
006300190917     D rcvdq           PR                  ExtPgm('QRCVDTAQ')
006400190917     D  dqname                       10
006500190917     D  dqlibn                       10
006600190924     D  dqdatalen                     5  0
006700190917     D  dqdata                    64512
006800190917     D  dqwait                        5  0
006900190924     D  dqkeyorder                    2
007000190924     D  dqkeylen                      3  0
007100190924     D  dqkey                       256
007200190924     D  dqsenderlen                   3  0
007300190924     D  dqsender                     44
007400190917
007500190924     D dqinfo          DS                  LikeDs(dbdqlib_dqinfo_T)
007600190924
007700190917     D dqname          S             10
007800190917     D dqlibn          S             10
007900190924     D dqdatalen       S              5  0
008000190917     D dqdata          S          64512
008100190917     D dqwait          S              5  0
008200190924     D dqkeyorder      S              2
008300190924     D dqkeylen        S              3  0
008400190924     D dqkey           S            256
008500190924     D dqsenderlen     S              3  0
008600190924     D dqsender        S             44
008700190917
008800190917     D retVal          S          32704    Varying
008900190828
009000190828      /free
009100190924       clear dqinfo;
009200190924
009300190917       dqname = dtaqName;
009400190917       dqlibn = dtaqLibn;
009500190924       dqdatalen = 64512;
009600190917       dqdata = *blanks;
009700190917       dqwait = waitTime;
009800190924       dqkeyorder = *blanks;
009900190924       dqkeylen = 0;
010000190924       dqkey = *blanks;
010100190924       dqsenderlen = 0;
010200190924       dqsender = *blanks;
010300190924       if %len(%trimr(keyValue)) <> 0;
010400190924         dqkey = keyValue;
010500190924         dqkeylen = %len(keyValue);
010600190924         dqkeyorder = keyOrder;
010700190924         if dqkeyorder = *blanks;
010800190924           dqkeyorder = 'GE';
010900190924         endif;
011000190924       endif;
011100190924
011200190924       if dqlibn = *blanks;
011300190924         dqlibn = '*LIBL';
011400190924       endif;
011500190924       if g_smartcase;
011600190924         dqname = toUpper(dqname);
011700190924         dqlibn = toUpper(dqlibn);
011800190924       endif;
011900190920       retVal = '';
012000190920       monitor;
012100190924         rcvdq(dqname:dqlibn:dqdatalen:dqdata:dqwait:
012200190924               dqkeyorder:dqkeylen:dqkey:dqsenderlen:dqsender);
012300190924         if dqdatalen > 0;
012400190924           retVal = %subst(dqdata:1:dqdatalen);
012500190924         else;
012600190924           retVal = '';
012700190924         endif;
012800190920       on-error;
012900190920       endmon;
013000190917       return retVal;
013100190828      /end-free
013200190828
013300190828     P                 E
013400190922      ****************************************************************
013500190922      * Send DTAQ Export
013600190922      ****************************************************************
013700190922     P dbdqlib_senddq...
013800190922     P                 B                   Export
013900190922     D dbdqlib_senddq...
014000190922     D                 PI             1    Varying
014100190922     D  dtaqName                     10    Varying Const
014200190922     D  dtaqLibn                     10    Varying Const
014300190922     D  dtaqData                  32704    Varying Const
014400190922     D  dtaqKey                     256    Varying Const
014500190922
014600190922     D snddq           PR                  ExtPgm('QSNDDTAQ')
014700190922     D  dqname                       10
014800190922     D  dqlibn                       10
014900190922     D  dqdatalen                     5  0
015000190922     D  dqdata                    64512    Options(*varsize)
015100190922     D  dqkeylen                      3  0 Options(*nopass)
015200190922     D  dqkey                       256    Options(*nopass:*varsize)
015300190922
015400190924     D dqinfo          DS                  LikeDs(dbdqlib_dqinfo_T)
015500190924
015600190922     D dqname          S             10
015700190922     D dqlibn          S             10
015800190922     D dqdatalen       S              5  0
015900190922     D dqdata          S          64512
016000190922     D dqkeylen        S              3  0
016100190922     D dqkey           S            256
016200190922
016300190922     D retVal          S              1    Varying
016400190922
016500190922      /free
016600190922       dqname = dtaqName;
016700190922       dqlibn = dtaqLibn;
016800190924       dqdata = dtaqData;
016900190924       dqdatalen = %len(dtaqData);
017000190924       dqkeylen = 0;
017100190924       dqkey = *blanks;
017200190924       if %len(%trimr(dtaqKey)) <> 0;
017300190924         dqkey = dtaqKey;
017400190924         dqkeylen = %len(dtaqKey);
017500190924       endif;
017600190924
017700190922       if dqlibn = *blanks;
017800190922         dqlibn = '*LIBL';
017900190922       endif;
018000190924       if g_smartcase;
018100190924         dqname = toUpper(dqname);
018200190924         dqlibn = toUpper(dqlibn);
018300190924       endif;
018400190922       retVal = '0';
018500190922       monitor;
018600190922         if dqkeylen > 0;
018700190922           snddq(dqname:dqlibn:dqdatalen:dqdata:dqkeylen:dqkey);
018800190922         else;
018900190922           snddq(dqname:dqlibn:dqdatalen:dqdata);
019000190922         endif;
019100190922         retVal = '1';
019200190922       on-error;
019300190922       endmon;
019400190922       return retVal;
019500190922      /end-free
019600190922
019700190922     P                 E
019800190919      ****************************************************************
019900190919      * Get DTAQ Info Export
020000190919      ****************************************************************
020100190919     P dbdqlib_getdqinfo...
020200190919     P                 B                   Export
020300190919     D dbdqlib_getdqinfo...
020400190919     D                 PI                  LikeDs(dbdqlib_dqinfo_T)
020500190919     D  dtaqName                     10    Varying Const
020600190919     D  dtaqLibn                     10    Varying Const
020700190919
020800190919     D getdqinfo       PR                  ExtPgm('QMHQRDQD')
020900190919     D  info                               LikeDs(dbdqlib_dqinfo_T)
021000190919     D  infoLength                   10I 0
021100190919     D  infoFormat                    8    Const
021200190919     D  infoDQName                   20    Const
021300190919
021400190919     D dqname          S             10
021500190919     D dqlibn          S             10
021600190919
021700190919     D infdq           S             20
021800190919     D inflen          S             10I 0
021900190919     D infformat       S              8
022000190919
022100190919     D retVal          DS                  LikeDs(dbdqlib_dqinfo_T)
022200190919
022300190919      /free
022400190924       if g_smartcase;
022500190924         dqname = toUpper(dtaqName);
022600190924         dqlibn = toUpper(dtaqLibn);
022700190924       else;
022800190924         dqname = dtaqName;
022900190924         dqlibn = dtaqLibn;
023000190924       endif;
023100190924
023200190919       infdq = dqname + dqlibn;
023300190919       infformat = 'RDQD0100';
023400190919       inflen = %size(retVal);
023500190919
023600190919       clear retVal;
023700190920       monitor;
023800190920         getdqinfo(retVal:inflen:infformat:infdq);
023900190920       on-error;
024000190920       endmon;
024100190919       return retVal;
024200190919      /end-free
024300190919
024400190919     P                 E
024500190920      ****************************************************************
024600190924      * Get DTAQ Info Export SQL Table Function
024700190920      ****************************************************************
024800190920     P dbdqlib_getdqinfo_udtf...
024900190920     P                 B                   Export
025000190920     D dbdqlib_getdqinfo_udtf...
025100190920     D                 PI
025200190920     D  i_dtaqName                   10    Varying Const
025300190920     D  i_dtaqLibn                   10    Varying Const
025400190920     D  o_msgLength                  10I 0
025500190920     D  o_keyLength                  10I 0
025600190920     D  o_keySeq                      1    Varying
025700190920     D  o_inclSender                  1    Varying
025800190920     D  o_forceInd                    1    Varying
025900190920     D  o_description                50    Varying
026000190920     D  o_type                        1    Varying
026100190920     D  o_autoReclaim                 1    Varying
026200190920     D  o_enfrcLocks                  1    Varying
026300190920     D  o_msgInQ                     10I 0
026400190920     D  o_msgAlloc                   10I 0
026500190920     D  o_dqName                     10    Varying
026600190920     D  o_dqLibn                     10    Varying
026700190920     D  o_maxEntAlw                  10I 0
026800190920     D  o_initEnt                    10I 0
026900190920     D  o_maxEntSpec                 10    Varying
027000190920     D  o_lastRclmDat                 8    Varying
027100190920     D  n_dtaqName                    5I 0 Const
027200190920     D  n_dtaqLibn                    5I 0 Const
027300190920     D  n_msgLength                   5I 0 Const
027400190920     D  n_keyLength                   5I 0 Const
027500190920     D  n_keySeq                      5I 0 Const
027600190920     D  n_inclSender                  5I 0 Const
027700190920     D  n_forceInd                    5I 0 Const
027800190920     D  n_description                 5I 0 Const
027900190920     D  n_type                        5I 0 Const
028000190920     D  n_autoReclaim                 5I 0 Const
028100190920     D  n_enfrcLocks                  5I 0 Const
028200190920     D  n_msgInQ                      5I 0 Const
028300190920     D  n_msgAlloc                    5I 0 Const
028400190920     D  n_dqName                      5I 0 Const
028500190920     D  n_dqLibn                      5I 0 Const
028600190920     D  n_maxEntAlw                   5I 0 Const
028700190920     D  n_initEnt                     5I 0 Const
028800190920     D  n_maxEntSpec                  5I 0 Const
028900190920     D  n_lastRclmDat                 5I 0 Const
029000190920     D  SQLSTT                        5A
029100190920     D  function                    517A   Varying Const
029200190920     D  specific                    128A   Varying Const
029300190920     D  errorMsg                     70A   Varying
029400190920     D  callType                     10I 0 Const
029500190920
029600190920     D data            DS                  Static LikeDs(dbdqlib_dqinfo_T)
029700190920     D dataRead        S               N   Static
029800190920
029900190920      /free
030000190920       SQLSTT = '00000';
030100190920       select;
030200190920       when callType = udtf_call_open;
030300190920         exsr doOpen;
030400190920       when callType = udtf_call_fetch;
030500190920         exsr doFetch;
030600190920       when callType = udtf_call_close;
030700190920         exsr doClose;
030800190920       other;
030900190920       endsl;
031000190920       return;
031100190920
031200190920       begsr doOpen;
031300190920       clear data;
031400190920       if n_dtaqName = udtf_parm_null;
031500190920         SQLSTT = '38999';
031600190920         leavesr;
031700190920       endif;
031800190920       if n_dtaqLibn = udtf_parm_null;
031900190920         SQLSTT = '38999';
032000190920         leavesr;
032100190920       endif;
032200190920       data = dbdqlib_getdqinfo(i_dtaqName:i_dtaqLibn);
032300190920       dataRead = false;
032400190920       if data.bytesReturned = 0;
032500190920         dataRead = true;
032600190920       endif;
032700190920       endsr;
032800190920
032900190920       begsr doFetch;
033000190920       if dataRead;
033100190920         SQLSTT = '02000';
033200190920         leavesr;
033300190920       endif;
033400190920       o_msgLength = data.msgLength;
033500190920       o_keyLength = data.keyLength;
033600190920       o_keySeq = data.keySequence;
033700190920       o_inclSender = data.inclSender;
033800190920       o_forceInd = data.forceInd;
033900190920       o_description = data.description;
034000190920       o_type = data.type;
034100190920       o_autoReclaim = data.autoReclaim;
034200190920       o_enfrcLocks = data.enfrcDQLocks;
034300190920       o_msgInQ = data.numMsgsInQ;
034400190920       o_msgAlloc = data.numMsgsAlloc;
034500190920       o_dqName = data.name;
034600190920       o_dqLibn = data.library;
034700190920       o_maxEntAlw = data.maxEntriesAlw;
034800190920       o_initEnt = data.initEntries;
034900190920       if data.maxEntriesSpc = -1;
035000190920         o_maxEntSpec = '*MAX16MB';
035100190920       elseif data.maxEntriesSpc = -2;
035200190920         o_maxEntSpec = '*MAX2GB';
035300190920       else;
035400190920         o_maxEntSpec = '';
035500190920       endif;
035600190920       o_lastRclmDat = data.lastReclmDate;
035700190920       dataRead = true;
035800190920       endsr;
035900190920
036000190920       begsr doClose;
036100190920       clear data;
036200190920       endsr;
036300190920
036400190920      /end-free
036500190920
036600190920     P                 E
036700190924      ****************************************************************
036800190924      * convert string to upper
036900190924      ****************************************************************
037000190924     P toUpper         B
037100190924     D toUpper         PI            10    Varying
037200190924     D  value                        10    Varying Const
037300190924
037400190924     D retVal          S             10    Varying
037500190924
037600190924      /free
037700190924       exec sql
037800190924        set :retVal = ucase(:value);
037900190924       return retVal;
038000190924      /end-free
038100190924
038200190924     P                 E
