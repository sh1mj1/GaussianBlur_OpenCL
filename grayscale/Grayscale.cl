// OpenCL kernel. Each work item takes care of one element of c

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void kernel_grayscale(__global unsigned char *src,
								__global unsigned char *dst,
								const int width,
								const int height)
{
	int row = get_global_id(0) / width;
	int col = get_global_id(0) % width;
	int pix;
	float blue = 0, green = 0, red = 0, gray = 0;

	for(int m=0; m<9; m++)
	{
		for(int n=0; n<9; n++)
		{
			pix=row*width + col;
				red	 = src[pix*3 + 0] * 0.2126;
				green	 = src[pix*3 + 1] * 0.7152;
				blue	 = src[pix*3 + 2] * 0.0722;
				gray	 = red+green+blue;
				dst[pix*3 + 0] = gray;
				dst[pix*3 + 1] = gray;
				dst[pix*3 + 2] = gray;
		}
	}
}





