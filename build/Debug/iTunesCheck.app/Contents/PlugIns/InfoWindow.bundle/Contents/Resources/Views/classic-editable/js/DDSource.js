
(function() {

var Dom = YAHOO.util.Dom;
var Event = YAHOO.util.Event;
var DDM = YAHOO.util.DragDropMgr;

YAHOO.example.DDSource = function(id, sGroup, config) {

    if (id) {
        this.init(id, sGroup, config);
        this.initFrame();
        this.logger = this.logger || YAHOO;
    }

    var el = this.getDragEl();
    Dom.setStyle(el, "opacity", 0.67);

    this.setPadding(-4);
    this.goingUp = false;
    this.lastY = 0;
    this.deleted = false;
    this.selfHealed = 0;
    this.shouldAnimateBack = false;
};

YAHOO.extend(YAHOO.example.DDSource, YAHOO.util.DDProxy, {

    startDrag: function(x, y) {
        
        this.addToGroup("activeTags");
        this.removeFromGroup("inactiveTags");
        
        //this.logger.log(this.id + " startDrag");

        var dragEl = this.getDragEl();
        var clickEl = this.getEl();
        //Dom.setStyle(clickEl, "visibility", "hidden");
		var body = Dom.get("body");
        dragEl.innerHTML = clickEl.innerHTML;
        dragEl.className = body.className;

        Dom.setStyle(dragEl, "color", Dom.getStyle(body, "color"));
        Dom.setStyle(dragEl, "fontSize", Dom.getStyle(body, "fontSize"));
        Dom.setStyle(dragEl, "fontFamily", Dom.getStyle(body, "fontFamily"));
        Dom.setStyle(dragEl, "border", "0");
    },

    endDrag: function(e) {
    	this.removeFromGroup("activeTags");
    	this.addToGroup("inactiveTags");

		if (this.shouldAnimateBack)
		{
			var srcEl = this.getEl();
			var proxy = this.getDragEl();
			Dom.setStyle(proxy, "visibility", "visible");
	
			// animate the proxy element to the src element's location
			var a = new YAHOO.util.Motion( 
				proxy, { 
					points: { 
						to: Dom.getXY(srcEl)
					}
				}, 
				0.3, 
				YAHOO.util.Easing.easeOut 
			)
			var proxyid = proxy.id;
			var id = this.id;
			a.onComplete.subscribe(function() {
					Dom.setStyle(proxyid, "visibility", "hidden");
					Dom.setStyle(id, "visibility", "");
				});
			a.animate();
		}
		else
		{
			var oldblank = Dom.get("placeholder");
			
			// reset the placeholder for the next insert operation
			var newblank = document.createElement("div");
			newblank.id = "placeholder";
			newblank.className = "large";
			newblank.innerHTML = oldblank.innerHTML;
			
			// create the new active tag
			var srcEl = this.getEl();
			oldblank.innerHTML = srcEl.innerHTML;
			oldblank.id = srcEl.id.substr(0, (srcEl.id.length-4)) + Util.getGUID();
			Dom.setStyle(oldblank, "height", "");
			new YAHOO.example.DDList(oldblank.id, "activeTags");
			
			// insert the placeholder
			document.getElementsByTagName("body")[0].appendChild(newblank);
			
			DDM.refreshCache("activeTags");
		}
    },

    onDragDrop: function(e, id) {
    //alert("dropped on " + id);
    	if (id.length == 1 && id[0].id == 'trashcan')
    	{
    		this.shouldAnimateBack = true;
    	}
    },

    onDrag: function(e, id) {
        // figure out which direction we are moving
        var y = Event.getPageY(e);

        if (y < this.lastY) {
            this.goingUp = true;
        } else if (y > this.lastY) {
            this.goingUp = false;
        }

        this.lastY = y;
    },

    onDragOver: function(e, id) {
    	var srcEl = this.getEl();
        var destEl;

        if ("string" == typeof id) {
            // POINT mode
            destEl = Dom.get(id);
        } else { 
            // INTERSECT mode
            destEl= YAHOO.util.DDM.getBestMatch(id).getEl();
            //alert(destEl.id);
        }
        var p = destEl.parentNode;
        var blank = Dom.get('placeholder');
        
		if (destEl.id != 'trashcan')
		{
			if (destEl.id != 'body')
			{
				if (this.selfHealed != 0)
				{
					var collapseAnim = new YAHOO.util.Anim(blank, {height: {to: this.selfHealed}}, 0.3);
					collapseAnim.animate();
					this.selfHealed = 0;
				}
				if (this.goingUp) {
					p.insertBefore(blank, destEl);
				} else {
					p.insertBefore(blank, destEl.nextSibling);
				}
		
				DDM.refreshCache("activeTags");
			}
		}
		else
		{
			if (this.selfHealed == 0)
			{
				//alert("animating... height " + parseInt(Dom.getStyle(srcEl, "height")));
				this.selfHealed = parseInt(Dom.getStyle(blank, "height"));
				var collapseAnim = new YAHOO.util.Anim(blank, {height: {to: 0}}, 0.3);
				collapseAnim.animate();
			}
		}
    },

    onDragEnter: function(e, id) {
    },

    onDragOut: function(e, id) {
    },

    toString: function() {
        return "DDSource " + this.id;
    }
});

})();
