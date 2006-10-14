tell application "iTunes"
	set theTrack to replaceValue
	return {the name of theTrack, the artist of theTrack, the album of theTrack, the rating of theTrack}
end tell