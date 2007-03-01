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

#import <WebKit/DOMHTMLElement.h>

@class DOMHTMLCollection;
@class DOMHTMLElement;
@class DOMHTMLTableCaptionElement;
@class DOMHTMLTableSectionElement;
@class NSString;

@interface DOMHTMLTableElement : DOMHTMLElement
- (DOMHTMLTableCaptionElement *)caption;
- (void)setCaption:(DOMHTMLTableCaptionElement *)newCaption;
- (DOMHTMLTableSectionElement *)tHead;
- (void)setTHead:(DOMHTMLTableSectionElement *)newTHead;
- (DOMHTMLTableSectionElement *)tFoot;
- (void)setTFoot:(DOMHTMLTableSectionElement *)newTFoot;
- (DOMHTMLCollection *)rows;
- (DOMHTMLCollection *)tBodies;
- (NSString *)align;
- (void)setAlign:(NSString *)newAlign;
- (NSString *)bgColor;
- (void)setBgColor:(NSString *)newBgColor;
- (NSString *)border;
- (void)setBorder:(NSString *)newBorder;
- (NSString *)cellPadding;
- (void)setCellPadding:(NSString *)newCellPadding;
- (NSString *)cellSpacing;
- (void)setCellSpacing:(NSString *)newCellSpacing;
- (NSString *)frameBorders;
- (void)setFrameBorders:(NSString *)newFrameBorders;
- (NSString *)rules;
- (void)setRules:(NSString *)newRules;
- (NSString *)summary;
- (void)setSummary:(NSString *)newSummary;
- (NSString *)width;
- (void)setWidth:(NSString *)newWidth;
- (DOMHTMLElement *)createTHead;
- (void)deleteTHead;
- (DOMHTMLElement *)createTFoot;
- (void)deleteTFoot;
- (DOMHTMLElement *)createCaption;
- (void)deleteCaption;
- (DOMHTMLElement *)insertRow:(int)index;
- (void)deleteRow:(int)index;
@end
