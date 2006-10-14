tell application "System Events"
	if (get name of every application process) contains "iTunes" then
		tell application "iTunes"
			if player state is playing then
				return the database ID of the current track
			else
				return -2
			end if
		end tell
	else
		return -1
	end if
end tell
