//
//  Detect.s
//  SampleApp
//
//  Created by gavinYang on 2021/12/12.
//
.text
.global _AntiDebugFromPath ,_mystatTest,_memset,_stat

_mystatTest:
sub    sp, sp, #0xc0             ; =0xc0
stp    x29, x30, [sp, #0xb0]
add    x29, sp, #0xb0            ; =0xb0
sub    x8, x29, #0x8             ; =0x8
str    x8, [sp]
str    x0, [x8]
add    x0, sp, #0x18             ; =0x18
str    x0, [sp, #0x8]
mov    w1, #0x0
mov    x2, #0x90
bl     _memset
ldr    x8, [sp]
ldr    x1, [sp, #0x8]
ldr    x0, [x8]
bl     _stat
str    w0, [sp, #0x14]
ldp    x29, x30, [sp, #0xb0]
add    sp, sp, #0xc0             ; =0xc0
ret

_AntiDebugFromPath:
sub    sp, sp, #0x10             ; =0x10
str    x0, [sp, #0x8]
ldr    x8, [sp, #0x8]
mov    x8, x8
mov    x0, x8
mov    x1, #0x0
mov    x2, #0x0
mov    x3, #0x0
mov    w16, #0xbc
svc    #0x80
add    sp, sp, #0x10             ; =0x10
ret
