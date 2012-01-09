//
//  MainViewController.h
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
