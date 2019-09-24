000100190830      ****************************************************************
000200190830      *
000300190830      *    IBM i Open Source Collection
000400190830      *
000500190830      *    Copyright SNS GmbH, Bayreuth, Germany
000600190830      *    Published under GNU GPLv3 License
000700190830      *
000800190917      *    Author: Joe Guetzlaff, 09.19
000900020708      ****************************************************************
001000131030
001100190919     D dbdqlib_dqinfo_T...
001200190919     D                 DS                  Qualified Template Inz
001300190919     D  bytesReturned                10I 0
001400190919     D  bytesAvail                   10I 0
001500190919     D  msgLength                    10I 0
001600190919     D  keyLength                    10I 0
001700190919     D  keySequence                   1
001800190919     D  inclSender                    1
001900190919     D  forceInd                      1
002000190919     D  description                  50
002100190919     D  type                          1
002200190919     D  autoReclaim                   1
002300190919     D  enfrcDQLocks                  1
002400190919     D  numMsgsInQ                   10I 0
002500190919     D  numMsgsAlloc                 10I 0
002600190919     D  name                         10
002700190919     D  library                      10
002800190919     D  maxEntriesAlw                10I 0
002900190919     D  initEntries                  10I 0
003000190919     D  maxEntriesSpc                10I 0
003100190919     D  lastReclmDate                 8
003200190919
003300190917     D dbdqlib_readdq...
003400190917     D                 PR         32704    Varying
003500190917     D dtaqName                      10    Varying Const
003600190917     D dtaqLibn                      10    Varying Const
003700190917     D waitTime                       5  0 Const
003800190917     D keyValue                     256    Varying Const
003900190924     D keyOrder                       2    Varying Const
004000190830
004100190922     D dbdqlib_senddq...
004200190922     D                 PR             1    Varying
004300190922     D dtaqName                      10    Varying Const
004400190922     D dtaqLibn                      10    Varying Const
004500190922     D dtaqData                   32704    Varying Const
004600190922     D dtaqKey                      256    Varying Const
004700190922
004800190919     D dbdqlib_getdqinfo...
004900190919     D                 PR                  LikeDs(dbdqlib_dqinfo_T)
005000190919     D dtaqName                      10    Varying Const
005100190919     D dtaqLibn                      10    Varying Const
005200190919
