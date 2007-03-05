var FindController = null;

function FindController_new()
{
	var fc = new Object();
	fc.fwc = window.FindWindowController;
	fc.playlists = fc.fwc.playlists();
	
	fc.populatePlaylistSelect = function(select)
	{
		var playlistText = '';
		for (var i = 0; i < fc.playlists.length; ++i)
		{
			playlistText += '<option>' + fc.playlists[i] + '</option>';
		}
		Text.fill(select, playlistText);
	};
	
	fc.performSearch = function()
	{
		var results = fc.fwc.resultsForSearch(document.getElementById('searchField').value);
		var resultsText = '';
		for (var i = 0; i < results.length; ++i)
		{
			resultsText += '<ul>' + results[i] + '</ul>';
		}
		Text.fill('searchResultsList', resultsText);
		Util.show('searchResultsContainer');
	};
	
	fc.checkKeyPress = function(event)
	{
		//alert("keypress: " + Util.checkKeyEvent(event));
		if ('return' == Util.checkKeyEvent(event))
		{
			fc.performSearch();
			return true;
		}
		else
		{
			return false;
		}
	};
	
	return fc;
};

function initFind()
{
	FindController = FindController_new();
	FindController.populatePlaylistSelect('playlistSelect');

	var searchField = document.getElementById('searchField');
	Util.addEventToObject(searchField, 'keypress', FindController.checkKeyPress);
	Util.hide('searchResultsContainer');
	searchField.focus();
}
