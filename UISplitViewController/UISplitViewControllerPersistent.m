//
//  UISplitViewControllerPersistent.m
//  EGOViewStackPersistence
//
//  Created by Shaun Harrison on 5/2/10.
//  Copyright 2010 enormego. All rights reserved.
//

#import "UISplitViewControllerPersistent.h"

#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED

@implementation UISplitViewController (EGOViewStackPersistence)

- (void)restoreViewController:(NSCoder*)aDecoder {
	[super restoreViewController:aDecoder];
	
	NSArray* frozenViewControllers = [aDecoder decodeObjectForKey:@"kFrozenViewControllers"];

	// Data was corrupted
	if(![frozenViewControllers isKindOfClass:[NSArray class]]) return;
	if(self.viewControllers.count != frozenViewControllers.count) return;
	
	NSUInteger index = 0;
	for(UIViewController* viewController in self.viewControllers) {
		NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:[frozenViewControllers objectAtIndex:index]];
		[viewController restoreViewController:decoder];
		[decoder finishDecoding];
		[decoder release];
		index++;
	}
}

- (void)freezeViewController:(NSCoder*)aCoder {
	NSMutableArray* frozenViewControllers = [[NSMutableArray alloc] initWithCapacity:self.viewControllers.count];
	
	for(UIViewController* viewController in self.viewControllers) {
		NSMutableData* encodedData = [[NSMutableData alloc] init];
		NSKeyedArchiver* coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:encodedData];
		[viewController freezeViewController:coder];
		[coder finishEncoding];
		[coder release];
		
		[frozenViewControllers addObject:encodedData];
		[encodedData release];
	}
	
	[aCoder encodeObject:frozenViewControllers forKey:@"kFrozenViewControllers"];
	[super freezeViewController:aCoder];
}

@end

#endif