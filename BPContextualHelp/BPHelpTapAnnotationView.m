// BPHelpTapAnnotationView.m
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

#import "BPHelpTapAnnotationView.h"

static const CGFloat BPCircleRadius = 35.0;

@interface BPHelpTapAnnotationView ()

@property (nonatomic, assign) CGPoint circlePoint;

@end

@implementation BPHelpTapAnnotationView

- (id)initWithAnnotation:(id <BPHelpAnnotation>)annotation
{
	if ((self = [super initWithFrame:CGRectZero]))
	{
		self.annotation = annotation;
		
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
	}
	
	return self;
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	UIView *wrapperView = self.superview;
	UIView *anchorView = self.annotation.anchorView;
	CGPoint anchorPoint = UIInterfaceOrientationIsLandscape(interfaceOrientation) ? self.annotation.landscapeAnchorPoint : self.annotation.portraitAnchorPoint;
	CGRect anchorFrame = CGRectMake(anchorPoint.x, anchorPoint.y, 1.0, 1.0);
	if (anchorView != nil)
	{
		anchorFrame = [anchorView convertRect:anchorView.bounds toView:nil];
		anchorFrame = [anchorView.window convertRect:anchorFrame toWindow:self.window];
		anchorFrame = [wrapperView convertRect:anchorFrame fromView:nil];
	}
	
	self.circlePoint = CGPointMake(CGRectGetMidX(anchorFrame) + self.annotation.contentOffset.width, CGRectGetMidY(anchorFrame) + self.annotation.contentOffset.height);
	self.frame = CGRectMake(self.circlePoint.x - BPCircleRadius, self.circlePoint.y - BPCircleRadius, BPCircleRadius * 2, BPCircleRadius * 2);
}

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 2, 2)];
	UIColor *strokeColor = [UIColor colorWithRed:0.965 green:0.855 blue:0.451 alpha:1];
	UIColor *fillColor = [UIColor colorWithRed:0.965 green:0.855 blue:0.451 alpha:0.6];
	[fillColor set];
	[path fill];
	[strokeColor set];
	
	CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
	CGContextClip(UIGraphicsGetCurrentContext());
	CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeZero, 3.0, [UIColor colorWithWhite:0.0 alpha:0.3].CGColor);
	[path setLineWidth:5.0];
	[path stroke];
}

@end
