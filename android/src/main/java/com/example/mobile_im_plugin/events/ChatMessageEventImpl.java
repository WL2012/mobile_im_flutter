package com.example.mobile_im_plugin.events;

import android.content.Context;
import android.util.Log;

import net.x52im.mobileimsdk.android.event.ChatMessageEvent;
import net.x52im.mobileimsdk.server.protocal.ErrorCode;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class ChatMessageEventImpl implements ChatMessageEvent {
    private final static String TAG = ChatMessageEventImpl.class.getSimpleName();
    private Context mainGUI = null;
    private MethodChannel channel;
    public ChatMessageEventImpl(MethodChannel channel) {
        this.channel = channel;
    }
    /**
     * 收到普通消息的回调事件通知。
     * <br>应用层可以将此消息进一步按自已的IM协议进行定义，从而实现完整的即时通信软件逻辑。
     *
     * @param fingerPrintOfProtocal 当该消息需要QoS支持时本回调参数为该消息的特征指纹码，否则为null
     * @param userid                消息的发送者id（MobileIMSDK框架中规定发送者id="0"即表示是由服务端主动发过的，否则表示的
     *                              是其它客户端发过来的消息）
     * @param dataContent           消息内容的文本表示形式
     * @param typeu                 意义：应用层专用字段——用于应用层存放聊天、推送等场景下的消息类型。 注意：此值为-1时表示未定
     *                              义。MobileIMSDK_X框架中，本字段为保留字段，不参与框架的核心算法，专留用应用 层自行定义
     *                              和使用。 默认：-1。
     * @see <a href="http://docs.52im.net/extend/docs/api/mobileimsdk/server_netty/net/openmob/mobileimsdk/server/protocal/Protocal.html" target="_blank">Protocal</a>
     */
    @Override
    public void onRecieveMessage(String fingerPrintOfProtocal, String userid, String dataContent, int typeu) {
        Log.d(TAG, "【DEBUG_UI】[typeu=" + typeu + "]收到来自用户" + userid + "的消息:" + dataContent);
        this.channel.invokeMethod("onReceiveMessage", dataContent);
    }

    /**
     * 服务端反馈的出错信息回调事件通知。
     *
     * @param errorCode 错误码，定义在常量表 ErrorCode.ForS 类中
     * @param errorMsg  描述错误内容的文本信息
     * @see <a href="http://docs.52im.net/extend/docs/api/mobileimsdk/server/net/openmob/mobileimsdk/server/protocal/ErrorCode.ForS.html">ErrorCode.ForS类</a>
     */
    @Override
    public void onErrorResponse(int errorCode, String errorMsg) {
        Log.d(TAG, "【DEBUG_UI】收到服务端错误消息，errorCode=" + errorCode + ", errorMsg=" + errorMsg);

        if (errorCode == ErrorCode.ForS.RESPONSE_FOR_UNLOGIN)
            Log.d(TAG, "服务端会话已失效，自动登陆/重连将启动! (\"+errorCode+\")");

        else
            Log.d(TAG, "Server反馈错误码：" + errorCode + ",errorMsg=" + errorMsg);

    }

    public ChatMessageEventImpl setMainGUI(Context mainGUI) {
        this.mainGUI = mainGUI;
        return this;
    }

}
