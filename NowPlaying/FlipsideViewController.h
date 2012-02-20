//
//  FlipsideViewController.h
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet id <FlipsideViewControllerDelegate>    delegate;
@property (strong, nonatomic) GADBannerView                                 *bannerView;

- (IBAction)done:(id)sender;

@end
