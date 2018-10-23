//
//  QCloudCOSXMLEndPoint.m
//  Pods
//
//  Created by Dong Zhao on 2017/8/22.
//
//

#import "QCloudCOSXMLEndPoint.h"
#import "NSString+RegularExpressionCategory.h"
@implementation QCloudCOSXMLEndPoint

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _isPrefixURL = YES;
    _serviceName = @"myqcloud.com";
    return self;
}



- (NSString *)formattedBucket:(NSString*)bucket withAPPID:(NSString*)APPID {
    NSInteger subfixLength = APPID.length + 1;
    if (bucket.length <= subfixLength) {
        return bucket;
    }
    NSString* APPIDSubfix = [NSString stringWithFormat:@"-%@",APPID];
    NSString* subfixString = [bucket substringWithRange:NSMakeRange(bucket.length - subfixLength  , subfixLength)];
    if ([subfixString isEqualToString:APPIDSubfix]) {
        return [bucket substringWithRange:NSMakeRange(0, bucket.length - subfixLength)];
    }
    //should not reach here
    return bucket;
}

-(NSURL *)serverURLWithBucket:(NSString *)bucket appID:(NSString *)appID regionName:(NSString *)regionName{
    if (self.serverURLLiteral) {
        return self.serverURLLiteral;
    }
    
    NSString* scheme = @"https";
    if (!self.useHTTPS) {
        scheme = @"http";
    }
    static NSString *regularExpression = @"[a-zA-Z0-9.-]*";
    BOOL isLegal = [bucket matchesRegularExpression:regularExpression];
    NSAssert(isLegal, @"bucket name contains illegal character! It can only contains a-z, A-Z, 0-9, '.' and '-' ");
    if (!isLegal) {
        QCloudLogDebug(@"bucket %@ contains illeagal character, building service url pregress  returns immediately", bucket);
        return  nil;
    }
    
    NSString* formattedBucketName = [self formattedBucket:bucket withAPPID:appID]; ;
    NSString *regionNametmp = nil;
    if (regionName) {
        regionNametmp = regionName;
    }else{
        regionNametmp = self.regionName;
    }
    NSString *tmpBucket = formattedBucketName;
    if (appID) {
        tmpBucket = [NSString stringWithFormat:@"%@-%@",formattedBucketName,appID];
    }
    NSURL *serverURL;

        if (_isPrefixURL) {
            if (regionNametmp) {
                    serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@.cos.%@.%@",scheme,tmpBucket,regionNametmp,self.serviceName]];
                }else{
                    serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@.cos.%@",scheme,tmpBucket,self.serviceName]];
                }
        }else{
            if (regionNametmp) {
                    serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://cos.%@.%@/%@",scheme,regionNametmp,self.serviceName,tmpBucket]];
                }else{
                    serverURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://cos.%@/%@",scheme,self.serviceName,tmpBucket]];
                }
            }
   
    return serverURL;
}
-(void)setIsPrefixURL:(BOOL)isPrefixURL{
    _isPrefixURL = isPrefixURL;
}
- (void)setRegionName:(QCloudRegion)regionName {
    //Region 仅允许由 a-z, A-Z, 0-9, 英文句号. 和 - 构成。
    if ([self.serviceName isEqualToString:@"myqcloud.com"]) {
        NSParameterAssert(regionName);
        static NSString *regularExpression = @"[a-zA-Z0-9.-]*";
        BOOL isLegal = [regionName matchesRegularExpression:regularExpression];
        NSAssert(isLegal, @"Region name contains illegal character! It can only contains a-z, A-Z, 0-9, '.' and '-' ");
        if (!isLegal) {
            QCloudLogDebug(@"Region %@ contains illeagal character, setter returns immediately", regionName);
            return ;
        }
    }
   
   
    _regionName = regionName;
}
- (id)copyWithZone:(NSZone *)zone {
    QCloudCOSXMLEndPoint* endpoint = [super copyWithZone:nil];
    endpoint.regionName = self.regionName;
    endpoint.serviceName = self.serviceName;
    endpoint.isPrefixURL = self.isPrefixURL;
    return endpoint;
}
@end
