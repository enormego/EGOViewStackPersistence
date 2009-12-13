//
//  EGOViewStackPersistenceController.h
//  EGOViewStackPersistence
//
//  Created by Shaun Harrison on 12/13/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGOViewStackPersistenceController : NSObject {
@private
	NSString* __cachedFile;
	BOOL _discardOnVersionChange;
}

+ (EGOViewStackPersistenceController*)sharedViewStackPersistenceController;

- (void)freezeViewController:(UIViewController*)viewController;
- (void)restoreViewController:(UIViewController*)viewController;

/**
 *	If YES, requires frozen state version to match the current bundle version.
 *	Leaving this as YES is recommended, since view hiarchies and properties
 *	can change from version to version
 *
 *	Default: YES
 */
@property(nonatomic,assign) BOOL discardOnVersionChange;
@end
