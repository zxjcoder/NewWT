//
//  HostManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/28/16.
//  Copyright © 2016 WT. All rights reserved.
//

#ifdef DEBUG

//局域网服务器
//#define kApiServerUrl @"http://192.168.3.6:9090/"
//#define kWebServerUrl @"http://192.168.3.6/"

//外网测试服务器
#define kApiServerUrl @"https://appdev.wutongsx.com/"
#define kWebServerUrl @"https://dev.wutongsx.com/"

//外网正式服务器
//#define kApiServerUrl @"https://appapi.wutongsx.com/"
//#define kWebServerUrl @"https://www.wutongsx.com/"

#else

//外网正式服务器
#define kApiServerUrl @"https://appapi.wutongsx.com/"
#define kWebServerUrl @"https://www.wutongsx.com/"

#endif
