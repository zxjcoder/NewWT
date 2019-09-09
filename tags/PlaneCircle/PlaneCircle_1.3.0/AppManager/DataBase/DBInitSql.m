//
//  DBInitSql.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DBInitSql.h"

@implementation DBInitSql

static NSArray *_initSql = nil;
+(void)genInitSql
{
    _initSql = @[
                 @0, @[],   //占位
                 @1, @[@"\
                       create table dbversion (	\
                       version           numeric(8) not null,	\
                       note              text,	\
                       primary key (version)	\
                       )",
                       @"\
                       create table sys_paras (	\
                       para_name         varchar(100) not null,	\
                       para_value        text,	\
                       para_desc         text,	\
                       primary key (para_name)	\
                       )"],
                 @2, @[@"\
                       create table play_practice (	\
                       ids                  varchar(100) not null,	\
                       title                text,	\
                       time                 varchar(1000),	\
                       play_time            numeric(20),	\
                       speech_img           varchar(1000),	\
                       bkimg                varchar(1000),	\
                       speech_url           varchar(1000),	\
                       share_content        text,	\
                       nickname             varchar(500),	\
                       create_time          varchar(100),	\
                       speech_content       text,	\
                       ccount               numeric(20),	\
                       mcount               numeric(20),	\
                       applauds             numeric(20),	\
                       isCollection         numeric(20),	\
                       isPraise             numeric(20),	\
                       rowIndex             numeric(20),	\
                       sortby               numeric(20), /*排序*/\
                       primary key (ids)	\
                       )"],
                 @3, @[@"\
                       create table sns_practice (	\
                       ids                  varchar(100) not null,	\
                       title                text,	\
                       time                 varchar(1000),	\
                       play_time            numeric(20),	\
                       speech_img           varchar(1000),	\
                       bkimg                varchar(1000),	\
                       speech_url           varchar(1000),	\
                       share_content        text,	\
                       nickname             varchar(500),	\
                       create_time          varchar(100),	\
                       speech_content       text,	\
                       ccount               numeric(20),	\
                       mcount               numeric(20),	\
                       applauds             numeric(20),	\
                       isCollection         numeric(20),	\
                       isPraise             numeric(20),	\
                       rowIndex             numeric(20),	\
                       sortby               numeric(20), /*排序*/\
                       primary key (ids)	\
                       )"],
                 @4, @[@"\
                       create table sns_audio (	\
                       ids                  varchar(100) not null,	\
                       audioTitle           text,	\
                       audioAuthor          varchar(500),	\
                       audioPath            text,	\
                       audioLocalPath       text,	\
                       audioImage           text,	\
                       audioPlayTime        numeric(20),	\
                       sortby               numeric(20), /*排序*/\
                       primary key (ids)	\
                       )"],
                 @5, @[@"\
                       create table sns_practice_detail (	\
                       ids                  varchar(100) not null,	\
                       userId               varchar(100) not null,	\
                       title                text,	\
                       time                 varchar(1000),	\
                       play_time            numeric(20),	\
                       speech_img           varchar(1000),	\
                       bkimg                varchar(1000),	\
                       speech_url           varchar(1000),	\
                       share_content        text,	\
                       nickname             varchar(500),	\
                       create_time          varchar(100),	\
                       speech_content       text,	\
                       ccount               numeric(20),	\
                       mcount               numeric(20),	\
                       applauds             numeric(20),	\
                       isCollection         numeric(20),	\
                       isPraise             numeric(20),	\
                       rowIndex             numeric(20),	\
                       sortby               numeric(20), /*排序*/\
                       primary key (ids,userId)	\
                       )"],
                 @6, @[@"\
                       create table sns_appconfig(\
                       appVersion           varchar(100) not null,	\
                       platform             numeric(20),	\
                       appStatus            numeric(20),	\
                       sortby               numeric(20), /*排序*/\
                       primary key (appVersion)	\
                       )"],
                 @7, @[@"ALTER TABLE sns_appconfig ADD COLUMN rankStatus numeric(20) default(0);"],
                 @8, @[@"\
                       create table sns_notice(\
                       ids                      varchar(100) not null,	\
                       noticeTitle              varchar(1000),	\
                       noticeDesc               text,	\
                       noticeType               numeric(20),	\
                       noticeLogo               varchar(1000),	\
                       noticeCount              numeric(20),	\
                       noticeTime               varchar(100),	\
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids)	\
                       )",
                       @"\
                       create table sns_notice_detail(\
                       ids                      varchar(100) not null,	\
                       noticeContent            text,	\
                       noticeDesc               text,	\
                       noticeNickName           varchar(1000),	\
                       noticeTime               varchar(100),	\
                       isRead                   numeric(20),	\
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids)	\
                       )"],
                 @9, @[@"\
                       create table sns_topic(\
                       tagId                    varchar(100) not null,	\
                       userId                   varchar(100) not null,	\
                       typeId                   varchar(100) not null,	\
                       tagName                  varchar(1000),	\
                       tagLogo                  varchar(1000),	\
                       status                   numeric(20),	\
                       isAtt                    numeric(20),	\
                       isCollection             numeric(20),	\
                       attCount                 numeric(20),	\
                       sortby                   numeric(20), /*排序*/\
                       primary key (tagId,userId,typeId)	\
                       )",
                       @"ALTER TABLE sns_practice_detail ADD COLUMN dataType numeric(20) default(0);"],
                 @10,@[@"\
                       create table sns_image(\
                       typeid                   varchar(100) not null,	\
                       typename                 varchar(100) not null,	\
                       imgurl                   varchar(1000) not null,	\
                       sortby                   numeric(20), /*排序*/\
                       primary key (typeid,typename,imgurl)	\
                       )",
                       @"ALTER TABLE sns_practice_detail ADD COLUMN showText numeric(20) default(0);"],
                 @11,@[@"\
                       create table sns_catchcrash(\
                       pkid                     integer not null, /*设置主键*/ \
                       name                     varchar(1000), \
                       reason                   varchar(1000), \
                       createtime               datetime , \
                       primary key (pkid)	\
                       )",
                       @"\
                       create table sns_catchcrash_stack(\
                       pkid                     integer not null, /*设置主键*/ \
                       ccid                     varchar(100) not null, \
                       content                  text, \
                       primary key (pkid,ccid)	\
                       )"],
                 @11,@[@"\
                       create table sns_practice_question(\
                       ids                      varchar(100) not null, \
                       pid                      varchar(100) not null, \
                       qtype                    numeric(20)  not null, \
                       aid                      varchar(100), \
                       title                    varchar(1000), \
                       userId                   varchar(100), \
                       nickname                 varchar(1000), \
                       head_img                 varchar(1000), \
                       sign                     varchar(1000), \
                       answerContent            text, \
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids,pid,qtype)	\
                       )"],
                 @12,@[@"\
                       create table sns_answer_detail(\
                       ids                      varchar(100) not null, \
                       loginUserId              varchar(100) not null, \
                       title                    text, \
                       userId                   varchar(100), \
                       nickname                 varchar(1000), \
                       sign                     varchar(140), \
                       head_img                 varchar(1000), \
                       discuss_time             varchar(100), \
                       question_id              varchar(100), \
                       question_title           text, \
                       resultRpt                numeric(20), \
                       agree                    numeric(20), \
                       disagree                 numeric(20), \
                       isRept                   numeric(20), \
                       isAgree                  numeric(20), \
                       commentCount             numeric(20), \
                       isCollection             numeric(20), \
                       primary key (ids,loginUserId)	\
                       )",
                       @"\
                       create table sns_answer_comment(\
                       ids                      varchar(100) not null, \
                       answerId                 varchar(100) not null, \
                       content                  text, \
                       userId                   varchar(100), \
                       nickname                 varchar(1000), \
                       head_img                 varchar(1000), \
                       createTime               varchar(100), \
                       type                     numeric(20),  \
                       obj_id                   varchar(100), \
                       status                   numeric(20),  \
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids,answerId)	\
                       )",
                       @"\
                       create table sns_comment_reply(\
                       ids                      varchar(100) not null, \
                       commentId                varchar(100) not null, \
                       parent_id                varchar(100), \
                       content                  text, \
                       user_id                  varchar(100), \
                       hnickname                varchar(1000), \
                       reply_user_id            varchar(100),  \
                       nickname                 varchar(1000), \
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids,commentId)	\
                       )"],
                 ];
    
#if ! __has_feature(objc_arc)
    [_initSql retain];
#endif
}

+(NSArray*)getInitSql
{
    if (_initSql == nil)
    {
        [DBInitSql genInitSql];
    }
    
    return _initSql;
}

@end
