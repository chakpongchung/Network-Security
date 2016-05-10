#include <stdio.h>
#include <string.h>
#include <math.h>
#include "cdjpeg.h"       /* Common decls for jpeg files */


/*

Sachin Shetty


DESCRIPTION OF PROGRAM

This program decodes the embedded text from the watermarked image . The lenght of the message decoded depends on 
the resolution of the image and other factors. For this program a message of 760 characters can be encoded for
800 x 600 images .

USAGE

./decode <watermarkedimage> <decodedmessage>

*/


int mask[132000],decode_int[33000];

int
main (int argc, char **argv)
{
  	struct jpeg_decompress_struct srcinfo;
  	struct jpeg_compress_struct dstinfo;
  	struct jpeg_error_mgr jsrcerr, jdsterr;
  	jvirt_barray_ptr *coef_arrays;
  	JDIMENSION i, compnum, rownum, blocknum;
   	size_t block_row_size;
  	JBLOCKARRAY coef_buffers[MAX_COMPONENTS],zig_zag[MAX_COMPONENTS];
  	JBLOCKARRAY row_ptrs[MAX_COMPONENTS];

  	FILE * input_file, *output_file;

 	int text=0,length,length_set=0,data_set=0 ,count_bits=0,test_mask=0,l=0;
 	int get_a=0,get_b=0,val_a=0,val_b=0;

 	srcinfo.err = jpeg_std_error(&jsrcerr);
	jpeg_create_decompress(&srcinfo);
  	dstinfo.err = jpeg_std_error(&jdsterr);
 	jpeg_create_compress(&dstinfo);
   	jsrcerr.trace_level = jdsterr.trace_level;
   	srcinfo.mem->max_memory_to_use = dstinfo.mem->max_memory_to_use;

       if ( argc == 3)
        {

  	input_file = fopen(argv[1] , "rb"); 
        output_file = fopen(argv[2], "w");
  	jpeg_stdio_src(&srcinfo, input_file);
  	(void) jpeg_read_header(&srcinfo, TRUE);
        for (compnum=0; compnum<srcinfo.num_components; compnum++)
            coef_buffers[compnum] = ((&dstinfo)->mem->alloc_barray) 
                                ((j_common_ptr) &dstinfo, JPOOL_IMAGE,
                              srcinfo.comp_info[compnum].width_in_blocks,
                              srcinfo.comp_info[compnum].height_in_blocks);
        coef_arrays = jpeg_read_coefficients(&srcinfo);
    	jpeg_copy_critical_parameters(&srcinfo, &dstinfo);
      	for (compnum=0; compnum<srcinfo.num_components; compnum++)
        {
        	block_row_size = (size_t) SIZEOF(JCOEF)*DCTSIZE2
	                     *srcinfo.comp_info[compnum].width_in_blocks;
		for (rownum=0; rownum<srcinfo.comp_info[compnum].height_in_blocks; rownum++)
	   	{
            		int k , l,j;
	      		row_ptrs[compnum] = ((&dstinfo)->mem->access_virt_barray) 
	                          ((j_common_ptr) &dstinfo, coef_arrays[compnum], 
	     			rownum, (JDIMENSION) 1, FALSE);
      			for (blocknum=0; blocknum<srcinfo.comp_info[compnum].width_in_blocks;
              			blocknum++)
			{ 
				k=-1; l =0;
       				for (i=0; i<DCTSIZE2; i++)
           				{
 						if (!length_set)
             						{
								if ( (i >0  )  && ( row_ptrs[compnum][0][blocknum][i] != 0) && (abs(row_ptrs[compnum][0][blocknum][i]) > 15))

                  							{
                                   

                               							int test_amask=0x08,k=0;
                               							int test = abs (row_ptrs[compnum][0][blocknum][i]);
                               							if (get_a ==1 && get_b ==1 ) 
                                							{
                                     								val_b *= 8;
                                 								length_set = 1;
                                 							}
                               							if (!get_a )
                               								{
                               									get_a=1;
                                
                               									for ( k = 0 ; k < 4;k++)
                                								{
                                   									if (test & test_amask)
                                     									val_a   += test_amask;
                                									test_amask =test_amask >> 1;
                                								}
                             								} 
                             							else 
                               						 	{
                                    
                                  						       	if (test & 0x01) val_b +=pow(2,val_a);
                                  							val_a-=1;
                                  							if (val_a == 0 ) get_b =1;
                                						}					 

                  							}
            								else
                  								coef_buffers[compnum][rownum][blocknum][i] =
            									row_ptrs[compnum][0][blocknum][i] ;
             						}
           					else
             						{
                						if (!data_set)
                   							{
										if ( (i >0  )  && ( row_ptrs[compnum][0][blocknum][i] != 0) && (abs(row_ptrs[compnum][0][blocknum][i]) > 1))
                       								{
                    									int test_mask=2,k=0;
                            						   		int test = abs (row_ptrs[compnum][0][blocknum][i]);
                               								if ( test >= 4)
                              								{
                               								       while (test_mask)	
                                								{
                                   									if (test & test_mask)
                                     								mask[count_bits] = mask[count_bits] | test_mask;
                                									test_mask = test_mask >> 1;
                                								}
                              								count_bits++;
                          								if ( count_bits == (val_b/2) ) data_set=1; 
                   									}
                   								}
                  								else
                                                                                     coef_buffers[compnum][rownum][blocknum][i] = row_ptrs[compnum][0][blocknum][i] ;
                                                                        }
                						else   coef_buffers[compnum][rownum][blocknum][i] = row_ptrs[compnum][0][blocknum][i] ;
            						}

        				}
			}
     
		}
}


i=0;
l=0;
while ( i < count_bits)
{
int k;
int decode_mask=0x80;
if (!test_mask) test_mask = 0x02;
 while (decode_mask)
  {
   if ( mask[i] & test_mask)
       decode_int[l] += decode_mask;
   test_mask >>=1;
  if (!test_mask) { i++; test_mask=0x02; }
 
  decode_mask >>=1;
  }
fprintf (output_file,"%c",decode_int[l]);
l++;
}
 (void) jpeg_finish_decompress(&srcinfo);
  jpeg_destroy_decompress(&srcinfo);
  fclose (input_file);
}

else

 {
    printf ("USAGE : \n");
    printf ("./decode <watermarkedimage> <decodedmessage>\n");  
}

return 0;      /* suppress no-return-value warnings */
}

