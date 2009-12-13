//
//  UIViewControllerPersistent.h
//  EGOViewStackPersistence
//
//  Created by Shaun Harrison on 12/13/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (EGOViewStackPersistence)

- (void)restoreViewController:(NSCoder*)aDecoder;
- (void)freezeViewController:(NSCoder*)aCoder;

@end
