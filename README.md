## **RunProcess**


### Introduction

**RunProcess** is a simple batch / CLI tool to execute a commands at specified time.  


### Installation

*RunProcess* must only be copied in destination directory


### CLI Options

Syntax is following:   
`RunProcess <start time> [<stop time>] [/R] <subproc path> [<parameters>]`  
with following options:  

* *<start time\>* is absolute time of start of subprocess; if *<stop time\>* is specified, subprocess is stopped at specified time (if not finished). Format is: *"YYYY/MM/DD hh:mm:ss"*
* */R* restart subprocess if stop
* *<subproc path\>* is subcommand to execute at specified time, optionally followed by its parameters
* in <subproc path\> and <parameters\>, "$n" is substituted with run number (incremented if process restart)
