// NSArray+BPContextualHelp.m
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

#import "NSArray+BPContextualHelp.h"

BOOL BPArrayIsEmpty(NSArray *a)
{
	return (a == nil || a == (id) [NSNull null] || ![a isKindOfClass:[NSArray class]] || [a count] == 0);
}

@implementation NSArray (BPExtensions)

+ (instancetype)arrayWithArrays:(NSArray *)array, ...
{
	if (array == nil)
	{
		return [self array];
	}
	
	NSMutableArray *finalArray = [NSMutableArray arrayWithCapacity:array.count];
	[finalArray addObjectsFromArray:array];
	NSArray *sourceArray = nil;
	va_list args;
	va_start(args, array);
	while ((sourceArray = va_arg(args, NSArray *)))
	{
		[finalArray addObjectsFromArray:sourceArray];
	}
	va_end(args);
	return [self arrayWithArray:finalArray];
}

- (NSMutableArray *)mutableVersion
{
	NSData *data = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
	return [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
}

- (NSArray *)arrayByRemovingObject:(id)anObject
{
	if (anObject == nil)
	{
		return self;
	}
	
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];
	[array removeObject:anObject];
	return array;
}

- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)removals
{
	if (BPArrayIsEmpty(removals))
	{
		return self;
	}
	
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];
	for (id obj in removals)
	{
		[array removeObject:obj];
	}
	return array;
}

- (NSArray *)filteredArrayUsingBlock:(BPArrayFilteringBlock)filteringBlock
{
	NSMutableArray *subarray = [NSMutableArray arrayWithCapacity:[self count]];
	for (id item in self)
	{
		if (filteringBlock(item))
		{
			[subarray addObject:item];
		}
	}
	
	return subarray;
}



@end
