function Text(){}



Text.replace = function(text, data)
{
	var rval = text;
	for (i in data)
	{
		var regex = new RegExp('\{\{' + i + '\}\}', 'g');
		rval = rval.replace(regex, data[i]);
	}
	return rval;
};


Text.fill = function(obj, text)
{
	Util.ensureIsObject(obj).innerHTML = text;
}


Text.replaceAndFill = function(obj, text, data)
{
	Text.fill(obj, Text.replace(text, data));
};
