# Script to perform an Unattended SQL Server Install, Build SQL Cluster,Add Node to a Cluster,Remove Node from a Cluster, Uninstall SQL and execute Pre and Post install Tasks.
# Script Help :-
#---------------
# Parameter 1 :- "-c" to specify the path of User Input File for the Install
# Parameter 2 :- "-a" to Specify the Action of Install; The Value of -a can be only Install, InstallFailoverCluster, AddNode, RemoveNode, Uninstall,PreInstall,PostInstall or Reinstall
# Example1:- SQLInstall.ps1 -c <User Input File Full UNC Path> -a <Action>
# Example2:- SQLInstall.ps1 -c c:\SQLAutoInstallConfig.ini -a Install

Clear-Host

<#*************Variable Declaration******************#>

<#Pre-Install Function Variable  --- Prefix "p"#>
$pSQL_SERVER_NAME = $null
$pINSTANCE_NAME = $null
$pSQLUSERDBDRIVE = $null
$pSQLUSERLOGDRIVE = $null
$pSQLBACKUPDRIVE = $null
$pSQLTEMPDBDATADRIVE = $null
$pSQLTEMPDBLOGDRIVE = $null
$pASDATADRIVE = $null
$pASLOGDRIVE = $null
$pASBACKUPDRIVE = $null
$pASTEMPDRIVE = $null
$pbasefolder = $null
$pINSTALLSQLDATADIR = $null
$pSQLUSERDBDIR = $null
$pSQLUSERDBLOGDIR = $null
$pSQLBACKUPDIR = $null
$pSQLTEMPDBDIR = $null
$pASLOGDIR = $null
$pASDATADIR = $null
$pASBACKUPDIR = $null
$pASTEMPDIR = $null
$pSQLInstallFolders = @()
$pSQLINSTALL = $null
$pASINSTALL = $null
$pSQLINSTALLCONFIGPATH = $null

<#CreateConfig Function Variables  --- Prefix "c"#>
$cSQLInstallFolders = @()
$cCreateConfigArray = @()
$cAction = $null
$cSQLVERSION = $null
$cINSTANCE_NAME = $null
$cSQLINSTALL = $null
$cASINSTALL = $null
$cRSINSTALL = $null
$cISINSTALL = $null
$cSQLSVCACCT = $null
$cSQLSVCPWD = $null
$cSQLCOLLATION = $null
$cSQLSYSADMINACCOUNTS = $null
$cSQLSVCSTARTUPTYPE = $null
$cSAPWD = $null
$cSECURITYMODE = $null
$cASSVCACCT = $null
$cASSVCPWD = $null
$cASCOLLATION = $null
$cASSYSADMINACCOUNTS = $null
$cASSERVERMODE = $null
$cASSVCSTARTUPTYPE = $null
$cISAVCACCT = $null
$cISSVCPWD = $null
$cISSVCSTARTUPTYPE = $null
$cRSSVCACCT = $null
$cRSSVCPWD = $null
$cFAILOVERCLUSTERDISKS = $null
$cFAILOVERCLUSTERGROUP = $null
$cFAILOVERCLUSTERIPADDRESSES = $null
$cFAILOVERCLUSTERNETWORKNAME = $null
$cFEATURES = $null
$cConfigFile_Install

<#Main Program Variable --- Prefix "u"#>
###Arg Input Assign Variables
$ufilename = $null
$uconfig = @()
$uConfigFile = @()
$uAction =$null
$uconfigVal =@()
$uParameterHelp = $null

###Folder and FilePath Variables
$uSQLInstallFolders = @()
$uoutinifile = $null
$uSQLSetupEXE = $null
$uStartProcessArg = $null
$uStartProcessArg_Reinstall = $null
$uInstallOutLog = $null
$utempInstallOutLog = $null
$uSQLBootStrapLog = $null
$uSQLBootStrapLog_readline =$null
$ufeaturecnt = 0

###user Install Config Variables#>
$uSQL_SERVER_NAME = $null 
$uSQLVERSION = $null
$uINSTANCE_NAME = $null
$uSQLINSTALL = $null
$uSQLCLIENTINSTALL = $null
$uASINSTALL = $null
$uRSINSTALL = $null
$uISINSTALL = $null
$uDQCINSTALL = $null
$uMDSINSTALL = $null
$uFEATURES = $null
$uSQLUSERDBDRIVE = $null
$uSQLUSERLOGDRIVE = $null
$uSQLBACKUPDRIVE = $null
$uSQLTEMPDBDATADRIVE = $null
$uSQLTEMPDBLOGDRIVE = $null
$uSQLSVCACCT = $null
$uSQLSVCPWD = $null
$uSQLCOLLATION = $null
$uSQLSYSADMINACCOUNTS = $null
$uSQLSVCSTARTUPTYPE = $null
$uSAPWD = $null
$uSECURITYMODE = $null
$uASDATADRIVE = $null
$uASLOGDRIVE = $null
$uASBACKUPDRIVE = $null
$uASTEMPDRIVE = $null = $null
$uASCONFIGDIRVE = $null
$uASSVCACCT = $null
$uASSVCPWD = $null
$uASCOLLATION = $null
$uASSYSADMINACCOUNTS = $null
$uASSERVERMODE = $null
$uASSVCSTARTUPTYPE = $null
$uISAVCACCT = $null
$uISSVCPWD = $null
$uISSVCSTARTUPTYPE = $null
$uRSSVCACCT = $null
$uRSSVCPWD = $null
$uFAILOVERCLUSTERDISKS = $null
$uFAILOVERCLUSTERGROUP = $null
$uFAILOVERCLUSTERIPADDRESSES = $null
$uFAILOVERCLUSTERNETWORKNAME = $null
$uSQLINSTALLCONFIGPATH = $null
$uSQLSETUPPATH = $null
#$uSCRIPTLOG = $null
$uREINSTALLFILEPATH = $null
$uConfigFile_Install = $null
$unow = $null
$ubootstrapstring = $null
$ubootstrapstring_errorlog = $null
$ubootstrapdate = $null
$uenddateVal = @()

<#Script Error Routine Variables#>
$uerrorlog = $null
$perrorlog = $null
$umod1 = 0
$umod2 = 0
$pmod_error = 0
$pmod2_1 = 0
$pmod2_1_1 = 0
$pmod2_2 = 0
$pmod2_3 = 0
$pmod2_4 = 0
$pmod2_5 = 0
$pmod2_6 = 0
$pmod2_7 = 0
$pmod2_8 = 0
$umod3 = 0
$umod4 = 0
$umod5 = 0
$umod2_1_1 = 0

