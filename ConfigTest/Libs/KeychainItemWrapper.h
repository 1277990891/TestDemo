
#import <UIKit/UIKit.h>

@interface KeychainItemWrapper : NSObject

@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

@property (nonatomic, assign) id secAttrAccount;
@property (nonatomic, assign) id secValueData;

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;

+ (KeychainItemWrapper*)uniqueIdentifierItem;
+ (KeychainItemWrapper*)sessionTokenItem;

- (NSString*)uniqueIdentifier;

@end
