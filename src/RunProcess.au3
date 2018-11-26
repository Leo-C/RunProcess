; ===========================================================
; RunProcess: start and stop subprocess at specififed time
;
; Version: 0.95
; Author: Leonardo Cocco
; Last Edit: 18/11/2017
; ===========================================================
;Command line syntax:
; RunProcess <start time> [<stop time>] [/R] <subproc path> [<parameters>]
; in <path> e parameters "$n" is substituted with run number (if process restart)
; Time Format = "YYYY/MM/DD hh:mm:ss"
; /R restart process if stop
#NoTrayIcon

#include <Constants.au3>
#include <Date.au3>


Dim $ret

If $CmdLine[0] < 2 Then
	ConsoleWrite("Syntax: RunProcess <start time> [<stop time>] [/R] <subproc path> [<subproc params>]" & @CRLF)
	ConsoleWrite("  in <path> e <parameters> ""$n"" is substituted with run n. (if process restart)" & @CRLF)
	ConsoleWrite("  Time Format = ""YYYY/MM/DD hh:mm:ss""" & @CRLF)
	ConsoleWrite("  /R restart subprocess if stop" & @CRLF)
	
	$ret = 1
ElseIf $CmdLine[0] = 2 Then
	$ret = RunProc($CmdLine[1], $CmdLine[2], "", False, GetPars(3))
ElseIf $CmdLine[0] = 3 Then
	If $CmdLine[2] = "/R" Then
		$ret = RunProc($CmdLine[1], "", True, $CmdLine[3], GetPars(4))
	Else
		$ret = RunProc($CmdLine[1], $CmdLine[2], False, $CmdLine[3], GetPars(4))
	EndIf
Else
	If $CmdLine[2] = "/R" Then
		$ret = RunProc($CmdLine[1], "", ($CmdLine[2] = "/R"), $CmdLine[3], GetPars(4))
	ElseIf $CmdLine[3] = "/R" Then
		$ret = RunProc($CmdLine[1], $CmdLine[2], True, $CmdLine[4], GetPars(5))
	Else
		$ret = RunProc($CmdLine[1], $CmdLine[2], False, $CmdLine[3], GetPars(4))
	EndIf
EndIf

Exit $ret


;compute and juxtapose parameters of started executable
Func GetPars($cnt_pars)
	Dim $cnt
	Dim $pars
	
	For $cnt = $cnt_pars To $CmdLine[0]
		$pars = $pars & " " & $CmdLine[$cnt]
	Next
	
	Return $pars
EndFunc

Func RunProc($start, $stop, $restart, $cmd, $pars)
	Dim $wait_start, $wait_stop
	Dim $now
	Dim $cnt
	Dim $pid
	Dim $ret
	
	$now = StringFormat("%s/%s/%s %s:%s:%s",@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC)
	$wait_start = _DateDiff("s",$now,$start)
	If $wait_start > 0 Then
		Sleep($wait_start*1000)
	EndIf
	
	
	$ret = 0
	$cnt = 1
	$pid = Run(StringReplace($cmd & $pars,"$n",$cnt), "", @SW_HIDE)
	While True
		If $stop == "" Then
			$ret = ProcessWait($pid)
		Else
			$now = StringFormat("%s/%s/%s %s:%s:%s",@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC)
			$wait_stop = _DateDiff("s",$now,$stop)
			$ret = ProcessWaitClose($pid,$wait_stop)
			If $ret == 0 Then ;timeout
				$ret = ProcessClose($pid)
				ExitLoop
			Else
				$ret = @extended ;exit code of process
			EndIf
		EndIf
		
		If $restart Then
			$cnt = $cnt + 1
			$pid = Run(StringReplace($cmd & $pars,"$n",$cnt), "", @SW_HIDE)
		Else
			ExitLoop
		EndIf
	WEnd
	
	Return $ret
EndFunc
