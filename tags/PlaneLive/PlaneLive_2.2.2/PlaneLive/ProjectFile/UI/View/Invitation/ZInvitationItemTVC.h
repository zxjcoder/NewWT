//
//  ZInvitationItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZInvitationItemTVC : ZBaseTVC

@property (copy, nonatomic) void(^onInvitationClick)(ModelUserInvitation *model, ZInvitationItemTVC *tvc);

@end
