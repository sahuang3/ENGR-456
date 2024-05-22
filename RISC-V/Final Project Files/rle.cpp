	y_code[0] = 0x0000; // not used, but put here for easier coding on later steps
	y_val[0] = x[0]; // EOI/DC Pass along
	zero_count = 0;
    out_index = 0;
	for (i = 1; i < 64; i++){
		val = x[i];
		if (val == 0) {zero_count++;}
		else {
			while (zero_count > 15){
				y_code[out_index] = 0x00f0;
				y_val[out_index] = 0x0000; // not used, but put here for easier coding on later steps
				zero_count -= 16;
                out_index++;
			}
			y_code[out_index] = zero_count << 4 | get_size(val);
			y_val[out_index] = val;
			zero_count = 0;
            out_index++;
		}
	}
    if x[63] != 0 {
        y_code[out_index] = 0x0000;
        y_val[out_index] = 0x0001;
    }

    uint16_t get_size(short val){
	if (val == 0) {return 0;}
	if (val < 0) {val = ~val + 1;} // use 2's comp to find size
    // algo: http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogObvious
	uint16_t size = 0;
    if (val & 0xff00) {
        val = val >> 8; // UNSIGNED >>
        size |= 8;
    } 
    if (val & 0xf0) {
        val = val >> 4; // UNSIGNED >>
        size |= 4;
    } 
    if (val & 0xc) {
        val = val >> 2; // UNSIGNED >>
        size |= 2;
    } 
    if (val & 0x2) {
        size |= 1;
    } 
	return (size+1);
}