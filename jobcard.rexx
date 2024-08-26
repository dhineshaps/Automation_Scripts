/*REXX MACRO FOR JOB CARD */

ADDRESS ISREDIT
'MACRO'
"LINE_AFTER 0 = '//"USERID()"A JOB "TEST",'"
"LINE_AFTER 1 = '//            CLASS=M,'"
"LINE_AFTER 2 = '//            NOTIFY="USERID()",'"
"LINE_AFTER 3 = '//  

/* For Executing the above Macro the required Dataset needs to be in SYSEXEC or SYSPROC, for Testing purposes we can add it dynamically by executing the below Rexx. */
DNAME = '{PDS}' /* Example - TEST.MACRO.REXX Where 'JOBCARD' Memeber Present */
ADDRESS TSO
"FREE FI(SYSEXEC)"
"ALLOC FI(SYSEXEC) DA(DNAME) SHR
