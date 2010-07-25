//
//  EGOViewStackPersistenceController.m
//  EGOViewStackPersistence
//
//  Created by Shaun Harrison on 12/13/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "EGOViewStackPersistenceController.h"
#import "UIViewControllerPersistent.h"

static id __instance;
#define BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

@implementation EGOViewStackPersistenceController
@synthesize discardOnVersionChange=_discardOnVersionChange;

+ (EGOViewStackPersistenceController*)sharedViewStackPersistenceController {
	@synchronized(self) {
		if(!__instance) {
			__instance = [[[self class] alloc] init];	
		}
	}
	
	return __instance;
}

- (id)init {
	if((self = [super init])) {
		__cachedFile = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
															  NSUserDomainMask,
															  YES) lastObject]
						 stringByAppendingPathComponent:@"EGOViewStackPersistence.plist"] retain];		
		
	}
	
	return self;
}

- (void)freezeViewController:(UIViewController*)viewController {
	NSMutableData* encodedData = [[NSMutableData alloc] init];
	NSKeyedArchiver* coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:encodedData];
	[viewController freezeViewController:coder];
	
	[coder encodeObject:BUNDLE_VERSION forKey:@"kBundleVersion"];
	[coder finishEncoding];
	
	[encodedData writeToFile:__cachedFile atomically:YES];
	[encodedData release];
}

- (void)restoreViewController:(UIViewController*)viewController {
	if(![[NSFileManager defaultManager] fileExistsAtPath:__cachedFile]) return;

	NSError* error = NULL;
	NSData* encodedData = [NSData dataWithContentsOfFile:__cachedFile options:0 error:&error];
	
	if(error || encodedData.length == 0) return;
	
	NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:encodedData];
	
	if(!self.discardOnVersionChange || [BUNDLE_VERSION isEqual:[decoder decodeObjectForKey:@"kBundleVersion"]]) {
		[viewController restoreViewController:decoder];
	}
	
	[decoder finishDecoding];
	[decoder release];
}

- (void)dealloc {
	[__cachedFile release];
	[super dealloc];
}

@end
