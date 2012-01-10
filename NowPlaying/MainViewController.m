//
//  MainViewController.m
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MainViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize songTitle = _songTitle;
@synthesize artist = _artist;
@synthesize albumTitle = _albumTitle;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if (musicPlayer.nowPlayingItem) {
        NSLog(@"#nowplaying");
        NSString    *title = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        self.songTitle.text = title;
        NSLog(@"title: %@", title);
        NSString    *artist = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        self.artist.text = artist;
        NSLog(@"artist: %@", artist);
        NSString    *albumTitle = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        self.albumTitle.text = albumTitle;
        NSLog(@"albumTitle: %@", albumTitle);
    }
    else {
        NSLog(@"nowPlayingItem is nil.");
    }
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
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"Hello. This is a tweet."];
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    if (musicPlayer.nowPlayingItem) {
        [str setString:@"#nowplaying"];
        NSLog(@"#nowplaying");
        NSString    *title = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        if (title) {
            [str appendString:@" "];
            [str appendString:title];
        }
        NSLog(@"title: %@", title);
        NSString    *artist = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        if (artist) {
            [str appendString:@" - "];
            [str appendString:artist];
        }
        NSLog(@"artist: %@", artist);
        NSString    *albumTitle = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        if (albumTitle) {
            [str appendString:@" ["];
            [str appendString:albumTitle];
            [str appendString:@"]"];
        }
        NSLog(@"albumTitle: %@", albumTitle);
    }
    else {
        NSLog(@"nowPlayingItem is nil.");
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
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}

@end
