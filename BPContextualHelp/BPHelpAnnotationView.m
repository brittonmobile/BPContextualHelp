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

#import "BPHelpAnnotationView.h"

#import "UIView+BPContextualHelp.h"
#import "NSString+BPContextualHelp.h"

static const CGFloat BPArrowWidth = 19.0;
static const CGFloat BPArrowHeight = 9.0;

static const CGFloat BPPaddingLeft = 12.0;
static const CGFloat BPPaddingRight = 12.0;
static const CGFloat BPPaddingTop = 8.0;
static const CGFloat BPPaddingBottom = 8.0;

static const CGFloat BPMaximumWidth = 160.0;
static const CGFloat BPCornerRadius = 8.0;

static const CGFloat BPFontSize = 12.0;

@interface BPHelpAnnotationView ()

@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, assign) CGRect balloonRect;

@property (nonatomic, BPContextualHelpRetainOrStrong) UILabel *textLabel;

@end

@implementation BPHelpAnnotationView

- (id)initWithAnnotation:(id <BPHelpAnnotation>)annotation
{
	if ((self = [super initWithFrame:CGRectZero]))
	{
		#if __has_feature(objc_arc)
		_annotation = annotation;
		#else
		_annotation = [annotation retain];
		#endif
		
		_textLabel = [[[UILabel alloc] initWithFrame:CGRectZero] bp_autorelease];
		_textLabel.numberOfLines = 0;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textColor = [UIColor blackColor];
		_textLabel.font = [UIFont boldSystemFontOfSize:BPFontSize];
		_textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_textLabel.isAccessibilityElement = NO;
		[self addSubview:_textLabel];
		
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
	[_annotation release], _annotation = nil;
	
	[_textLabel release], _textLabel = nil;
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
		UIViewController *viewController = [anchorView viewController];
		if (viewController.navigationController != nil) viewController = viewController.navigationController;
		
		if (viewController.presentingViewController != nil && viewController.modalPresentationStyle == UIModalPresentationFullScreen)
		{
			if (viewController.navigationController != nil)
			{
				anchorFrame = [anchorView convertRect:anchorView.bounds toView:viewController.navigationController.view];
			}
			else
			{
				anchorFrame = [anchorView convertRect:anchorView.bounds toView:viewController.view];
			}
		}
		else
		{
			anchorFrame = [anchorView convertRect:anchorView.bounds toView:viewController.view.window.rootViewController.view];
		}
	}
	
	//Figure out the content size
	CGSize contentSize = CGSizeZero;
	if (!BPStringIsEmpty(self.annotation.text))
	{
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
		}
		else
		{
			contentSize = [self.annotation.text sizeWithFont:[UIFont boldSystemFontOfSize:BPFontSize] constrainedToSize:CGSizeMake(BPMaximumWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
		}
	}
	
	contentSize = CGSizeMake(ceil(contentSize.width), ceil(contentSize.height));
	
	//Figure out where the point will be and the balloon rect -- they're in wrapperView coordinates at this point
	CGPoint arrowPoint = CGPointZero;
	CGRect balloonRect = CGRectMake(0.0, 0.0, contentSize.width + BPPaddingLeft + BPPaddingRight, contentSize.height + BPPaddingTop + BPPaddingBottom);
	switch (self.annotation.direction)
	{
		case BPHelpAnnotationDirectionTop:
		{
			arrowPoint = CGPointMake(CGRectGetMidX(anchorFrame), CGRectGetMaxY(anchorFrame));
			balloonRect.origin.x = CGRectGetMidX(anchorFrame) - CGRectGetWidth(balloonRect) / 2 + self.annotation.contentOffset.width;
			balloonRect.origin.y = arrowPoint.y + BPArrowHeight + self.annotation.contentOffset.height;
			
			CGFloat minX = fmin(arrowPoint.x, balloonRect.origin.x);
			CGFloat maxX = fmax(arrowPoint.x, CGRectGetMaxX(balloonRect));
			CGFloat minY = fmin(arrowPoint.y, CGRectGetMinY(balloonRect));
			CGFloat maxY = fmax(arrowPoint.y, CGRectGetMaxY(balloonRect));
			self.frame = CGRectMake(minX, minY, maxX - minX, maxY - minY);
			break;
		}
		case BPHelpAnnotationDirectionRight:
		{
			arrowPoint = CGPointMake(CGRectGetMinX(anchorFrame), CGRectGetMidY(anchorFrame));
			balloonRect.origin.x = arrowPoint.x - BPArrowHeight - CGRectGetWidth(balloonRect) + self.annotation.contentOffset.width;
			balloonRect.origin.y = CGRectGetMidY(anchorFrame) - CGRectGetHeight(balloonRect) / 2 + self.annotation.contentOffset.height;
			
			CGFloat minX = fmin(arrowPoint.x, balloonRect.origin.x);
			CGFloat maxX = fmax(arrowPoint.x, CGRectGetMaxX(balloonRect));
			CGFloat minY = fmin(arrowPoint.y, CGRectGetMinY(balloonRect));
			CGFloat maxY = fmax(arrowPoint.y, CGRectGetMaxY(balloonRect));
			self.frame = CGRectMake(minX, minY, maxX - minX, maxY - minY);
			break;
		}
		case BPHelpAnnotationDirectionBottom:
		{
			arrowPoint = CGPointMake(CGRectGetMidX(anchorFrame), CGRectGetMinY(anchorFrame));
			balloonRect.origin.x = CGRectGetMidX(anchorFrame) - CGRectGetWidth(balloonRect) / 2 + self.annotation.contentOffset.width;
			balloonRect.origin.y = arrowPoint.y - BPArrowHeight - CGRectGetHeight(balloonRect) + self.annotation.contentOffset.height;
			
			CGFloat minX = fmin(arrowPoint.x, balloonRect.origin.x);
			CGFloat maxX = fmax(arrowPoint.x, CGRectGetMaxX(balloonRect));
			CGFloat minY = fmin(arrowPoint.y, CGRectGetMinY(balloonRect));
			CGFloat maxY = fmax(arrowPoint.y, CGRectGetMaxY(balloonRect));
			self.frame = CGRectMake(minX, minY, maxX - minX, maxY - minY);
			break;
		}
		case BPHelpAnnotationDirectionLeft:
		{
			arrowPoint = CGPointMake(CGRectGetMaxX(anchorFrame), CGRectGetMidY(anchorFrame));
			balloonRect.origin.x = arrowPoint.x + BPArrowHeight + self.annotation.contentOffset.width;
			balloonRect.origin.y = CGRectGetMidY(anchorFrame) - CGRectGetHeight(balloonRect) / 2 + self.annotation.contentOffset.height;
			self.frame = CGRectMake(arrowPoint.x, CGRectGetMinY(balloonRect), CGRectGetWidth(balloonRect) + BPArrowHeight, CGRectGetHeight(balloonRect));
			break;
		}
		case BPHelpAnnotationDirectionNone:
			//No point
			balloonRect.origin.x = CGRectGetMidX(anchorFrame) - CGRectGetWidth(balloonRect) / 2 + self.annotation.contentOffset.width;
			balloonRect.origin.y = CGRectGetMidY(anchorFrame) - CGRectGetHeight(balloonRect) / 2 + self.annotation.contentOffset.height;
			self.frame = balloonRect;
			break;
	}
	
	//Convert the arrowPoint and balloonRect to local coordinates
	self.arrowPoint = [self convertPoint:arrowPoint fromView:wrapperView];
	self.balloonRect = CGRectIntegral([self convertRect:balloonRect fromView:wrapperView]);
	
	self.textLabel.frame = CGRectMake(CGRectGetMinX(self.balloonRect) + BPPaddingLeft, CGRectGetMinY(self.balloonRect) + BPPaddingTop, contentSize.width, contentSize.height);
	self.textLabel.text = self.annotation.text;
}

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	UIColor *color1 = [UIColor colorWithRed:0.965 green:0.863 blue:0.482 alpha:0.9];
	UIColor *color2 = [UIColor colorWithRed:0.792 green:0.671 blue:0.286 alpha:0.9];
	
	CGFloat tlX = CGRectGetMinX(self.balloonRect);
	CGFloat tlY = CGRectGetMinY(self.balloonRect);
	CGFloat trX = CGRectGetMaxX(self.balloonRect);
	CGFloat trY = tlY;
	CGFloat blX = tlX;
	CGFloat blY = CGRectGetMaxY(self.balloonRect);
	CGFloat brX = trX;
	CGFloat brY = blY;
	
	switch (self.annotation.direction)
	{
		case BPHelpAnnotationDirectionTop:
		{
			[path moveToPoint:CGPointMake(tlX + BPCornerRadius, tlY)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x - BPArrowWidth / 2, tlY)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x - BPArrowWidth / 2, self.arrowPoint.y + BPArrowHeight)];
			[path addLineToPoint:self.arrowPoint];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x + BPArrowWidth / 2, self.arrowPoint.y + BPArrowHeight)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x + BPArrowWidth / 2, trY)];
			[path addLineToPoint:CGPointMake(trX - BPCornerRadius, trY)];
			[path addArcWithCenter:CGPointMake(trX - BPCornerRadius, trY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 * 3 endAngle:0 clockwise:YES];
			[path addLineToPoint:CGPointMake(brX, brY - BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(brX - BPCornerRadius, brY - BPCornerRadius) radius:BPCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
			[path addLineToPoint:CGPointMake(blX + BPCornerRadius, blY)];
			[path addArcWithCenter:CGPointMake(blX + BPCornerRadius, blY - BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
			[path addLineToPoint:CGPointMake(tlX, tlY + BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(tlX + BPCornerRadius, tlY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
			break;
		}
		case BPHelpAnnotationDirectionRight:
		{
			[path moveToPoint:CGPointMake(tlX + BPCornerRadius, tlY)];
			[path addLineToPoint:CGPointMake(trX - BPCornerRadius, trY)];
			[path addArcWithCenter:CGPointMake(trX - BPCornerRadius, trY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 * 3 endAngle:0 clockwise:YES];
			
			[path addLineToPoint:CGPointMake(trX, self.arrowPoint.y - BPArrowWidth / 2)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x - BPArrowHeight, self.arrowPoint.y - BPArrowWidth / 2)];
			[path addLineToPoint:self.arrowPoint];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x - BPArrowHeight, self.arrowPoint.y + BPArrowWidth / 2)];
			[path addLineToPoint:CGPointMake(brX, self.arrowPoint.y + BPArrowWidth / 2)];
			
			[path addLineToPoint:CGPointMake(brX, brY - BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(brX - BPCornerRadius, brY - BPCornerRadius) radius:BPCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
			[path addLineToPoint:CGPointMake(blX + BPCornerRadius, blY)];
			[path addArcWithCenter:CGPointMake(blX + BPCornerRadius, blY - BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
			[path addLineToPoint:CGPointMake(tlX, tlY + BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(tlX + BPCornerRadius, tlY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
			break;
		}
		case BPHelpAnnotationDirectionBottom:
		{
			[path moveToPoint:CGPointMake(tlX + BPCornerRadius, tlY)];
			[path addLineToPoint:CGPointMake(trX - BPCornerRadius, trY)];
			[path addArcWithCenter:CGPointMake(trX - BPCornerRadius, trY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 * 3 endAngle:0 clockwise:YES];
			[path addLineToPoint:CGPointMake(brX, brY - BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(brX - BPCornerRadius, brY - BPCornerRadius) radius:BPCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x + BPArrowWidth / 2, brY)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x + BPArrowWidth / 2, self.arrowPoint.y - BPArrowHeight)];
			[path addLineToPoint:self.arrowPoint];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x - BPArrowWidth / 2, self.arrowPoint.y - BPArrowHeight)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x - BPArrowWidth / 2, blY)];
			[path addLineToPoint:CGPointMake(blX + BPCornerRadius, blY)];
			[path addArcWithCenter:CGPointMake(blX + BPCornerRadius, blY - BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
			[path addLineToPoint:CGPointMake(tlX, tlY + BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(tlX + BPCornerRadius, tlY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
			break;
		}
		case BPHelpAnnotationDirectionLeft:
		{
			[path moveToPoint:CGPointMake(tlX + BPCornerRadius, tlY)];
			[path addLineToPoint:CGPointMake(trX - BPCornerRadius, trY)];
			[path addArcWithCenter:CGPointMake(trX - BPCornerRadius, trY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 * 3 endAngle:0 clockwise:YES];
			[path addLineToPoint:CGPointMake(brX, brY - BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(brX - BPCornerRadius, brY - BPCornerRadius) radius:BPCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
			[path addLineToPoint:CGPointMake(blX + BPCornerRadius, blY)];
			[path addArcWithCenter:CGPointMake(blX + BPCornerRadius, blY - BPCornerRadius) radius:BPCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
			
			[path addLineToPoint:CGPointMake(blX, self.arrowPoint.y + BPArrowWidth / 2)];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x + BPArrowHeight, self.arrowPoint.y + BPArrowWidth / 2)];
			[path addLineToPoint:self.arrowPoint];
			[path addLineToPoint:CGPointMake(self.arrowPoint.x + BPArrowHeight, self.arrowPoint.y - BPArrowWidth / 2)];
			[path addLineToPoint:CGPointMake(tlX, self.arrowPoint.y - BPArrowWidth / 2)];
			
			[path addLineToPoint:CGPointMake(tlX, tlY + BPCornerRadius)];
			[path addArcWithCenter:CGPointMake(tlX + BPCornerRadius, tlY + BPCornerRadius) radius:BPCornerRadius startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
			break;
		}
		case BPHelpAnnotationDirectionNone:
			path = [UIBezierPath bezierPathWithRoundedRect:self.balloonRect cornerRadius:BPCornerRadius];
			break;
	}
	
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
