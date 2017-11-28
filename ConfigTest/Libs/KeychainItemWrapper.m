
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

static KeychainItemWrapper* sUniqueIdentifierKeychainItem = nil;
NSString* const NGUniqueIdentifierKeychainItemIdentifier = @"com.netpulse.keychain.uniqueidentifier";

@interface KeychainItemWrapper (PrivateMethods)

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

- (void)writeToKeychain;

@end

@implementation KeychainItemWrapper

@synthesize keychainItemData, genericPasswordQuery;

- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
{
    if (self = [super init])
    {
        genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
		[genericPasswordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [genericPasswordQuery setObject:identifier forKey:(id)kSecAttrGeneric];
        [genericPasswordQuery setObject:identifier forKey:(id)kSecAttrService];
		
		if (accessGroup != nil)
		{
#if TARGET_IPHONE_SIMULATOR
#else
			[genericPasswordQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
		}
		
        [genericPasswordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [genericPasswordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:genericPasswordQuery];
        
        NSMutableDictionary *outDictionary = nil;
        
        if (SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary) != noErr)
        {
            NSMutableDictionary* tempQuery2 = [tempQuery mutableCopy];
            [tempQuery2 removeObjectForKey:(id)kSecAttrService];
            if (SecItemCopyMatching((CFDictionaryRef)tempQuery2, (CFTypeRef *)&outDictionary) != noErr)
            {
                [self resetKeychainItem];

                [keychainItemData setObject:identifier forKey:(id)kSecAttrGeneric];
                [keychainItemData setObject:identifier forKey:(id)kSecAttrService];
                if (accessGroup != nil)
                {
#if TARGET_IPHONE_SIMULATOR
#else
                    [keychainItemData setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
                }
            }
            else
            {
                self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
                [self.keychainItemData setObject:identifier forKey:(id)kSecAttrService];
                [self writeToKeychain];
            }
		}
        else
        {
            self.keychainItemData = [self secItemFormatToDictionary:outDictionary];
        }
       
		[outDictionary release];
    }
    
	return self;
}

- (void)dealloc
{
    [keychainItemData release];
    [genericPasswordQuery release];
    
	[super dealloc];
}

- (void)setObject:(id)inObject forKey:(id)key 
{
    if (inObject == nil) return;
    id currentObject = [keychainItemData objectForKey:key];
    if (![currentObject isEqual:inObject])
    {
        [keychainItemData setObject:inObject forKey:key];
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key
{
    return [keychainItemData objectForKey:key];
}

- (void)resetKeychainItem
{
	OSStatus junk = noErr;
    if (!keychainItemData) 
    {
        self.keychainItemData = [NSMutableDictionary dictionary];
    }
    else if (keychainItemData)
    {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:keychainItemData];
		junk = SecItemDelete((CFDictionaryRef)tempDictionary);
        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
    }
    
    [keychainItemData setObject:@"" forKey:(id)kSecAttrAccount];
    [keychainItemData setObject:@"" forKey:(id)kSecAttrLabel];
    [keychainItemData setObject:@"" forKey:(id)kSecAttrDescription];
    
    [keychainItemData setObject:@"" forKey:(id)kSecValueData];
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];

    NSString *passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *passwordData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)returnDictionary, (CFTypeRef *)&passwordData) == noErr)
    {
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        
        NSString *password = [[[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length]
                                                     encoding:NSUTF8StringEncoding] autorelease];
        [returnDictionary setObject:password forKey:(id)kSecValueData];
    }
    else
    {
        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
    }
    
    [passwordData release];
   
	return returnDictionary;
}

- (void)writeToKeychain
{
    NSDictionary *attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
	OSStatus result;
    
    if (SecItemCopyMatching((CFDictionaryRef)genericPasswordQuery, (CFTypeRef *)&attributes) == noErr)
    {
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        [updateItem setObject:[genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:keychainItemData];
        [tempCheck removeObjectForKey:(id)kSecClass];
		
#if TARGET_IPHONE_SIMULATOR
		[tempCheck removeObjectForKey:(id)kSecAttrAccessGroup];
#endif
        
        result = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
		NSAssert( result == noErr, @"Couldn't update the Keychain Item." );
    }
    else
    {
        result = SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:keychainItemData], NULL);
		NSAssert( result == noErr, @"Couldn't add the Keychain Item." );
    }
}

+ (KeychainItemWrapper*)uniqueIdentifierItem
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sUniqueIdentifierKeychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:NGUniqueIdentifierKeychainItemIdentifier accessGroup:nil];
    });
    return sUniqueIdentifierKeychainItem;
}

- (NSString*)uniqueIdentifier
{
    NSString* uniqueIdentifier = self.secValueData;

    if (uniqueIdentifier.length == 0)
    {
        self.secValueData = [[NSUUID UUID] UUIDString];
    }
    
    return self.secValueData;
}

- (id)secValueData
{
    return [self objectForKey:(__bridge id)(kSecValueData)];
}

- (void)setSecValueData:(id)secValueData
{
    [self setObject:secValueData forKey:(__bridge id)(kSecValueData)];
}

+ (KeychainItemWrapper*)sessionTokenItem
{
    static KeychainItemWrapper* sessionTokenKeychainItem = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionTokenKeychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"NGSessionTokenKeychainItemIdentifier" accessGroup:nil];
    });
    return sessionTokenKeychainItem;
}

@end
