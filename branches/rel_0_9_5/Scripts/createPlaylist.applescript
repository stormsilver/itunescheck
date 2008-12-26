tell application "iTunes"
	set theList to {listValue}
	
	set thePlaylists to every user playlist
	repeat with i from 1 to the count of thePlaylists
		if the name of item i of thePlaylists is "QuickPlay" then
			delete item i of thePlaylists
			set i to the count of thePlaylists
		end if
	end repeat
	
	set thePlaylist to make new playlist
	set the name of thePlaylist to "QuickPlay"
	
	repeat with i from 1 to the count of theList
		if the class of item i of theList is file track then
			if the location of item i of theList is not missing value then
				duplicate item i of theList to thePlaylist
			end if
		else
			duplicate item i of theList to thePlaylist
		end if
	end repeat
	
	set the view of browser window "iTunes" to thePlaylist
	set theResult to search thePlaylist for "songValue artistValue"
	play item 1 of theResult
end tell