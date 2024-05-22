#include "asap.h"
#include "./../quantize_y.h"

void quantize_Y(core_input input[2], core_output output[2]){
    int32_t temp;
    int32_t temp2;
    while (1) {
        for (uint8_t i=0; i<64; i++){
            temp2 = x[i] * Q_Y[i];
            y[i] = (temp2 + 0x8000) >> 16;
        }
    }
}