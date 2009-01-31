/*
 *  defines.h
 *  iTunesCheck
 *
 *  Created by Eric Hankins on 12/22/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */


#define WIDTH_SCRIPT @"var d = document.getElementById('body');var cs = getComputedStyle(d, '');var width = (d.scrollWidth + parseInt(cs.borderLeftWidth) + parseInt(cs.borderRightWidth) + parseInt(cs.marginLeft) + parseInt(cs.marginRight));width;"
#define HEIGHT_SCRIPT @"var d = document.getElementById('body');var cs = getComputedStyle(d, '');var height = (d.scrollHeight + parseInt(cs.borderTopWidth) + parseInt(cs.borderBottomWidth) + parseInt(cs.marginTop) + parseInt(cs.marginBottom));height;"
#define InfoController NetStormsilverItunescheckInfowindowInfoController
#define InfoWindowPreferencesController NetStormsilverItunescheckInfowindowPreferencesController

#define BasicController NetStormsilverItunescheckBasichotkeysBasicController

#define QuickPlayPreferencesController NetStormsilverItunescheckQuickPlayPreferencesController
#define FindController NetStormsilverItunescheckQuickPlayFindController