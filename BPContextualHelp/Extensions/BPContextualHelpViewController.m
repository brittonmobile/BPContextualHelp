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

+ (instancetype)viewController
{
	return [[[self alloc] initWithNibName:nil bundle:nil] bp_autorelease];
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
	[_loadViewBlock release], _loadViewBlock = nil;
	[_viewDidLoadBlock release], _viewDidLoadBlock = nil;
	[_viewWillUnloadBlock release], _viewWillUnloadBlock = nil;
	[_viewDidUnloadBlock release], _viewDidUnloadBlock = nil;
	
	[_didReceiveMemoryWarningBlock release], _didReceiveMemoryWarningBlock = nil;
	
	[_viewWillAppearBlock release], _viewWillAppearBlock = nil;
	[_viewDidAppearBlock release], _viewDidAppearBlock = nil;
	[_viewWillDisappearBlock release], _viewWillDisappearBlock = nil;
	[_viewDidDisappearBlock release], _viewDidDisappearBlock = nil;
	
	[_shouldAutorotateBlock release], _shouldAutorotateBlock = nil;
	[_willAnimateRotationBlock release], _willAnimateRotationBlock = nil;
	
	[_updateViewConstraintsBlock release], _updateViewConstraintsBlock = nil;
	
	[_accessibilityElementAtIndexBlock release], _accessibilityElementAtIndexBlock = nil;
	[_accessibilityElementCountBlock release], _accessibilityElementCountBlock = nil;
	[_indexOfAccessibilityElementBlock release], _indexOfAccessibilityElementBlock = nil;
	
	[super dealloc];
}
#endif

#pragma mark -
#pragma mark View Lifecycle

- (void)loadView
{
	if (self.loadViewBlock != nil) self.loadViewBlock();
}

- (void)viewDidLoad
{
	if (self.viewDidLoadBlock != nil) self.viewDidLoadBlock();
}

- (void)viewWillUnload
{
	if (self.viewWillUnloadBlock != nil) self.viewWillUnloadBlock();
}

- (void)viewDidUnload
{
	if (self.viewDidUnloadBlock != nil) self.viewDidUnloadBlock();
}

- (void)didReceiveMemoryWarning
{
	if (self.didReceiveMemoryWarningBlock != nil) self.didReceiveMemoryWarningBlock();
}

- (void)viewWillAppear:(BOOL)animated
{
	if (self.viewWillAppearBlock != nil) self.viewWillAppearBlock(animated);
}

- (void)viewDidAppear:(BOOL)animated
{
	if (self.viewDidAppearBlock != nil) self.viewDidAppearBlock(animated);
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (self.viewWillDisappearBlock != nil) self.viewWillDisappearBlock(animated);
}

- (void)viewDidDisappear:(BOOL)animated
{
	if (self.viewDidDisappearBlock != nil) self.viewDidDisappearBlock(animated);
}

#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (self.shouldAutorotateBlock != nil) return self.shouldAutorotateBlock(toInterfaceOrientation);
	return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (self.willAnimateRotationBlock != nil) self.willAnimateRotationBlock(toInterfaceOrientation, duration);
}

#pragma mark -
#pragma mark Constraints

- (void)updateViewConstraints
{
	[super updateViewConstraints];
	if (self.updateViewConstraintsBlock != nil) self.updateViewConstraintsBlock();
}

#pragma mark -
#pragma mark Accessibility

- (id)accessibilityElementAtIndex:(NSInteger)index
{
	if (self.accessibilityElementAtIndexBlock != nil) return self.accessibilityElementAtIndexBlock(index);
	return nil;
}

- (NSInteger)accessibilityElementCount
{
	if (self.accessibilityElementCountBlock != nil) return self.accessibilityElementCountBlock();
	return 0;
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
	if (self.indexOfAccessibilityElementBlock != nil) return self.indexOfAccessibilityElementBlock(element);
	return NSNotFound;
}

@end
