//
//  NSObject+AssociatedObject.h
//  onruby
//
//  Created by Martin Wilhelmi on 30.09.14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Associating)
@property (nonatomic, retain) id associatedObject;

- (id)associatedObject;
- (void)setAssociatedObject:(id)associatedObject;
@end
