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
		var results = fc.fwc.resultsForSearchInPlaylist(document.getElementById('searchField').value, 'SelecTron');
		var resultsText = '';
		for (var i = 0; i < results.length; ++i)
		{
			resultsText += '<tr class="' + (i%2==0?'evenRow':'oddRow') + '"><td>' + results[i][0] + '</td><td>' + results[i][1] + '</td></tr>';
		}
		Text.fill('searchResultsTable', resultsText);
		Util.show('searchResultsContainer');
		fc.fwc.resize();
	};
	
	fc.watchSearchReturnKey = function(event)
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
	
	fc.watchEscapeKey = function(event)
	{
		//alert("keypress: " + Util.checkKeyEvent(event));
		if ('escape' == Util.checkKeyEvent(event))
		{
			fc.fwc.close();
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
	Util.addEventToObject(searchField, 'keypress', FindController.watchSearchReturnKey);
	Util.addEventToObject(document, 'keypress', FindController.watchEscapeKey);
	Util.hide('searchResultsContainer');
	searchField.focus();
}
