//
//  BskyBaseNetConfig.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/6/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BskyBaseNetConfig.h"
#import <AFNetworking.h>

@implementation BskyBaseNetConfig

- (void)setType:(SeverType)type
{
    [super setType:type];
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css", nil] forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    switch (type) {
        case SeverType_Dev:
            config.baseUrl = @"https://ssldev.jkscw.com.cn/";
//            config.baseUrl = @"http://192.168.0.108:8080/";
//            config.baseUrl = @"http://192.168.10.123:4564";
            break;
        case SeverType_Test:
            config.baseUrl = @"https://ssldev.jkscw.com.cn/";
//            config.baseUrl = @"http://192.168.10.125:4564/";
            
            break;
        case SeverType_Release:
            config.baseUrl = @"https://apissl.jkscw.com.cn/";
            break;
        default:
            break;
    }
//    AFHTTPSessionManager *manager = [agent valueForKey:@"_manager"];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
//    __block AFHTTPSessionManager *blockManager = manager;
//    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
//        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
//        /**
//                  *  导入多张CA证书
//                  */
//        NSString *cerPath = [[NSBundle mainBundle]pathForResource:@"bskyHttps" ofType:@"cer"];//自签名证书
//        NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
//        NSSet *cerArray = [NSSet setWithObjects:caCert, nil];
//        blockManager.securityPolicy.pinnedCertificates = cerArray;
//        SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
//        NSCAssert(caRef != nil, @"caRef is nil");
//        NSArray *caArray = @[(__bridge id)(caRef)];
//        NSCAssert(caArray != nil, @"caArray is nil");
//        OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
//        SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
//        NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
//        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//        __autoreleasing NSURLCredential *credential = nil;
//        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//            if ([blockManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
//                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//                if (credential) {
//                    disposition = NSURLSessionAuthChallengeUseCredential;
//                }else
//                {
//                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//                }
//            }
//            else
//            {
//                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
//            }
//        }
//        else
//        {
//            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
//        }
//        return disposition;
//    }];
}


@end
