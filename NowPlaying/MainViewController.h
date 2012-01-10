//
//  MainViewController.h
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel  *songTitle;
@property (strong, nonatomic) IBOutlet UILabel  *artist;
@property (strong, nonatomic) IBOutlet UILabel  *albumTitle;

- (IBAction)tweet:(id)sender;

@end
