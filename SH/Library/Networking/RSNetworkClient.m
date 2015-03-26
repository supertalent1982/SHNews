#import "RSNetworkClient.h"

#import "CJSONDeserializer.h"
#import "AppDelegate.h"
#import "CJSONDataSerializer.h"
#import "NSData+Base64.h"

@interface RSNetworkClient()

-(void)doSendRequest;
- (void)cancelConnection;
@end



@implementation RSNetworkClient

//test home
//static NSString *serverUrl = @"http://store.ctwitter.com.ar/index.php/";
//test client
//static NSString *serverUrl = @"http://www.corporate-group.net/avi44talk/index.php/";

@synthesize selector;
@synthesize delegate    = _delegate;
@synthesize additionalData;
@synthesize username    = _username;
@synthesize password    = _password;
@synthesize receivedData    = _receivedData;
@synthesize connection      = _connection;
@synthesize progressSelector    = _progressSelector;
@synthesize bytesWritten    = _bytesWritten;
@synthesize expectedToWrite = _expectedToWrite;

+(NSString*)serverURL {
    return @"http://188.121.37.148/mobApi/";
}
+(RSNetworkClient *)client {
	return [[RSNetworkClient alloc]init];
}

-(id)init{
	if(self==[super init]) {
		self.additionalData = [NSMutableDictionary  dictionary];
        self.receivedData  = [[NSMutableData alloc] init];
	}
	return self;
}

-(void)doSendRequest {
    [self cancelConnection];
    NSURL *confUrl = nil;
    NSString *verb = [self.additionalData objectForKey:@"verb"];
	NSLog(@"Verb = %@", verb);
    [self.additionalData removeObjectForKey:@"verb"];
    NSString *requestURL = [self.additionalData objectForKey:@"url"];
    if([requestURL rangeOfString:@"http://"].location == 0) {
        confUrl = [NSURL URLWithString:requestURL];
    } else {
        confUrl = [NSURL URLWithString:[[NSString stringWithFormat:[self.additionalData objectForKey:@"url"], [RSNetworkClient serverURL]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [self.additionalData removeObjectForKey:@"url"];
    NSLog(@"Request to url %@",confUrl);
#ifdef DEBUG
    NSLog(@"Request %@",self.additionalData);
#endif
    
    NSURL *url = confUrl;
    NSDictionary *parameters = self.additionalData;
    
	NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    
    [headers setValue:@"*/*" forKey:@"Accept"];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:@"Keep-Alive" forKey:@"Connection"]; // Avoid HTTP 1.1 "keep alive" for the connection
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    if ([parameters count]>0)
    {
        CJSONDataSerializer *serializer = [[CJSONDataSerializer alloc] init];
        [request setHTTPBody:[serializer serializeDictionary:parameters]];
        
    }
    [request setHTTPMethod:verb];
    [request setTimeoutInterval:5000];
	
    [request setAllHTTPHeaderFields:headers];
	NSLog(@"request=%@", request.debugDescription);
    [self setConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]];
    if(!self.connection)
    {
        NSLog(@"error no conn");
    }
}

- (NSMutableURLRequest*)makeRequest:(NSDictionary*)data url:(NSString*)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [RSNetworkClient serverURL], url]]];
    [request setHTTPMethod:@"POST"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
    
    NSMutableData *body = [NSMutableData data];
    //[body appendData:[@"Content-Type: application/json\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:postData];
    
    [request setHTTPBody:body];
    
    return request;
    
}

- (void)cancelConnection {
	[self.connection cancel];
    self.connection = nil;
}

- (void)cancelRequest
{
    self.delegate = nil;
}

- (void)sendRequest:(NSString *)param {
	[self.additionalData setObject:param forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)uploadProfile {
	[self.additionalData setObject:@"%@uploadProfile.php" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSInteger count = [challenge previousFailureCount];
    if (count == 0) {
        NSURLCredential* credential = [NSURLCredential credentialWithUser:self.username
																 password:self.password
															  persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential
               forAuthenticationChallenge:challenge];
    }
    else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        if ([delegate respondsToSelector:@selector(wrapperHasBadCredentials:)]) {
            //[delegate wrapperHasBadCredentials:self];
        }
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    switch (statusCode) {
        case 200:
            break;
        default:
            if (delegate && [delegate respondsToSelector:@selector(wrapper:didReceiveStatusCode:)]) {
                //[delegate wrapper:self didReceiveStatusCode:statusCode];
            }
            break;
    }
    [self.receivedData setLength:0];
#ifdef DEBUG
	NSLog(@"didReceiveResponse: %d", statusCode);
#endif
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"RSNetworkClient ERROR=%@", error);
    if (error.code == NSURLErrorTimedOut)
    {
        NSLog(@"====================== TIMEOUT ====== ");
    }
    [self cancelConnection];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wrapper:didFailWithError:)]) {
        [self.delegate wrapper:nil didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    self.bytesWritten = totalBytesWritten;
    self.expectedToWrite = totalBytesExpectedToWrite;
    if(self.delegate && [self.delegate respondsToSelector:self.progressSelector]){
        [self.delegate performSelectorOnMainThread:self.progressSelector withObject:self waitUntilDone:NO];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self cancelConnection];
    NSData *respdata = self.receivedData;
    NSString *response = [[NSString alloc] initWithData:respdata encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *resp = nil;
    if([response rangeOfString:@"["].location==0) {
        NSArray *responseArray = [[CJSONDeserializer deserializer] deserializeAsArray:respdata error:&error];
        resp = [NSDictionary dictionaryWithObject:responseArray forKey:@"response"];
    } else {
        resp = [[CJSONDeserializer deserializer] deserializeAsDictionary:respdata error:&error];
    }
    
    if(error){
        NSLog(@"could not parse response %@",error);
    }
#ifndef DEBUG
	if(resp) {
		NSLog(@"Valid response: %@",resp);
	}	else {
		NSLog(@"Response: %@", response);
	}
#endif
	if(self.delegate) {
		if( self.delegate && [self.delegate respondsToSelector:self.selector]) {
			[self.delegate performSelectorOnMainThread:self.selector withObject:resp waitUntilDone:NO];
		}
	}
    else
    {
        NSLog(@"mmmmmmmmmmmmmm");
    }
}

#pragma mark -
@end
