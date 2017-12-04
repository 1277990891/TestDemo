
//
//  UseAccountViewController.m
//  ConfigTest
//
//  Created by li bo on 04/12/2017.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "UseAccountViewController.h"


@interface UseAccountViewController ()

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *accountTableView;

@end

@implementation UseAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Private

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        NSFetchRequest* fetchRequest = [NSFetchRequest new];

        NSEntityDescription* entity = [NSEntityDescription entityForName:@"NSUserAccount" inManagedObjectContext:self.model.managedObjectContext];
        [fetchRequest setEntity:entity];

        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"height" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

        //        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"activity == %@", self.activity];
        NSFetchedResultsController* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.model.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        //        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;

        NSError* error = nil;
        if (![self.fetchedResultsController performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _fetchedResultsController;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    NSInteger result = [self.fetchedResultsController.sections count];

    return result;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];

    return  sectionInfo.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell* resultCell = nil;
    if (resultCell == nil) {
        resultCell = [self.accountTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSUserAccount* account = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self configureNSUserAccountCell:resultCell withAccount:account forIndexPath:indexPath];
    }

    return resultCell;
}

- (void)configureNSUserAccountCell:(UITableViewCell*)cell withAccount:(NSUserAccount*)account forIndexPath:(NSIndexPath*)indexPath
{
    cell.textLabel.text = account.email;
}

- (NSIndexPath*)indexPathOfLastObject
{
    NSIndexPath* result = nil;

    NSInteger numberOfSections = self.fetchedResultsController.sections.count;
    NSInteger numberOfRowsInLastSection = self.fetchedResultsController.sections[numberOfSections - 1].numberOfObjects;

    if (numberOfSections > 0 && numberOfRowsInLastSection > 0)
    {
        result = [NSIndexPath indexPathForRow:(numberOfRowsInLastSection - 1) inSection:(numberOfSections - 1)];
    }

    return result;
}
@end
