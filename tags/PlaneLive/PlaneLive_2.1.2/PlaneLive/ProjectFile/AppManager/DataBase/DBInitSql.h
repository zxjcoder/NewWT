//
//  DBInitSql.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBInitSql : NSObject

//取得各版本数据库初始化脚本[verX, [sqlstr, sqlstr, ...], verX, [sqlstr, sqlstr, ...], ...]
+(NSArray*)getInitSql;

@end
