//
//  _Router+hybrid.h
//  kata
//
//  Created by fallen.ink on 07/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_router.h"

@interface NSObject (hybrid)

/**
 *  open html link
 *
 *  @param url link
 */
- (void)router_openHtml:(NSString *)url;

- (void)router_openHtml:(NSString *)url extraParams:(NSDictionary *)params;

@end
