property theList : {"doc", "docx"}

on run {input, parameters}
	set output to {}
	tell application "Microsoft Word" to set theOldDefaultPath to get default file path file path type documents path
	repeat with x in input
		try
			set theDoc to contents of x
			tell application "Finder"
				set theFilePath to container of theDoc as text
				
				set ext to name extension of theDoc
				if ext is in theList then
					set theName to name of theDoc
					copy length of theName to l
					copy length of ext to exl
					
					set n to l - exl - 1
					copy characters 1 through n of theName as string to theFilename
					
					set theFilename to theFilename & ".pdf"
					
					tell application "Microsoft Word"
						set default file path file path type documents path path theFilePath
						open theDoc
						set theActiveDoc to the active document
						save as theActiveDoc file format format PDF file name theFilename
						copy (POSIX path of (theFilePath & theFilename as string)) to end of output
						close theActiveDoc
					end tell
				end if
			end tell
		end try
	end repeat
	
	set thefirstpage to (POSIX path of (theFilePath & theFilename as string))
	set theShell to ("lpr -P PRINTERNAME -o InputSlot=Tray1 -o page-ranges=1-1 " & quoted form of POSIX path of thefirstpage)
	try
		do shell script theShell
	end try
	
	set theShell to ("lpr -P PRINTERNAME -o InputSlot=Tray3 -o page-ranges=2-999 " & quoted form of POSIX path of thefirstpage)
	try
		do shell script theShell
	end try
	
	set theDel to ("rm -f " & quoted form of POSIX path of thefirstpage)
	try
		do shell script theDel
	end try
	
	tell application "Microsoft Word" to set default file path file path type documents path path theOldDefaultPath
	return output
end run
