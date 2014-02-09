#import "FMDatabase.h"
//NSString *databasePath;
@interface FMDatabaseFunctions : NSObject 
{
}
@end

@implementation FMDatabaseFunctions

/*
- (void) initialize
{
	FMDatabase *db = [[FMDatabase alloc] init ];
	NSString* dbPath = [db getDatabasePath]; 
	BOOL success = [db databaseExists:dbPath];
	if (!success)
		NSLog(@"DataBase Doesnot Exists");
	databasePath = [[ NSString alloc]initWithString:(NSString*)dbPath]; 
}
*/

/*
//================

//For Inserting

- (void) inserting
{
	FMDatabase* db = [FMDatabase databaseWithPath:databasePath];
	if (![db open]) {
		NSLog(@"Could not open db.");
	}

	[db beginTransaction];
//	[db executeUpdate:@"insert into Situation (SituationID,SituationName) values(?,?)",
//	[NSNumber numberWithInt:[situationID intValue]],
//	[NSString stringWithFormat:situAddName]];
	[db commit];
	[db close];
}	
	
	
//===============

//To Fetch

- (void) fetch
{
	FMDatabase* db = [FMDatabase databaseWithPath:databasePath];
	if (![db open]) {
		NSLog(@"Could not open db.");
	}
	FMResultSet *rs = [db executeQuery:@"select * from TableName"];
	while ([rs next]) {
//		NSInteger situId = [rs intForColumn:@"SituationID"];
//		NSString *situName = [rs stringForColumn:@"SituationName"];
	}
	[rs close];
}
	
	
//===============

//To Delete
- (void) delete
{
	FMDatabase* db = [FMDatabase databaseWithPath:databasePath];
	if (![db open]) {
		NSLog(@"Could not open db.");
	}

	NSString *query=[NSString stringWithFormat:@"delete from PracticeSituationMap where SituationID=%d",0];


	FMResultSet *rs = [db executeQuery:query];
	while ([rs next]) {
		
	}
	[rs close];
}	
*/	
//==============

//To Update
/*
- (void) update
{
	[db beginTransaction];
	[db executeUpdate:@"update FBTBSettings set SettingType = ?,BoolDefault=?,BoolAskMe=?,BoolNever=? Where SettingType=?",
	[NSString stringWithFormat:type],
	[NSNumber numberWithInt:BoolDefault],
	[NSNumber numberWithInt:BoolAskMe],
	[NSNumber numberWithInt:BoolNever],
	[NSString stringWithFormat:type]];
	[db commit];
}
*/
//delete from RatedVents where (strftime('%s','now') - strftime('%s',createdTime) > 86400);
/*
-(void)getNextDate{
	
	NSDate *myDate= [NSDate date];
	
	NSLog(@"Previous Date: %@",myDate);
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	// now build a NSDate object for the next day
	NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
	[offsetComponents setDay:1];
	NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: myDate options:0];
	
	NSLog(@"Next Date: %@",nextDate );
}
*/


@end
