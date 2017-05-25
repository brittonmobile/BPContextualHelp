// BPHelpAnnotationView.m
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

#import "BPHelpOverlayView.h"

#import "BPHelpAnnotation.h"
#import "BPHelpAnnotationView.h"

#import "BPContextualHelpViewController.h"
#import "NSArray+BPContextualHelp.h"
#import "UIWindow+BPContextualHelp.h"

@interface BPHelpOverlayView ()

@property (nonatomic, BPContextualHelpRetainOrStrong) UIWindow *startingKeyWindow;
@property (nonatomic, BPContextualHelpRetainOrStrong) UIWindow *window;
@property (nonatomic, BPContextualHelpRetainOrStrong) UIView *shieldView;
@property (nonatomic, BPContextualHelpRetainOrStrong) NSMutableArray *annotations;
@property (nonatomic, BPContextualHelpRetainOrStrong) NSMutableArray *annotationViews;
@property (nonatomic, BPContextualHelpRetainOrStrong) NSMutableArray *annotationAccessibilityElements;

@end

@implementation BPHelpOverlayView

+ (BPHelpOverlayView *)helpOverlayViewWithAnnotations:(NSArray *)annotations
{
	BPHelpOverlayView *overlay = [[[self alloc] initWithFrame:CGRectZero] bp_autorelease];
	if (!BPCHArrayIsEmpty(annotations)) [overlay.annotations addObjectsFromArray:annotations];
	return overlay;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		_annotations = [[NSMutableArray alloc] init];
		_annotationViews = [[NSMutableArray alloc] init];
		_annotationAccessibilityElements = [[NSMutableArray alloc] init];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.contentScaleFactor = [[UIScreen mainScreen] scale];
		self.accessibilityViewIsModal = YES;
	}
	
	return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
	[_completionBlock release], _completionBlock = nil;
	
	[_startingKeyWindow release], _startingKeyWindow = nil;
	[_window release], _window = nil;
	[_shieldView release], _shieldView = nil;
	[_annotations release], _annotations = nil;
	[_annotationViews release], _annotationViews = nil;
	[_annotationAccessibilityElements release], _annotationAccessibilityElements = nil;
	[super dealloc];
}
#endif

- (void)_constructUI
{
	UIView *shieldView = [[[UIView alloc] initWithFrame:CGRectZero] bp_autorelease];
	shieldView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
	shieldView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	shieldView.opaque = NO;
	shieldView.contentScaleFactor = [[UIScreen mainScreen] scale];
	self.shieldView = shieldView;
	
	UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_shieldTapped:)] bp_autorelease];
	tap.delegate = self;
	[shieldView addGestureRecognizer:tap];
	
	//Annotations
	for (id <BPHelpAnnotation> annotation in self.annotations)
	{
		BPHelpAnnotationView *view = [annotation view];
		[self addSubview:view];
		[self.annotationViews addObject:view];
		[view updateLayoutForOrientation:[[UIApplication sharedApplication] keyWindow].rootViewController.interfaceOrientation];
	}
}

- (void)_updateAccessibilityElements
{
	[self.annotationAccessibilityElements removeAllObjects];
	NSUInteger index = 0;
	for (id <BPHelpAnnotation> annotation in self.annotations)
	{
		BPHelpAnnotationView *view = self.annotationViews[index];;
		UIAccessibilityElement *e = [annotation accessibilityElementInContainer:self];
		[self.annotationAccessibilityElements addObject:(e ? : [NSNull null])];
		CGRect af = [self convertRect:view.frame toView:nil];
		e.accessibilityFrame = af;
		index++;
	}
}

