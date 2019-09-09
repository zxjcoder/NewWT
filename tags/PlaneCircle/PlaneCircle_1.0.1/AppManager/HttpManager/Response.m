
//
//  Response.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "Response.h"
#import "Utils.h"

#define kResponseCodeKey @"resultCode"
#define kResponseMsgKey @"resultMsg"

@implementation Response

+ (id)sharedWithJSONString:(NSString *)result
{
    Response *resp = [[Response alloc] init];
    if (result == nil || [result isKindOfClass:[NSNull class]]) {
        resp.code = kSNS_RETURN_SERVER_DATA_ERROR;
        resp.msg = kSNS_RETURN_SERVER_DATA_ERROR_Text;
        resp.body = nil;
        resp.success = NO;
        return resp;
    }
    
    NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (dicResult==nil) {
        resp.code = kSNS_RETURN_SERVER_DATA_ERROR;
        resp.msg = kSNS_RETURN_SERVER_DATA_ERROR_Text;
        resp.body = nil;
        resp.success = NO;
    } else {
        resp.code = [Utils getSNSInteger:dicResult[kResponseCodeKey]];
        resp.msg = [Utils getSNSString:dicResult[kResponseMsgKey]];
        resp.body = dicResult;
        resp.success = resp.code == kSNS_RETURN_SUCCESS;
    }
    return resp;
}

+(id)sharedWithJSONData:(NSData *)result
{
    Response *resp = [[Response alloc] init];
    if (result == nil || [result isKindOfClass:[NSNull class]] || [result length] == 0) {
        resp.code = kSNS_RETURN_SERVER_DATA_ERROR;
        resp.msg = kSNS_RETURN_SERVER_DATA_ERROR_Text;
        resp.body = nil;
        resp.success = NO;
        return resp;
    }
    
    NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
    if (dicResult==nil) {
        resp.code = kSNS_RETURN_SERVER_DATA_ERROR;
        resp.msg = kSNS_RETURN_SERVER_DATA_ERROR_Text;
        resp.body = nil;
        resp.success = NO;
    } else {
        resp.code = [Utils getSNSInteger:dicResult[kResponseCodeKey]];
        resp.msg = [Utils getSNSString:dicResult[kResponseMsgKey]];
        resp.body = dicResult;
        resp.success = resp.code == kSNS_RETURN_SUCCESS;
    }
    return resp;
}

+ (id)sharedWithJSONDictionary:(NSDictionary *)result
{
    Response *resp = [[Response alloc] init];
    if (result == nil || [result isKindOfClass:[NSNull class]]) {
        resp.code = kSNS_RETURN_SERVER_DATA_ERROR;
        resp.msg = kSNS_RETURN_SERVER_DATA_ERROR_Text;
        resp.body = nil;
        resp.success = NO;
        return resp;
    } else {
        resp.code = [Utils getSNSInteger:result[kResponseCodeKey]];
        resp.msg = [Utils getSNSString:result[kResponseMsgKey]];
        resp.body = result;
        resp.success = resp.code == kSNS_RETURN_SUCCESS;
    }
    return resp;
}

+(id)sharedWithError:(NSError *)error
{
    Response *resp = [[Response alloc] init];
    resp.body = nil;
    resp.success = NO;
    resp.code = error.code;
    resp.msg = [self getErrorMessageWithCode:error.code];
//    GBLog(@"%s error: %@", __FUNCTION__, error);
    return resp;
}

+(id)sharedWithException
{
    Response *resp = [[Response alloc] init];
    resp.code = kSNS_RETURN_SERVER_DATA_ERROR;
    resp.msg = kSNS_RETURN_SERVER_DATA_ERROR_Text;
    resp.body = nil;
    resp.success = NO;
//    GBLog(@"%s error: sharedWithException", __FUNCTION__);
    return resp;
}

/*
 *  根据返回CODE转换成对应的错误信息
 */
