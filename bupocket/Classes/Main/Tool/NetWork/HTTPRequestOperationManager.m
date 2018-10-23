//
//  HTTPRequestOperationManager.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "HTTPRequestOperationManager.h"
#import "URLRequestSerialization.h"

@interface HTTPRequestOperationManager()

@property(nonatomic,strong) NSString *URL;
@property(nonatomic,strong) NSString *method;
@property(nonatomic,strong) NSDictionary *parameters;
@property(nonatomic,strong) NSMutableURLRequest *request;
@property(nonatomic,strong) NSURLSession *session;
@property(nonatomic,strong) NSURLSessionDataTask *task;

@end

@implementation HTTPRequestOperationManager

- (instancetype)initWithMethod:(NSString *)method URL:(NSString *)URL parameters:(id)parameters
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.URL = URL;
    self.method = method;
    self.parameters = parameters;
//    self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    self.request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URL parameters:parameters error:nil];
    self.request.timeoutInterval = 10.f;
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    self.session = [NSURLSession sharedSession];
    return self;
}

-(void)test{
    NSLog(@"URL = %@",self.URL);
}

-(void)setRequest{
    if ([self.method isEqual:@"GET"]&&self.parameters.count>0) {
        
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[self.URL stringByAppendingString:@"?"] stringByAppendingString: [URLRequestSerialization LYQueryStringFromParameters:self.parameters]]]];
    }
    self.request.HTTPMethod = self.method;
    
    if (self.parameters.count>0) {
        [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
}


-(void)setBody{
    if (self.parameters.count>0&&![self.method isEqual:@"GET"]) {
        
        self.request.HTTPBody = [[URLRequestSerialization LYQueryStringFromParameters:self.parameters] dataUsingEncoding:NSUTF8StringEncoding];
    }
}


-(void)setTaskWithSuccess:(void(^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(void (^)(NSError *__nullable error))failure
{
    self.task = [self.session dataTaskWithRequest:self.request completionHandler:^(NSData * data,NSURLResponse *response,NSError *error){
        if (error) {
            failure(error);
        }else{
            if (success) {
                success(data,response);
            }
        }
    }];
    [self.task resume];
}


-(void)driveTask:(void(^)(NSData *__nullable data,NSURLResponse * __nullable response))success
         failure:(void (^)(NSError *__nullable error))failure
{
    [self setRequest];
    [self setBody];
    [self setTaskWithSuccess:success failure:failure];
}

@end
