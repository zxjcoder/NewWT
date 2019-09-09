//
//  RegexKeyManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//


/**
 *  NSPredicate - regexStr
 */
#define kPredicate_UserName @"^([a-zA-Z]|[u4e00-u9fa5]){0,10}$"
#define kPredicate_Url @"^[a-zA-z]+://[^\\s]*$"
#define kPredicate_IdentityCard @"^(\\d{14}|\\d{17})(\\d|[xX])$"
#define kPredicate_Code @"^\\d{6}$"
#define kPredicate_Email @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
//@"^1(3|5|6|7|8|9)\\d{9}$"
#define kPredicate_Mobile @"^(0|86|17951)?(13[0-9]|15[0-9]|16[0-9]|18[0-9]|19[0-9]|17[0-9]|14[0-9])[0-9]{8}$"
#define kPredicate_Phone @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
#define kPredicate_CarNo @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$"
//@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$" //-只能包含数字和字母
#define kPredicate_Password @"^[0-9A-Za-z]{6,16}$"
#define kPredicate_NickName @"^([\u4e00-\u9fa5]{1,38})|[a-zA-Z_0-9]{1,38}|[\u4E00-\u9FA5A-Za-z0-9_.]{1,38}$"
#define kPredicate_RealName @"^([\u4e00-\u9fa5]{1,15})$"
#define kPredicate_Qualifications @"^[a-zA-Z0-9]{2,16}$"

#define kPredicate_BankName @"^([\u4e00-\u9fa5]{2,10})$"
#define kPredicate_BankNumber @"^[0-9]{5,20}$"

#define kPredicate_Chinese @"^[\\u3000-\\u301e\\ufe10-\\ufe19\\ufe30-\\ufe44\\ufe50-\\ufe6b\\uff01-\\uffee]{0,}$"
#define kPredicate_QQ @"^[1-9]\\d{4,16}$"
