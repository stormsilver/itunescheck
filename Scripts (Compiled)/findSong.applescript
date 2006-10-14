tell application "iTunes"
	set the view of browser window "iTunes" to playlistValue
	set res_tracks to search playlistValue for "searchValue"
	set theTracks to {}
	
	if the (count of res_tracks) < 1 then
		return "1"
	else if the (count of res_tracks) is equal to 1 then
		set my_track to item 1 of res_tracks
		if the class of my_track is file track then
			if the location of my_track is missing value then
				return "-1"
			end if
		end if
		play my_track
		return "2"
	else
		repeat with i from 1 to the count of res_tracks
			set the end of theTracks to {the name of item i of res_tracks, the artist of item i of res_tracks, item i of res_tracks}
		end repeat
		return theTracks
	end if
end tell