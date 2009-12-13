//
//  UINavigationControllerPersistent.m
//  EGOViewStackPersistence
//
//  Created by Shaun Harrison on 12/13/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "UINavigationControllerPersistent.h"


@implementation UINavigationController (EGOViewStackPersistence)

- (void)restoreViewController:(NSCoder*)aDecoder {
	[super restoreViewController:aDecoder];
	
	NSArray* frozenViewControllers = [aDecoder decodeObjectForKey:@"kFrozenViewControllers"];
	
	if(![frozenViewControllers isKindOfClass:[NSArray class]]) return;
	
	if(self.viewControllers.count > 1) {
		/**
		 *	We restore the rootViewController to support nibs fully, however
		 *	anything more than that, is a bit risky.
		 */
		return;
	}
	
	
	BOOL restoreRootViewController = self.viewControllers.count == 1;

	NSMutableArray* restoredViewControllers = [[NSMutableArray alloc] initWithCapacity:frozenViewControllers.count];
	for(NSData* encodedData in frozenViewControllers) {
		NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:encodedData];
		
		UIViewController* viewController = nil;
		Class class = NSClassFromString([decoder decodeObjectForKey:@"kClassName"]);
		
		if(restoreRootViewController) {
			viewController = [[self.viewControllers objectAtIndex:0] retain];
			NSLog(@"Restoring rootViewController: %@", viewController);
			[viewController restoreViewController:aDecoder];
			restoreRootViewController = NO;
		} else if([decoder containsValueForKey:@"kTableViewSyle"]) {
			viewController = [(UITableViewController*)[class alloc] initWithStyle:[decoder decodeIntegerForKey:@"kTableViewSyle"]];
		} else {
			viewController = [[class alloc] init];
		}
		
		[viewController restoreViewController:decoder];
		[restoredViewControllers addObject:viewController];
		[viewController release];
		
		[decoder finishDecoding];
		[decoder release];
	}
	
	[self setViewControllers:restoredViewControllers animated:NO];
	[restoredViewControllers release];
}

- (void)freezeViewController:(NSCoder*)aCoder {
	NSMutableArray* frozenViewControllers = [[NSMutableArray alloc] initWithCapacity:self.viewControllers.count];
	
	for(UIViewController* viewController in self.viewControllers) {
		NSMutableData* encodedData = [[NSMutableData alloc] init];
		NSKeyedArchiver* coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:encodedData];
		[coder encodeObject:NSStringFromClass([viewController class]) forKey:@"kClassName"];
		
		if([viewController isKindOfClass:[UITableViewController class]]) {
			[coder encodeInteger:((UITableViewController*)viewController).tableView.style forKey:@"kTableViewSyle"];
		}
		
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
