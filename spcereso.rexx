/* REXX Tool to resolve the space issue */

SAY “Enter the Dataset to increase space: “
PULL ODNAME

/* Validating the Dataset exits */
IF SYSDSN(ODNAME) = OK THEN
    DO
        SAY “Old dataset exits and proceeding “
		
        /*Creating New Dataset Name */
        NEWDS = ODNAME||’.’||’D’||DATE(J)||’.’||’T’||TIME(S)
		
        SAY NEWDS /*HLQ.SAMPLE.D24237.T456  - Example*/
		 
        /* Calling the required functions to perform the operations */
		
		  CALL GETATTRIB /* Getting attributes for creating new dataset with increased space */
		  CALL NEWDSCREATION /* Creating New Dataset  using above attributes */
		  CALL OLDDSREAD /* Reading the content in Compound Variable*/
		  CALL  NEWWRITE /* Writing the above read content in newly created dataset */
		  CALL DELOLDDS /* Deleting the old Dataset */
		  CALL  RENAMEDS /*Renaming the new dataset to old dataset name */
	  
    END
ELSE
    DO
        SAY “Old Dataset not exits Please validate it”
        EXIT
    END
EXIT
/********************************************************/

GETATTRIB:
	SAY “Please enter the below attribute for allocating New Dataset”
	SAY “Enter the Record Length: “
	PULL RLGTH
	SAY “Enter the Block Size: “
	PULL BSIZE
	SAY “Enter the Space Units: TRKS,BLKS,CYLS .. “
	PULL SUNIT
	SAY  “Enter the Record Format: “
	PULL RFRM
	IF RFRM = ‘FB’ THEN
		 DO
			  RFRM = ‘F B’  /*Handling Fixed format as per Rexx */
		  END
	SAY “Enter the primary Quantity: “
	PULL PQTY
	SAY “Enter the Secondary Quantity: “
	PULL SQTY
	
RETURN

/********************************************************/
NEWDSCREATION:
   SAY “Creating the New Dataset”
   
   “ALLOC DD(OUTFILE) DA(NEWDS) NEW SPACE(“PQTY” “SQTY”) “,
   “”SUNIT” LRECL(“RLGTH”) BLOCK(“BSIZE”) RECFM(“RFRM”)”
   
   IF RC = 0 THEN
   DO
     SAY “Successfully Created new Dataset: “ NEWDS
   END
  ELSE
   DO
     SAY “Error in creating the New Dataset”
     EXIT
   END 
   
 RETURN  
 
/********************************************************/ 
OLDDSREAD:
    SAY “Reading the old dataset into compound variables”
   
    “ALLOC DD(IND) DA(“ODNAME”) SHR REUSE”
    “EXECIO * DISKR IND(STEM INI. FINIS”
	
    IF RC = 0 THEN
     SAY “Reading Completed Successfully”
	 
   “FREE DD(IND)”
   
RETURN

/********************************************************/
NEWWRITE:

    SAY “Writing the old dataset into new dataset”
	 
    “ALLOC DD(OUTD) DA(“NEWDS”) SHR REUSE”
    “EXECIO * DISKW OUTD(STEM INI. FINIS”
	
    IF RC = 0 THEN
     SAY “Writing into New Dataset Completed Successfully”
	 
    “FREE DD(OUTD)”
RETURN

/********************************************************/

DELOLDDS:

    SAY  “Deleting the Old Dataset”
    
	“DELETE “ ODNAME
    
	IF RC = 0 THEN
       SAY “Old Dataset Deleted”
	   
RETURN
/********************************************************/

RENAMEDS:
    SAY “Renaming the New Dataset with Old Dataset Name”
	
    “ALTER “NEWDS” NEWNAME(“ODNAME”)”
     
	 IF RC = 0 THEN
        SAY “Renaming Completed”
		
RETURN
