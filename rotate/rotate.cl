#pragma OPENCL EXTENSION cl_khr_fp64 : enable

__kernel void kernel_rotate(__global unsigned char *src_img,
								__global unsigned char *dst_img,
								const int width,
								const int height)
{
	int row = get_global_id(0)/width;
	int col = get_global_id(0)%width;
	int pix;
	int drow = (get_global_id(0))/width;
	int dcol = (get_global_id(0))%width;
	int dpix;
		for(int m=0; m<9; m++)
		{
			for(int n=0; n<9; n++)
			{
				pix = row*width + col;
				dpix = (dcol*width) + drow;
					dst_img[dpix*3 + 0] = src_img[pix*3 + 0];
					dst_img[dpix*3 + 1] = src_img[pix*3 + 1];
					dst_img[dpix*3 + 2] = src_img[pix*3 + 2];
				
			}
		}
}

