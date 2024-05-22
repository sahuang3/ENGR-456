#include "asap.h"

const uint16_t huffman_table_DC_Y[] = {
	0,
	2,
	3,
	4,
	5,
	6,
	14,
	30,
	62,
	126,
	254,
	510
};

const uint16_t huffman_table_DC_Y_sizes[] = {
	2,
	3,
	3,
	3,
	3,
	3,
	4,
	5,
	6,
	7,
	8,
	9
};

const uint16_t huffman_table_AC_Y0[] = {
	10,
	0,
	1,
	4,
	11,
	26,
	120,
	248,
	1014,
	65410,
	65411,
};
const uint16_t huffman_table_AC_Y1[] = {
	12,
	27,
	121,
	502,
	2038,
	65412,
	65413,
	65414,
	65415,
	65416,
};
const uint16_t huffman_table_AC_Y2[] = {
	28,
	249,
	1015,
	4084,
	65417,
	65418,
	65419,
	65420,
	65421,
	65422,
};
const uint16_t huffman_table_AC_Y3[] = {
	58,
	503,
	4085,
	65423,
	65424,
	65425,
	65426,
	65427,
	65428,
	65429,
};
const uint16_t huffman_table_AC_Y4[] = {
	59,
	1016,
	65430,
	65431,
	65432,
	65433,
	65434,
	65435,
	65436,
	65437,
};
const uint16_t huffman_table_AC_Y5[] = {
	122,
	2039,
	65438,
	65439,
	65440,
	65441,
	65442,
	65443,
	65444,
	65445,
};
const uint16_t huffman_table_AC_Y6[] = {
	123,
	4086,
	65446,
	65447,
	65448,
	65449,
	65450,
	65451,
	65452,
	65453,
};
const uint16_t huffman_table_AC_Y7[] = {
	250,
	4087,
	65454,
	65455,
	65456,
	65457,
	65458,
	65459,
	65460,
	65461,
};
const uint16_t huffman_table_AC_Y8[] = {
	504,
	32704,
	65462,
	65463,
	65464,
	65465,
	65466,
	65467,
	65468,
	65469,
};
const uint16_t huffman_table_AC_Y9[] = {
	505,
	65470,
	65471,
	65472,
	65473,
	65474,
	65475,
	65476,
	65477,
	65478,
};
const uint16_t huffman_table_AC_Ya[] = {
	506,
	65479,
	65480,
	65481,
	65482,
	65483,
	65484,
	65485,
	65486,
	65487,
};
const uint16_t huffman_table_AC_Yb[] = {
	1017,
	65488,
	65489,
	65490,
	65491,
	65492,
	65493,
	65494,
	65495,
	65496,
};
const uint16_t huffman_table_AC_Yc[] = {
	1018,
	65497,
	65498,
	65499,
	65500,
	65501,
	65502,
	65503,
	65504,
	65505,
};
const uint16_t huffman_table_AC_Yd[] = {
	2040,
	65506,
	65507,
	65508,
	65509,
	65510,
	65511,
	65512,
	65513,
	65514,
};
const uint16_t huffman_table_AC_Ye[] = {
	65515,
	65516,
	65517,
	65518,
	65519,
	65520,
	65521,
	65522,
	65523,
	65524,
};
const uint16_t huffman_table_AC_Yf[] = {
	2041,
	65525,
	65526,
	65527,
	65528,
	65529,
	65530,
	65531,
	65532,
	65533,
	65534
};

uint8_t get_size(int16_t val){
	if (val == 0) return 0;
	uint8_t size = 0;
	if (val < 0) {val = ~val + 1;}
	while (val != 0) {
		size++;
		val = val >> 1;
	}
	return size;
}

uint16_t get_AC_Y_val(uint8_t code){
    if (code < 0x10) {
        return huffman_table_AC_Y0[code & 0xf];
    } else if (code < 0x20){
        return huffman_table_AC_Y1[(code & 0xf) - 1];
    } else if (code < 0x30){
        return huffman_table_AC_Y2[(code & 0xf) - 1];
    } else if (code < 0x40){
        return huffman_table_AC_Y3[(code & 0xf) - 1];
    } else if (code < 0x50){
        return huffman_table_AC_Y4[(code & 0xf) - 1];
    } else if (code < 0x60){
        return huffman_table_AC_Y5[(code & 0xf) - 1];
    } else if (code < 0x70){
        return huffman_table_AC_Y6[(code & 0xf) - 1];
    } else if (code < 0x80){
        return huffman_table_AC_Y7[(code & 0xf) - 1];
    } else if (code < 0x90){
        return huffman_table_AC_Y8[(code & 0xf) - 1];
    } else if (code < 0xa0){
        return huffman_table_AC_Y9[(code & 0xf) - 1];
    } else if (code < 0xb0){
        return huffman_table_AC_Ya[(code & 0xf) - 1];
    } else if (code < 0xc0){
        return huffman_table_AC_Yb[(code & 0xf) - 1];
    } else if (code < 0xd0){
        return huffman_table_AC_Yc[(code & 0xf) - 1];
    } else if (code < 0xe0){
        return huffman_table_AC_Yd[(code & 0xf) - 1];
    } else if (code < 0xf0){
        return huffman_table_AC_Ye[(code & 0xf) - 1];
    } else {
        return huffman_table_AC_Yf[code & 0xf];
    }
}

void huffman_Y(){

	int16_t prev_DC_Y = 0;
    short val;
    short val_inter;
	uint8_t code = 1;
    uint8_t size_of_bits = 0;
	
	while (1) {
		size_of_bits = get_size(x_val[0]);
        out_index = 0
		y_val[out_index] = huffman_table_DC_Y[size_of_bits];
		y_size[out_index] = huffman_table_DC_Y_sizes[size_of_bits];
        out_index++;
		y_val[out_index] = x_val[0];
		y_size[out_index] = size_of_bits;
        out_index++;
        in_index = 1;
		code = 1; // to start loop
		while (code > 0) {
			code = x_code[in_index];
			val = x_val[in_index];
            in_index++;
			while (code == 0xf0) {
				y_val[out_index] = get_AC_Y_val(code);
				y_size[out_index] = get_size_AC(get_AC_Y_val(code));
                out_index++;
                code = x_code[in_index];
                val = x_val[in_index];
                in_index++;
			}
			
            if (in_index == 65) {return;} // If you've read 64 input values, then you know the 65th is junk and the EOB is skipped.
			
            y_val[out_index] = get_AC_Y_val(code);
            y_size[out_index] = get_size_AC(get_AC_Y_val(code));
            out_index++;
			
			if (code == 0) {return;} // on EOB you don't write back val
            y_val[out_index] = val;
            y_size[out_index] = get_size(val);
            out_index++;
		}
	}
}