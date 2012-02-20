//
//  MainViewController.m
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
- (void)didSongChanged:(NSNotification *)notification;
@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
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

#pragma mark - Tweet
- (IBAction)tweet:(id)sender
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"#nowplaying"];
    if (self.musicPlayer.nowPlayingItem) {
        NSString    *title = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        if (title) {
            [str appendString:@" ♪ "];
            [str appendString:title];
        }
        NSString    *artist = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        if (artist) {
            [str appendString:@" - "];
            [str appendString:artist];
        }
        NSString    *albumTitle = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (albumTitle) {
            [str appendString:@" ["];
            [str appendString:albumTitle];
            [str appendString:@"]"];
        }
    }
    [tweetViewController setInitialText:str];
    
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
