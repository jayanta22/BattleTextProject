//
//  ShopObjectCC.h
//  BattleTextProject
//
//   Created by freelancer on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloaderCC.h"

@interface ShopObjectCC : NSObject
@property (nonatomic,retain) NSString *idChances;
@property (nonatomic,retain) NSString *itemType;
@property (nonatomic,retain) NSString *item;
@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *imageLink;
@property (nonatomic,retain) UIImage *imgThumb;
@property (nonatomic,retain) NSString *chances;
@property (nonatomic,retain) ImageDownloaderCC *imgObject;

@end
