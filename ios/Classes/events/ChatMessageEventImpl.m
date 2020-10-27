//  ----------------------------------------------------------------------
//  Copyright (C) 2020  即时通讯网(52im.net) & Jack Jiang.
//  The MobileIMSDK_X (MobileIMSDK v4.x) Project.
//  All rights reserved.
//
//  > Github地址: https://github.com/JackJiang2011/MobileIMSDK
//  > 文档地址:    http://www.52im.net/forum-89-1.html
//  > 技术社区：   http://www.52im.net/
//  > 技术交流群： 320837163 (http://www.52im.net/topic-qqgroup.html)
//  > 作者公众号： “即时通讯技术圈】”，欢迎关注！
//  > 联系作者：   http://www.52im.net/thread-2792-1-1.html
//
//  "即时通讯网(52im.net) - 即时通讯开发者社区!" 推荐开源工程。
//  ----------------------------------------------------------------------

#import "ChatMessageEventImpl.h"
#import "ErrorCode.h"
#import "AutoReLoginDaemon.h"


@interface ChatMessageEventImpl()

@property (strong, nonatomic) FlutterMethodChannel *channel;

@end

/**
 * 与IM服务器的数据交互事件在此ChatTransDataEvent子类中实现即可。
 *
 * @author Jack Jiang, 20170501
 * @version.1.1
 */
@implementation ChatMessageEventImpl

- (instancetype)initWithChannel: (FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        self.channel = channel;
    }
    return self;
}

/*!
 * 收到普通消息的回调事件通知。
 * <br>
 * 应用层可以将此消息进一步按自已的IM协议进行定义，从而实现完整的即时通信软件逻辑。
 *
 * @param fingerPrintOfProtocal 当该消息需要QoS支持时本回调参数为该消息的特征指纹码，否则为null
 * @param userid 消息的发送者id（RainbowCore框架中规定发送者id=“0”即表示是由服务端主动发过的，否则表示的是其它客户端发过来的消息）
 * @param dataContent 消息内容的文本表示形式
 */

- (void)onTransBuffer:(NSString *)fingerPrintOfProtocal withUserId:(NSString *)userid andContent:(NSString *)dataContent andTypeu:(int)typeu {
    NSLog(@"xxxxxxx【DEBUG_UI】[%d]收到来自用户%@的消息:%@===%@", typeu, userid, dataContent,self.channel);
    [self.channel invokeMethod: @"onReceiveMessage" arguments: dataContent];
}

/*!
 * 服务端反馈的出错信息回调事件通知。
 *
 * @param errorCode 错误码，定义在常量表 ErrorCode 中有关服务端错误码的定义
 * @param errorMsg 描述错误内容的文本信息
 * @see ErrorCode
 */
- (void)onErrorResponse:(int)errorCode withErrorMsg:(NSString *)errorMsg {
    
    // UI显示
    NSString *content;
    if(errorCode == ForS_RESPONSE_FOR_UNLOGIN)
    {
        content = [NSString stringWithFormat:@"服务端会话已失效，自动登陆/重连启动! (%d)", errorCode];
    }
    else
    {
        content = [NSString stringWithFormat:@"Server反馈错误码：%d,errorMsg=%@", errorCode, errorMsg];
    }
    NSLog(@"【DEBUG_UI】收到服务端错误消息，errorCode=%d, errorMsg=%@ ,content =%@", errorCode, errorMsg, content);
}

@end
