//
//  GroupCell.h
//  Yelp
//
//  Created by Sarp Centel on 2/16/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupCell : NSObject

@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, strong) NSString *sectionLabel;
@property (nonatomic, strong) NSArray *rowLabels;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *yelpFilterName;
@property (nonatomic, assign, readonly) NSInteger numRows;

- initWithSectionLabel:(NSString*)sectionLabel rowLabels:(NSArray*)rowLabels yelpFilterName:(NSString*)filterName;
- (NSString*)labelForRow:(NSInteger) row;
- (BOOL) isRowOn:(NSInteger)row;

@end
