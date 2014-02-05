// BPHelpDisclosureAnnotation.m
//
// Copyright (c) 2014 Britton Mobile Development (http://brittonmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BPHelpDisclosureAnnotation.h"

#import "BPHelpDisclosureAnnotationView.h"

#import "NSObject+BPContextualHelp.h"

@implementation BPHelpDisclosureAnnotation

- (BPHelpDisclosureAnnotationView *)view
{
	BPHelpDisclosureAnnotationView *view = [[[BPHelpDisclosureAnnotationView alloc] initWithAnnotation:self] bp_autorelease];
	return view;
}

- (UIAccessibilityElement *)accessibilityElementInContainer:(id)container
{
	UIAccessibilityElement *e = [[[UIAccessibilityElement alloc] initWithAccessibilityContainer:container] bp_autorelease];
	e.accessibilityLabel = [self text];
	e.accessibilityTraits = UIAccessibilityTraitButton;
	e.accessibilityHint = NSLocalizedString(@"Double tap for more help.", @"double tap for more help accessibility hint");
	return e;
}

@end
