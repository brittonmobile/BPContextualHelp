// BPHelpDisclosureAnnotationView.m
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

#import "BPHelpDisclosureAnnotationView.h"

#import "UIView+BPContextualHelp.h"

static const CGFloat BPPaddingLeft = 12.0;
static const CGFloat BPPaddingRight = 12.0;
static const CGFloat BPPaddingTop = 8.0;
static const CGFloat BPPaddingBottom = 8.0;

static const CGFloat BPMaximumWidth = 160.0;
static const CGFloat BPCornerRadius = 8.0;
static const CGFloat BPDisclosureWidth = 44.0;

static const CGFloat BPFontSize = 12.0;

@interface BPHelpDisclosureAnnotationView ()

@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, assign) CGRect balloonRect;

@property (nonatomic, BPContextualHelpRetainOrStrong) UILabel *textLabel;
@property (nonatomic, BPContextualHelpRetainOrStrong) CAShapeLayer *darkBevelLayer;
@property (nonatomic, BPContextualHelpRetainOrStrong) CAShapeLayer *lightBevelLayer;
@property (nonatomic, BPContextualHelpRetainOrStrong) CALayer *disclosureIconLayer;

@end

@implementation BPHelpDisclosureAnnotationView

- (id)initWithAnnotation:(id <BPHelpAnnotation>)annotation
{
	if ((self = [super initWithFrame:CGRectZero]))
	{
		self.annotation = annotation;
		
		_textLabel = [[[UILabel alloc] initWithFrame:CGRectZero] bp_autorelease];
		_textLabel.numberOfLines = 0;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor blackColor];
		_textLabel.font = [UIFont boldSystemFontOfSize:BPFontSize];
		_textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_textLabel.isAccessibilityElement = NO;
		[self addSubview:_textLabel];
		
		_darkBevelLayer = [CAShapeLayer layer];
		_darkBevelLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
		_darkBevelLayer.anchorPoint = CGPointZero;
		_darkBevelLayer.contentsScale = [[UIScreen mainScreen] scale];
		[self.layer addSublayer:_darkBevelLayer];
		
		_lightBevelLayer = [CAShapeLayer layer];
		_lightBevelLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
		_lightBevelLayer.anchorPoint = CGPointZero;
		_lightBevelLayer.contentsScale = [[UIScreen mainScreen] scale];
		[self.layer addSublayer:_lightBevelLayer];
		
		_disclosureIconLayer = [CALayer layer];
		_disclosureIconLayer.contents = (id) [UIImage imageNamed:@"BPContextualHelpArrow"].CGImage;
		_disclosureIconLayer.bounds = CGRectMake(0.0, 0.0, 21.0, 21.0);
		_disclosureIconLayer.contentsScale = [[UIScreen mainScreen] scale];
		[self.layer addSublayer:_disclosureIconLayer];
		
		self.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
		self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
		self.layer.shadowOpacity = 1.0;
		self.layer.shadowRadius = 1.0;
		
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
	}
	
	return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
	[_textLabel release], _textLabel = nil;
	[_darkBevelLayer release], _darkBevelLayer = nil;
	[_lightBevelLayer release], _lightBevelLayer = nil;
	[_disclosureIconLayer release], _disclosureIconLayer = nil;
	[super dealloc];
}
#endif

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	UIView *wrapperView = self.superview;
	UIView *anchorView = self.annotation.anchorView;
	CGPoint anchorPoint = UIInterfaceOrientationIsLandscape(interfaceOrientation) ? self.annotation.landscapeAnchorPoint : self.annotation.portraitAnchorPoint;
	CGRect anchorFrame = CGRectMake(anchorPoint.x, anchorPoint.y, 1.0, 1.0);
	if (anchorView != nil)
	{
		UIViewController *viewController = [anchorView bpch_viewController];
		anchorFrame = [anchorView convertRect:anchorView.bounds toView:viewController.view];
	}
	
	//Figure out the content size
	CGSize contentSize = CGSizeZero;
	if ([self.annotation.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
	{
		CGSize maximumSize = CGSizeMake(BPMaximumWidth, CGFLOAT_MAX);
		NSUInteger options = NSStringDrawingUsesLineFragmentOrigin;
		NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:BPFontSize]};
		CGRect boundingRect = CGRectZero;
		
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.annotation.text methodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)]];
		[invocation setTarget:self.annotation.text];
		[invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
		[invocation setArgument:&maximumSize atIndex:2];
		[invocation setArgument:&options atIndex:3];
		[invocation setArgument:&attributes atIndex:4];
		[invocation invoke];
		[invocation getReturnValue:&boundingRect];
		contentSize = boundingRect.size;
		//contentSize = [self.annotation.text boundingRectWithSize:CGSizeMake(BPMaximumWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:BPFontSize]} context:nil].size;
	}
	else
	{
		UIFont *font = [UIFont boldSystemFontOfSize:BPFontSize];
		CGSize maximumSize = CGSizeMake(BPMaximumWidth, CGFLOAT_MAX);
		NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping;
		
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self.annotation.text methodSignatureForSelector:@selector(sizeWithFont:forWidth:lineBreakMode:)]];
		[invocation setTarget:self.annotation.text];
		[invocation setSelector:@selector(sizeWithFont:forWidth:lineBreakMode:)];
		[invocation setArgument:&font atIndex:2];
		[invocation setArgument:&maximumSize atIndex:3];
		[invocation setArgument:&lineBreakMode atIndex:4];
		[invocation invoke];
		[invocation getReturnValue:&contentSize];
		//contentSize = [self.annotation.text sizeWithFont:[UIFont boldSystemFontOfSize:BPFontSize] constrainedToSize:CGSizeMake(BPMaximumWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	}
	
	contentSize = CGSizeMake(ceil(contentSize.width), ceil(contentSize.height));
	
	//Figure out the balloon rect -- they're in wrapperView coordinates at this point
	CGRect balloonRect = CGRectMake(0.0, 0.0, contentSize.width + BPDisclosureWidth + BPPaddingLeft + BPPaddingRight, contentSize.height + BPPaddingTop + BPPaddingBottom);
	balloonRect.origin.x = CGRectGetMidX(anchorFrame) - CGRectGetWidth(balloonRect) / 2;
	balloonRect.origin.y = CGRectGetMidY(anchorFrame) - CGRectGetHeight(balloonRect) / 2;
	self.frame = balloonRect;
	
	//Convert to local coordinates
	self.balloonRect = [self convertRect:balloonRect fromView:wrapperView];
	
	//Position the layers
	self.textLabel.frame = CGRectMake(CGRectGetMinX(self.balloonRect) + BPPaddingLeft, CGRectGetMinY(self.balloonRect) + BPPaddingTop, contentSize.width, contentSize.height);
	self.textLabel.text = self.annotation.text;
	
	self.darkBevelLayer.position = CGPointMake(contentSize.width + BPPaddingLeft + BPPaddingRight, 0.0);
	self.darkBevelLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, 1.0, CGRectGetHeight(self.balloonRect))].CGPath;
	
	self.lightBevelLayer.position = CGPointMake(contentSize.width + BPPaddingLeft + BPPaddingRight + 1.0, 0.0);
	self.lightBevelLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, 1.0, CGRectGetHeight(self.balloonRect))].CGPath;
	
	self.disclosureIconLayer.position = CGPointMake(contentSize.width + BPPaddingLeft + BPPaddingRight + BPDisclosureWidth / 2, CGRectGetMidY(self.balloonRect));
}

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.balloonRect cornerRadius:BPCornerRadius];
	
	UIColor *color1 = [UIColor colorWithRed:0.965 green:0.863 blue:0.482 alpha:0.9];
	UIColor *color2 = [UIColor colorWithRed:0.792 green:0.671 blue:0.286 alpha:0.9];
	
	CGFloat tlX = CGRectGetMinX(self.balloonRect);
	CGFloat tlY = CGRectGetMinY(self.balloonRect);
	CGFloat blX = tlX;
	CGFloat blY = CGRectGetMaxY(self.balloonRect);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//Draw the color gradient
	CGContextSaveGState(context);
	{
		CGGradientRef gradient = CGGradientCreateWithColors(NULL, (CFArrayRef) @[(id) color1.CGColor, (id) color2.CGColor], NULL);
		CGContextAddPath(context, path.CGPath);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(tlX, tlY), CGPointMake(blX, blY), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}
	CGContextRestoreGState(context);
	
	//Draw the top bevel
	CGContextSaveGState(context);
	{
		UIBezierPath *offsetPath = [[path copy] bp_autorelease];
		[offsetPath applyTransform:CGAffineTransformMakeTranslation(0.0, 1.0)];
		
		UIBezierPath *topPath = [[path copy] bp_autorelease];
		[topPath appendPath:offsetPath];
		topPath.usesEvenOddFillRule = YES;
		
		CGRect pathBounds = [path bounds];
		CGRect remainder = CGRectZero;
		CGRectDivide(pathBounds, &pathBounds, &remainder, CGRectGetMinY(self.balloonRect) + BPCornerRadius - CGRectGetMinY(pathBounds), CGRectMinYEdge);
		CGContextClipToRect(context, pathBounds);
		CGContextAddPath(context, path.CGPath);
		CGContextClip(context);
		
		[[UIColor colorWithRed:0.984 green:0.925 blue:0.643 alpha:1] set];
		[topPath fill];
	}
	CGContextRestoreGState(context);
	
	//Draw the bottom bevel
	CGContextSaveGState(context);
	{
		UIBezierPath *offsetPath = [[path copy] bp_autorelease];
		[offsetPath applyTransform:CGAffineTransformMakeTranslation(0.0, -1.0)];
		
		UIBezierPath *bottomPath = [[path copy] bp_autorelease];
		[bottomPath appendPath:offsetPath];
		bottomPath.usesEvenOddFillRule = YES;
		
		CGRect pathBounds = [path bounds];
		CGRect remainder = CGRectZero;
		CGRectDivide(pathBounds, &pathBounds, &remainder, CGRectGetMaxY(pathBounds) - (CGRectGetMaxY(self.balloonRect) - BPCornerRadius), CGRectMaxYEdge);
		CGContextClipToRect(context, pathBounds);
		CGContextAddPath(context, path.CGPath);
		CGContextClip(context);
		
		[[UIColor colorWithRed:0.675 green:0.573 blue:0.251 alpha:1] set];
		[bottomPath fill];
	}
	CGContextRestoreGState(context);
	
	self.layer.shadowPath = path.CGPath;
}

@end
