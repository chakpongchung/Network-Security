#include <stdio.h>
#include <string.h>
#include <math.h>
#include "cdjpeg.h"       /* Common decls for Reading jpeg files */

/*

SACHIN SHETTY 

DESCRIPTION OF PROGRAM 

This program encodes hidden message in a jpeg image . The length of the message depends on the resolution on the image
For image of size 800 x 600 900 characters can be succesfully embedded and decoded  . For smaller resolutions the length 
differs

USAGE :

./embed <source image> <messagefile> <destinationimage>

*/

int mask[133000];

/* Utility to convert message into binary bits */

 
char * convert(char str[])

{
char *result=malloc(280000); 
int i,j,hex_res,k=0;

  for ( i = 0 ; i < strlen(str) ; i++ )
  {
  int test_mask=0x80;
  int test=str[i];
    for ( j =0 ; j < 8 ; j++ )
     {
      int res = test & test_mask;
      if (res ) 
           result[k++]='1';
      else result[k++]='0';
      test_mask = test_mask >> 1;
     }
 }
result[k]='\0';
j=0;
for ( i = 0 ; i< strlen(result) ; i+=2 )
 {
         if ( result[i] == '1') mask[j] |= 0x02;
         if ( result[i+1] == '1') mask[j] |= 0x01;
  j+=1;

}
return (result);
} 
    

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

  FILE *input_file, *output_file, *fp_message;

  int filesize, text=0, length_set=0,data_set=0,count_bits=0;
  char *bin_str,*str,*res_str,mess_encr[255],encode_str[255];

  int len_a =3,val_a=0,len_b=0,val_b=0,test_amask=0x04,test_bmask;
  int len_mask=0, index,k,l,fp_char=0,c, temp, elem;

  srcinfo.err = jpeg_std_error(&jsrcerr);
  jpeg_create_decompress(&srcinfo);
  dstinfo.err = jpeg_std_error(&jdsterr);
  jpeg_create_compress(&dstinfo);
  jsrcerr.trace_level = jdsterr.trace_level;
  srcinfo.mem->max_memory_to_use = dstinfo.mem->max_memory_to_use;

  if ( argc == 4 )
  {

  input_file = fopen(argv[1] , "rb"); 
  output_file =fopen(argv[3] , "wb"); 
  fp_message =fopen(argv[2] , "r"); 

  jpeg_stdio_src(&srcinfo, input_file);

/* Read the message to be encoded into the buffer */
  str = (char *) malloc (33000);
  while ((c=fgetc(fp_message)) != -1)
  	str[fp_char++]=c;
  str[fp_char]='\0';
  fseek(fp_message, 0, SEEK_SET);

  bin_str=convert(str);
  printf ("Message File Read and Converted to Bits\n");
  (void) jpeg_read_header(&srcinfo, TRUE);
   for (compnum=0; compnum<srcinfo.num_components; compnum++)
            coef_buffers[compnum] = ((&dstinfo)->mem->alloc_barray) 
                                ((j_common_ptr) &dstinfo, JPOOL_IMAGE,
                              srcinfo.comp_info[compnum].width_in_blocks,
                              srcinfo.comp_info[compnum].height_in_blocks);
   coef_arrays = jpeg_read_coefficients(&srcinfo);
   jpeg_copy_critical_parameters(&srcinfo, &dstinfo);
   for (  elem = 0 ; elem <= 15 ; elem++)
     {
         int   temp =  pow( 2 , elem);
         if (temp > strlen(str))
            {
               len_b = elem-1;
               break;
            }
     }
   test_bmask = pow(2,len_b);
   printf ("Reading High Frequency Components from the Image \n");
   for (compnum=0; compnum<srcinfo.num_components; compnum++)
     {
          block_row_size = (size_t) SIZEOF(JCOEF)*DCTSIZE2 *srcinfo.comp_info[compnum].width_in_blocks;

	  for (rownum=0; rownum<srcinfo.comp_info[compnum].height_in_blocks; rownum++)
	   {
            int k , l,tag=1,j;
            row_ptrs[compnum] = ((&dstinfo)->mem->access_virt_barray) 
	                          ((j_common_ptr) &dstinfo, coef_arrays[compnum], 
                         	     rownum, (JDIMENSION) 1, FALSE);
            for (blocknum=0; blocknum<srcinfo.comp_info[compnum].width_in_blocks;
              blocknum++)
               {
                   int x,y,count=0;
                   k=-1; l =0;
                   for (i=0; i<DCTSIZE2; i++)
                    {
             		if (!length_set)
             		 {

                            if ( (i >0)  &&   ( row_ptrs[compnum][0][blocknum][i] != 0) && (abs(row_ptrs[compnum][0][blocknum][i]) > 15))
                             {
                     
                               int length=strlen(str);
                               int test;
                               if ( len_a ==0 && len_b ==0 ) length_set = 1; 
                               if (len_a != 0)
                                {  
                               		int test_amask = 0x08;
                               		len_a=0;
                               		test = abs(row_ptrs[compnum][0][blocknum][i]);
                                	test >>=4; 
                               		for ( k = 0 ; k < 4 ; k++ )
                                 		{
                                   			test<<=1;
                                   			if ( test_amask & len_b)
                                        		test |=  1;
                                    			test_amask >>=1;
                                 		}
                               }
                              else  
                                {  
                               		len_b -=1;
                                 	test = abs(row_ptrs[compnum][0][blocknum][i]);
                                 	test >>=1; 
                                 	test <<=1;
                                	if ( strlen(str) & test_bmask) test |= 1; 
                                	test_bmask >>=1;
                               }
                              
                            if ( row_ptrs[compnum][0][blocknum][i] < 0 ) 
                               coef_buffers[compnum][rownum][blocknum][i]=-test;
                               
                            else 
                               coef_buffers[compnum][rownum][blocknum][i]=test;
                               
                         }
                       else
                  		coef_buffers[compnum][rownum][blocknum][i] =
            			row_ptrs[compnum][0][blocknum][i] ;
                     }
                     else
             		{
                		if (!data_set)    
                   			{
 						if ( ( i  > 0 )  &&   ( row_ptrs[compnum][0][blocknum][i] != 0) && (abs(row_ptrs[compnum][0][blocknum][i]) > 1))
                       				{

                       					int k=0;
                               				int test = abs(row_ptrs[compnum][0][blocknum][i]);
                               				if ( test >=4 )
                              					{
                               						int test_mask=0x02;
                               						test >>= 2;
                                					for ( k = 0 ; k < 2 ; k++ )
                               							{
                                  							test <<=1;
                                  							if (  mask[count_bits] & test_mask)
                                   							test |=0x01;
                                 							test_mask >>=1;
                               							}
                             						if ( test !=0 && test !=1)
                              						{
                             							if ( row_ptrs[compnum][0][blocknum][i] < 0 )
                                  					          coef_buffers[compnum][rownum][blocknum][i]=-test;
                            							else
                          							  coef_buffers[compnum][rownum][blocknum][i] = test;
                             							count_bits++;
                           						}
                             					}
                          				if ( count_bits == ( strlen(bin_str)/ 2) ) data_set=1;

                       				}
                  			       else coef_buffers[compnum][rownum][blocknum][i] = row_ptrs[compnum][0][blocknum][i] ;
                   			}
                			else   coef_buffers[compnum][rownum][blocknum][i] = row_ptrs[compnum][0][blocknum][i] ;
            		}
                      
               }
         }
     }
}
printf ("Embedding  Message File to the Image adjusting the high frequency components \n");
     for (compnum=0; compnum<srcinfo.num_components; compnum++)
          {
             block_row_size = (size_t) SIZEOF(JCOEF)*DCTSIZE2
	                     *srcinfo.comp_info[compnum].width_in_blocks;
	   for (rownum=0; rownum<srcinfo.comp_info[compnum].height_in_blocks; rownum++)
	   {
           	int k , l;
	        row_ptrs[compnum] = ((&dstinfo)->mem->access_virt_barray) 
	                          ((j_common_ptr) &dstinfo, coef_arrays[compnum], 
	        rownum, (JDIMENSION) 1, FALSE);
                for (blocknum=0; blocknum<srcinfo.comp_info[compnum].width_in_blocks;
                     blocknum++)
       		for (i=0; i<DCTSIZE2; i++)
            		row_ptrs[compnum][0][blocknum][i]= coef_buffers[compnum][rownum][blocknum][i] ;
          }
        }
  jpeg_stdio_dest(&dstinfo, output_file);
  jpeg_write_coefficients(&dstinfo, coef_arrays);
  jpeg_finish_compress(&dstinfo);
  jpeg_destroy_compress(&dstinfo);
  (void) jpeg_finish_decompress(&srcinfo);
  jpeg_destroy_decompress(&srcinfo);
  fclose(output_file);
  fclose (input_file);

}

else

 {
    printf ("Usage : \n"); 
    printf ("./embed <imagefile> <message> <outputimage> : \n"); 

 }

  return 0;      /* suppress no-return-value warnings */
}

