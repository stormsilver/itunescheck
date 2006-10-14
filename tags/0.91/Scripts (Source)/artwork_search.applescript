tell application "iTunes"
	set theTrack to current track
	if class of theTrack is not file track or artworks of theTrack is not {} then
		return the data of front artwork of the current track
	end if
	
	set trackFile to location of theTrack
	
	tell application "Finder"
		set artworkFolder to (the container of file trackFile)
		
		repeat with theFile in (every item of artworkFolder whose name does not start with ".")
			set fileType to the kind of theFile
			if (fileType is "JPEG Image") then
				set file_reference to (open for access (theFile as alias))
				set imageData to read file_reference as data
				close access file_reference
				return imageData
			end if
		end repeat
	end tell
end tell
