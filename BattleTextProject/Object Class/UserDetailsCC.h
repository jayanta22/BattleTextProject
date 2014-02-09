//
//  UserDetailsCC.h
//  BattleTextProject
//
//   Created by freelancer on 22/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloaderCC.h"

@interface UserDetailsCC : NSObject

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *totalWin;
@property(nonatomic,retain) NSString *weeklyScore;
@property(nonatomic,assign) BOOL challengeUser;
@property(nonatomic,retain) NSString *thumbImgLink;
@property(nonatomic,retain) NSString *imgLink;
@property(nonatomic,retain) NSString *grpName;
@property(nonatomic,retain) NSString *grpID;
@property(nonatomic,retain) UIImage *imgLeader;
@property(nonatomic, retain)NSString *usderID;
@property (nonatomic, readwrite)int playerStatus;
@property (nonatomic, retain)NSString *gameToken;
@property (nonatomic, retain)NSString *minDuration;
@property(nonatomic,retain) ImageDownloaderCC *imgIconObj;

@end
