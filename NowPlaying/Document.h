//
//  Document.h
//  NowPlaying
//
//  Created by 村上 幸雄 on 12/02/26.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (assign, nonatomic) BOOL          selectedSongTitle;
@property (assign, nonatomic) BOOL          selectedArtist;
@property (assign, nonatomic) BOOL          selectedAlbumTitle;
@property (assign, nonatomic) BOOL          selectedArtwork;
@property (assign, nonatomic) NSUInteger    starsNum;

- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;
@end
