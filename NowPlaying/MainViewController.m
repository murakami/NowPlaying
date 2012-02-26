//
//  MainViewController.m
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MainViewController.h"

@interface MainViewController ()
- (void)toggleSongTitle;
- (void)toggleArtist;
- (void)toggleAlbumTitle;
- (void)toggleArtwork;
- (void)updateItem;
- (void)didSongChanged:(NSNotification *)notification;
@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize document = _document;
@synthesize infoButton = _infoButton;
@synthesize songTitle = _songTitle;
@synthesize artist = _artist;
@synthesize albumTitle = _albumTitle;
@synthesize artworkImageView = _artworkImageView;
@synthesize musicPlayer = _musicPlayer;
@synthesize bannerView = bannerView_;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate	*appl = nil;
	appl = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	self.document = appl.document;
    
    self.artworkImageView.layer.masksToBounds = YES;
    self.artworkImageView.layer.cornerRadius = 4.0f;
    self.artworkImageView.layer.borderWidth = 3.0f;
    self.artworkImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self updateItem];
    
    _musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    [self didSongChanged:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSongChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.musicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];

    // Create a view of the standard size at the bottom of the screen.
    self.bannerView = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    self.bannerView.adUnitID = @"a14f4244f3bf0f7";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];
    
    // Initiate a generic request to load it with an ad.
#ifdef	ADMOB_TESTDRIVE
    GADRequest  *request = [GADRequest request];
    
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           @"106cc33b2ebf0a0ca4ac485b14c8ac0c83b84415",
                           @"4935d1b01126293b035587a1f360286e45dd8943",
                           nil];
    [bannerView_ loadRequest:request];
#else   /* ADMOB_TESTDRIVE */
    [self.bannerView loadRequest:[GADRequest request]];
#endif  /* ADMOB_TESTDRIVE */
    
    self.bannerView.delegate = self;
}

