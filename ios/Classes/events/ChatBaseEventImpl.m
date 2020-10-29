#import "ChatBaseEventImpl.h"
#import "AutoReLoginDaemon.h"

@interface ChatBaseEventImpl()

@property (strong, nonatomic) FlutterMethodChannel *channel;

@end

/**
 * 与IM服务器的连接事件在此ChatBaseEvent子类中实现即可。
 *
 * @author Jack Jiang, 20170501
 * @version.1.1
 */
@implementation ChatBaseEventImpl

- (instancetype)initWithChannel: (FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        self.channel = channel;
    }
    return self;
}


- (void)onLoginMessage:(int)dwErrorCode {
    if (dwErrorCode == 0) {
        NSLog(@"【DEBUG_UI】IM服务器登录/连接成功！");
        // UI显示
    } else {
        NSLog(@"【DEBUG_UI】IM服务器登录/连接失败，错误代码：%d", dwErrorCode);
        // UI显示
    }
    
    // 此观察者只有开启程序首次使用登陆界面时有用
    if(self.loginOkForLaunchObserver != nil)
    {
        self.loginOkForLaunchObserver(nil, [NSNumber numberWithInt:dwErrorCode]);
        
        //## Try bug FIX! 20160810：上方的observer作为block代码应是被异步执行，此处立即设置nil的话，实测
        //##                        中会遇到怎么也登陆不进去的问题（因为此observer已被过早的nil了！）
//      self.loginOkForLaunchObserver = nil;
    }
}

- (void)onLinkCloseMessage:(int)dwErrorCode {
    NSLog(@"【DEBUG_UI】与IM服务器的网络连接出错关闭了，error：%d", dwErrorCode);
    // UI显示
}

@end
