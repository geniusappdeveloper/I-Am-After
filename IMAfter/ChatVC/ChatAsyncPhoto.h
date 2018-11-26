//
//  ChatAsyncPhoto.h
//  Epiwell
//
//  Created by Manvir singh on 28/01/18.
//  Copyright © 2018 Manvir singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQPhotoMediaItem.h>


@interface ChatAsyncPhoto : JSQPhotoMediaItem


@property (nonatomic, strong) UIImageView *asyncImageView;

- (instancetype)initWithURL:(NSURL *)URL;
@end
