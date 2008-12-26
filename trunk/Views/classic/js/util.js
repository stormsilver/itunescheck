function Util(){}






/* Visibility stuff */
Util.isVisible = function(obj)
{
	obj = Util.ensureIsObject(obj);
	if (obj.style.display != 'none' && obj.style.visibility != 'hidden')
	{
		return true;
	}
	else
	{
		return false;
	}
}

Util.show = function(obj)
{
	Util.ensureIsObject(obj).style.display = 'block';
};
Util.showHidden = function(obj)
{
	Util.ensureIsObject(obj).style.visibility = 'visible';
};

Util.hide = function(obj)
{
	Util.ensureIsObject(obj).style.display = 'none';
};
Util.hideHidden = function(obj)
{
	Util.ensureIsObject(obj).style.visibility = 'hidden';
};


Util.ensureIsObject = function(thing)
{
	if (typeof(thing) != 'object')
	{
		return document.getElementById(thing);
	}
	else
	{
		return thing;
	}
};







/* Event stuff */
Util.addEventToObject = function(object, event, func)
{
	object = Util.ensureIsObject(object);
	if (object.addEventListener)
		object.addEventListener(event, func, false );
	else if (object.attachEvent)
	{
		object["e"+type+fn] = func;
		object[event+func] = function() { object["e"+event+func]( window.event ); }
		object.attachEvent( "on"+event, object[event+func] );
	}
};
Util.removeEventFromObject = function(object, event, func)
{
	if (object.removeEventListener)
		object.removeEventListener( event, func, false );
	else if (object.detachEvent)
	{
		object.detachEvent( "on"+event, object[event+func] );
		object[event+func] = null;
		object["e"+event+func] = null;
	}
};
Util.setEventForObject = function(object, event, func)
{
	object = Util.ensureIsObject(object);
	object[event] = null;
	object[event] = (typeof object[event] != 'function') ? func : function(){func();};
};

Util.checkKeyEvent = function (e)
{
	var characterCode;
	if (!e)
	{
		e = window.event;
	}
	if (e.which)
	{
		characterCode = e.which;
	}
	else if (e.keyCode)
	{
		characterCode = e.keyCode;
	}
	
	switch (characterCode)
	{
		// Return
		case 13:
			return "return";
			break;
		
		// Escape
		case 27:
			return "escape";
			break;
		
		// Tab
		case 9:
			return "tab";
			break;
	}
};














/* XML stuff */
Util.getElement = function(element, parentElement)
{
	var result = null;
    var children = parentElement.childNodes;
    for (var i=0; i < children.length; ++i)
    {
    	if (children[i].nodeName == element)
    	{
    		result = children[i];
    		break;
    	}
    }
    
    return result;
	//return parentElement.getElementsByTagName(element)[0];
};
Util.getElements = function(element, parentElement)
{
	var result = new Array();
    var children = parentElement.childNodes;
    for (var i=0; i < children.length; ++i)
    {
    	if (children[i].nodeName == element)
    	{
    		result.push(children[i]);
    	}
    }
    
    return result;
};
Util.getElementValue = function(element, parentElement)
{
    //var result = parentElement.getElementsByTagName(element)[0];
    var result = Util.getElement(element, parentElement);
    
    if (result)
    {
    	switch (result.childNodes.length)
        {
        	case 0:
        		return null;
        	
        	case 1:
        		return result.firstChild.nodeValue;
        	
        	default:
        		return result.childNodes[1].nodeValue;
        }
    }
    else 
    {
    	return "";
    }
};
Util.getError = function(req)
{
	if (req.responseXML)
	{
		var error = Util.getElement('error', req.responseXML);
		if (error)
		{
			return Util.getElementValue('errorMessage', error);
		}
		else
		{
			return null;
		}
	}
	else
	{
		alert("Invalid XML response. Server returned:\n" + req.responseText);
		return "Invalid XML response.";
	}
};
Util.isNull = function(req)
{
	if (req.responseXML)
	{
		var n = Util.getElement('null', req.responseXML);
		if (n)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		alert("Invalid XML response. Server returned:\n" + req.responseText);
		return true;
	}
}








/*	Date stuff	*/
Util.formatInputDate = function(obj)
{
	if (obj)
	{
		var date = Date.parseString(obj.value);
		if (date)
		{
			obj.value = date.format('yyyy-MM-dd HH:mm:ss');
		}
		else
		{
			date = Date.parseString(obj.value, 'yyyy-MM-dd HH:mm:ss');
			if (!date)
			{
				alert("Invalid date: " + obj.value);
			}
		}
	}
};

Util.formatOutputDate = function(str)
{
	if (str && str != "0000-00-00 00:00:00")
	{
		var date = Date.parseString(str, 'yyyy-MM-dd HH:mm:ss');
		return date.format('MM/dd/yyyy');
	}
	else
	{
		return '';
	}
};
