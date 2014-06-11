
#import "RSNetworkClient.h"

#import "CJSONDeserializer.h"
#import "CJSONDataSerializer.h"

#import "Reachability.h"

#import "P2LCommon.h"
#import "LoginViewController.h"


@interface RSNetworkClient()

-(void)doSendRequest;
- (void)cancelConnection;
@end



@implementation RSNetworkClient

//test home
//static NSString *serverUrl = @"http://store.ctwitter.com.ar/index.php/";
//test client
//static NSString *serverUrl = @"http://www.corporate-group.net/avi44talk/index.php/";
@synthesize callingType;
@synthesize rsdelegate;

@synthesize additionalData;
@synthesize username        = _username;
@synthesize password        = _password;
@synthesize receivedData    = _receivedData;
@synthesize connection      = _connection;

@synthesize bytesWritten    = _bytesWritten;
@synthesize expectedToWrite = _expectedToWrite;

+(NSString*)serverURL {
    //return @"http://pop2learn.rheadev.com.ar/ci/index.php/";
    //    return @"http://plazafamilia.com/dev/ci/index.php/";
    return @"http://app.familyplaza.us/index.php/";
    
     //return @"http://192.168.10.134/iphone_project/index.php/";
}

+(RSNetworkClient *)client {
	return [[RSNetworkClient alloc] init];
}

-(id)init{
    
    self=[super init];
	
    self.additionalData = [NSMutableDictionary  dictionary];
    
    self.receivedData  = [[NSMutableData alloc] init];
	
	return self;
}
/**
 * Check Internet Connection return bool value
 */
-(BOOL)checkNetworkConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return false;
    } else {
        NSLog(@"There IS internet connection");
        return true;
    }
}
/**
 * Send Request to the Server
 */
-(void)doSendRequest {
    
    [self cancelConnection];
    
    if(![self checkNetworkConnection])
    {
        [LOADINGVIEW hideLoadingView];
        showError(@"Error", @"No Internet Connection");
        return;
    }
    NSURL *confUrl = nil;
    NSString *verb = [self.additionalData objectForKey:@"verb"];
  
	NSLog(@"Verb = %@", verb);
   
    [self.additionalData removeObjectForKey:@"verb"];
    if([[self.additionalData objectForKey:@"url"] rangeOfString:@"http://"].location == 0) {
        confUrl = [NSURL URLWithString:[self.additionalData objectForKey:@"url"]];
    } else {
        NSString *urlStr = [NSString stringWithFormat:[self.additionalData objectForKey:@"url"], [RSNetworkClient serverURL]];
                            
        confUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [self.additionalData removeObjectForKey:@"url"];
#ifdef DOLOG
    NSLog(@"Request to url %@",confUrl);
#endif
#ifdef VVERBOSE
    NSLog(@"Request %@",self.additionalData);
#endif
    
    NSURL *url = confUrl;
    NSDictionary *parameters = self.additionalData;
    NSLog(@"additionalDataparameters -- %@",parameters);
    
	NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    
    [headers setValue:@"*/*" forKey:@"Accept"];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:@"Keep-Alive" forKey:@"Connection"]; // Avoid HTTP 1.1 "keep alive" for the connection
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    if ([parameters count]>0)
    {
        CJSONDataSerializer *serializer = [[CJSONDataSerializer alloc] init];
        [request setHTTPBody:[serializer serializeDictionary:parameters]];
        
    }
    [request setHTTPMethod:verb];
	
    [request setAllHTTPHeaderFields:headers];
#ifdef DOLOG
	NSLog(@"request=%@", request.debugDescription);
#endif
    [self setConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]];
    if(!self.connection)
    {
        NSLog(@"error no conn");
    }
}

- (void)cancelConnection
{
    //DII WHAT ? maybe I'm still waiting for the answer from previous requests
//so no mo
#ifdef DIIVERBOSE
    NSLog(@"DII !!!! will cancel connection %@",self.connection.currentRequest.debugDescription);
#endif
//    [self.connection cancel];
    self.connection = nil;
}



