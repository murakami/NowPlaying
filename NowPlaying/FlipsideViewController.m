//
//  FlipsideViewController.m
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/01/09.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()
@end

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize bannerView = bannerView_;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

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
    /* return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown); */
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
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
    [UIView commitAnimations];
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error
{
    DBGMSG(@"%s", __func__);
    //DBGMSG(@"adView:didFailToReceiveAdWithError:%@", error localizedDescription]);
}

@end
