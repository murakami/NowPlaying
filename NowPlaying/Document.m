//
//  Document.m
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/02/26.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "Document.h"

@interface Document ()
@end

@implementation Document

@synthesize selectedSongTitle = _selectedSongTitle;
@synthesize selectedArtist = _selectedArtist;
@synthesize selectedAlbumTitle = _selectedAlbumTitle;
@synthesize selectedArtwork = _selectedArtwork;

- (id)init
{
    DBGMSG(@"%s", __func__);
	if ((self = [super init]) != nil) {
        self.selectedSongTitle = YES;
        self.selectedArtist = YES;
        self.selectedAlbumTitle = YES;
        self.selectedArtwork = NO;
	}
	return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
	//[super dealloc];
}

- (void)clearDefaults
{
}

- (void)updateDefaults
{
}

- (void)loadDefaults
{
}

@end
