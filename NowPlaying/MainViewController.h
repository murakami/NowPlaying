//
//  MainViewController.h
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "Document.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, GADBannerViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) Document                  *document;
@property (strong, nonatomic) IBOutlet UIButton         *infoButton;
@property (strong, nonatomic) IBOutlet UILabel          *songTitle;
@property (strong, nonatomic) IBOutlet UILabel          *artist;
@property (strong, nonatomic) IBOutlet UILabel          *albumTitle;
@property (strong, nonatomic) IBOutlet UIImageView      *artworkImageView;
@property (strong, nonatomic) MPMusicPlayerController   *musicPlayer;
@property (strong, nonatomic) GADBannerView             *bannerView;

- (IBAction)tweet:(id)sender;

@end
