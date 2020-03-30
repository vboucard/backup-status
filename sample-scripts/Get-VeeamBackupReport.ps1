
<#PSScriptInfo

.VERSION 1.0

.GUID a0c2c3f8-c28c-42dd-bfde-6f541057e0af

.AUTHOR saw-friendship@yandex.ru

.COMPANYNAME 

.COPYRIGHT 

.TAGS saw-friendship Veeam Html Report BackUpJob

.LICENSEURI 

.PROJECTURI https://sawfriendship.wordpress.com/

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Veeam backup job report.
 You can run this script from windows task scheduler and receive html report by Email
 
#> 


[CmdletBinding()]
param(
	[switch]$AsHtml,
	[switch]$SendMail,
	[string]$MailFrom,
	[string]$MailTo,
	[string]$MailSubject = 'VeeamReport',
	[string]$MailServer
	)
	
	if(!(Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue)){
		if((Get-PSSnapin -Registered -Name VeeamPSSnapin -ErrorAction SilentlyContinue)){
			Add-PSSnapin VeeamPSSnapin
		} else {Write-Warning "VeeamPSSnapin not exist"; break}
	}
	
	$join = ' :: '
	
	$Jobs = Get-VBRJob -PipelineVariable Job | % {
		
		try{
			$LastBackup = $job.GetLastBackup()
			$LastBackupStart = [datetime]($LastBackup.LastPointCreationTime)
			$LastBackupEnd = [datetime]($LastBackup.MetaUpdateTime)
			$LastBackupStartString = $LastBackupStart.ToString('yyyy-MM-dd HH:mm:ss')
			$LastBackupEndString = $LastBackupEnd.ToString('yyyy-MM-dd HH:mm:ss')
			if($LastBackupEnd -ge $LastBackupStart){
				$LastBackupDuration = $LastBackupEnd - $LastBackupStart
				$LastBackupDurationString = $LastBackupDuration.ToString('dd\.hh\:mm\:ss')
			}
		}catch{}
		
		[pscustomobject][ordered]@{
			Name = $Job.Name
			LastResult = $job.GetLastResult()
			LastBackupStart = $LastBackupStartString
			LastBackupEnd = $LastBackupEndString
			LastBackupDuration = $LastBackupDurationString
			Object = $Job.GetObjectsInJob().Location -join $join
	
		}
		Remove-Variable LastBackup,LastBackupStart,LastBackupStartString,LastBackupEnd,LastBackupEndString,LastBackupDuration,LastBackupDurationString -ErrorAction SilentlyContinue
		
	} | Sort-Object -Property LastBackupStart -Descending
	
	if(!$AsHtml){
		$OUT = $Jobs
	} else {
	$HtmlHead = @"
	<style type="text/css">
	table {border-collapse: collapse; width:100%;}
	th {border: 1px solid black; background-color:black; color:white;}
	td {border: 1px solid black;}
	</style>
"@
	$PreContent = @"
	<table bgcolor=54b948 color=fffafa><tr><td>
	<h1>Veeam Report</h1>
	<h2>
	Job Success: $(($Jobs | ? {$_.LastResult -eq 'Success'}).count)<br>
	Job Warning: $(($Jobs | ? {$_.LastResult -eq 'Warning'}).count)<br>
	Job Failed: $(($Jobs | ? {$_.LastResult -eq 'Failed'}).count)<br>
	Job None: $(($Jobs | ? {$_.LastResult -eq 'None'}).count)<br>
	</h2></tr></td></table><br>
"@
	
		$OUT = $Jobs | ConvertTo-Html -Head $HtmlHead -PreContent $PreContent
		$OUT = $OUT -replace @($join,'<br>')
		$OUT = $OUT -replace @('<table>','<table>')
		$OUT = $OUT -replace @('<td>Success</td>','<td bgcolor=54b948>Success</td>')
		$OUT = $OUT -replace @('<td>Warning</td>','<td bgcolor=ffd700>Warning</td>')
		$OUT = $OUT -replace @('<td>Failed</td>','<td bgcolor=e66761>Failed</td>')
		$OUT = $OUT -replace @('<td>None</td>','<td bgcolor=fffafa>None</td>')
	}
	
	if($SendMail){
		Send-MailMessage -Encoding utf8 -Body ($OUT | Out-String) -BodyAsHtml -To $MailTo -From $MailFrom -Subject $MailSubject -SmtpServer $MailServer
	} else {
		$OUT
	}
	