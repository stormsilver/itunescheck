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

#import <WebKit/DOMElement.h>

@class DOMHTMLCollection;
@class NSString;

@interface DOMHTMLElement : DOMElement
- (NSString *)title;
- (void)setTitle:(NSString *)newTitle;
- (NSString *)idName;
- (void)setIdName:(NSString *)newIdName;
- (NSString *)lang;
- (void)setLang:(NSString *)newLang;
- (NSString *)dir;
- (void)setDir:(NSString *)newDir;
- (NSString *)className;
- (void)setClassName:(NSString *)newClassName;
- (NSString *)innerHTML;
- (void)setInnerHTML:(NSString *)newInnerHTML;
- (NSString *)innerText;
- (void)setInnerText:(NSString *)newInnerText;
- (NSString *)outerHTML;
- (void)setOuterHTML:(NSString *)newOuterHTML;
- (NSString *)outerText;
- (void)setOuterText:(NSString *)newOuterText;
- (DOMHTMLCollection *)children;
- (NSString *)contentEditable;
- (void)setContentEditable:(NSString *)newContentEditable;
- (BOOL)isContentEditable;
- (NSString *)titleDisplayString;
@end
