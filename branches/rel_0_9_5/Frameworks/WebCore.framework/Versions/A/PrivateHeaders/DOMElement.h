/*
 * Copyright (C) 2004, 2005, 2006, 2007 Apple Inc. All rights reserved.
 * Copyright (C) 2006 Samuel Weinig <sam.weinig@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE COMPUTER, INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE COMPUTER, INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

#import <WebCore/DOMNode.h>


@class DOMAttr;
@class DOMCSSStyleDeclaration;
@class DOMElement;
@class DOMNodeList;
@class NSString;

@interface DOMElement : DOMNode
- (NSString *)tagName;
- (DOMCSSStyleDeclaration *)style;
- (int)offsetLeft;
- (int)offsetTop;
- (int)offsetWidth;
- (int)offsetHeight;
- (DOMElement *)offsetParent;
- (int)clientWidth;
- (int)clientHeight;
- (int)scrollLeft;
- (void)setScrollLeft:(int)newScrollLeft;
- (int)scrollTop;
- (void)setScrollTop:(int)newScrollTop;
- (int)scrollWidth;
- (int)scrollHeight;
- (NSString *)getAttribute:(NSString *)name;
- (void)setAttribute:(NSString *)name value:(NSString *)value;
- (void)removeAttribute:(NSString *)name;
- (DOMAttr *)getAttributeNode:(NSString *)name;
- (DOMAttr *)setAttributeNode:(DOMAttr *)newAttr;
- (DOMAttr *)removeAttributeNode:(DOMAttr *)oldAttr;
- (DOMNodeList *)getElementsByTagName:(NSString *)name;
- (NSString *)getAttributeNS:(NSString *)namespaceURI localName:(NSString *)localName;
- (void)setAttributeNS:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName value:(NSString *)value;
- (void)removeAttributeNS:(NSString *)namespaceURI localName:(NSString *)localName;
- (DOMNodeList *)getElementsByTagNameNS:(NSString *)namespaceURI localName:(NSString *)localName;
- (DOMAttr *)getAttributeNodeNS:(NSString *)namespaceURI localName:(NSString *)localName;
- (DOMAttr *)setAttributeNodeNS:(DOMAttr *)newAttr;
- (BOOL)hasAttribute:(NSString *)name;
- (BOOL)hasAttributeNS:(NSString *)namespaceURI localName:(NSString *)localName;
- (void)focus;
- (void)blur;
- (void)scrollIntoView:(BOOL)alignWithTop;
- (void)scrollIntoViewIfNeeded:(BOOL)centerIfNeeded;
@end

@interface DOMElement (DOMElementDeprecated)
- (void)setAttribute:(NSString *)name :(NSString *)value;
- (NSString *)getAttributeNS:(NSString *)namespaceURI :(NSString *)localName;
- (void)setAttributeNS:(NSString *)namespaceURI :(NSString *)qualifiedName :(NSString *)value;
- (void)removeAttributeNS:(NSString *)namespaceURI :(NSString *)localName;
- (DOMNodeList *)getElementsByTagNameNS:(NSString *)namespaceURI :(NSString *)localName;
- (DOMAttr *)getAttributeNodeNS:(NSString *)namespaceURI :(NSString *)localName;
- (BOOL)hasAttributeNS:(NSString *)namespaceURI :(NSString *)localName;
@end
