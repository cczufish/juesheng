//
//  RoomViewController.h
//  AnyChat
//
//  Created by bairuitech on 13-7-5.
//
//

#import <UIKit/UIKit.h>
#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"
#import "AnyChatMaindelegete.h"

@interface RoomViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, AnyChatNotifyMessageDelegate>
{
    IBOutlet UITableView *onlineUserTable;
    NSMutableArray *onlineUserList;
    AnyChatPlatform *anychat;
    int iCurrentChatUserId;
}

@property (nonatomic, retain) IBOutlet UITableView *onlineUserTable;
@property (nonatomic, retain) NSMutableArray *onlineUserList;
@property (nonatomic, retain) id<AnyChatMaindelegete> delegate;


-(void) RefreshRoomUserList;

- (IBAction) OnLeaveRoomBtnClicked:(id)sender;

@end

