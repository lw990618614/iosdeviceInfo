//
//  main.m
//  ClientTest
//
//  Created by 王鹏飞 on 16/7/1.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
struct my_structure {
    uint64_t first_element; // 64 bits = 64/8 bytes = 8 bytes
    uint32_t second_element; // 32 bits = 32/8 bytes = 4 bytes
    char *third_element; // 64 bits = 64/8 bytes = 8 bytes
};
int main(int argc, char * argv[]) {
    
//    struct my_structure mystruct;
//        unsigned int *addr = (unsigned int*)&mystruct; // get address of structure
//    uint64_t *addr_first_element = (uint64_t *)addr; // address of first element = address of struct
//    uint32_t *addr_second_element = addr + sizeof(mystruct.first_element); // address of first + size of it
//    char *addr_third_element = (char *)addr_second_element + sizeof(mystruct.second_element);
//        // get some data ready
//    uint64_t first = 0x4141; uint32_t second = 0x4242; char third[] = "CCCC";
//        // copy them to our retrivied addresses
//    memcpy(addr_first_element, &first, sizeof(first)); memcpy(addr_second_element, &second, sizeof(second)); memcpy(addr_third_element, &third, sizeof(third));
//        // read the data back
//        printf( "element 1: 0x%llx\n"
//                "element 2: 0x%x\n"
//    "element 3: %s\n", *addr_first_element, *addr_second_element,
//    addr_third_element );
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
