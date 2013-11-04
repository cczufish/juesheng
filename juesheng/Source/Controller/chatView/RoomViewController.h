//
//  RoomViewController.h
//  AnyChat
//
//  Created by bairuitech on 13-7-5.
//
//

#import "Three20UI/Three20UI.h"
#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"

@interface RoomViewController : TTViewController<UITableViewDelegate, UITableViewDataSource, AnyChatNotifyMessageDelegate>
{
    IBOutlet UITableView *onlineUserTable;
    NSMutableArray *onlineUserList;
    AnyChatPlatform *anychat;
    int iCurrentChatUserId;
    NSNumber *_classType;
    NSNumber *_fId;
    NSNumber *_fRoomId;
}

@property (nonatomic, retain) IBOutlet UITableView *onlineUserTable;
@property (nonatomic, retain) NSMutableArray *onlineUserList;
@property (nonatomic, retain) NSNumber *classType;
@property (nonatomic, retain) NSNumber *fId;

-(void) RefreshRoomUserList;

- (void) OnLeaveRoomBtnClicked:(id)sender;
- (id)initWithURL:(NSURL *)URL query:(NSDictionary *)query;
@end

