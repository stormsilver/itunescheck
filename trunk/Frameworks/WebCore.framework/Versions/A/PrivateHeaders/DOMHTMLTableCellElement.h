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

#import <WebCore/DOMHTMLElement.h>

@class NSString;

@interface DOMHTMLTableCellElement : DOMHTMLElement
- (int)cellIndex;
- (NSString *)abbr;
- (void)setAbbr:(NSString *)newAbbr;
- (NSString *)align;
- (void)setAlign:(NSString *)newAlign;
- (NSString *)axis;
- (void)setAxis:(NSString *)newAxis;
- (NSString *)bgColor;
- (void)setBgColor:(NSString *)newBgColor;
- (NSString *)ch;
- (void)setCh:(NSString *)newCh;
- (NSString *)chOff;
- (void)setChOff:(NSString *)newChOff;
- (int)colSpan;
- (void)setColSpan:(int)newColSpan;
- (NSString *)headers;
- (void)setHeaders:(NSString *)newHeaders;
- (NSString *)height;
- (void)setHeight:(NSString *)newHeight;
- (BOOL)noWrap;
- (void)setNoWrap:(BOOL)newNoWrap;
- (int)rowSpan;
- (void)setRowSpan:(int)newRowSpan;
- (NSString *)scope;
- (void)setScope:(NSString *)newScope;
- (NSString *)vAlign;
- (void)setVAlign:(NSString *)newVAlign;
- (NSString *)width;
- (void)setWidth:(NSString *)newWidth;
@end
