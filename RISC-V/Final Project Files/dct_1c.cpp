#include "asap.h"

void dct_p1(core_input input[2], core_output output[2]){
    uint8_t idx;
    short vals[64];
    short x[8];
    short a00;
    short a10;
    short a20;
    short a30;
    short a40;
    short a50;
    short a60;
    short a70;
    short a01;
    short a11;
    short a21;
    short a31;
    short neg_a41;
    short a51;
    short a61;
    short a22;
    int32_t a23;
    int32_t mul5;
    int32_t a43;
    int32_t a53;
    int32_t a63;
    int32_t a54;
    int32_t a74;
    int32_t temp;
    int32_t temp1;

    for(uint8_t i = 0; i < 8; i++){ // for each column

        a00 = x[i+ 0] + x[i+56];
        a10 = x[i+ 8] + x[i+48];
        a20 = x[i+16] + x[i+40];
        a30 = x[i+24] + x[i+32];
        a40 = x[i+24] - x[i+32];
        a50 = x[i+16] - x[i+40];
        a60 = x[i+ 8] - x[i+48];
        a70 = x[i+ 0] - x[i+56];

        a01 = a00 + a30; 
        a11 = a10 + a20; 
        a21 = a10 - a20; 
        a31 = a00 - a30; 
        neg_a41 = a40 + a50; 
        a51 = a50 + a60; 
        a61 = a60 + a70; 

        a22 = a21 + a31;

        a23 = a22 * 11585;
        mul5 = (a61 - neg_a41) * 6270;
        a43 = (neg_a41 * 8867) - mul5;
        a53 = a51 * 11585;
        a63 = (a61 * 21407) - mul5;

        temp1 = a70 << 14;
        a54 = temp1 + a53;
        a74 = temp1 - a53;

        // Keeping everything homogenous
        y[i+0] = a01 + a11 << 2;
        y[i+32] = a01 - a11 << 2;

        // Only 10 bits are required before the decimal
        temp1 = a31 << 14;
        temp = temp1 + a23;
        y[i+16] = (temp + 0x800) >> 12; // Lazy Rounding
        temp = temp1 - a23;
        y[i+48] = (temp + 0x800) >> 12; // Lazy Rounding
        temp = a74 + a43;
        y[i+40] = (temp + 0x800) >> 12; // Lazy Rounding
        temp = a54 + a63;
        y[i+8] = (temp + 0x800) >> 12; // Lazy Rounding
        temp = a54 - a63;
        y[i+56] = (temp + 0x800) >> 12; // Lazy Rounding
        temp = a74 - a43;
        y[i+24] = (temp + 0x800) >> 12; // Lazy Rounding
    }
}