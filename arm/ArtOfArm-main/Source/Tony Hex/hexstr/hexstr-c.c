// hexstr-c.c
//  
// Convert values of various sizes to zero terminated hex strings.
//     u64ToHexStr   64-bit double word
//     u32ToHexStr   32-bit word
//     u16ToHexStr   16-bit half word
//     u8ToHexStr    8-bit byte
//     u4ToHexStr    4-bit nibble

#include "hexstr.h"

const char *lookup = "0123456789ABCDEF";

const char *u64ToHexStr(char *buffer, uint64_t value) {
    buffer[ 0] = lookup[ value >> 60];
    buffer[ 1] = lookup[(value >> 56) & 0xF];
    buffer[ 2] = lookup[(value >> 52) & 0xF];
    buffer[ 3] = lookup[(value >> 48) & 0xF];
    buffer[ 4] = lookup[(value >> 44) & 0xF];
    buffer[ 5] = lookup[(value >> 40) & 0xF];
    buffer[ 6] = lookup[(value >> 36) & 0xF];
    buffer[ 7] = lookup[(value >> 32) & 0xF];
    buffer[ 8] = lookup[(value >> 28) & 0xF];
    buffer[ 9] = lookup[(value >> 24) & 0xF];
    buffer[10] = lookup[(value >> 20) & 0xF];
    buffer[11] = lookup[(value >> 16) & 0xF];
    buffer[12] = lookup[(value >> 12) & 0xF];
    buffer[13] = lookup[(value >>  8) & 0xF];
    buffer[14] = lookup[(value >>  4) & 0xF];
    buffer[15] = lookup[ value        & 0xF];
    buffer[16] = 0;
    
    return buffer;
}

const char *u32ToHexStr(char  *buffer, uint32_t value) {
    buffer[0] = lookup[(value >> 28) & 0xF];
    buffer[1] = lookup[(value >> 24) & 0xF];
    buffer[2] = lookup[(value >> 20) & 0xF];
    buffer[3] = lookup[(value >> 16) & 0xF];
    buffer[4] = lookup[(value >> 12) & 0xF];
    buffer[5] = lookup[(value >>  8) & 0xF];
    buffer[6] = lookup[(value >>  4) & 0xF];
    buffer[7] = lookup[ value        & 0xF];
    buffer[8] = 0;

    return buffer;
}

const char *u16ToHexStr(char  *buffer, uint16_t value) {
    buffer[0] = lookup[(value >> 12) & 0xF];
    buffer[1] = lookup[(value >>  8) & 0xF];
    buffer[2] = lookup[(value >>  4) & 0xF];
    buffer[3] = lookup[ value        & 0xF];
    buffer[4] = 0;

    return buffer;
}

const char *u8ToHexStr(char  *buffer, uint8_t  value) {
    buffer[0] = lookup[(value >>  4) & 0xF];
    buffer[1] = lookup[ value        & 0xF];
    buffer[2] = 0;

    return buffer;
}

const char *u4ToHexStr(char  *buffer, uint8_t  value) {
    buffer[0] = lookup[value & 0xF];
    buffer[1] = 0;

    return buffer;
}