- (void)viewDidUnload
{
    self.document = nil;
    
    [self.musicPlayer endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.songTitle = nil;
    self.artist = nil;
    self.albumTitle = nil;
    self.artworkImageView = nil;
    self.musicPlayer = nil;
    
    self.bannerView.delegate = nil;
    self.bannerView = nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self didSongChanged:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint currentPoint = [touch locationInView:touch.view];
        if (touch.view == self.songTitle) {
            DBGMSG(@"%s, songTitle, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
        }
        else if (touch.view == self.artist) {
            DBGMSG(@"%s, artist, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
        }
        else if (touch.view == self.albumTitle) {
            DBGMSG(@"%s, albumTitle, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
        }
        else if (touch.view == self.artworkImageView) {
            DBGMSG(@"%s, artworkImageView, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
        }
        else {
            DBGMSG(@"%s, none, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects]) {
        CGPoint currentPoint = [touch locationInView:touch.view];
        CGRect  bounds = touch.view.bounds;
        CGSize  size = bounds.size;
        if (touch.view == self.songTitle) {
            DBGMSG(@"%s, songTitle, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
            if ((0.0 <= currentPoint.x) && (currentPoint.x < size.width)
                && (0.0 <= currentPoint.y) && (currentPoint.y < size.height)) {
                DBGMSG(@"    in!");
                [self toggleSongTitle];
            }
            else {
                DBGMSG(@"    out!");
            }
        }
        else if (touch.view == self.artist) {
            DBGMSG(@"%s, artist, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
            if ((0.0 <= currentPoint.x) && (currentPoint.x < size.width)
                && (0.0 <= currentPoint.y) && (currentPoint.y < size.height)) {
                DBGMSG(@"    in!");
                [self toggleArtist];
            }
            else {
                DBGMSG(@"    out!");
            }
        }
        else if (touch.view == self.albumTitle) {
            DBGMSG(@"%s, albumTitle, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
            if ((0.0 <= currentPoint.x) && (currentPoint.x < size.width)
                && (0.0 <= currentPoint.y) && (currentPoint.y < size.height)) {
                DBGMSG(@"    in!");
                [self toggleAlbumTitle];
            }
            else {
                DBGMSG(@"    out!");
            }
        }
        else if (touch.view == self.artworkImageView) {
            DBGMSG(@"%s, artworkImageView, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
            if ((0.0 <= currentPoint.x) && (currentPoint.x < size.width)
                && (0.0 <= currentPoint.y) && (currentPoint.y < size.height)) {
                DBGMSG(@"    in!");
                [self toggleArtwork];
            }
            else {
                DBGMSG(@"    out!");
            }
        }
        else {
            DBGMSG(@"%s, none, location(%5.1f, %5.1f)", __func__, currentPoint.x, currentPoint.y);
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark - Tweet

- (IBAction)tweet:(id)sender
{
    BOOL    flagEnable = NO;

    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"#nowplaying"];
    UIImage *artworkImage = nil;
    if (self.musicPlayer.nowPlayingItem) {
        NSString    *title = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        if (title && self.document.selectedSongTitle) {
            [str appendString:@" ♪ "];
            [str appendString:title];
            flagEnable = YES;
        }
        NSString    *artist = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        if (artist && self.document.selectedArtist) {
            [str appendString:@" - "];
            [str appendString:artist];
            flagEnable = YES;
        }
        NSString    *albumTitle = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (albumTitle && self.document.selectedAlbumTitle) {
            [str appendString:@" ["];
            [str appendString:albumTitle];
            [str appendString:@"]"];
            flagEnable = YES;
        }
        MPMediaItemArtwork  *artwork = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork && self.document.selectedArtwork) {
            artworkImage = [artwork imageWithSize:CGSizeMake(32.0, 32.0)];
        }
    }
    [tweetViewController setInitialText:str];
    if (artworkImage) {
        BOOL    result = [tweetViewController addImage:artworkImage];
        DBGMSG(@"addImage:%d", (int)result);
    }
    
    if (! flagEnable) {
        DBGMSG(@"%s, (none)", __func__);
        return;
    }
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        /*
        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        */
        NSLog(@"%@", output);
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}

#pragma mark - extensions

- (void)toggleSongTitle
{
    if (self.document.selectedSongTitle) {
        self.document.selectedSongTitle = NO;
        self.songTitle.textColor = [UIColor lightGrayColor];
    }
    else {
        self.document.selectedSongTitle = YES;
        self.songTitle.textColor = [UIColor whiteColor];
    }
    [self updateItem];
}

- (void)toggleArtist
{
    if (self.document.selectedArtist) {
        self.document.selectedArtist = NO;
    }
    else {
        self.document.selectedArtist = YES;
    }
    [self updateItem];
}

- (void)toggleAlbumTitle
{
    if (self.document.selectedAlbumTitle) {
        self.document.selectedAlbumTitle = NO;
    }
    else {
        self.document.selectedAlbumTitle = YES;
    }
    [self updateItem];
}

- (void)toggleArtwork
{
    if (self.document.selectedArtwork) {
        self.document.selectedArtwork = NO;
    }
    else {
        self.document.selectedArtwork = YES;
    }
    [self updateItem];
}

- (void)updateItem
{
    if (self.document.selectedSongTitle) {
        self.songTitle.textColor = [UIColor blueColor];
    }
    else {
        self.songTitle.textColor = [UIColor lightGrayColor];
    }
    
    if (self.document.selectedArtist) {
        self.artist.textColor = [UIColor blueColor];
    }
    else {
        self.artist.textColor = [UIColor lightGrayColor];
    }
    
    if (self.document.selectedAlbumTitle) {
        self.albumTitle.textColor = [UIColor blueColor];
    }
    else {
        self.albumTitle.textColor = [UIColor lightGrayColor];
    }
    
    if (self.document.selectedArtwork) {
        self.artworkImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    }
    else {
        self.artworkImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
}

- (void)didSongChanged:(NSNotification *)notification
{
    if (self.musicPlayer.nowPlayingItem) {
        NSString    *title = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        self.songTitle.text = title;
        NSString    *artist = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        self.artist.text = artist;
        NSString    *albumTitle = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        self.albumTitle.text = albumTitle;
        MPMediaItemArtwork  *artwork = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:self.artworkImageView.frame.size];
            if (artworkImage) {
                self.artworkImageView.image = artworkImage;
            }
            else {
                self.artworkImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none" ofType:@"png"]];
            }
        }
        else {
            self.artworkImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none" ofType:@"png"]];
        }
    }
    else {
        self.songTitle.text = @"(none)";
        self.artist.text = @"(none)";
        self.albumTitle.text = @"(none)";
    }
}

#pragma mark -
#pragma mark AdMobDelegate methods

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    DBGMSG(@"%s", __func__);
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height - bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    self.infoButton.frame = CGRectMake(self.infoButton.frame.origin.x,
                                      421.0 - bannerView.frame.size.height,
                                      self.infoButton.frame.size.width,
                                      self.infoButton.frame.size.height);
    [UIView commitAnimations];
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error
{
    DBGMSG(@"%s", __func__);
    //DBGMSG(@"adView:didFailToReceiveAdWithError:%@", error localizedDescription]);
    [UIView beginAnimations:@"animateAdMobBannerOff" context:NULL];
    self.infoButton.frame = CGRectMake(self.infoButton.frame.origin.x,
                                      421.0,
                                      self.infoButton.frame.size.width,
                                      self.infoButton.frame.size.height);
     [UIView commitAnimations];
}

@end
