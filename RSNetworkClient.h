#import <Foundation/Foundation.h>
@class DataObject;

@protocol RSNetworkClientResponseDelegate <NSObject>

-(void)RSNetworkClientResponse:(NSString *)callingType response:(NSDictionary *)response;

@end


@interface RSNetworkClient : NSObject <NSURLConnectionDataDelegate>{
	id delegate;
	SEL selector;
	NSMutableDictionary *additionalData;
	
}
@property (nonatomic,retain) NSString *callingType;

@property (nonatomic, assign) float bytesWritten;
@property (nonatomic, assign) float expectedToWrite;
@property (nonatomic, strong) NSMutableDictionary *additionalData;
@property (nonatomic,strong)    NSString *username;
@property (nonatomic,strong)    NSString *password;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSURLConnection *connection;

@property(nonatomic,retain)id<RSNetworkClientResponseDelegate>rsdelegate;
+(RSNetworkClient *)client;
+(NSString *)serverURL;

- (void)login;
- (void)registerUser;
- (void)updateProfile;
- (void)getGradesAndSubjects;
- (void)shareSet;
- (void)editSet;
- (void)deleteSet;
- (void)searchSet;
- (void)downloadSet;
- (void)getRoles;
- (void)getCareers;
- (void)addChild;
- (void)updateChild;
- (void)deleteChild;
- (void)sendScore;
- (void)getSetStatus;//by jin
- (void)setSetStatus;//by jin
- (void)sendFeedBack;//by jin
- (void)addRating;//by jin
- (void)getRating;//by jin
- (void)getAllRatings; //dii
- (void)addAssignments;//by jin
- (void)getAssignments;//by jin
- (void)getBadgeInfo;//by jin
- (void)forgetPass;//by jin
- (void)getParents;//by jin
- (void)getTeachers;//by jin
- (void)getApprovalItems; //DII
- (void)getDomains;//by jin
- (void)getGameAssigned;// by jin
- (void)getSkill;//by jin
- (void)getFavorites;//by jin
- (void)searchFavorites;//by jin
- (void)getTrendingHashtags;//by jin
- (void)searchVideoByHashtag;//by jin
- (void)getRatingByUser;//by jin
- (void)getFlagCheckBoxParam;
- (void)sendFlagValue;
- (void)checkUserAvailability;
- (void)getSchoolTeacherClasses;
- (void)getClasseType;


-(void)getLanguages;
-(void)getRepresentingPadrinoParam;
-(void)getAboutUSPadrinoParam;
-(void)getteacherSchoollvlParam;
-(void)getVideoTypeParam;

-(void)getVideoTypeCareerParam;
-(void)gettellAboutCareerParam;
-(void)gettestVideoTypeCareerParam;
@end