+(NSString*)getErrorMessageWithCode:(NSInteger)code
{
    switch (code) {
        case kSNS_RETURN_SERVER_DATA_ERROR: return kSNS_RETURN_SERVER_DATA_ERROR_Text;
        case kSNS_RETURN_SERVER_TOKEN_EXPIRED: return kSNS_RETURN_SERVER_TOKEN_EXPIRED_Text;
            
        case kSNS_RETURN_SERVER_1: return kSNS_RETURN_SERVER_1_Text;
        case kSNS_RETURN_SERVER_2: return kSNS_RETURN_SERVER_2_Text;
        case kSNS_RETURN_SERVER_3: return kSNS_RETURN_SERVER_3_Text;
        case kSNS_RETURN_SERVER_4: return kSNS_RETURN_SERVER_4_Text;
        case kSNS_RETURN_SERVER_5: return kSNS_RETURN_SERVER_5_Text;
        case kSNS_RETURN_SERVER_6: return kSNS_RETURN_SERVER_6_Text;
        case kSNS_RETURN_SERVER_7: return kSNS_RETURN_SERVER_7_Text;
        case kSNS_RETURN_SERVER_8: return kSNS_RETURN_SERVER_8_Text;
        case kSNS_RETURN_SERVER_9: return kSNS_RETURN_SERVER_9_Text;
        case kSNS_RETURN_SERVER_10: return kSNS_RETURN_SERVER_10_Text;
        case kSNS_RETURN_SERVER_11: return kSNS_RETURN_SERVER_11_Text;
            
        case kSNS_RETURN_SERVER_3840:return kSNS_RETURN_SERVER_3840_Text;
        case kSNS_RETURN_SERVER_NSFileLockingError:return kSNS_RETURN_SERVER_NSFileLockingError_Text;
        case kSNS_RETURN_SERVER_NSFileReadUnknownError:return kSNS_RETURN_SERVER_NSFileReadUnknownError_Text;
        case kSNS_RETURN_SERVER_NSFileReadNoPermissionError:return kSNS_RETURN_SERVER_NSFileReadNoPermissionError_Text;
        case kSNS_RETURN_SERVER_NSFileReadInvalidFileNameError:return kSNS_RETURN_SERVER_NSFileReadInvalidFileNameError_Text;
        case kSNS_RETURN_SERVER_NSFileReadCorruptFileError:return kSNS_RETURN_SERVER_NSFileReadCorruptFileError_Text;
        case kSNS_RETURN_SERVER_NSFileReadNoSuchFileError:return kSNS_RETURN_SERVER_NSFileReadNoSuchFileError_Text;
        case kSNS_RETURN_SERVER_NSFileReadInapplicableStringEncodingError:return kSNS_RETURN_SERVER_NSFileReadInapplicableStringEncodingError_Text;
        case kSNS_RETURN_SERVER_NSFileReadUnsupportedSchemeError:return kSNS_RETURN_SERVER_NSFileReadUnsupportedSchemeError_Text;
        case kSNS_RETURN_SERVER_NSFileReadTooLargeError:return kSNS_RETURN_SERVER_NSFileReadTooLargeError_Text;
        case kSNS_RETURN_SERVER_NSFileReadUnknownStringEncodingError:return kSNS_RETURN_SERVER_NSFileReadUnknownStringEncodingError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteUnknownError:return kSNS_RETURN_SERVER_NSFileWriteUnknownError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteNoPermissionError:return kSNS_RETURN_SERVER_NSFileWriteNoPermissionError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteInvalidFileNameError:return kSNS_RETURN_SERVER_NSFileWriteInvalidFileNameError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteInapplicableStringEncodingError:return kSNS_RETURN_SERVER_NSFileWriteInapplicableStringEncodingError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteUnsupportedSchemeError:return kSNS_RETURN_SERVER_NSFileWriteUnsupportedSchemeError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteOutOfSpaceError:return kSNS_RETURN_SERVER_NSFileWriteOutOfSpaceError_Text;
        case kSNS_RETURN_SERVER_NSFileWriteVolumeReadOnlyError:return kSNS_RETURN_SERVER_NSFileWriteVolumeReadOnlyError_Text;
        case kSNS_RETURN_SERVER_NSKeyValueValidationError:return kSNS_RETURN_SERVER_NSKeyValueValidationError_Text;
        case kSNS_RETURN_SERVER_NSFormattingError:return kSNS_RETURN_SERVER_NSFormattingError_Text;
        case kSNS_RETURN_SERVER_NSUserCancelledError:return kSNS_RETURN_SERVER_NSUserCancelledError_Text;
        case kSNS_RETURN_SERVER_NSPropertyListReadUnknownVersionError:return kSNS_RETURN_SERVER_NSPropertyListReadUnknownVersionError_Text;
        case kSNS_RETURN_SERVER_NSPropertyListReadStreamError:return kSNS_RETURN_SERVER_NSPropertyListReadStreamError_Text;
        case kSNS_RETURN_SERVER_NSPropertyListWriteStreamError:return kSNS_RETURN_SERVER_NSPropertyListWriteStreamError_Text;
        case kSNS_RETURN_SERVER_NSPropertyListErrorMaximum:return kSNS_RETURN_SERVER_NSPropertyListErrorMaximum_Text;
        case kSNS_RETURN_SERVER_NSExecutableNotLoadableError:return kSNS_RETURN_SERVER_NSExecutableNotLoadableError_Text;
        case kSNS_RETURN_SERVER_NSExecutableArchitectureMismatchError:return kSNS_RETURN_SERVER_NSExecutableArchitectureMismatchError_Text;
        case kSNS_RETURN_SERVER_NSExecutableRuntimeMismatchError:return kSNS_RETURN_SERVER_NSExecutableRuntimeMismatchError_Text;
        case kSNS_RETURN_SERVER_NSExecutableLoadError:return kSNS_RETURN_SERVER_NSExecutableLoadError_Text;
        case kSNS_RETURN_SERVER_NSExecutableLinkError:return kSNS_RETURN_SERVER_NSExecutableLinkError_Text;
        case kSNS_RETURN_SERVER_NSExecutableErrorMaximum:return kSNS_RETURN_SERVER_NSExecutableErrorMaximum_Text;
            
        case kSNS_RETURN_200: return kSNS_RETURN_200_Text;
        case kSNS_RETURN_201: return kSNS_RETURN_201_Text;
        case kSNS_RETURN_202: return kSNS_RETURN_202_Text;
        case kSNS_RETURN_203: return kSNS_RETURN_203_Text;
        case kSNS_RETURN_204: return kSNS_RETURN_204_Text;
            
        case kSNS_RETURN_301: return kSNS_RETURN_301_Text;
        case kSNS_RETURN_302: return kSNS_RETURN_302_Text;
        case kSNS_RETURN_303: return kSNS_RETURN_303_Text;
        case kSNS_RETURN_304: return kSNS_RETURN_304_Text;
        case kSNS_RETURN_305: return kSNS_RETURN_305_Text;
        case kSNS_RETURN_306: return kSNS_RETURN_306_Text;
            
        case kSNS_RETURN_400: return kSNS_RETURN_400_Text;
        case kSNS_RETURN_401: return kSNS_RETURN_401_Text;
        case kSNS_RETURN_402: return kSNS_RETURN_402_Text;
        case kSNS_RETURN_403: return kSNS_RETURN_403_Text;
        case kSNS_RETURN_404: return kSNS_RETURN_404_Text;
        case kSNS_RETURN_407: return kSNS_RETURN_407_Text;
        case kSNS_RETURN_415: return kSNS_RETURN_415_Text;
            
        case kSNS_RETURN_500: return kSNS_RETURN_500_Text;
        case kSNS_RETURN_501: return kSNS_RETURN_501_Text;
        case kSNS_RETURN_502: return kSNS_RETURN_502_Text;
        case kSNS_RETURN_503: return kSNS_RETURN_503_Text;
            
        case kSNS_RETURN_WECHAT_40001: return kSNS_RETURN_WECHAT_40001_Text;
        case kSNS_RETURN_WECHAT_40002: return kSNS_RETURN_WECHAT_40002_Text;
        case kSNS_RETURN_WECHAT_40003: return kSNS_RETURN_WECHAT_40003_Text;
        case kSNS_RETURN_WECHAT_40004: return kSNS_RETURN_WECHAT_40004_Text;
        case kSNS_RETURN_WECHAT_40007: return kSNS_RETURN_WECHAT_40007_Text;
        case kSNS_RETURN_WECHAT_40008: return kSNS_RETURN_WECHAT_40008_Text;
        case kSNS_RETURN_WECHAT_40009: return kSNS_RETURN_WECHAT_40009_Text;
        case kSNS_RETURN_WECHAT_40010: return kSNS_RETURN_WECHAT_40010_Text;
        case kSNS_RETURN_WECHAT_40011: return kSNS_RETURN_WECHAT_40011_Text;
        case kSNS_RETURN_WECHAT_40012: return kSNS_RETURN_WECHAT_40012_Text;
        case kSNS_RETURN_WECHAT_40013: return kSNS_RETURN_WECHAT_40013_Text;
        case kSNS_RETURN_WECHAT_40014: return kSNS_RETURN_WECHAT_40014_Text;
        case kSNS_RETURN_WECHAT_40015: return kSNS_RETURN_WECHAT_40015_Text;
        case kSNS_RETURN_WECHAT_40016: return kSNS_RETURN_WECHAT_40016_Text;
        case kSNS_RETURN_WECHAT_40017: return kSNS_RETURN_WECHAT_40017_Text;
        case kSNS_RETURN_WECHAT_40018: return kSNS_RETURN_WECHAT_40018_Text;
        case kSNS_RETURN_WECHAT_40019: return kSNS_RETURN_WECHAT_40019_Text;
        case kSNS_RETURN_WECHAT_40020: return kSNS_RETURN_WECHAT_40020_Text;
        case kSNS_RETURN_WECHAT_40023: return kSNS_RETURN_WECHAT_40023_Text;
        case kSNS_RETURN_WECHAT_40024: return kSNS_RETURN_WECHAT_40024_Text;
        case kSNS_RETURN_WECHAT_40025: return kSNS_RETURN_WECHAT_40025_Text;
        case kSNS_RETURN_WECHAT_40026: return kSNS_RETURN_WECHAT_40026_Text;
        case kSNS_RETURN_WECHAT_40027: return kSNS_RETURN_WECHAT_40027_Text;
        case kSNS_RETURN_WECHAT_40029: return kSNS_RETURN_WECHAT_40029_Text;
        case kSNS_RETURN_WECHAT_40030: return kSNS_RETURN_WECHAT_40030_Text;
        case kSNS_RETURN_WECHAT_40036: return kSNS_RETURN_WECHAT_40036_Text;
        case kSNS_RETURN_WECHAT_40037: return kSNS_RETURN_WECHAT_40037_Text;
        case kSNS_RETURN_WECHAT_40039: return kSNS_RETURN_WECHAT_40039_Text;
        case kSNS_RETURN_WECHAT_40048: return kSNS_RETURN_WECHAT_40048_Text;
        case kSNS_RETURN_WECHAT_40054: return kSNS_RETURN_WECHAT_40054_Text;
        case kSNS_RETURN_WECHAT_40055: return kSNS_RETURN_WECHAT_40055_Text;
        case kSNS_RETURN_WECHAT_40066: return kSNS_RETURN_WECHAT_40066_Text;
        case kSNS_RETURN_WECHAT_41001: return kSNS_RETURN_WECHAT_41001_Text;
        case kSNS_RETURN_WECHAT_41002: return kSNS_RETURN_WECHAT_41002_Text;
        case kSNS_RETURN_WECHAT_41003: return kSNS_RETURN_WECHAT_41003_Text;
        case kSNS_RETURN_WECHAT_41004: return kSNS_RETURN_WECHAT_41004_Text;
        case kSNS_RETURN_WECHAT_41005: return kSNS_RETURN_WECHAT_41005_Text;
        case kSNS_RETURN_WECHAT_41006: return kSNS_RETURN_WECHAT_41006_Text;
        case kSNS_RETURN_WECHAT_41007: return kSNS_RETURN_WECHAT_41007_Text;
        case kSNS_RETURN_WECHAT_41008: return kSNS_RETURN_WECHAT_41008_Text;
        case kSNS_RETURN_WECHAT_41009: return kSNS_RETURN_WECHAT_41009_Text;
        case kSNS_RETURN_WECHAT_41010: return kSNS_RETURN_WECHAT_41010_Text;
        case kSNS_RETURN_WECHAT_42001: return kSNS_RETURN_WECHAT_42001_Text;
        case kSNS_RETURN_WECHAT_42002: return kSNS_RETURN_WECHAT_42002_Text;
        case kSNS_RETURN_WECHAT_42003: return kSNS_RETURN_WECHAT_42003_Text;
        case kSNS_RETURN_WECHAT_43001: return kSNS_RETURN_WECHAT_43001_Text;
        case kSNS_RETURN_WECHAT_43002: return kSNS_RETURN_WECHAT_43002_Text;
        case kSNS_RETURN_WECHAT_43003: return kSNS_RETURN_WECHAT_43003_Text;
        case kSNS_RETURN_WECHAT_43004: return kSNS_RETURN_WECHAT_43004_Text;
        case kSNS_RETURN_WECHAT_44001: return kSNS_RETURN_WECHAT_44001_Text;
        case kSNS_RETURN_WECHAT_44002: return kSNS_RETURN_WECHAT_44002_Text;
        case kSNS_RETURN_WECHAT_44003: return kSNS_RETURN_WECHAT_44003_Text;
        case kSNS_RETURN_WECHAT_44004: return kSNS_RETURN_WECHAT_44004_Text;
        case kSNS_RETURN_WECHAT_44005: return kSNS_RETURN_WECHAT_44005_Text;
        case kSNS_RETURN_WECHAT_45001: return kSNS_RETURN_WECHAT_45001_Text;
        case kSNS_RETURN_WECHAT_45002: return kSNS_RETURN_WECHAT_45002_Text;
        case kSNS_RETURN_WECHAT_45003: return kSNS_RETURN_WECHAT_45003_Text;
        case kSNS_RETURN_WECHAT_45004: return kSNS_RETURN_WECHAT_45004_Text;
        case kSNS_RETURN_WECHAT_45005: return kSNS_RETURN_WECHAT_45005_Text;
        case kSNS_RETURN_WECHAT_45006: return kSNS_RETURN_WECHAT_45006_Text;
        case kSNS_RETURN_WECHAT_45007: return kSNS_RETURN_WECHAT_45007_Text;
        case kSNS_RETURN_WECHAT_45008: return kSNS_RETURN_WECHAT_45008_Text;
        case kSNS_RETURN_WECHAT_45009: return kSNS_RETURN_WECHAT_45009_Text;
        case kSNS_RETURN_WECHAT_45010: return kSNS_RETURN_WECHAT_45010_Text;
        case kSNS_RETURN_WECHAT_45011: return kSNS_RETURN_WECHAT_45011_Text;
        case kSNS_RETURN_WECHAT_45012: return kSNS_RETURN_WECHAT_45012_Text;
        case kSNS_RETURN_WECHAT_45016: return kSNS_RETURN_WECHAT_45016_Text;
        case kSNS_RETURN_WECHAT_45017: return kSNS_RETURN_WECHAT_45017_Text;
        case kSNS_RETURN_WECHAT_45018: return kSNS_RETURN_WECHAT_45018_Text;
        case kSNS_RETURN_WECHAT_50001: return kSNS_RETURN_WECHAT_50001_Text;
    }
    return kSNS_RETURN_SERVER_DEFAULT_Text;
}

@end
