// OpenCL kernel. Each work item takes care of one element of c

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void kernel_blur(__global unsigned char *src,
							__global unsigned char *dst,
							const int width,
							const int height) 
{

    int row = get_global_id(0) / width;
    int col = get_global_id(0) % width;
	int pix;
    float blue = 0, green = 0, red = 0;
	float mask[9][9]=
	{	{0.011237, 0.011637, 0.011931, 0.012111, 0.012172, 0.012111, 0.011931, 0.011637, 0.011237},
		{0.011637, 0.012051, 0.012356, 0.012542, 0.012605, 0.012542, 0.012356, 0.012051, 0.011637},
		{0.011931, 0.012356, 0.012668, 0.012860, 0.012924, 0.012860, 0.012668, 0.012356, 0.011931},
		{0.012111, 0.012542, 0.012860, 0.013054, 0.013119, 0.013054, 0.012860, 0.012542, 0.012111},
		{0.012172, 0.012605, 0.012924, 0.013119, 0.013185, 0.013119, 0.012924, 0.012605, 0.012172},
		{0.012111, 0.012542, 0.012860, 0.013054, 0.013119, 0.013054, 0.012860, 0.012542, 0.012111},
		{0.011931, 0.012356, 0.012668, 0.012860, 0.012924, 0.012860, 0.012668, 0.012356, 0.011931},
		{0.011637, 0.012051, 0.012356, 0.012542, 0.012605, 0.012542, 0.012356, 0.012051, 0.011637},
		{0.011237, 0.011637, 0.011931, 0.012111, 0.012172, 0.012111, 0.011931, 0.011637, 0.011237}
	};
  
    for(int m=0; m<9; m++)
    {   
        for(int n=0; n<9; n++)
        {   
	    	pix=(((row+m-4)%height)*width)*3 + ((col+n-4)%width)*3;
            red   += src[pix + 0] * mask[m][n];
            green += src[pix + 1] * mask[m][n]; 
            blue  += src[pix + 2] * mask[m][n];
        }   
    }   

    dst[(row*width + col)*3 + 0] =red;
    dst[(row*width + col)*3 + 1] =green;
    dst[(row*width + col)*3 + 2] =blue;
 
}

