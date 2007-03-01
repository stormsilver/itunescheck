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
@class NSURL;

@interface DOMHTMLImageElement : DOMHTMLElement
- (NSString *)name;
- (void)setName:(NSString *)newName;
- (NSString *)align;
- (void)setAlign:(NSString *)newAlign;
- (NSString *)alt;
- (void)setAlt:(NSString *)newAlt;
- (NSString *)border;
- (void)setBorder:(NSString *)newBorder;
- (int)height;
- (void)setHeight:(int)newHeight;
- (int)hspace;
- (void)setHspace:(int)newHspace;
- (BOOL)isMap;
- (void)setIsMap:(BOOL)newIsMap;
- (NSString *)longDesc;
- (void)setLongDesc:(NSString *)newLongDesc;
- (NSString *)src;
- (void)setSrc:(NSString *)newSrc;
- (NSString *)useMap;
- (void)setUseMap:(NSString *)newUseMap;
- (int)vspace;
- (void)setVspace:(int)newVspace;
- (int)width;
- (void)setWidth:(int)newWidth;
- (NSString *)altDisplayString;
- (NSURL *)absoluteImageURL;
@end
