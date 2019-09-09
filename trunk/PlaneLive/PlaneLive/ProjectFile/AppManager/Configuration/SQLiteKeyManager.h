//
//  SQLiteKeyManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

//返回对象
#define kResultKey @"result"
//是否顶部
#define kIsHeaderKey @"isHeader"
//是否刷新
#define kIsRefreshKey @"isRefresh"
//用户对象
#define kUserKey @"user"
//话题
#define kTagKey @"article"
//问题
#define kQuestionKey @"ques"
//问题
#define kQuestionAllKey @"question"
//回答
#define kAnswerKey @"answers"

//设备TOKEN
#define kSQLITE_DEVICE_TOKEN @"ZSQLITE_DEVICE_TOKEN"
//播放条关闭
#define kSQLITE_CLOSE_PLAY_VIEW @"ZSQLITE_CLOSE_PLAY_VIEW"
//消息角标
#define kSQLITE_MESSAGE_COUNT @"ZSQLITE_MESSAGE_COUNT"
//是否第一次启动
#define kSQLITE_FRIST_START @"ZSQLITE_FRIST_START227"
//文件大小
#define kSQLITE_LOCAL_FILE_SIZE @"kSQLITE_LOCAL_FILE_SIZE"
//上次播放状态
#define kSQLITE_LAST_STOPPLAYSTATE @"kSQLITE_LAST_STOPPLAYSTATE"

//是否点了不再提示修改昵称
#define kSQLITE_LAST_USERINFOPROMPT @"kSQLITE_LAST_USERINFOPROMPT"
//是否点了绑定账号以后再说
#define kSQLITE_LAST_BINDPHONEPROMPT @"kSQLITE_LAST_BINDPHONEPROMPT"


//设置3D Touch显示提问界面
#define kSQLITE_TOUCH_SHOW_QUESTION @"kSQLITE_TOUCH_SHOW_QUESTION"

///记录是否提问提示层
#define kSQLITE_LAST_QUESTION_PUBLISH_PROMPT @"kSQLITE_LAST_QUESTION_PUBLISH_PROMPT"

//上次提问的内容
#define kSQLITE_LAST_QUESTION_TITLE @"kSQLITE_LAST_QUESTION_TITLE"
//上次提问的描述
#define kSQLITE_LAST_QUESTION_CONTENT @"kSQLITE_LAST_QUESTION_CONTENT"
//上次回答的内容
#define kSQLITE_LAST_ANSWER_CONTENT @"kSQLITE_LAST_ANSWER_CONTENT"

//上次推送内容
#define kSQLITE_LAST_PUSHDATA @"kSQLITE_LAST_PUSHDATA"
//上次需要打开页面的参数
#define kSQLITE_LAST_SHOWVCURL @"kSQLITE_LAST_SHOWVCURL"

#define kSQLITEPlayViewLastPlayType @"kSQLITEPlayViewLastPlayType"
#define kSQLITEPlayViewLastPlayIndex [NSString stringWithFormat:@"kSQLITEPlayViewLastPlayIndex%@", kLoginUserId]


