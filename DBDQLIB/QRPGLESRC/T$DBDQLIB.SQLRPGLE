000100190830      ****************************************************************
000200190830      *
000300190830      *    IBM i Open Source Collection
000400190830      *
000500190830      *    Copyright SNS GmbH, Bayreuth, Germany
000600190830      *    Published under GNU GPLv3 License
000700190830      *
000800190917      *    Author: Joe Guetzlaff, 09.19
000900190830      ****************************************************************
001000190903     H COPYRIGHT ('Copyright © by +
001100190903     H             SNS GmbH, Bayreuth, Germany +
001200190903     H             mindstream solutions llc, Cape Coral, FL, USA +
001300190903     H             Published under GNU GPLv3 License')
001400190903
001500190917     H BNDDIR    ('IXPERTBND':'QC2LE')
001600190830     H DFTACTGRP (*NO)
001700190830     H ACTGRP    (*NEW   )
001800190830     H ALWNULL   (*USRCTL)                                                      PGM SPECIFIC
001900190830     H FIXNBR    (*ZONED : *INPUTPACKED)                                        PGM SPECIFIC
002000190830     H OPTION    (*NOXREF : *NODEBUGIO)
002100190830     H CCSID     (*CHAR:*JOBRUN)
002200190830     H CCSID     (*UCS2:1200   )
002300140622
002400190921       exec sql set option commit = *none, naming = *sql;
002500190921
002600190917      /copy ixpertoss/qincludele,dbdqlib
002700140721
002800980226      ****************************************************************
002900140622
003000140622      /free
003100190920       test01();
003200190821       *inlr = *on;
003300140622      /end-free
003400140622
003500190830      ****************************************************************
003600190920     P test00          B
003700190921     D test00          PI
003800190821
003900190917     D data            S          64512    Varying
004000190919     D info            DS                  LikeDs(dbdqlib_dqinfo_T)
004100190821
004200140720      /free
004300190919       info = dbdqlib_getdqinfo('MLBNETTST':'JOE');
004400190917       data = dbdqlib_readdq('MLBNETTST':'JOE':0:'');
004500140720      /end-free
004600190821
004700190821     P                 E
004800190920      ****************************************************************
004900190920     P test01          B
005000190921     D test01          PI
005100190920
005200190920     D data            S          32704    Varying
005300190920
005400190920      /free
005500190920       exec sql
005600190920        set :data = ixpertoss.dtaq_read('MLBNETTST', 'JOE', 0, '');
005700190920      /end-free
005800190920
005900190920     P                 E