- (void)show
{
	#if !__has_feature(objc_arc)
	[self retain];
	#endif
	[self _constructUI];
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	self.startingKeyWindow = mainWindow;
	self.startingKeyWindow.accessibilityElementsHidden = YES;
	self.window = [[[UIWindow alloc] initWithFrame:mainWindow.frame] bp_autorelease];
	self.window.windowLevel = UIWindowLevelAlert;
	self.window.opaque = NO;
	self.window.transform = self.startingKeyWindow.transform;
	self.window.accessibilityElementsHidden = NO;
	BPContextualHelpViewController *viewController = [[[BPContextualHelpViewController alloc] init] bp_autorelease];
	viewController.view = self.shieldView;
	viewController.bpch_shouldAutorotateBlock = ^(UIInterfaceOrientation interfaceOrientation) { return YES; };
	viewController.bpch_willAnimateRotationBlock = ^(UIInterfaceOrientation interfaceOrientation, NSTimeInterval duration)
	{
		if ([self.annotationViews count] != [self.annotationAccessibilityElements count])
		{
			[self _updateAccessibilityElements];
		}
		
		NSUInteger index = 0;
		for (BPHelpAnnotationView *annotationView in self.annotationViews)
		{
			[annotationView updateLayoutForOrientation:interfaceOrientation];
			if (self.annotationAccessibilityElements[index] != [NSNull null]) ((UIAccessibilityElement *) self.annotationAccessibilityElements[index]).accessibilityFrame = [self convertRect:annotationView.frame toView:nil];
			index++;
		}
		
		[self _updateAccessibilityElements];
	};
	viewController.bpch_childViewControllerForStatusBarHiddenBlock = ^UIViewController *{
		return mainWindow.bpch_visibleViewController;
	};
	viewController.bpch_childViewControllerForStatusBarStyleBlock = ^UIViewController *{
		return mainWindow.bpch_visibleViewController;
	};
	viewController.bpch_accessibilityElementAtIndexBlock = ^(NSInteger index){
		return [self accessibilityElementAtIndex:index];
	};
	viewController.bpch_accessibilityElementCountBlock = ^{
		return [self accessibilityElementCount];
	};
	viewController.bpch_indexOfAccessibilityElementBlock = ^(id element){
		return [self indexOfAccessibilityElement:element];
	};
	self.window.rootViewController = viewController;
	self.window.screen = [UIScreen mainScreen];
	[self.window makeKeyAndVisible];
	
	self.alpha = 0.0;
	self.frame = self.shieldView.bounds;
	[self.shieldView addSubview:self];
	
	[self _updateAccessibilityElements];
	
	//Animate in
	[UIView animateWithDuration:0.15
						  animations:^{
							  self.alpha = 1.0;
						  }
						  completion:^(BOOL finished) {
							  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, viewController);
						  }];
}

- (void)_hide
{
	[self _hideWithCompletionBlock:nil];
}

- (void)_hideWithCompletionBlock:(BPHelpOverlayViewCompletionBlock)completionBlock
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[UIView animateWithDuration:0.35
						  animations:^{
							  self.shieldView.alpha = 0.0;
						  }
						  completion:^(BOOL finished) {
							  if (self.completionBlock != nil)
							  {
								  self.completionBlock();
							  }
							  
							  [self.shieldView removeFromSuperview];
							  [self removeFromSuperview];
							  self.window.hidden = YES;
							  [self.startingKeyWindow makeKeyWindow];
							  self.startingKeyWindow.accessibilityElementsHidden = NO;
								#if !__has_feature(objc_arc)
							  [self release];
								#endif
							  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
							  
							  if (completionBlock != nil) completionBlock();
						  }];
}

#pragma mark -
#pragma mark Accessibility

- (id)accessibilityElementAtIndex:(NSInteger)index
{
	NSArray *filteredElements = [self.annotationAccessibilityElements bpch_filteredArrayUsingBlock:^BOOL(id item) {
		return (item != [NSNull null]);
	}];
	return filteredElements[index];
}

- (NSInteger)accessibilityElementCount
{
	NSArray *filteredElements = [self.annotationAccessibilityElements bpch_filteredArrayUsingBlock:^BOOL(id item) {
		return (item != [NSNull null]);
	}];
	return [filteredElements count];
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
	NSArray *filteredElements = [self.annotationAccessibilityElements bpch_filteredArrayUsingBlock:^BOOL(id item) {
		return (item != [NSNull null]);
	}];
	return [filteredElements indexOfObject:element];
}

#pragma mark -
#pragma mark Gestures

- (void)_shieldTapped:(UITapGestureRecognizer *)gesture
{
	CGPoint p = [gesture locationInView:self];
	
	if (gesture.state == UIGestureRecognizerStateEnded)
	{
		BPHelpAnnotationTapBlock tapBlock = nil;
		for (BPHelpAnnotationView *annotationView in self.annotationViews)
		{
			if (CGRectContainsPoint(annotationView.frame, p))
			{
				if (annotationView.annotation.tapBlock != nil)
				{
					tapBlock = [annotationView.annotation.tapBlock copy];
					break;
				}
			}
		}
		
		[self _hideWithCompletionBlock:^{
			if (tapBlock != nil)
			{
				tapBlock();
				#if !__has_feature(objc_arc)
				[tapBlock release];
				#endif
			}
		}];
	}
}

@end