<#*************************START:Function to Create SQL Server Install Folders(Pre-Install)*******************************************#>
Function Pre-SQLInstall($pSQL_SERVER_NAME,$pINSTANCE_NAME,$pbasefolder,$pSQLUSERDBDRIVE,$pSQLUSERLOGDRIVE,$pSQLBACKUPDRIVE,$pSQLTEMPDBDATADRIVE,$pSQLTEMPDBLOGDRIVE,$pASDATADRIVE,$pASLOGDRIVE,$pASBACKUPDRIVE,$pASTEMPDRIVE,$pSQLINSTALL,$pASINSTALL)
{

		
	<#######Verify if the Folders exists############>
		#Create C:\SQLInstall folder for Log files
		$pSQLINSTALLCONFIGPATH = "C:\SQLInstall"
		if(Test-Path $pSQLINSTALLCONFIGPATH)
		{
		 Write-Host -ForegroundColor Cyan "[Module 2.0]:SQL Install Log Folder [$pSQLINSTALLCONFIGPATH] Already Exists"
		 $perrorlog = $perrorlog + "[Module 2.0]:SQL Install Log Folder [$pSQLINSTALLCONFIGPATH] Already Exists"+"`n`r`n`r"
		}
		else{
			 
			  Try
				{
					New-Item -Path $pSQLINSTALLCONFIGPATH -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.1]Error Creating [$pSQLINSTALLCONFIGPATH]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.1]Error Creating [$pSQLINSTALLCONFIGPATH]:" +$_.Exception.Message+"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_1_1 = 1
				}
				if($pmod2_1_1 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.1]:SQL Install Log Folder [$pSQLINSTALLCONFIGPATH] Created"
				$perrorlog = $perrorlog + "[Module 2.1]:SQL Install Log Folder [$pSQLINSTALLCONFIGPATH] Created" +"`n`r`n`r"
				}
			}
		
		#Create SQL DB Engine Folder if SQL Install is enabled
		if($pSQLINSTALL -eq "TRUE")
		{
		<#START [Module 2.1]:Check SQL UserDB Data Folder#>
		If($pSQLUSERDBDRIVE -ne "(null)")
		{
		$pSQLUSERDBDIR = $pSQLUSERDBDRIVE+":\"+$pbasefolder+"\Data"
		$pINSTALLSQLDATADIR = $pSQLUSERDBDRIVE+":\"+$pbasefolder
		if(Test-Path $pSQLUSERDBDIR)
		{Write-Host -ForegroundColor Cyan "[Module 2.1]:SQL User Database Data Folder [$pSQLUSERDBDIR] Already Exists"
		 $perrorlog = $perrorlog + "[Module 2.1]:SQL User Database Data Folder [$pSQLUSERDBDIR] Already Exists"+"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pSQLUSERDBDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.1]Error Creating [$pSQLUSERDBDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.1]Error Creating [$pSQLUSERDBDIR]:" +$_.Exception.Message+"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_1 = 1
				}
				if($pmod2_1 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.1]:SQL User Database Data Folder [$pSQLUSERDBDIR] Created"
				$perrorlog = $perrorlog + "[Module 2.1]:SQL User Database Data Folder [$pSQLUSERDBDIR] Created" +"`n`r`n`r"
				}
			}
		}
		<#END [Module 2.1]:Check SQL UserDB Data Folder#>
		
		<#START [Module 2.2]:Check SQL UserDB Log Folder#>
		If($pSQLUSERLOGDRIVE -ne "(null)")
		{
		$pSQLUSERDBLOGDIR = $pSQLUSERLOGDRIVE+":\"+$pbasefolder+"\TLog"
		if(Test-Path $pSQLUSERDBLOGDIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.2]:SQL User Database TLog Folder [$pSQLUSERDBLOGDIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.2]:SQL User Database TLog Folder [$pSQLUSERDBLOGDIR] Already Exists" +"`n`r`n`r" 
		}
		else{	
				Try
				{
					New-Item -Path $pSQLUSERDBLOGDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.2]Error Creating [$pSQLUSERDBLOGDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.2]Error Creating [$pSQLUSERDBLOGDIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_2 = 1
				}
				if($pmod2_2 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.2]:SQL User Database TLog Folder [$pSQLUSERDBLOGDIR] Created"
				$perrorlog = $perrorlog + "[Module 2.2]:SQL User Database TLog Folder [$pSQLUSERDBLOGDIR] Created" +"`n`r`n`r" 
				}
			}
		}
		<#END [Module 2.2]:Check SQL UserDB Log Folder#>
		
		<#START [Module 2.3]:Check SQL Backup Folder#>
		If($pSQLBACKUPDRIVE -ne "(null)")
		{
		$pSQLBACKUPDIR = $pSQLBACKUPDRIVE+":\"+$pbasefolder+"\Backup"
		if(Test-Path $pSQLBACKUPDIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.3]:SQLBackup Folder [$pSQLBACKUPDIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.3]:SQLBackup Folder [$pSQLBACKUPDIR] Already Exists" +"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pSQLBACKUPDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.3]Error Creating [$pSQLBACKUPDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.3]Error Creating [$pSQLBACKUPDIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_3 = 1
				}
				if($pmod2_3 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.3]:SQL Backup Folder [$pSQLBACKUPDIR] Created"
				$perrorlog = $perrorlog + "[Module 2.3]:SQL Backup Folder [$pSQLBACKUPDIR] Created" +"`n`r`n`r"
				}
			}
		}
		<#END [Module 2.3]:Check SQL Backup Folder#>
		
		<#START [Module 2.4]:Check SQL TempDB data Folder#>
		If($pSQLTEMPDBDATADRIVE -ne "(null)")
		{
		$pSQLTEMPDBDIR = $pSQLTEMPDBDATADRIVE+":\"+$pbasefolder+"\Data"
		if(Test-Path $pSQLTEMPDBDIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.4]:SQL TempDB data Folder [$pSQLTEMPDBDIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.4]:SQL TempDB data Folder [$pSQLTEMPDBDIR] Already Exists" +"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pSQLTEMPDBDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.4]Error Creating [$pSQLTEMPDBDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.4]Error Creating [$pSQLTEMPDBDIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_4 = 1
				}
				if($pmod2_4 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.4]:SQL TempDB data Folder [$pSQLTEMPDBDIR] Created"
				$perrorlog = $perrorlog + "[Module 2.4]:SQL TempDB data Folder [$pSQLTEMPDBDIR] Created" +"`n`r`n`r"
				}
			}
		}
		<#END [Module 2.4]:Check SQL TempDB data Folder#>
		}
		
		#Create AS Folder if AS Install is enabled
		if($pASINSTALL -eq "TRUE")
		{
		<##START [Module 2.5]:Check AS Log Folder#>
		If($pASLOGDRIVE -ne "(null)")
		{
		$pASLOGDIR = $pASLOGDRIVE+":\"+$pbasefolder+"\OLAPLog"
		if(Test-Path $pASLOGDIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.5]:SQL AS Log Folder [$pASLOGDIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.5]:SQL AS Log Folder [$pASLOGDIR] Already Exists" +"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pASLOGDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.5]Error Creating [$pASLOGDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.5]Error Creating [$pASLOGDIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_5 = 1
				}
				if($pmod2_5 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.5]:SQL AS Log Folder [$pASLOGDIR] Created"
				$perrorlog = $perrorlog + "[Module 2.5]:SQL AS Log Folder [$pASLOGDIR] Created" +"`n`r`n`r"
				}
			}
		}
		<##END [Module 2.5]:Check AS Log Folder#>
		
		<#START [Module 2.6]:Check AS Data Folder#>
		If($pASDATADRIVE -ne "(null)")
		{
		$pASDATADIR = $pASDATADRIVE+":\"+$pbasefolder+"\OLAPData"
		if(Test-Path $pASDATADIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.6]:SQL AS Data Folder [$pASDATADIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.6]:SQL AS Data Folder [$pASDATADIR] Already Exists" +"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pASDATADIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.6]Error Creating [$pASDATADIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.6]Error Creating [$pASDATADIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_6 = 1
				}
				if($pmod2_6 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.6]:SQL AS Data Folder [$pASDATADIR] Created"
				$perrorlog = $perrorlog + "[Module 2.6]:SQL AS Data Folder [$pASDATADIR] Created" +"`n`r`n`r"
				}
			}
		}
		<#END [Module 2.6]:Check AS Data Folder#>
		
		<#START [Module 2.7]:Check AS Backup Folder#>
		If($pASBACKUPDRIVE -ne "(null)")
		{
		$pASBACKUPDIR = $pASBACKUPDRIVE+":\"+$pbasefolder+"\OLAPBackup"
		if(Test-Path $pASBACKUPDIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.7]:SQL AS Backup Folder [$pASBACKUPDIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.7]:SQL AS Backup Folder [$pASBACKUPDIR] Already Exists" +"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pASBACKUPDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.7]Error Creating [$pASBACKUPDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.7]Error Creating [$pASBACKUPDIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_7 = 1
				}
				if($pmod2_7 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.7]:SQL AS Backup Folder [$pASBACKUPDIR] Created"
				$perrorlog = $perrorlog + "[Module 2.7]:SQL AS Backup Folder [$pASBACKUPDIR] Created" +"`n`r`n`r"
				}
			}
		}
		<#END [Module 2.7]:Check AS Backup Folder#>
		
		<#START [Module 2.8]:Check AS Temp Folder#>
		If($pASTEMPDRIVE -ne "(null)")
		{
		$pASTEMPDIR = $pASTEMPDRIVE+":\"+$pbasefolder+"\OLAPTemp"
		if(Test-Path $pASTEMPDIR)
		{
			Write-Host -ForegroundColor Cyan "[Module 2.8]:SQL AS Temp Folder [$pASTEMPDIR] Already Exists"
			$perrorlog = $perrorlog + "[Module 2.8]:SQL AS Temp Folder [$pASTEMPDIR] Already Exists" +"`n`r`n`r"
		}
		else{	
				Try
				{
					New-Item -Path $pASTEMPDIR -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[Module 2.8]Error Creating [$pASTEMPDIR]:"$_.Exception.Message
					$perrorlog = $perrorlog + "[Module 2.8]Error Creating [$pASTEMPDIR]:"+ $_.Exception.Message +"`n`r`n`r" 
					$pmod_error = 1
					$pmod2_8 = 1
				}
				if($pmod2_8 -eq 0)
				{
				Write-Host -ForegroundColor Cyan "[Module 2.8]:SQL AS Temp Folder Folder - $pASTEMPDIR Created"
				$perrorlog = $perrorlog + "[Module 2.8]:SQL AS Temp Folder Folder - $pASTEMPDIR Created" +"`n`r`n`r"
				}
			}
		}
		<#END [Module 2.8]:Check AS Temp Folder#>
		}
		
		$pSQLInstallFolders = ($pINSTALLSQLDATADIR,$pSQLUSERDBDIR,$pSQLUSERDBLOGDIR,$pSQLBACKUPDIR,$pSQLTEMPDBDIR,$pASLOGDIR,$pASDATADIR,$pASBACKUPDIR,$pASTEMPDIR,$pmod_error,$perrorlog)
		Return ,$pSQLInstallFolders

}
<#*************************END:Function to Create SQL Server Install Folders(Pre-Install)*******************************************#>

