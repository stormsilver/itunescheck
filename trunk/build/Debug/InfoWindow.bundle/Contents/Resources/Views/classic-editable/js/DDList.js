
(function() {

var Dom = YAHOO.util.Dom;
var Event = YAHOO.util.Event;
var DDM = YAHOO.util.DragDropMgr;

YAHOO.example.DDList = function(id, sGroup, config) {

    if (id) {
        this.init(id, sGroup, config);
        this.initFrame();
        this.logger = this.logger || YAHOO;
    }

    var el = this.getDragEl();
    Dom.setStyle(el, "opacity", 0.67);
    //Dom.setStyle(el, "cursor", "move");

    this.setPadding(-4);
    this.goingUp = false;
    this.lastY = 0;
    this.deleted = false;
    this.selfHealed = 0;
    if (config)
    {
    	this.isSource = (config.source == true ? true : false);
    }
};

YAHOO.extend(YAHOO.example.DDList, YAHOO.util.DDProxy, {

    startDrag: function(x, y) {
        //this.logger.log(this.id + " startDrag");

        var dragEl = this.getDragEl();
		var clickEl = this.getEl();
        dragEl.innerHTML = clickEl.innerHTML;
        
        if (this.isSource)
        {
			var body = Dom.get("body");
			dragEl.className = body.className;
			Dom.setStyle(dragEl, "color", Dom.getStyle(body, "color"));
			Dom.setStyle(dragEl, "fontSize", Dom.getStyle(body, "fontSize"));
			Dom.setStyle(dragEl, "fontFamily", Dom.getStyle(body, "fontFamily"));
			//this.addToGroup("activeTags");
		}
		else
		{
        	Dom.setStyle(clickEl, "visibility", "hidden");
			dragEl.className = clickEl.className;
			Dom.setStyle(dragEl, "color", Dom.getStyle(clickEl, "color"));
			Dom.setStyle(dragEl, "fontSize", Dom.getStyle(clickEl, "fontSize"));
			Dom.setStyle(dragEl, "fontFamily", Dom.getStyle(clickEl, "fontFamily"));
		}
		Dom.setStyle(dragEl, "border", "0");
    },

    endDrag: function(e) {

		if (!this.deleted)
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
			// remove this thing
			var parent = this.getEl().parentNode;
        	this.unreg();
        	parent.removeChild(this.getEl());
		}
    },

    onDragDrop: function(e, id) {
        //alert("DROP: " + id);
        if (id.length == 1 && id[0].id == 'trashcan')
        {
        	//alert("on the trashcan: " + this);
        	this.deleted = true;
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
            //alert(destEl);
        }
        var p = destEl.parentNode;
        
		if (destEl.id != 'trashcan')
		{
			if (destEl.id != 'body')
			{
				if (this.selfHealed != 0)
				{
					var collapseAnim = new YAHOO.util.Anim(srcEl, {height: {to: this.selfHealed}}, 0.3);
					collapseAnim.animate();
					this.selfHealed = 0;
				}
				if (this.goingUp) {
					p.insertBefore(srcEl, destEl);
				} else {
					p.insertBefore(srcEl, destEl.nextSibling);
				}
		
				DDM.refreshCache("activeTags");
			}
		}
		else
		{
			if (this.selfHealed == 0)
			{
				//alert("animating... height " + parseInt(Dom.getStyle(srcEl, "height")));
				this.selfHealed = parseInt(Dom.getStyle(srcEl, "height"));
				var collapseAnim = new YAHOO.util.Anim(srcEl, {height: {to: 0}}, 0.3);
				collapseAnim.animate();
			}
		}
    },

    onDragEnter: function(e, id) {
    },

    onDragOut: function(e, id) {
    },

    toString: function() {
        return "DDList " + this.id;
    }

});


})();

