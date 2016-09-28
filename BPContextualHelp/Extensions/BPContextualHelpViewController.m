// BPContextualHelpViewController.m
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

#import "BPContextualHelpViewController.h"

#import "NSObject+BPContextualHelp.h"

@interface BPContextualHelpViewController ()

@end

@implementation BPContextualHelpViewController

+ (instancetype)bpch_viewController
{
	return [[[self alloc] initWithNibName:nil bundle:nil] bp_autorelease];
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
	[_bpch_loadViewBlock release], _bpch_loadViewBlock = nil;
	[_bpch_viewDidLoadBlock release], _bpch_viewDidLoadBlock = nil;
	[_bpch_viewWillUnloadBlock release], _bpch_viewWillUnloadBlock = nil;
	[_bpch_viewDidUnloadBlock release], _bpch_viewDidUnloadBlock = nil;
	
	[_bpch_didReceiveMemoryWarningBlock release], _bpch_didReceiveMemoryWarningBlock = nil;
	
	[_bpch_viewWillAppearBlock release], _bpch_viewWillAppearBlock = nil;
	[_bpch_viewDidAppearBlock release], _bpch_viewDidAppearBlock = nil;
	[_bpch_viewWillDisappearBlock release], _bpch_viewWillDisappearBlock = nil;
	[_bpch_viewDidDisappearBlock release], _bpch_viewDidDisappearBlock = nil;
	
	[_bpch_shouldAutorotateBlock release], _bpch_shouldAutorotateBlock = nil;
	[_bpch_willAnimateRotationBlock release], _bpch_willAnimateRotationBlock = nil;
	
	[_bpch_updateViewConstraintsBlock release], _bpch_updateViewConstraintsBlock = nil;
	
	[_bpch_accessibilityElementAtIndexBlock release], _bpch_accessibilityElementAtIndexBlock = nil;
	[_bpch_accessibilityElementCountBlock release], _bpch_accessibilityElementCountBlock = nil;
	[_bpch_indexOfAccessibilityElementBlock release], _bpch_indexOfAccessibilityElementBlock = nil;
	
	[super dealloc];
}
#endif

#pragma mark -
#pragma mark View Lifecycle

- (void)loadView
{
	if (self.bpch_loadViewBlock != nil) self.bpch_loadViewBlock();
}

- (void)viewDidLoad
{
	if (self.bpch_viewDidLoadBlock != nil) self.bpch_viewDidLoadBlock();
}

- (void)viewWillUnload
{
	if (self.bpch_viewWillUnloadBlock != nil) self.bpch_viewWillUnloadBlock();
}

- (void)viewDidUnload
{
	if (self.bpch_viewDidUnloadBlock != nil) self.bpch_viewDidUnloadBlock();
}

- (void)didReceiveMemoryWarning
{
	if (self.bpch_didReceiveMemoryWarningBlock != nil) self.bpch_didReceiveMemoryWarningBlock();
}

- (void)viewWillAppear:(BOOL)animated
{
	if (self.bpch_viewWillAppearBlock != nil) self.bpch_viewWillAppearBlock(animated);
}

- (void)viewDidAppear:(BOOL)animated
{
	if (self.bpch_viewDidAppearBlock != nil) self.bpch_viewDidAppearBlock(animated);
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (self.bpch_viewWillDisappearBlock != nil) self.bpch_viewWillDisappearBlock(animated);
}

- (void)viewDidDisappear:(BOOL)animated
{
	if (self.bpch_viewDidDisappearBlock != nil) self.bpch_viewDidDisappearBlock(animated);
}

#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (self.bpch_shouldAutorotateBlock != nil) return self.bpch_shouldAutorotateBlock(toInterfaceOrientation);
	return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (self.bpch_willAnimateRotationBlock != nil) self.bpch_willAnimateRotationBlock(toInterfaceOrientation, duration);
}

#pragma mark -
#pragma mark Constraints

- (void)updateViewConstraints
{
	[super updateViewConstraints];
	if (self.bpch_updateViewConstraintsBlock != nil) self.bpch_updateViewConstraintsBlock();
}

#pragma mark -
#pragma mark Accessibility

- (id)accessibilityElementAtIndex:(NSInteger)index
{
	if (self.bpch_accessibilityElementAtIndexBlock != nil) return self.bpch_accessibilityElementAtIndexBlock(index);
	return nil;
}

- (NSInteger)accessibilityElementCount
{
	if (self.bpch_accessibilityElementCountBlock != nil) return self.bpch_accessibilityElementCountBlock();
	return 0;
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
	if (self.bpch_indexOfAccessibilityElementBlock != nil) return self.bpch_indexOfAccessibilityElementBlock(element);
	return NSNotFound;
}

@end