<#*********************************START:Function to Create the Install Configuration File******************************************#>
Function CreateConfig($cSQLInstallFolders,$cCreateConfigArray)
{
		Try
		{
		$cAction = $cCreateConfigArray[0]
		$cSQLVERSION = $cCreateConfigArray[1]
		$cINSTANCE_NAME = $cCreateConfigArray[2]
		$cSQLINSTALL = $cCreateConfigArray[3]
		$cASINSTALL = $cCreateConfigArray[4]
		$cRSINSTALL = $cCreateConfigArray[5]
		$cISINSTALL = $cCreateConfigArray[6]
		$cSQLSVCACCT = $cCreateConfigArray[7]
		$cSQLSVCPWD = $cCreateConfigArray[8]
		$cSQLCOLLATION = $cCreateConfigArray[9]
		$cSQLSYSADMINACCOUNTS = $cCreateConfigArray[10]
		$cSQLSVCSTARTUPTYPE = $cCreateConfigArray[11]
		$cSAPWD = $cCreateConfigArray[12]
		$cSECURITYMODE = $cCreateConfigArray[13]
		$cASSVCACCT = $cCreateConfigArray[14]
		$cASSVCPWD = $cCreateConfigArray[15]
		$cASCOLLATION = $cCreateConfigArray[16]
		$cASSYSADMINACCOUNTS = $cCreateConfigArray[17]
		$cASSERVERMODE = $cCreateConfigArray[18]
		$cASSVCSTARTUPTYPE = $cCreateConfigArray[19]
		$cISAVCACCT = $cCreateConfigArray[20]
		$cISSVCPWD = $cCreateConfigArray[21]
		$cISSVCSTARTUPTYPE = $cCreateConfigArray[22]
		$cRSSVCACCT = $cCreateConfigArray[23]
		$cRSSVCPWD = $cCreateConfigArray[24]
		$cFAILOVERCLUSTERDISKS = $cCreateConfigArray[25]
		$cFAILOVERCLUSTERGROUP = $cCreateConfigArray[26]
		$cFAILOVERCLUSTERIPADDRESSES = $cCreateConfigArray[27]
		$cFAILOVERCLUSTERNETWORKNAME = $cCreateConfigArray[28]
		$cFEATURES = $cCreateConfigArray[29]
		
		<#Create the SQL Install Configuration File#>
		Switch ($cAction)
		{
			#Create Configuration File for Stand-Alone SQL Server Install 
			"Install" {
		 			 	$cConfigFile_Install = ";SQL Server StandAlone Install Configuration File"
						if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[OPTIONS]"}elseif($cSQLVERSION -eq "SQL2008"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[SQLSERVER2008]"}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"IACCEPTSQLSERVERLICENSETERMS="+'"True"'+"`r`n"+"ACTION="+'"Install"'+"`r`n"+"ENU="+'"True"'+"`r`n"+"QUIET="+'"True"' 
						if($cFEATURES-ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FEATURES="+$cFEATURES}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"HELP="+'"False"'+"`r`n"+"INDICATEPROGRESS="+'"False"'+"`r`n"+"INSTALLSHAREDDIR="+'"C:\Program Files\Microsoft SQL Server"'
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTALLSHAREDWOWDIR="+'"C:\Program Files (x86)\Microsoft SQL Server"'
						#Instance name included only for DB,AS or RS install
						if(($cSQLINSTALL -eq "TRUE") -or ($cASINSTALL -eq "TRUE") -or ($cRSINSTALL -eq "TRUE"))
						{
						if($cINSTANCE_NAME -eq "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+"MSSQLSERVER"+'"'}else{$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+$cINSTANCE_NAME+'"'}
						}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQMREPORTING="+'"False"'+"`r`n"+"ERRORREPORTING="+'"False"'+"`r`n"+"INSTANCEDIR="+'"C:\Program Files\Microsoft SQL Server"'
						if($cSQLINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server DB Engine Configuration Details******"
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"BROWSERSVCSTARTUPTYPE="+'"'+"Manual"
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLSVCSTARTUPTYPE="+'"'+"Automatic"+'"'+"`r`n"+"AGTSVCSTARTUPTYPE="+'"'+"Automatic"+'"'+"`r`n"+"FILESTREAMLEVEL="+'"'+"0"+'"'+"`r`n"+"SECURITYMODE="+'"'+"SQL"+'"'+"`r`n"+"TCPENABLED="+'"'+"1"+'"'+"`r`n"+"NPENABLED="+'"'+"1"+'"'
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SAPWD="+'"'+$cSAPWD+'"'
						if($cSQLBACKUPDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLBACKUPDIR="+'"'+$cSQLInstallFolders[3]+'"'}
						if($cSQLUSERDBDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLUSERDBDIR="+'"'+$cSQLInstallFolders[1]+'"'+"`r`n"+"INSTALLSQLDATADIR="+'"'+$cSQLInstallFolders[1]+'"'}
						if($cSQLUSERLOGDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLUSERDBLOGDIR="+'"'+$cSQLInstallFolders[2]+'"'+"`r`n"+"SQLTEMPDBLOGDIR="+'"'+$cSQLInstallFolders[2]+'"'}
						if($cSQLTEMPDBDATADRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLTEMPDBDIR="+'"'+$cSQLInstallFolders[4]+'"'}
						if($cSQLCOLLATION -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLCOLLATION="+'"'+$cSQLCOLLATION+'"'}
						if($cSQLSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLSVCACCOUNT="+'"'+$cSQLSVCACCT+'"'+"`r`n"+"SQLSVCPASSWORD="+'"'+$cSQLSVCPWD+'"'
													 $cConfigFile_Install = $cConfigFile_Install+"`r`n"+"AGTSVCACCOUNT="+'"'+$cSQLSVCACCT+'"'+"`r`n"+"AGTSVCPASSWORD="+'"'+$cSQLSVCPWD+'"'
													}
						if($cSQLSYSADMINACCOUNTS -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLSYSADMINACCOUNTS="+'"'+$cSQLSYSADMINACCOUNTS+'"'}
						}
						if($cASINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server Analysis Services Configuration Details******"
						if(($cSQLVERSION -eq "SQL2012") -and ($cASSERVERMODE -ne "(null)")){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+"ASSERVERMODE="+'"'+$cASSERVERMODE+'"'}
						if($cASCOLLATION -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASCOLLATION="+'"'+$cASCOLLATION+'"'}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASSVCSTARTUPTYPE="+'"'+"Automatic"+'"'+"`r`n"+"ASPROVIDERMSOLAP="+'"'+"1"+'"'
						if($cASSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASSVCACCOUNT="+'"'+$cASSVCACCT+'"'+"`r`n"+"ASSVCPASSWORD="+'"'+$cASSVCPWD+'"'}
						if($cASSYSADMINACCOUNTS -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASSYSADMINACCOUNTS="+'"'+$cASSYSADMINACCOUNTS+'"'}
						if($cASDATADRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASDATADIR="+'"'+$cSQLInstallFolders[6]+'"'}
						if($cASLOGDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASLOGDIR="+'"'+$cSQLInstallFolders[5]+'"'}
						if($cASBACKUPDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASBACKUPDIR="+'"'+$cSQLInstallFolders[7]+'"'}
						if($cASTEMPDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASTEMPDIR="+'"'+$cSQLInstallFolders[8]+'"'}
						if($cASDATADRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASCONFIGDIR="+'"'+$cSQLInstallFolders[6]+'"'}
						}
						if($cISINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server IS Services Configuration Details******"
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ISSVCSTARTUPTYPE="+'"'+"Automatic"+'"'
						if($cISAVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ISSVCACCOUNT="+'"'+$cISAVCACCT+'"'+"`r`n"+"ISSVCPASSWORD="+'"'+$cISSVCPWD+'"'}
						}
						if($cRSINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server RS Services Configuration Details******"
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"RSSVCStartupType="+'"'+"Automatic"+'"'
						if($cRSSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"RSSVCACCOUNT="+'"'+$cRSSVCACCT+'"'+"`r`n"+"RSSVCPASSWORD="+'"'+$cRSSVCPWD+'"'}
						}
					  }
			#Create Configuration File for SQL Server Cluster Install-Build Cluster
			"InstallFailoverCluster" {
						$cConfigFile_Install = ";SQL Server Cluster Install Configuration File"
						if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[OPTIONS]"}elseif($cSQLVERSION -eq "SQL2008"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[SQLSERVER2008]"}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"IACCEPTSQLSERVERLICENSETERMS="+'"True"'+"`r`n"+"ACTION="+'"InstallFailoverCluster"'+"`r`n"+"ENU="+'"True"'+"`r`n"+"QUIET="+'"True"' 
						if($cFEATURES-ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FEATURES="+$cFEATURES}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"HELP="+'"False"'+"`r`n"+"INDICATEPROGRESS="+'"False"'+"`r`n"+"INSTALLSHAREDDIR="+'"C:\Program Files\Microsoft SQL Server"'
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTALLSHAREDWOWDIR="+'"C:\Program Files (x86)\Microsoft SQL Server"'
						#Instance name included only for DB,AS or RS install
						if(($cSQLINSTALL -eq "TRUE") -or ($cASINSTALL -eq "TRUE") -or ($cRSINSTALL -eq "TRUE"))
						{
						if($cINSTANCE_NAME -eq "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+"MSSQLSERVER"+'"'}else{$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+$cINSTANCE_NAME+'"'}
						}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQMREPORTING="+'"False"'+"`r`n"+"ERRORREPORTING="+'"False"'+"`r`n"+"INSTANCEDIR="+'"C:\Program Files\Microsoft SQL Server"'
						if($cSQLINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server DB Engine Configuration Details******"
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FILESTREAMLEVEL="+'"'+"0"+'"'+"`r`n"+"SECURITYMODE="+'"'+"SQL"+'"'
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SAPWD="+'"'+$cSAPWD+'"'
						if($cSQLBACKUPDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLBACKUPDIR="+'"'+$cSQLInstallFolders[3]+'"'}
						if($cSQLUSERDBDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLUSERDBDIR="+'"'+$cSQLInstallFolders[1]+'"'+"`r`n"+"INSTALLSQLDATADIR="+'"'+$cSQLInstallFolders[1]+'"'}
						if($cSQLUSERLOGDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLUSERDBLOGDIR="+'"'+$cSQLInstallFolders[2]+'"'+"`r`n"+"SQLTEMPDBLOGDIR="+'"'+$cSQLInstallFolders[2]+'"'}
						if($cSQLTEMPDBDATADRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLTEMPDBDIR="+'"'+$cSQLInstallFolders[4]+'"'}
						if($cSQLCOLLATION -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLCOLLATION="+'"'+$cSQLCOLLATION+'"'}
						if($cSQLSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLSVCACCOUNT="+'"'+$cSQLSVCACCT+'"'+"`r`n"+"SQLSVCPASSWORD="+'"'+$cSQLSVCPWD+'"'
													 $cConfigFile_Install = $cConfigFile_Install+"`r`n"+"AGTSVCACCOUNT="+'"'+$cSQLSVCACCT+'"'+"`r`n"+"AGTSVCPASSWORD="+'"'+$cSQLSVCPWD+'"'
													}
						if($cSQLSYSADMINACCOUNTS -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLSYSADMINACCOUNTS="+'"'+$cSQLSYSADMINACCOUNTS+'"'}
						}
						if($cASINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server Analysis Services Configuration Details******"
						if(($cSQLVERSION -eq "SQL2012") -and ($cASSERVERMODE -ne "(null)")){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+"ASSERVERMODE="+'"'+$cASSERVERMODE+'"'}
						if($cASCOLLATION -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASCOLLATION="+'"'+$cASCOLLATION+'"'}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASPROVIDERMSOLAP="+'"'+"1"+'"'
						if($cASSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASSVCACCOUNT="+'"'+$cASSVCACCT+'"'+"`r`n"+"ASSVCPASSWORD="+'"'+$cASSVCPWD+'"'}
						if($cASSYSADMINACCOUNTS -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASSYSADMINACCOUNTS="+'"'+$cASSYSADMINACCOUNTS+'"'}
						if($cASDATADRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASDATADIR="+'"'+$cSQLInstallFolders[6]+'"'}
						if($cASLOGDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASLOGDIR="+'"'+$cSQLInstallFolders[5]+'"'}
						if($cASBACKUPDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASBACKUPDIR="+'"'+$cSQLInstallFolders[7]+'"'}
						if($cASTEMPDRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASTEMPDIR="+'"'+$cSQLInstallFolders[8]+'"'}
						if($cASDATADRIVE -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASCONFIGDIR="+'"'+$cSQLInstallFolders[6]+'"'}
						}
						if($cISINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server IS Services Configuration Details******"
						if($cISAVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ISSVCACCOUNT="+'"'+$cISAVCACCT+'"'+"`r`n"+"ISSVCPASSWORD="+'"'+$cISSVCPWD+'"'}
						}
						if($cRSINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server RS Services Configuration Details******"
						if($cRSSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"RSSVCACCOUNT="+'"'+$cRSSVCACCT+'"'+"`r`n"+"RSSVCPASSWORD="+'"'+$cRSSVCPWD+'"'}
						}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server Cluster Configuration Details******"
						if($cFAILOVERCLUSTERDISKS -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERDISKS="+$cFAILOVERCLUSTERDISKS}
						if($cFAILOVERCLUSTERGROUP -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERGROUP="+'"'+$cFAILOVERCLUSTERGROUP+'"'}
						if($cFAILOVERCLUSTERIPADDRESSES -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERIPADDRESSES="+'"'+$cFAILOVERCLUSTERIPADDRESSES+'"'}
						if($cFAILOVERCLUSTERNETWORKNAME -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERNETWORKNAME="+$cFAILOVERCLUSTERNETWORKNAME}
					  }
			#Create Configuration File for SQL Server Cluster Install-AddNode 
			"AddNode" {
						$cConfigFile_Install = ";SQL Server Cluster AddNode Configuration File"
						if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[OPTIONS]"}elseif($cSQLVERSION -eq "SQL2008"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[SQLSERVER2008]"}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"IACCEPTSQLSERVERLICENSETERMS="+'"True"'+"`r`n"+"ACTION="+'"AddNode"'+"`r`n"+"ENU="+'"True"'+"`r`n"+"QUIET="+'"True"' 
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"HELP="+'"False"'+"`r`n"+"INDICATEPROGRESS="+'"False"'
						if(($cSQLINSTALL -eq "TRUE") -or ($cASINSTALL -eq "TRUE") -or ($cRSINSTALL -eq "TRUE"))
						{if($cINSTANCE_NAME -eq "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+"MSSQLSERVER"+'"'}else{$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+$cINSTANCE_NAME+'"'}}
						if($cSQLINSTALL -eq "TRUE")
						{
						if($cSQLSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"SQLSVCACCOUNT="+'"'+$cSQLSVCACCT+'"'+"`r`n"+"SQLSVCPASSWORD="+'"'+$cSQLSVCPWD+'"'
													 $cConfigFile_Install = $cConfigFile_Install+"`r`n"+"AGTSVCACCOUNT="+'"'+$cSQLSVCACCT+'"'+"`r`n"+"AGTSVCPASSWORD="+'"'+$cSQLSVCPWD+'"'
													}
						}
						if($cISINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server IS Services Configuration Details******"
						if($cISSVCPWD -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ISSVCPASSWORD="+'"'+$cISSVCPWD+'"'}
						}
						if($cRSINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server RS Services Configuration Details******"
						if($cRSSVCPWD -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"RSSVCPASSWORD="+'"'+$cRSSVCPWD+'"'}
						}
						if($cASINSTALL -eq "TRUE")
						{
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server Analysis Services Configuration Details******"
						if($cASSVCACCT -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"ASSVCACCOUNT="+'"'+$cASSVCACCT+'"'+"`r`n"+"ASSVCPASSWORD="+'"'+$cASSVCPWD+'"'}
						}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server Cluster Configuration Details******"
						if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+"CONFIRMIPDEPENDENCYCHANGE="+'"'+"FALSE"+'"'}
						if($cFAILOVERCLUSTERGROUP -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERGROUP="+'"'+$cFAILOVERCLUSTERGROUP+'"'}
						if($cFAILOVERCLUSTERNETWORKNAME -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERNETWORKNAME="+$cFAILOVERCLUSTERNETWORKNAME}
					  }
			#Create Configuration File to remove a Node from a SQL Cluster
			"RemoveNode"{
						 $cConfigFile_Install = ";SQL Server Cluster RemoveNode Configuration File"
						 if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[OPTIONS]"}elseif($cSQLVERSION -eq "SQL2008"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[SQLSERVER2008]"}
						 $cConfigFile_Install = $cConfigFile_Install+"`r`n"+"IACCEPTSQLSERVERLICENSETERMS="+'"True"'+"`r`n"+"ACTION="+'"RemoveNode"'+"`r`n"+"ENU="+'"True"'+"`r`n"+"QUIET="+'"True"' 
						 $cConfigFile_Install = $cConfigFile_Install+"`r`n"+"HELP="+'"False"'+"`r`n"+"INDICATEPROGRESS="+'"False"'
						 if($cINSTANCE_NAME -eq "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+"MSSQLSERVER"+'"'}else{$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+$cINSTANCE_NAME+'"'}
						 $cConfigFile_Install = $cConfigFile_Install+"`r`n"+";******SQL Server Cluster Configuration Details******"
						 if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+"CONFIRMIPDEPENDENCYCHANGE="+'"'+"FALSE"+'"'}
						 if($cFAILOVERCLUSTERNETWORKNAME -ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FAILOVERCLUSTERNETWORKNAME="+$cFAILOVERCLUSTERNETWORKNAME}
					  }
			#Create Configuration File to Uninstall SQL Server Components
			"Uninstall"{
						$cConfigFile_Install = ";SQL Server Uninstall Configuration File"
						if($cSQLVERSION -eq "SQL2012"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[OPTIONS]"}elseif($cSQLVERSION -eq "SQL2008"){$cConfigFile_Install = $cConfigFile_Install +"`r`n"+ "[SQLSERVER2008]"}
						$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"IACCEPTSQLSERVERLICENSETERMS="+'"True"'+"`r`n"+"ACTION="+'"Uninstall"'+"`r`n"+"ENU="+'"True"'+"`r`n"+"QUIET="+'"True"' 
						if($cFEATURES-ne "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"FEATURES="+$cFEATURES}
						#Instance name included only for DB,AS or RS install
						if(($cSQLINSTALL -eq "TRUE") -or ($cASINSTALL -eq "TRUE") -or ($cRSINSTALL -eq "TRUE"))
						{
						if($cINSTANCE_NAME -eq "(null)"){$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+"MSSQLSERVER"+'"'}else{$cConfigFile_Install = $cConfigFile_Install+"`r`n"+"INSTANCENAME="+'"'+$cINSTANCE_NAME+'"'}
						}
					  }
		}
		}
		Catch
		{
			Write-Host -ForegroundColor Red "ERROR [Module 2]:"$_.Exception.Message
		}
		#write-host $cConfigFile_Install
		Return $cConfigFile_Install
}
<#*********************************START:Function to Create the Install Configuration File******************************************#>

<#*************************************************START:Main Program***************************************************************#>
<#Command Line Argument Verification#>
if($args.Length -ne 4)
{
Write-Host "Incorrect Paramenter Count use -c to specify the User Input File and use -a to specify the Action" -ForegroundColor Red
$uParameterHelp = "
Help:-
******
  #Parameter 1 :- -c to specify the path of User Input File for the Install
  #Parameter 2 :- -a to Specify the Action of Install; The Value of -a can be only Install, InstallFailoverCluster, AddNode, RemoveNode, Uninstall,PreInstall,PostInstall or Reinstall
  #Example1:- SQLInstall.ps1 -c <User Input File Full UNC Path> -a <Action>
  #Example2:- SQLInstall.ps1 -c c:\SQLAutoInstallConfig.ini -a Install"
Write-Host $uParameterHelp -ForegroundColor Blue
}
<#START:Install MAIN Program#>
elseif((($args[0] -eq "-c") -or ($args[0] -eq "-C")) -and (($args[2] -eq "-a") -or ($args[2] -eq "-A")) -and (($args[3] -eq "Install") -or ($args[3] -eq "InstallFailoverCluster") -or ($args[3] -eq "AddNode") -or ($args[3] -eq "RemoveNode") -or ($args[3] -eq "Uninstall") -or ($args[3] -eq "Reinstall") -or ($args[3] -eq "PreInstall") -or ($args[3] -eq "Postinstall")))
{
		
		<#Get Date#>
		[datetime]$unow = Get-Date
		Write-Host "START[SQL Install Script]: SQL INSTALL PROGRAM MAIN"
		$uerrorlog="START[SQL Install Script]: SQL INSTALL PROGRAM MAIN"+"`n`r`n`r"
		Write-Host "----------------------------"
		$uerrorlog=$uerrorlog+"----------------------------"+"`n`r`n`r" 
		Write-Host "`n"
		$ufilename = $args[1]
		$uAction = $args[3]
		Write-Host "ACTION:$uAction"
		$uerrorlog="ACTION:"+$uAction+"`n`r`n`r`n`r`n`r"
		Write-Host "`n"
		<#*******START [Module 1]:Read user Install Config Input File Module******#>
		
		Write-Host "START [Module 1]: Read User Input File Module"
		$uerrorlog=$uerrorlog+"START [Module 1]: Read User Input File Module"+"`n`r`n`r"
		Try
		{
			$uConfigFile = get-content $ufilename -ErrorAction Stop
			ForEach($uconfig in $uConfigFile)
			{
				if($uconfig -match "(.*)=(.*)")
				{
					$uconfigVal = $uconfig.Split("=")
					#$configVal[0] + '=' + $configVal[1]
					Switch ($uconfigVal[0])
					{
						"SQL_SERVER_NAME" {$uSQL_SERVER_NAME = $uconfigVal[1].Trim()}
						"SQLVERSION" {$uSQLVERSION = $uconfigVal[1].Trim()}
						"INSTANCE_NAME" {$uINSTANCE_NAME = $uconfigVal[1].Trim()}
						"SQLINSTALL" {$uSQLINSTALL = $uconfigVal[1].Trim()}
						"SQLCLIENTINSTALL" {$uSQLCLIENTINSTALL = $uconfigVal[1].Trim()}
						"ASINSTALL" {$uASINSTALL = $uconfigVal[1].Trim()}
						"RSINSTALL" {$uRSINSTALL = $uconfigVal[1].Trim()}
						"ISINSTALL" {$uISINSTALL = $uconfigVal[1].Trim()}
						"DQCINSTALL" {$uDQCINSTALL = $uconfigVal[1].Trim()}
						"MDSINSTALL" {$uMDSINSTALL = $uconfigVal[1].Trim()}
						"SQLUSERDBDRIVE" {$uSQLUSERDBDRIVE = $uconfigVal[1].Trim()}
						"SQLUSERLOGDRIVE" {$uSQLUSERLOGDRIVE = $uconfigVal[1].Trim()}
						"SQLBACKUPDRIVE" {$uSQLBACKUPDRIVE = $uconfigVal[1].Trim()}
						"SQLTEMPDBDATADRIVE" {$uSQLTEMPDBDATADRIVE = $uconfigVal[1].Trim()}
						"SQLTEMPDBLOGDRIVE" {$uSQLTEMPDBLOGDRIVE = $uconfigVal[1].Trim()}
						"SQLSVCACCT" {$uSQLSVCACCT = $uconfigVal[1].Trim()}
						"SQLSVCPWD" {$uSQLSVCPWD = $uconfigVal[1].Trim()}
						"SQLCOLLATION" {$uSQLCOLLATION = $uconfigVal[1].Trim()}
						"SQLSYSADMINACCOUNTS" {$uSQLSYSADMINACCOUNTS = $uconfigVal[1].Trim()}
						"SQLSVCSTARTUPTYPE" {$uSQLSVCSTARTUPTYPE = $uconfigVal[1].Trim()}
						"SAPWD" {$uSAPWD = $uconfigVal[1].Trim()}
						"SECURITYMODE" {$uSECURITYMODE = $uconfigVal[1].Trim()}
						"ASDATADRIVE" {$uASDATADRIVE = $uconfigVal[1].Trim()}
						"ASLOGDRIVE" {$uASLOGDRIVE = $uconfigVal[1].Trim()}
						"ASBACKUPDRIVE" {$uASBACKUPDRIVE = $uconfigVal[1].Trim()}
						"ASTEMPDRIVE" {$uASTEMPDRIVE = $uconfigVal[1].Trim()}
						"ASCONFIGDIRVE" {$uASCONFIGDIRVE = $uconfigVal[1].Trim()}
						"ASSVCACCT" {$uASSVCACCT = $uconfigVal[1].Trim()}
						"ASSVCPWD" {$uASSVCPWD = $uconfigVal[1].Trim()}
						"ASCOLLATION" {$uASCOLLATION = $uconfigVal[1].Trim()}
						"ASSYSADMINACCOUNTS" {$ASSYSADMINACCOUNTS = $uconfigVal[1].Trim()}
						"ASSERVERMODE" {$uASSERVERMODE = $uconfigVal[1].Trim()}
						"ASSVCSTARTUPTYPE" {$uASSVCSTARTUPTYPE = $uconfigVal[1].Trim()}
						"ISAVCACCT" {$uISAVCACCT = $uconfigVal[1].Trim()}
						"ISSVCPWD" {$uISSVCPWD = $uconfigVal[1].Trim()}
						"ISSVCSTARTUPTYPE" {$uISSVCSTARTUPTYPE = $uconfigVal[1].Trim()}
						"RSSVCACCT" {$uRSSVCACCT = $uconfigVal[1].Trim()}
						"RSSVCPWD" {$uRSSVCPWD = $uconfigVal[1].Trim()}
						"FAILOVERCLUSTERDISKS" {$uFAILOVERCLUSTERDISKS = $uconfigVal[1].Trim()}
						"FAILOVERCLUSTERGROUP" {$uFAILOVERCLUSTERGROUP = $uconfigVal[1].Trim()}
						"FAILOVERCLUSTERIPADDRESSES" {$uFAILOVERCLUSTERIPADDRESSES = $uconfigVal[1].Trim()}
						"FAILOVERCLUSTERNETWORKNAME" {$uFAILOVERCLUSTERNETWORKNAME = $uconfigVal[1].Trim()}
						#"SQLINSTALLCONFIGPATH" {$uSQLINSTALLCONFIGPATH = $uconfigVal[1].Trim()}
						"SQLSETUPEXEPATH" {$uSQLSETUPPATH = $uconfigVal[1].Trim()}
						#"SCRIPTOUTPUTLOG" {$uSCRIPTLOG = $uconfigVal[1].Trim()}
						"REINSTALLFILEPATH" {$uREINSTALLFILEPATH = $uconfigVal[1].Trim()}
					}#end Switch
				}
			}
		}
		Catch
		{
			$umod1 = 1
			Write-Host -ForegroundColor Red "ERROR [Module 1]:"$_.Exception.Message
			$uerrorlog=$uerrorlog+"ERROR [Module 1]:"+$_.Exception.Message+"`n`r`n`r"
		}
		Finally
		{
			if($umod1 -eq 0){
								write-host -ForegroundColor DarkGreen "STATUS [Module 1]:SUCCESS"
								$uerrorlog=$uerrorlog+"STATUS [Module 1]:SUCCESS"+"`n`r`n`r"
								Write-Host "END [Module 1]: Read User Input File Module"
								$uerrorlog=$uerrorlog+"END [Module 1]: Read User Input File Module"+"`n`r`n`r`n`r`n`r"
							}else
							 {
							 	write-host -ForegroundColor red "STATUS [Module 1]:FAILED"
								$uerrorlog=$uerrorlog+"STATUS [Module 1]:FAILED"+"`n`r`n`r"
								Write-Host "END [Module 1]: Read User Input File Module"
								$uerrorlog=$uerrorlog+"END [Module 1]: Read User Input File Module"+"`n`r`n`r`n`r`n`r"
								EXIT;
							 }
			
			Write-Host "`n"
		}
		<#*******END [Module 1]:Read user Install Config Input File Module******#>
		<#Check SQL Server Version#>
		if(($uSQLVERSION -ne "SQL2012") -and ($uSQLVERSION -ne "SQL2008"))
		{
			write-host -ForegroundColor red "VERSION CHECK FAILED: SQLVERSION in user Input file need to be either SQL2008 or SQL2012"
			$uerrorlog=$uerrorlog+"VERSION CHECK FAILED: SQLVERSION in user Input file need to be either SQL2008 or SQL2012"+"`n`r`n`r"
			EXIT;
		}
		
		####Form the FEATURES String for Install
		if($uSQLINSTALL -eq "TRUE")
		{
			$ufeaturecnt=1
			$uFEATURES = $uFEATURES+"SQL"
		}
		if($uSQLCLIENTINSTALL -eq "TRUE")
		{
			if($ufeaturecnt -eq 1){$uFEATURES = $uFEATURES+","+"Tools"}else{$uFEATURES = $uFEATURES+"Tools"}
			$ufeaturecnt=1
		}
		if($uASINSTALL -eq "TRUE")
		{
			if($ufeaturecnt -eq 1){$uFEATURES = $uFEATURES+","+"AS"}else{$uFEATURES = $uFEATURES+"AS"}
			$ufeaturecnt=1
		}
		if($uRSINSTALL -eq "TRUE")
		{
			if($ufeaturecnt -eq 1){$uFEATURES = $uFEATURES+","+"RS"}else{$uFEATURES = $uFEATURES+"RS"}
			$ufeaturecnt=1
		}
		if($uISINSTALL -eq "TRUE")
		{
			if($ufeaturecnt -eq 1){$uFEATURES = $uFEATURES+","+"IS"}else{$uFEATURES = $uFEATURES+"IS"}
			$ufeaturecnt=1
		}
		if($uDQCINSTALL -eq "TRUE")
		{
			if($ufeaturecnt -eq 1){$uFEATURES = $uFEATURES+","+"DQC"}else{$uFEATURES = $uFEATURES+"DQC"}
			$ufeaturecnt=1
		}
		if($uMDSINSTALL -eq "TRUE")
		{
			if($ufeaturecnt -eq 1){$uFEATURES = $uFEATURES+","+"MDS"}else{$uFEATURES = $uFEATURES+"MDS"}
			$ufeaturecnt=1
		}
		
		<#Assign base folder name as SQLServer name for default Instance and SQLServername_Instancename for Named instance#>
			if($uINSTANCE_NAME -eq "MSSQLSERVER")
			{
				$ubasefolder = $uSQL_SERVER_NAME 
			}
			else
			{
				$ubasefolder = $uSQL_SERVER_NAME+"_"+$uINSTANCE_NAME
			}

		<#*******START [Module 2] Call Pre-Install Function to run the Pre-Install Scripts(create the SQL Database Directories)******#>
	if(($uAction -eq "Install") -or ($uAction -eq "InstallFailoverCluster") -or ($uAction -eq "PreInstall") )
	{
		Write-Host "START [Module 2]: Call Pre-Install Function"
		$uerrorlog=$uerrorlog+"START [Module 2]: Call Pre-Install Function"+"`n`r`n`r"
		Try
		{
		$uSQLInstallFolders = Pre-SQLInstall $uSQL_SERVER_NAME $uINSTANCE_NAME $ubasefolder $uSQLUSERDBDRIVE $uSQLUSERLOGDRIVE $uSQLBACKUPDRIVE $uSQLTEMPDBDATADRIVE $uSQLTEMPDBLOGDRIVE $uASDATADRIVE $uASLOGDRIVE $uASBACKUPDRIVE $uASTEMPDRIVE $uSQLINSTALL $uASINSTALL
		$uerrorlog=$uerrorlog+$uSQLInstallFolders[10]
		}
		Catch
		{
			$umod2 = 1
			Write-Host -ForegroundColor Red "ERROR [Module 2]:"$_.Exception.Message
			$uerrorlog=$uerrorlog+"ERROR [Module 2]:"+$_.Exception.Message+"`n`r`n`r"
		}
		Finally
		{
			if(($umod2 -eq 0) -and ($uSQLInstallFolders[9] -eq 0)){
								write-host -ForegroundColor DarkGreen "STATUS [Module 2]:SUCCESS"
								$uerrorlog=$uerrorlog+"STATUS [Module 2]:SUCCESS"+"`n`r`n`r"
								Write-Host "END [Module 2]: Call Pre-Install Function"
								$uerrorlog=$uerrorlog+"END [Module 2]: Call Pre-Install Function"+"`n`r`n`r`n`r`n`r"
							}else
							 {
							 	write-host -ForegroundColor red "STATUS [Module 2]:FAILED"
								$uerrorlog=$uerrorlog+"STATUS [Module 2]:FAILED"+"`n`r`n`r"
								Write-Host "END [Module 2]: Call Pre-Install Function"
								$uerrorlog=$uerrorlog+"END [Module 2]: Call Pre-Install Function"+"`n`r`n`r`n`r`n`r"
								EXIT;
							 }
			
			write-host "`n"
		}
	
	$uSQLInstallFolders[10] = $null
	}
		<#END [Module 2] Call Pre-Install Function#>
		
	$ufeaturecnt=0
	
		#create configuration array for CreateConfig Function
		$uCreateConfigArray=($uAction,$uSQLVERSION,$uINSTANCE_NAME,$uSQLINSTALL,$uASINSTALL,$uRSINSTALL,$uISINSTALL,$uSQLSVCACCT,$uSQLSVCPWD,$uSQLCOLLATION,$uSQLSYSADMINACCOUNTS,
		$uSQLSVCSTARTUPTYPE,$uSAPWD,$uSECURITYMODE,$uASSVCACCT,$uASSVCPWD,$uASCOLLATION,$ASSYSADMINACCOUNTS,$uASSERVERMODE,$uASSVCSTARTUPTYPE,$uISAVCACCT,$uISSVCPWD,$uISSVCSTARTUPTYPE,
		$uRSSVCACCT,$uRSSVCPWD,$uFAILOVERCLUSTERDISKS,$uFAILOVERCLUSTERGROUP,$uFAILOVERCLUSTERIPADDRESSES,$uFAILOVERCLUSTERNETWORKNAME,$uFEATURES) 
		
		
		#SQL Server Install Config File Path
		#$uoutinifile = $uSQLINSTALLCONFIGPATH+"\"+$ubasefolder+"_SQL"+$uAction+".ini"
		$uoutinifile = "C:\SQLInstall\"+$ubasefolder+"_SQL"+$uAction+".ini"
		
		#SQL Server Intall file Path 
		$uSQLSetupEXE = $uSQLSETUPPATH+"\setup.exe"
		
		#Internal Use Variable
		$uStartProcessArg = "/ConfigurationFile="+$uoutinifile
		$uStartProcessArg_Reinstall =  "/ConfigurationFile="+$uREINSTALLFILEPATH
		
		#Internal Use Variable
		$utempInstallOutLog = "c:\SQLInstall\temp_"+$ubasefolder+"_SQL"+$uAction+".out"
		#$uInstallOutLog = $uSCRIPTLOG+"\"+$ubasefolder+"_SQL"+$uAction+".out"
		$uInstallOutLog = "c:\SQLInstall\"+$ubasefolder+"_SQL"+$uAction+".out"
		
		#SQL BootStrap Folder SQL Install Log File
		if($uSQLVERSION -eq "SQL2012"){$uSQLBootStrapLog = "C:\Program Files\Microsoft SQL Server\110\Setup Bootstrap\Log\Summary.txt"}
		elseif($uSQLVERSION -eq "SQL2008"){$uSQLBootStrapLog = "C:\Program Files\Microsoft SQL Server\100\Setup Bootstrap\Log\Summary.txt"}
		$uSQLINSTALLCONFIGPATH = "C:\SQLInstall"
		
		#For Add Node Create SQLInstall Folder in C:\ Drive
		if($uAction -eq "AddNode")
		{
		if(Test-Path $uSQLINSTALLCONFIGPATH)
		{
		 Write-Host -ForegroundColor Cyan "[AddNode Folder Creation]:SQL Install Log Folder [$uSQLINSTALLCONFIGPATH] Already Exists"
		 $uerrorlog = $uerrorlog + "[AddNode Folder Creation]:SQL Install Log Folder [$uSQLINSTALLCONFIGPATH] Already Exists"+"`n`r`n`r`n`r`n`r"
		}
		else{
			 
			  Try
				{
					New-Item -Path $uSQLINSTALLCONFIGPATH -ItemType Directory -ErrorAction Stop | Out-Null
				}
				Catch
				{
					Write-Host -ForegroundColor Red "[AddNode Folder Creation]Error Creating [$uSQLINSTALLCONFIGPATH]:"$_.Exception.Message
					$uerrorlog = $uerrorlog + "[AddNode Folder Creation]Error Creating [$uSQLINSTALLCONFIGPATH]:" +$_.Exception.Message+"`n`r`n`r`n`r`n`r" 
					$umod2_1_1 = 1
				}
				Finally
				{
					if ($umod2_1_1 -eq 0)
					{
						Write-Host -ForegroundColor Cyan "[AddNode Folder Creation]:SQL Install Log Folder [$uSQLINSTALLCONFIGPATH] Created"
						$uerrorlog = $uerrorlog + "[AddNode Folder Creation]:SQL Install Log Folder [$uSQLINSTALLCONFIGPATH] Created" +"`n`r`n`r`n`r`n`r"
					}
					else
					{
						write-host -ForegroundColor red "STATUS [AddNode Folder Creation]:FAILED"
						$uerrorlog=$uerrorlog+"STATUS [AddNode Folder Creation]:FAILED"+"`n`r`n`r`n`r`n`r"
						EXIT;
					}
				}
			}	
		}
		
		<#*******START [Module 3]:Call CreateConfig Function to prepare the SQLInstall Configuration File********#>
	if(($uAction -ne "ReInstall") -and ($uAction -ne "PreInstall") -and ($uAction -ne "PostInstall"))
	{
		Write-Host "START [Module 3]: Call CreateConfig Function"
		$uerrorlog=$uerrorlog+"START [Module 3]: Call CreateConfig Function"+"`n`r`n`r"
		Try
		{
		$uConfigFile_Install = CreateConfig $uSQLInstallFolders $uCreateConfigArray
		$uConfigFile_Install|Out-File $uoutinifile
		}
		Catch
		{
			$umod3 = 1
			Write-Host -ForegroundColor Red "ERROR [Module 3]:"$_.Exception.Message
			$uerrorlog=$uerrorlog+"ERROR [Module 3]:"+$_.Exception.Message+"`n`r`n`r"
		}
		Finally
		{
			if($umod3 -eq 0){
								write-host "[Module 3]:SQL Server Install configuration file stored at [$uoutinifile]"
								$uerrorlog=$uerrorlog+"[Module 3]:SQL Server Install Configuration File stored at $uoutinifile"+"`n`r`n`r"
								write-host -ForegroundColor DarkGreen "STATUS [Module 3]:SUCCESS"
								$uerrorlog=$uerrorlog+"STATUS [Module 3]:SUCCESS"+"`n`r`n`r"
								Write-Host "END [Module 3]: Call CreateConfig Function"
								$uerrorlog=$uerrorlog+"END [Module 3]: Call CreateConfig Function"+"`n`r`n`r`n`r`n`r"
							}else
							 {
							 	write-host -ForegroundColor red "STATUS [Module 3]:FAILED"
								$uerrorlog=$uerrorlog+"STATUS [Module 3]:FAILED"+"`n`r`n`r"
								Write-Host "END [Module 3]: Call CreateConfig Function"
								$uerrorlog=$uerrorlog+"END [Module 3]: Call CreateConfig Function"+"`n`r`n`r`n`r`n`r"
								Try
								{
						 				$uerrorlog|out-file $uInstallOutLog
								}
								catch
								{
									Write-host -ForegroundColor Red "ERROR [Module Prepare Script Log]:($uInstallOutLog)"$_.Exception.Message
								}
								EXIT;
							 }
			
			write-host "`n"
		}
		
		<#*******END [Module 3]:Call CreateConfig Function to prepare the SQLInstall Configuration File********#>
		
		<#*******START [Module 4]:Execute SQL Server Setup********#>
		Write-Host "START [Module 4]:Execute SQL Server Setup"
		$uerrorlog=$uerrorlog+"START [Module 4]:Execute SQL Server Setup"+"`n`r`n`r"	
			Try
			{
			<#***************Execute SQL Server Install**********************#>
			Start-Process $uSQLSetupEXE -ArgumentList $uStartProcessArg -Wait -NoNewWindow -RedirectStandardOutput $utempInstallOutLog -ErrorAction Stop
			#Print the console output
			}
			Catch
			{
					$umod4 = 1
					Write-host -ForegroundColor Red "ERROR [Module 4]:"$_.Exception.Message
					$uerrorlog=$uerrorlog + "ERROR [Module 4]:" + $_.Exception.Message + "`n`r`n`r"
					Try
					{
					   $uerrorlog|out-file $uInstallOutLog
					}
					catch
					{
					 Write-host -ForegroundColor Red "ERROR [Module Prepare Script Log]:($uInstallOutLog)"$_.Exception.Message
					}
					EXIT;
			}
			Finally
			{
				Try
				{
					Get-Content $utempInstallOutLog|SELECT $_
					Remove-item $utempInstallOutLog
				}
				Catch
				{
					Write-host -ForegroundColor Red "ERROR [Module Temp Script Log]:($utempInstallOutLog)"$_.Exception.Message
				}
				if($umod4 -eq 0){
									Try
									{
									#Print the SQL BootStrap Folder Log if there is new Log
									foreach ($uSQLBootStrapLog_readline in get-content $uSQLBootStrapLog -ErrorAction Stop)
									{
										if($uSQLBootStrapLog_readline -match "End time:*")
										{
	  										$uenddateVal = $uSQLBootStrapLog_readline.Split(":")
	 								 		[datetime]$ubootstrapdate = $uenddateVal[1].Trim()+":"+$uenddateVal[2].Trim()+":"+$uenddateVal[3].Trim()
	  
										}
										if($uSQLBootStrapLog_readline -match "Requested action:*")
										{
											$ubootstrapstring = $ubootstrapstring + $uSQLBootStrapLog_readline+"`n`r"
											$ubootstrapstring_errorlog = $ubootstrapstring_errorlog + $uSQLBootStrapLog_readline+"`n`r`n`r"
											break
										}
										else
										{
											$ubootstrapstring = $ubootstrapstring + $uSQLBootStrapLog_readline+"`n`r"
											$ubootstrapstring_errorlog = $ubootstrapstring_errorlog + $uSQLBootStrapLog_readline+"`n`r`n`r"
										}
									}
									if($unow -lt $ubootstrapdate){Write-Host $ubootstrapstring;$uerrorlog=$uerrorlog+$ubootstrapstring_errorlog+"`n`r`n`r"}
									}
									catch
									{
										Write-host -ForegroundColor Red "ERROR [Module 4.1]:"$_.Exception.Message
										$uerrorlog=$uerrorlog + "ERROR [Module 4.1]:" + $_.Exception.Message + "`n`r`n`r"
										write-host -ForegroundColor red "STATUS [Module 4.1]:FAILED to Read SQL BootStrap Folder ErrorLog"
										$uerrorlog=$uerrorlog+"STATUS [Module 4.1]:FAILED to Read SQL BootStrap Folder ErrorLog"+"`n`r`n`r"
									}
									write-host -ForegroundColor DarkGreen "STATUS [Module 4]:SQL Setup started Successfully, Check Module 4 Comments for Install Status!"
									$uerrorlog=$uerrorlog+"STATUS [Module 4]:SQL Setup started Successfully, Check Module 4 Comments for Install Status!"+"`n`r`n`r"
									write-host -ForegroundColor DarkGreen "STATUS [Module 4]:SQL Server Install Summary Log located @$uSQLBootStrapLog"
									$uerrorlog=$uerrorlog+"STATUS [Module 4]:SQL Server Install Summary Log located @$uSQLBootStrapLog"+"`n`r`n`r"
									Write-Host "END [Module 4]:Execute SQL Server Setup"
									$uerrorlog=$uerrorlog+"END [Module 4]:Execute SQL Server Setup"+"`n`r`n`r`n`r`n`r"
								}else
							 	{
							 		write-host -ForegroundColor red "STATUS [Module 4]:FAILED"
									$uerrorlog=$uerrorlog+"STATUS [Module 4]:FAILED"+"`n`r`n`r"
									Write-Host "END [Module 4]:Execute SQL Server Setup"
									$uerrorlog=$uerrorlog+"END [Module 4]:Execute SQL Server Setup"+"`n`r`n`r`n`r`n`r"
									Try
									{
						 				$uerrorlog|out-file $uInstallOutLog
									}
									catch
									{
										Write-host -ForegroundColor Red "ERROR [Module Prepare Script Log]:($uInstallOutLog)"$_.Exception.Message
									}
									EXIT;
							 	}
				
				write-host "`n"
			}
			<#*******END [Module 4]:Execute SQL Server Setup********#>	
	}

	<#*******START [Re-Install Module]:Perform SQL Server Install with an already existing Configuration File********#>
	if($uAction -eq "ReInstall")
	{
		Write-Host "START [Re-Install Module]:Execute SQL Server Setup"
		$uerrorlog=$uerrorlog+"START [Re-Install Module]:Execute SQL Server Setup"+"`n`r`n`r"	
		Try
			{
			<#***************Execute SQL Server Install**********************#>
			Start-Process $uSQLSetupEXE -ArgumentList $uStartProcessArg_Reinstall -Wait -NoNewWindow -RedirectStandardOutput $utempInstallOutLog -ErrorAction Stop
			#Print the console output
			}
		Catch
			{
					$umod5 = 1
					Write-host -ForegroundColor Red "ERROR [Re-Install Module]:"$_.Exception.Message
					$uerrorlog=$uerrorlog + "ERROR [Re-Install Module]:" + $_.Exception.Message + "`n`r`n`r"
					Try
					{
						$uerrorlog|out-file $uInstallOutLog
					}
					catch
					{
						Write-host -ForegroundColor Red "ERROR [Module Prepare Script Log]:($uInstallOutLog)"$_.Exception.Message
					}
					EXIT;
			}
		Finally
			{
				Try
				{
				Get-Content $utempInstallOutLog|SELECT $_
				Remove-item $utempInstallOutLog
				}
				Catch
				{
					Write-host -ForegroundColor Red "ERROR [Module Temp Script Log]:($utempInstallOutLog)"$_.Exception.Message
				}
				if($umod5 -eq 0){
									Try
									{
									#Print the SQL BootStrap Folder Log if there is new Log
									foreach ($uSQLBootStrapLog_readline in get-content $uSQLBootStrapLog -ErrorAction Stop)
									{
										if($uSQLBootStrapLog_readline -match "End time:*")
										{
	  										$uenddateVal = $uSQLBootStrapLog_readline.Split(":")
	 								 		[datetime]$ubootstrapdate = $uenddateVal[1].Trim()+":"+$uenddateVal[2].Trim()+":"+$uenddateVal[3].Trim()
	  
										}
										if($uSQLBootStrapLog_readline -match "Requested action:*")
										{
											$ubootstrapstring = $ubootstrapstring + $uSQLBootStrapLog_readline+"`n`r"
											$ubootstrapstring_errorlog = $ubootstrapstring_errorlog + $uSQLBootStrapLog_readline+"`n`r`n`r"
											break
										}
										else
										{
											$ubootstrapstring = $ubootstrapstring + $uSQLBootStrapLog_readline+"`n`r"
											$ubootstrapstring_errorlog = $ubootstrapstring_errorlog + $uSQLBootStrapLog_readline+"`n`r`n`r"
										}
									}
									if($unow -lt $ubootstrapdate){Write-Host $ubootstrapstring;$uerrorlog=$uerrorlog+$ubootstrapstring_errorlog+"`n`r`n`r"}
									}
									catch
									{
										Write-host -ForegroundColor Red "ERROR [Re-Install Module]:"$_.Exception.Message
										$uerrorlog=$uerrorlog + "ERROR [Re-Install Module]:" + $_.Exception.Message + "`n`r`n`r"
										write-host -ForegroundColor red "STATUS [Re-Install Module]:FAILED to Read SQL BootStrap Folder ErrorLog"
										$uerrorlog=$uerrorlog+"STATUS [Re-Install Module]:FAILED to Read SQL BootStrap Folder ErrorLog"+"`n`r`n`r"
									}
										write-host -ForegroundColor DarkGreen "STATUS [Re-Install Module]:SQL Setup started Successfully, Check Module 4 Comments for Install Status!"
										$uerrorlog=$uerrorlog+"STATUS [Re-Install Module]:SQL Setup started Successfully, Check Module 4 Comments for Install Status!"+"`n`r`n`r"
										write-host -ForegroundColor DarkGreen "STATUS [Re-Install Module]:SQL Server Install Summary Log located @$uSQLBootStrapLog"
										$uerrorlog=$uerrorlog+"STATUS [Re-Install Module]:SQL Server Install Summary Log located @$uSQLBootStrapLog"+"`n`r`n`r"
										Write-Host "END [Re-Install Module]:Execute SQL Server Setup"
										$uerrorlog=$uerrorlog+"END [Re-Install Module]:Execute SQL Server Setup"+"``n`r`n`r`n`r`n`r"
								}else
							 	{
							 		write-host -ForegroundColor red "STATUS [Re-Install Module]:FAILED"
									$uerrorlog=$uerrorlog+"STATUS [Re-Install Module]:FAILED"+"`n`r`n`r"
									Write-Host "END [Re-Install Module]:Execute SQL Server Setup"
									$uerrorlog=$uerrorlog+"END [Re-Install Module]:Execute SQL Server Setup"+"`n`r`n`r`n`r`n`r"
									Try
									{
					  					 $uerrorlog|out-file $uInstallOutLog
									}
									catch
									{
					 					Write-host -ForegroundColor Red "ERROR [Module Prepare Script Log]:($uInstallOutLog)"$_.Exception.Message
									}
									EXIT;
							 	}
				
				write-host "`n"
			}
			<#*******END [Re-Install Module]:Execute SQL Server Setup********#>	

	}


	Try
	{
		 $uerrorlog|out-file $uInstallOutLog
	}
	catch
	{
		Write-host -ForegroundColor Red "ERROR [Module Prepare Script Log]:($uInstallOutLog)"$_.Exception.Message
	}
	Write-Host "END[SQLInstall Script]:SQL Install Configuration File for DR and Output Log file of the Script is stored at C:\SQLInstall\ of the server this script was run"

}
<#*************************************************START:Main Program***************************************************************#>
<#InCorrect Command Line Argument#>
else
{
Write-Host "Incorrect Paramenter, use -c to specify the User Input File and use -a to specify the Action;The Value of -a can be only Install, InstallFailoverCluster, AddNode, RemoveNode, Uninstall,PreInstall,PostInstall or Reinstall" -ForegroundColor Red
$uParameterHelp = "
Help:-
******
  #Parameter 1 :- -c to specify the path of User Input File for the Install
  #Parameter 2 :- -a to Specify the Action of Install; The Value of -a can be only Install, InstallFailoverCluster, AddNode, RemoveNode, Uninstall,PreInstall,PostInstall or Reinstall
  #Example1:- SQLInstall.ps1 -c <User Input File Full UNC Path> -a <Action>
  #Example2:- SQLInstall.ps1 -c c:\SQLAutoInstallConfig.ini -a Install"
Write-Host $uParameterHelp -ForegroundColor Blue
}