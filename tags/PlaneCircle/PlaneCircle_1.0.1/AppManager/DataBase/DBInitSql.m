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
