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
                       create table dbversion ( /*版本检查*/	\
                       version           numeric(8) not null,	\
                       note              text,	\
                       primary key (version)	\
                       );",
                       @"\
                       create table sys_paras ( /*参数配置*/	\
                       para_name         varchar(100) not null,	\
                       para_value        text,	\
                       para_desc         text,	\
                       primary key (para_name)	\
                       )"],
                 @2, @[@"\
                       create table play_practice ( /*播放过的微课记录表*/	\
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
                       create table sns_practice ( /*微课列表*/	\
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
                       create table sns_audio ( /*播放对象,已废弃该表*/	\
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
                       create table sns_practice_detail ( /*微课详情*/	\
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
                       create table sns_appconfig( /*app配置记录*/\
                       appVersion           varchar(100) not null,	\
                       platform             numeric(20),	\
                       appStatus            numeric(20),	\
                       sortby               numeric(20), /*排序*/\
                       primary key (appVersion)	\
                       )"],
                 @7, @[@"ALTER TABLE sns_appconfig ADD COLUMN rankStatus numeric(20) default(0);"],
                 @8, @[@"\
                       create table sns_notice( /*通知列表*/\
                       ids                      varchar(100) not null,	\
                       noticeTitle              varchar(1000),	\
                       noticeDesc               text,	\
                       noticeType               numeric(20),	\
                       noticeLogo               varchar(1000),	\
                       noticeCount              numeric(20),	\
                       noticeTime               varchar(100),	\
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids)	\
                       );",
                       @"\
                       create table sns_notice_detail( /*通知详情*/\
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
                       create table sns_topic( /*话题*/\
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
                       );",
                       @"ALTER TABLE sns_practice_detail ADD COLUMN dataType numeric(20) default(0);"],
                 @10,@[@"\
                       create table sns_image( /*图片保存*/\
                       typeid                   varchar(100) not null,	\
                       typename                 varchar(100) not null,	\
                       imgurl                   varchar(1000) not null,	\
                       sortby                   numeric(20), /*排序*/\
                       primary key (typeid,typename,imgurl)	\
                       );",
                       @"ALTER TABLE sns_practice_detail ADD COLUMN showText numeric(20) default(0);"],
                 @11,@[@"\
                       create table sns_catchcrash( /*异常错误记录*/\
                       pkid                     INTEGER PRIMARY KEY AUTOINCREMENT, /*设置主键*/ \
                       name                     varchar(1000), \
                       reason                   varchar(1000), \
                       content                  text, \
                       createtime               datetime \
                       )"],
                 @12,@[@"\
                       create table sns_practice_question( /*微课关联的问题*/\
                       ids                      varchar(100) not null, \
                       pid                      varchar(100) not null, \
                       qtype                    numeric(20)  not null, \
                       aid                      varchar(100),  \
                       title                    varchar(1000), \
                       userId                   varchar(100),  \
                       nickname                 varchar(1000), \
                       head_img                 varchar(1000), \
                       sign                     varchar(1000), \
                       answerContent            text, \
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids,pid,qtype)	\
                       )"],
                 @13,@[@"\
                       create table sns_answer_detail( /*问题详情*/\
                       ids                      varchar(100) not null, \
                       loginUserId              varchar(100) not null, \
                       title                    text, \
                       userId                   varchar(100),  \
                       nickname                 varchar(1000), \
                       sign                     varchar(140),  \
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
                       );",
                       @"\
                       create table sns_answer_comment( /*对问题评论的内容*/\
                       ids                      varchar(100) not null, \
                       answerId                 varchar(100) not null, \
                       content                  text, \
                       userId                   varchar(100),  \
                       nickname                 varchar(1000), \
                       head_img                 varchar(1000), \
                       createTime               varchar(100), \
                       type                     numeric(20),  \
                       obj_id                   varchar(100), \
                       status                   numeric(20),  \
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids,answerId)	\
                       );",
                       @"\
                       create table sns_comment_reply( /*对评论回复的内容*/\
                       ids                      varchar(100) not null, \
                       commentId                varchar(100) not null, \
                       parent_id                varchar(100),  \
                       content                  text, \
                       user_id                  varchar(100),  \
                       hnickname                varchar(1000), \
                       reply_user_id            varchar(100),  \
                       nickname                 varchar(1000), \
                       sortby                   numeric(20), /*排序*/\
                       primary key (ids,commentId)	\
                       )"],
                 @14, @[@"\
                        create table sns_user_task( /*用户任务列表*/\
                        ids                      varchar(100) not null, \
                        user_id                  varchar(100) not null, \
                        content                  text, \
                        speech_id                varchar(100), \
                        status                   numeric(20),  \
                        rule                     numeric(20),  \
                        sortby                   numeric(20), /*排序*/\
                        primary key (ids,user_id)	\
                        );",
                        @"\
                        create table sns_topic_detail( /*话题详情*/\
                        tagId               varchar(100) not null, \
                        tagName             varchar(500) not null, \
                        userId              varchar(100) not null, \
                        tagLogo             varchar(1000), \
                        question_id         varchar(1000), \
                        attCount            numeric(20), \
                        status              numeric(20), \
                        isCheck             numeric(20), \
                        isAtt               numeric(20), \
                        isCollection        numeric(20), \
                        sortby              numeric(20), /*排序*/\
                        primary key (tagId,userId)	\
                        );",
                        @"\
                        create table sns_topic_question( /*话题关联的问题*/\
                        ids                      varchar(100) not null, \
                        topicId                  varchar(100) not null, \
                        aid                      varchar(100),  \
                        title                    varchar(1000), \
                        userIdA                  varchar(100),  \
                        nicknameA                varchar(1000), \
                        head_imgA                varchar(1000), \
                        signA                    varchar(1000), \
                        answerContent            text, \
                        sortby                   numeric(20), /*排序*/\
                        primary key (ids,topicId)	\
                        );",
                        @"\
                        create table sns_topic_practice( /*话题关联的微课*/\
                        ids                  varchar(100) not null,	\
                        topicId              varchar(100) not null,	\
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
                        unlock               numeric(20),	\
                        mcount               numeric(20),	\
                        applauds             numeric(20),	\
                        isCollection         numeric(20),	\
                        isPraise             numeric(20),	\
                        rowIndex             numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids,topicId)	\
                        );",
                        @"ALTER TABLE play_practice ADD COLUMN unlock numeric(20) default(0);",
                        @"ALTER TABLE sns_practice ADD COLUMN unlock numeric(20) default(0);",
                        @"ALTER TABLE sns_practice_detail ADD COLUMN unlock numeric(20) default(0);"],
                 @15, @[@"\
                        create table sns_home_banner( /*首页广告*/\
                        ids                     varchar(100) not null, \
                        imageUrl                varchar(2000),	\
                        title                   varchar(500),	\
                        url                     varchar(2000),	\
                        type                    numeric(20),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",
                        @"\
                        create table sns_home_practice( /*首页微课*/\
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
                        unlock               numeric(20),	\
                        mcount               numeric(20),	\
                        applauds             numeric(20),	\
                        isCollection         numeric(20),	\
                        isPraise             numeric(20),	\
                        rowIndex             numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids, userId)	\
                        );",
                        @"\
                        create table sns_home_practice_task( /*首页微课关联的任务*/\
                        ids                      varchar(100) not null, \
                        user_id                  varchar(100) not null, \
                        content                  text, \
                        speech_id                varchar(100), \
                        status                   numeric(20),  \
                        rule                     numeric(20),  \
                        sortby                   numeric(20), /*排序*/\
                        primary key (ids, user_id, speech_id)	\
                        );",
                        @"\
                        create table sns_home_question( /*首页问答*/\
                        ids                     varchar(100) not null, \
                        title                   varchar(500),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",
                        @"\
                        create table sns_home_subscribe( /*首页订阅*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(500),	\
                        team_name                   varchar(500),	\
                        illustration                varchar(500),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids, userId)	\
                        );",
                        @"\
                        create table sns_practice_type( /*微课分类*/\
                        ids                         varchar(100) not null, \
                        type                        varchar(500),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",
                        @"\
                        create table sns_type_practice( /*微课分类下的微课列表*/\
                        ids                  varchar(100) not null,	\
                        typeId               varchar(100) not null,	\
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
                        unlock               numeric(20),	\
                        mcount               numeric(20),	\
                        applauds             numeric(20),	\
                        isCollection         numeric(20),	\
                        isPraise             numeric(20),	\
                        rowIndex             numeric(20),	\
                        address              numeric(20), /*1微课列表,2分类列表*/\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids, typeId, userId, address)	\
                        );",
                        @"\
                        create table sns_boutique_question( /*精品问答列表*/\
                        ids                     varchar(100) not null, \
                        title                   varchar(1000),	\
                        aid                     varchar(100),	\
                        content                 text,	\
                        nickname                varchar(500),	\
                        head_img                varchar(500),	\
                        userId                  varchar(100),	\
                        sign                    varchar(500),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",],
                 @16, @[@"\
                        create table sns_subscribe( /*订阅*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        team_name                   varchar(500),	\
                        team_info                   text,	\
                        theme_intro                 varchar(500),	\
                        illustration                varchar(500),	\
                        course_picture              varchar(500),	\
                        price                       varchar(100),	\
                        units                       varchar(100),	\
                        status                      numeric(20),	\
                        count                       numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_subscribe_detail( /*订阅详情*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        team_name                   varchar(500),	\
                        team_info                   text,	\
                        theme_intro                 varchar(500),	\
                        illustration                varchar(500),	\
                        price                       varchar(100),	\
                        units                       varchar(100),	\
                        status                      numeric(20),	\
                        count                       numeric(20),	\
                        fit_people                  text,	\
                        must_know                   text,	\
                        need_help                   text,	\
                        latest_push                 text,	\
                        isSubscribe                 numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_curriculum( /*订阅每期内容*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        subscribeId                 varchar(1000) not null,	\
                        title                       varchar(1000),	\
                        ctitle                      varchar(1000),	\
                        team_name                   varchar(1000),	\
                        team_intro                  varchar(1000),	\
                        content                     text,	\
                        course_imges                text,	\
                        illustration                varchar(500),	\
                        course_picture              varchar(500),	\
                        audio_picture               varchar(500),	\
                        audio_time                  varchar(500),	\
                        audio_url                   varchar(500),	\
                        price                       varchar(500),	\
                        units                       varchar(500),	\
                        create_time                 varchar(100),	\
                        free_read                   numeric(20),	\
                        play_time                   numeric(20),	\
                        rowIndex                    numeric(20),	\
                        address                     numeric(20), /*数据位置：1已订阅,2试读,3每期看,4连续播*/	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,subscribeId,userId,address)	\
                        );",
                        @"\
                        create table sns_found_practice_type( /*发现微课分类*/\
                        ids                         varchar(100) not null, \
                        type                        varchar(1000),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",
                        @"\
                        create table sns_orderwt( /*订单对象*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        type                        numeric(20),	\
                        order_no                    varchar(1000),	\
                        price                       varchar(100),	\
                        pay_type                    numeric(20),	\
                        status                      numeric(20),	\
                        pay_time                    varchar(100),	\
                        create_time                 varchar(100),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_recharge_record( /*充值记录*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        price                       varchar(1000),	\
                        pay_time                    varchar(1000),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_subscribe_play( /*购买记录*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        price                       varchar(1000),	\
                        pay_time                    varchar(1000),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_play_audio (/*新播放对象*/	\
                        ids                  varchar(100) not null,	\
                        audioTitle           text,	\
                        audioAuthor          varchar(500),	\
                        audioPath            text,	\
                        audioLocalPath       text,	\
                        audioImage           text,	\
                        totalDuration        varchar(100),	\
                        objId                varchar(100),	\
                        audioPlayType        numeric(20),	\
                        audioPlayTime        numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        CONSTRAINT sns_play_audio_pk PRIMARY KEY (ids,objId,audioPlayType)\
                        );",
                        @"\
                        create table sns_circle_hot_question( /*圈子推荐*/\
                        ids                     varchar(100) not null, \
                        title                   varchar(1000),	\
                        aid                     varchar(100),	\
                        content                 text,	\
                        nickname                varchar(500),	\
                        head_img                varchar(500),	\
                        userId                  varchar(100),	\
                        sign                    varchar(500),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",
                        @"\
                        create table sns_playlist_found( /*发现播放*/\
                        ids                  varchar(100) not null,	\
                        userId               varchar(100) not null, \
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
                        unlock               numeric(20),	\
                        rowIndex             numeric(20),	\
                        islastplay           numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_playlist_practice( /*微课播放*/\
                        ids                  varchar(100) not null,	\
                        userId               varchar(100) not null, \
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
                        unlock               numeric(20),	\
                        rowIndex             numeric(20),	\
                        islastplay           numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_playlist_subscribe_curriculum( /*订阅内容播放*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        subscribeId                 varchar(1000) not null,	\
                        title                       varchar(1000),	\
                        ctitle                      varchar(1000),	\
                        team_name                   varchar(1000),	\
                        content                     text,	\
                        course_imges                text,	\
                        illustration                varchar(500),	\
                        audio_picture               varchar(500),	\
                        audio_time                  varchar(500),	\
                        audio_url                   varchar(500),	\
                        create_time                 varchar(100),	\
                        free_read                   numeric(20),	\
                        play_time                   numeric(20),	\
                        rowIndex                    numeric(20),	\
                        islastplay                  numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,subscribeId,userId)	\
                        );",
                        @"ALTER TABLE sns_topic_question ADD COLUMN userIdQ varchar(100);",
                        @"ALTER TABLE sns_topic_question ADD COLUMN nicknameQ varchar(100);",
                        @"ALTER TABLE sns_topic_question ADD COLUMN head_imgQ varchar(100);",
                        @"ALTER TABLE sns_topic_question ADD COLUMN signQ varchar(100);",
                        @"ALTER TABLE sns_topic_question ADD COLUMN content text;",
                        @"ALTER TABLE sns_practice ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_practice ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_practice ADD COLUMN showText numeric(20) default(0);",
                        ],
                 @17, @[@"ALTER TABLE play_practice ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE play_practice ADD COLUMN person_title text;",
                        @"ALTER TABLE play_practice ADD COLUMN showText numeric(20) default(0);",
                        @"ALTER TABLE sns_practice_detail ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_practice_detail ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_topic_practice ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_topic_practice ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_topic_practice ADD COLUMN showText numeric(20) default(0);",
                        @"ALTER TABLE sns_home_practice ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_home_practice ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_home_practice ADD COLUMN showText numeric(20) default(0);",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN showText numeric(20) default(0);",
                        @"ALTER TABLE sns_playlist_found ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_playlist_found ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_playlist_found ADD COLUMN showText numeric(20) default(0);",],
                 @18, @[@"\
                        create table sns_circle_dynamic_question( /*圈子动态*/\
                        ids                     varchar(100) not null, \
                        title                   varchar(1000),	\
                        wid                     varchar(100),	\
                        userIdL                 varchar(100),	\
                        content                 text,	\
                        nickname                varchar(500),	\
                        head_img                varchar(500),	\
                        userId                  varchar(100),	\
                        sign                    varchar(500),	\
                        flag                    varchar(100),	\
                        type                    numeric(20),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids,userIdL)	\
                        );",
                        @"\
                        create table sns_circle_new_question( /*圈子最新*/\
                        ids                     varchar(100) not null, \
                        title                   varchar(1000),	\
                        aid                     varchar(100),	\
                        content                 text,	\
                        nicknameQ               varchar(500),	\
                        head_imgQ               varchar(500),	\
                        userIdQ                 varchar(100),	\
                        nicknameA               varchar(500),	\
                        head_imgA               varchar(500),	\
                        userIdA                 varchar(100),	\
                        signA                   varchar(500),	\
                        time                    varchar(100),	\
                        count                   varchar(100),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids)	\
                        );",],
                 @19, @[@"ALTER TABLE sns_circle_hot_question ADD COLUMN contentNoImage text;",
                        @"ALTER TABLE sns_circle_dynamic_question ADD COLUMN contentNoImage text;",
                        @"ALTER TABLE sns_circle_new_question ADD COLUMN contentNoImage text;",],
                 @20, @[@"ALTER TABLE sns_type_practice ADD COLUMN person_synopsis text;",
                        @"ALTER TABLE sns_type_practice ADD COLUMN person_title text;",
                        @"ALTER TABLE sns_type_practice ADD COLUMN showText numeric(20) default(0);",],
                 @21, @[@"\
                        create table sns_download_audio( /*下载语音*/\
                        ids                     varchar(100) not null,	\
                        userId                  varchar(100) not null, \
                        objId                   varchar(100) not null, \
                        audioTitle              text,	\
                        audioAuthor             varchar(1000),	\
                        cachePath               varchar(1000),	\
                        audioPath               varchar(1000),	\
                        audioImage              varchar(1000),	\
                        audioLocalPath          varchar(1000),	\
                        totalDuration           varchar(100),	\
                        audioPlayTime           numeric(20),	\
                        audioPlayType           numeric(20),	\
                        address                 numeric(20),	\
                        totalUnitCount          numeric(50),	\
                        completedUnitCount      numeric(50),	\
                        sortby                  numeric(20), /*排序*/\
                        primary key (ids,userId,audioPlayType)	\
                        )",
                        @"ALTER TABLE sns_practice_detail ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE sns_practice_detail ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_practice_detail ADD COLUMN buyStatus numeric(20);",
                        @"ALTER TABLE sns_type_practice ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE sns_type_practice ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_type_practice ADD COLUMN buyStatus numeric(20);",
                        @"ALTER TABLE play_practice ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE play_practice ADD COLUMN price varchar(100);",
                        @"ALTER TABLE play_practice ADD COLUMN buyStatus numeric(20);",
                        @"ALTER TABLE sns_home_practice ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE sns_home_practice ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_home_practice ADD COLUMN buyStatus numeric(20);",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN buyStatus numeric(20);",
                        @"ALTER TABLE sns_practice ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE sns_practice ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_practice ADD COLUMN buyStatus numeric(20);",
                        @"ALTER TABLE sns_playlist_found ADD COLUMN joinCart numeric(20);",
                        @"ALTER TABLE sns_playlist_found ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_playlist_found ADD COLUMN buyStatus numeric(20);",
                        @"\
                        create table sns_cart_practice ( /*购物车微课*/	\
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
                        joinCart             numeric(20),	\
                        price                varchar(100),	\
                        buyStatus            numeric(20),	\
                        showText             numeric(20),	\
                        unlock               numeric(20),	\
                        speech_content       text,	\
                        person_synopsis      text,	\
                        person_title         text,	\
                        ccount               numeric(20),	\
                        mcount               numeric(20),	\
                        applauds             numeric(20),	\
                        isCollection         numeric(20),	\
                        isPraise             numeric(20),	\
                        rowIndex             numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        )",
                        @"ALTER TABLE sns_subscribe_play ADD COLUMN units varchar(100);",
                        @"ALTER TABLE sns_subscribe_play ADD COLUMN type numeric(20);",
                        ],
                 @22, @[@"\
                        create table sns_purchase_practice ( /*已购微课*/	\
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
                        joinCart             numeric(20),	\
                        price                varchar(100),	\
                        buyStatus            numeric(20),	\
                        showText             numeric(20),	\
                        unlock               numeric(20),	\
                        speech_content       text,	\
                        person_synopsis      text,	\
                        person_title         text,	\
                        ccount               numeric(20),	\
                        mcount               numeric(20),	\
                        applauds             numeric(20),	\
                        isCollection         numeric(20),	\
                        isPraise             numeric(20),	\
                        rowIndex             numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        )",
                        @"\
                        create table sns_purchase_subscribe( /*已购订阅*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        team_name                   varchar(500),	\
                        team_info                   text,	\
                        theme_intro                 varchar(500),	\
                        illustration                varchar(500),	\
                        course_picture              varchar(500),	\
                        price                       varchar(100),	\
                        units                       varchar(100),	\
                        status                      numeric(20),	\
                        count                       numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"ALTER TABLE sns_download_audio ADD COLUMN progress numeric(20);",
                        @"\
                        create table sns_playrecord_practice ( /*微课播放记录*/	\
                        ids                  numeric(100) not null,	\
                        title                text,	\
                        time                 varchar(1000),	\
                        play_time            numeric(20),	\
                        speech_img           varchar(1000),	\
                        bkimg                varchar(1000),	\
                        speech_url           varchar(1000),	\
                        share_content        text,	\
                        nickname             varchar(500),	\
                        create_time          varchar(100),	\
                        joinCart             numeric(20),	\
                        price                varchar(100),	\
                        buyStatus            numeric(20),	\
                        showText             numeric(20),	\
                        unlock               numeric(20),	\
                        speech_content       text,	\
                        person_synopsis      text,	\
                        person_title         text,	\
                        ccount               numeric(20),	\
                        mcount               numeric(20),	\
                        applauds             numeric(20),	\
                        isCollection         numeric(20),	\
                        isPraise             numeric(20),	\
                        rowIndex             numeric(20),	\
                        sortby               numeric(20), /*排序*/\
                        primary key (ids)	\
                        )",
                        @"\
                        create table sns_playrecord_curriculum( /*订阅内容播放纪律*/\
                        ids                         numeric(100) not null, \
                        subscribeId                 numeric(1000) not null,	\
                        title                       varchar(1000),	\
                        ctitle                      varchar(1000),	\
                        team_name                   varchar(1000),	\
                        team_intro                  text,	\
                        content                     text,	\
                        course_imges                text,	\
                        illustration                varchar(500),	\
                        audio_picture               varchar(500),	\
                        audio_time                  varchar(500),	\
                        audio_url                   varchar(500),	\
                        create_time                 varchar(100),	\
                        free_read                   numeric(20),	\
                        price                       varchar(100),	\
                        course_picture              varchar(500),	\
                        speaker_name                varchar(100),	\
                        units                       varchar(100),	\
                        play_time                   numeric(20),	\
                        rowIndex                    numeric(20),	\
                        islastplay                  numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,subscribeId)	\
                        );",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN speaker_name varchar(100);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN team_intro text;",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN price varchar(100);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN units varchar(100);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN course_picture varchar(500);",],
                 @23, @[@"\
                        create table sns_home_curriculum( /*首页系列课程*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(500),	\
                        team_name                   varchar(500),	\
                        team_intro                  text,	\
                        theme_intro                 text,	\
                        create_time                 varchar(100),	\
                        price                       varchar(500),	\
                        units                       varchar(500),	\
                        illustration                varchar(500),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids, userId)	\
                        );",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN team_intro text;",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN theme_intro text;",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN create_time varchar(100);",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN price varchar(500);",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN units varchar(500);",
                        @"ALTER TABLE sns_home_question ADD COLUMN aid varchar(100);",
                        @"ALTER TABLE sns_home_question ADD COLUMN content text;",
                        @"ALTER TABLE sns_home_question ADD COLUMN nickname varchar(500);",
                        @"ALTER TABLE sns_home_question ADD COLUMN head_img varchar(500);",
                        @"ALTER TABLE sns_home_question ADD COLUMN userId varchar(100);",
                        @"ALTER TABLE sns_home_question ADD COLUMN sign varchar(500);",
                        @"ALTER TABLE sns_practice_type ADD COLUMN spe_img varchar(500);",
                        @"\
                        create table sns_series_courses( /*系列课程*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        team_name                   varchar(500),	\
                        team_info                   text,	\
                        theme_intro                 varchar(500),	\
                        illustration                varchar(500),	\
                        course_picture              varchar(500),	\
                        price                       varchar(100),	\
                        units                       varchar(100),	\
                        status                      numeric(20),	\
                        count                       numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_purchase_curriculum( /*已购系列课程*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        team_name                   varchar(500),	\
                        team_info                   text,	\
                        theme_intro                 varchar(500),	\
                        illustration                varchar(500),	\
                        course_picture              varchar(500),	\
                        price                       varchar(100),	\
                        units                       varchar(100),	\
                        status                      numeric(20),	\
                        count                       numeric(20),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_mymessage( /*我的留言*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        content                     text,	\
                        course_id                   varchar(100),\
                        subscribe_id                varchar(100),\
                        create_time                 varchar(100),\
                        title                       text,	\
                        price                       varchar(100),\
                        units                       varchar(100),\
                        applaudCount                numeric(20),	\
                        free_read                   numeric(20),	\
                        reply                       text,	\
                        reply_lecturer              varchar(100),\
                        reply_time                  varchar(100),\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        )",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN mcount numeric(20);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN applauds numeric(20);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN ccount numeric(20);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN isPraise numeric(20);",
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN isCollection numeric(20);",
                        @"ALTER TABLE sns_recharge_record ADD COLUMN pay_type varchar(100);",
                        @"ALTER TABLE sns_subscribe_play ADD COLUMN pay_type varchar(100);",
                        @"\
                        create table sns_reward_record( /*打赏记录*/\
                        ids                         varchar(100) not null, \
                        userId                      varchar(100) not null, \
                        title                       varchar(1000),	\
                        price                       varchar(100),	\
                        pay_time                    varchar(100),	\
                        pay_type                    varchar(100),	\
                        sortby                      numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        ],
                 @24,   @[
                        @"ALTER TABLE sns_playlist_subscribe_curriculum ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_playlist_practice ADD COLUMN speech_images text;",
                        @"ALTER TABLE sns_subscribe ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_series_courses ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_subscribe_detail ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_purchase_subscribe ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_purchase_curriculum ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN status numeric(20);",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_home_curriculum ADD COLUMN status numeric(20);",
                        @"ALTER TABLE sns_home_curriculum ADD COLUMN hits numeric(20);",
                        @"ALTER TABLE sns_subscribe ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_home_curriculum ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_home_subscribe ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_subscribe_detail ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_series_courses ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_purchase_subscribe ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_purchase_curriculum ADD COLUMN is_series_course numeric(20);",
                        @"ALTER TABLE sns_home_banner ADD COLUMN share_title text;",
                        @"ALTER TABLE sns_home_banner ADD COLUMN share_desc text;",
                        @"ALTER TABLE sns_subscribe_detail ADD COLUMN isExistFreeRead numeric(20);",
                        @"\
                        create table sns_xmtrack( /*喜马拉雅下载列表*/\
                        trackId                         numeric(100) not null, \
                        dataType                        numeric(100) not null, \
                        announcerid                     numeric(100) not null, \
                        announcerkind                   text,	\
                        announcernickname               text,	\
                        announceravatarUrl              text,	\
                        announcerisVerified             numeric(100),	\
                        commentCount                    numeric(100),	\
                        downloadCount                   numeric(100),	\
                        downloadSize                    numeric(100),	\
                        duration                        numeric(100),	\
                        favoriteCount                   numeric(100),	\
                        orderNum                        numeric(100),	\
                        playCount                       numeric(100),	\
                        playSize24M4a                   numeric(100),	\
                        playSize32                      numeric(100),	\
                        playSize64                      numeric(100),	\
                        playSize64M4a                   numeric(100),	\
                        playSizeAmr                     numeric(100),	\
                        source                          numeric(100),	\
                        coverUrlLarge                   text,	\
                        coverUrlMiddle                  text,	\
                        coverUrlSmall                   text,	\
                        downloadUrl                     text,	\
                        kind                            text,	\
                        playUrl24M4a                    text,	\
                        playUrl32                       text,	\
                        playUrl64                       text,	\
                        playUrl64M4a                    text,	\
                        playUrlAmr                      text,	\
                        subordinatedAlbumalbumTitle     text,	\
                        subordinatedAlbumcoverUrlLarge  text,	\
                        subordinatedAlbumcoverUrlMiddle text,	\
                        subordinatedAlbumcoverUrlSmall  text,	\
                        subordinatedAlbumalbumId        numeric(100),	\
                        trackIntro                      text,	\
                        trackTags                       text,	\
                        trackTitle                      text,	\
                        filePath                        text,	\
                        startPlayTime                   text,	\
                        updatedAt                       numeric(100),	\
                        createdAt                       numeric(100),	\
                        canDownload                     numeric(100),	\
                        playing                         numeric(100),	\
                        pause                           numeric(100),	\
                        listenedTime                    numeric(100),	\
                        listenedPosition                numeric(100),	\
                        status                          numeric(100),	\
                        downloadedBytes                 numeric(100),	\
                        totalBytes                      numeric(100),	\
                        sortby                          numeric(20), /*排序*/\
                        primary key (trackId, dataType, announcerid)	\
                        );",
                        @"\
                        create table sns_play_practice_detail(/*微课播放记录*/  \
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
                        showText             numeric(20),   \
                        unlock               numeric(20),   \
                        person_synopsis      text,          \
                        person_title         text,          \
                        arrImage             text,          \
                        buyStatus            numeric(20),   \
                        price                varchar(100),  \
                        joinCart             numeric(20),   \
                        sortby               numeric(20), /*排序*/\
                        primary key (ids,userId)	\
                        );",
                        @"\
                        create table sns_play_curriculum_detail(/*订阅系列课播放记录*/  \
                        ids                 varchar(100) not null, \
                        userId              varchar(100) not null,\
                        subscribeId         varchar(100), \
                        title               text,	\
                        speaker_name        text,	\
                        team_name           text,	\
                        team_intro          text,	\
                        illustration        text,	\
                        course_picture      text,	\
                        course_imges        text,	\
                        ctitle              text,	\
                        content             text,	\
                        create_time         text,	\
                        audio_picture       text,	\
                        audio_time          text,	\
                        audio_url           text,	\
                        is_series_course    numeric(20),	\
                        hits                numeric(20),	\
                        price               varchar(500),	\
                        units               varchar(500),	\
                        free_read           numeric(20),	\
                        play_time           numeric(20),	\
                        unReadCount         numeric(20),	\
                        rowIndex            numeric(20),	\
                        mcount              numeric(20),	\
                        applauds            numeric(20),	\
                        ccount              numeric(20),	\
                        isPraise            numeric(20),	\
                        isCollection        numeric(20),	\
                        sortby              numeric(20), /*排序*/ \
                        primary key (ids,userId)	\
                        );",
                        ],
                 @25, @[
                     @"\
                     create table sns_home_lawfirm( /*首页律所*/\
                     ids                        varchar(100) not null, \
                     userId                     varchar(100) not null, \
                     title                      text,	\
                     desc                       text,	\
                     logo                       text,	\
                     picture                    text,	\
                     total                      numeric(20),	\
                     sortby                     numeric(20), /*排序*/\
                     primary key (ids, userId)	\
                     );",
                     @"\
                     create table sns_lawfirm_list( /*律所列表*/\
                     ids                        varchar(100) not null, \
                     userId                     varchar(100) not null, \
                     title                      text,	\
                     desc                       text,	\
                     logo                       text,	\
                     picture                    text,	\
                     total                      numeric(20),	\
                     sortby                     numeric(20), /*排序*/\
                     primary key (ids, userId)	\
                     );",
                     @"ALTER TABLE sns_home_subscribe ADD COLUMN increasedCourseCount numeric(20);",
                     @"ALTER TABLE sns_series_courses ADD COLUMN increasedCourseCount numeric(20);",
                     @"ALTER TABLE sns_subscribe_detail ADD COLUMN increasedCourseCount numeric(20);",
                     @"ALTER TABLE sns_purchase_subscribe ADD COLUMN increasedCourseCount numeric(20);",
                     @"ALTER TABLE sns_purchase_curriculum ADD COLUMN increasedCourseCount numeric(20);",
                     @"ALTER TABLE sns_home_curriculum ADD COLUMN increasedCourseCount numeric(20);",
                     @"ALTER TABLE sns_subscribe ADD COLUMN increasedCourseCount numeric(20);",
                     ],
                 @26, @[
                     @"ALTER TABLE sns_subscribe_detail ADD COLUMN course_picture text;",
                     ],
                 @27, @[
                     @"\
                     create table sns_download_status( /*下载列表状态管理*/\
                     trackId                    varchar(100) not null, \
                     datatype                   varchar(100) not null, \
                     userId                     varchar(100) not null, \
                     status                     numeric(20), \
                     sortby                     numeric(20), /*排序*/\
                     primary key (trackId, datatype, userId)    \
                     );",
                     ],
                 @28, @[
                     @"ALTER TABLE sns_purchase_practice ADD COLUMN increasedCourseCount numeric(20);",
                     ],
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