- (void)login {
	[self.additionalData setObject:@"%@user/login" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    
    [self doSendRequest];
	
}
- (void)registerUser {
    [self.additionalData setObject:@"%@user/register" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

-(void)getRepresentingPadrinoParam{

    [self.additionalData setObject:@"%@user/getParams/padrino/representing" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

-(void)getAboutUSPadrinoParam{
    
    [self.additionalData setObject:@"%@user/getParams/padrino/hear_about_us" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
-(void)getLanguages
{
    [self.additionalData setObject:@"%@user/getParams/languages" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
-(void)getteacherSchoollvlParam{
    
    [self.additionalData setObject:@"%@user/getParams/school_levels" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}


-(void)getVideoTypeParam{
    [self.additionalData setObject:@"%@user/getParams/mainvideotypes" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

-(void)gettestVideoTypeCareerParam{
    [self.additionalData setObject:@"%@user/addVideoCareer" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

-(void)getVideoTypeCareerParam{
    [self.additionalData setObject:@"%@user/getParams/common/videotype" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

-(void)gettellAboutCareerParam{
    [self.additionalData setObject:@"%@user/getParams/aboutyou" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)sendScore {
    [self.additionalData setObject:@"%@user/submitScore" forKey:@"url"];
    [self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
    
}
- (void)getSchoolTeacherClasses {
    [self.additionalData setObject:@"%@user/getSchoolTeacherClasses" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)updateProfile {
    [self.additionalData setObject:@"%@user/editProfile" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)getGradesAndSubjects {
    [self.additionalData setObject:@"%@user/getStagesAndGradesAndSubjects" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)getRoles {
    [self.additionalData setObject:@"%@user/getRoles" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)getCareers {
    [self.additionalData setObject:@"%@user/getCareers" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)shareSet {
    [self.additionalData setObject:@"%@user/addQuestionSet" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
-(void)editSet {
    [self.additionalData setObject:@"%@user/update_set" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
-(void)deleteSet {
    [self.additionalData setObject:@"%@user/delete_set" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)searchSet {
    [self.additionalData setObject:@"%@user/searchSet" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)downloadSet {
    [self.additionalData setObject:@"%@user/getSetInformation" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)addChild {
    [self.additionalData setObject:@"%@user/addNewKid" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)getClasseType {
    [self.additionalData setObject:@"%@user/getParams/classtypes" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)updateChild {
    [self.additionalData setObject:@"%@user/editKidInfo" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)deleteChild {
    [self.additionalData setObject:@"%@user/deleteKid" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
    
}
//add by jin
- (void)getSetStatus {
	[self.additionalData setObject:@"%@user/getCategoryStatus" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
//add by jin
- (void)sendFeedBack {
	[self.additionalData setObject:@"%@user/flagCategoryStatus" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//add by jin
- (void)getBadgeInfo {
    [self.additionalData setObject:@"%@user/getBadgeInformation" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//by jin
- (void)addAssignments {
	[self.additionalData setObject:@"%@user/addAssignments" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//DII
-(void)getApprovalItems
{
	[self.additionalData setObject:@"%@user/getApprovalItems" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}


//by jin
- (void)getDomains {
	[self.additionalData setObject:@"%@user/getDomains" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//by jin
- (void)getSkill {
	[self.additionalData setObject:@"%@user/getSkills" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//by jin
- (void)forgetPass {
	[self.additionalData setObject:@"%@user/forgotPassword" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//by jin
- (void)getParents {
	[self.additionalData setObject:@"%@user/getParents" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    
      [self doSendRequest];
    
}

//by jin
- (void)getTeachers {
	[self.additionalData setObject:@"%@user/getTeachers" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//by jin
- (void)getGameAssigned {
	[self.additionalData setObject:@"%@user/getParentKidAssignments" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//by jin
- (void)getAssignments {
	//[self.additionalData setObject:@"%@user/getAssignments" forKey:@"url"];
    [self.additionalData setObject:@"%@user/searchAssignments" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//add by jin
- (void)addRating {
	[self.additionalData setObject:@"%@user/addRating" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
//add by jin
- (void)getRating {
    [self.additionalData setObject:@"%@user/getRating" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
//add by jin
- (void)getRatingByUser {
    [self.additionalData setObject:@"%@user/getRatingByUser" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)getAllRatings {
    [self.additionalData setObject:@"%@user/getAllRatings" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)getFlagCheckBoxParam{
    [self.additionalData setObject:@"%@user/getParams/flag_options" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)sendFlagValue {
    [self.additionalData setObject:@"%@user/flagCategoryStatus" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
//add by jin
-(void)getFavorites {
    [self.additionalData setObject:@"%@user/getFavorites" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
-(void)searchFavorites {
    [self.additionalData setObject:@"%@user/searchItems" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
//add by jin
- (void)setSetStatus {
	[self.additionalData setObject:@"%@user/updateCategoryStatus" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
- (void)checkUserAvailability
{
    [self.additionalData setObject:@"%@user/check_username" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}
//add by jin
- (void)getTrendingHashtags {
	[self.additionalData setObject:@"%@user/getTopTrendingHashtags" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

//add by jin
- (void)searchVideoByHashtag {
	[self.additionalData setObject:@"%@user/searchSetByHashtag" forKey:@"url"];
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
-(void)wrapperHasBadCredentials:(NSDictionary *)data
{
    NSLog(@"BadCredentials");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    switch (statusCode) {
        case 200:
            break;
        default:
            
            break;
    }
    [self.receivedData setLength:0];
#ifdef DOLOG
	NSLog(@"didReceiveResponse: %ld", (long)statusCode);
#endif
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
	
#ifdef VVERBOSE2
    NSString *response = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
	NSLog(@"Response: %@", response);
#endif
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [LOADINGVIEW hideLoadingView];
    showError(@"Error", @"Network Error");
    [self cancelConnection];
}
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    self.bytesWritten = totalBytesWritten;
    self.expectedToWrite = totalBytesExpectedToWrite;
   
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

	if(resp)
    {
		NSLog(@"Valid response: %@",resp);
	}
    else
    {
		NSLog(@"Response: %@", response);
        [LOADINGVIEW hideLoadingView];//if error than hide
        return;
	}

    @try {
        //if(IsPointerAnObject((__bridge void *)self) && self.delegate && IsPointerAnObject((__bridge void *)self.delegate))
            //DII	if(self.delegate)
        //Response To The Delegate
        
        NSLog(@"Calling Type %@",self.callingType);
        [self.rsdelegate RSNetworkClientResponse:self.callingType response:resp];
        
//        if(self.delegate)
//        {
//            if([self.delegate respondsToSelector:self.selector] && resp)
//            {
//                [self.delegate performSelectorOnMainThread:self.selector withObject:resp waitUntilDone:NO];
//            }
//        }
//        else
//        {
//            NSLog(@"self is corrupted !");
//        }
        
        
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark -
@end
