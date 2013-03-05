/*
 *  Finds the first smaller sample in the given array
 *
 *  INPUTS:
 *  array   : [double/single column vector] a sorted array
 *  value   : [double/single]
 *
 *  OUTPUT:
 *  index   : [double] the 
 *
 *  Sagi Perel, 10/2012
 */

#include "mex.h"
#include "matrix.h"

void
mexFunction(
	int num_output_args,        // Number of left hand side (output) arguments
	mxArray *output_arg[],      // Array of left hand side arguments
	int num_input_args,         // Number of right hand side (input) arguments
	const mxArray *input_arg[]) // Array of right hand side arguments
{
    double *array, value, *ptr;
    float  *array_f;
    int array_length, this_array_length;
    mxClassID array_type;
    int debug=0;
    int i;
    int start_idx, end_idx, middle_idx;
    double epsilon = 0.00001;

    //sanity check for input arguments
	if( num_input_args != 2) mexErrMsgTxt( "Cfind_first_smaller_sample_in_array2.c: wrong syntax: Cfind_first_smaller_sample_in_array2(array, value)\n");
    if( mxGetN(input_arg[0]) != 1 && mxGetM(input_arg[0]) != 1 ) mexErrMsgTxt( "Cfind_first_smaller_sample_in_array2.c: the array must be a vector\n");
    array_type = mxGetClassID(input_arg[0]);
    if( array_type != mxDOUBLE_CLASS && array_type != mxSINGLE_CLASS ) mexErrMsgTxt( "Cfind_first_smaller_sample_in_array2.c: the array must be a column vector of type double or float\n");
    
    if( mxGetN(input_arg[1]) != 1) mexErrMsgTxt( "Cfind_first_smaller_sample_in_array2.c: the value must be a double\n");
    if( mxGetM(input_arg[1]) != 1) mexErrMsgTxt( "Cfind_first_smaller_sample_in_array2.c: the value must be a double\n");
    
    array_length = (mxGetM(input_arg[0]) > mxGetN(input_arg[0])) ? mxGetM(input_arg[0]) : mxGetN(input_arg[0]);
    
    //read input arguments:
    ptr = (double*) mxGetData( input_arg[1]);
    value = *ptr;
    if(debug)
        printf("array_length=%d,value=%f\n",array_length,value);
   

    //-read the signal and find the first 
    switch(array_type)
    {
	    case mxDOUBLE_CLASS:
		    array = (double *) mxGetData( input_arg[0]);

            //verify the array is sorted
            if(array[0] < array[array_length-1])
                mexErrMsgTxt( "Cfind_first_smaller_sample_in_array2.c: array should be sorted in decreasing order\n");
            
		    //check for edge condition- if the first element is smaller than the value
		    if((array[0] - value)<0)
		    {
			    output_arg[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
			    *mxGetPr(output_arg[0]) = 1;
			    return;
		    }

		    //shrink the array size by half every time
		    start_idx  = 0;
		    end_idx = array_length-1;
		    while(1)
		    {
				
			    this_array_length = end_idx - start_idx + 1;
                            if(debug)
                            	printf("start_idx=%d end_idx=%d (%d)",start_idx, end_idx, this_array_length);

			    if(this_array_length <= 20)
			    {
				    middle_idx = search_array_serial(array, value, start_idx, this_array_length);
                    if(debug)
                        printf("\nthis_array_length<=20: middle_idx=%d\n",middle_idx);
				    if(middle_idx < 0)
				    {
					    output_arg[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
					    return;
				    }else{

					    output_arg[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
					    *mxGetPr(output_arg[0]) = middle_idx;
					    return;
				    }	
			    }

			    middle_idx = (this_array_length % 2 == 0 )? (start_idx+(this_array_length/2)) : (start_idx+((this_array_length-1)/2));
                            if(debug)
				printf(" middle_idx=%d,val=%f\n",middle_idx,array[middle_idx]);
			    //shrink the array size by half
			    if(mxIsNaN(array[middle_idx]))
			    {
                   if(middle_idx == start_idx)
                   {
                        output_arg[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
                        return;
                   }else{
                        middle_idx = middle_idx -1;
                   }
                }else{
                                    /*
                                    //if the middle_idx is exactly the value we are looking for- numerical issues might cause to miss it
				    if(array[middle_idx]-epsilon <= value && array[middle_idx]+epsilon >= value)
			            {
				   	output_arg[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
                                        *mxGetPr(output_arg[0]) = middle_idx+1;
                                        return;
                                    }
				    */

                    //else continue as usual
				    if((array[middle_idx] - value) < 0)
				    {
					    end_idx = middle_idx;	
				    }else{
					    start_idx  = middle_idx;
                    }
			    }
		    }	    

		    break;
	    case mxSINGLE_CLASS:
		    array_f = (float *) mxGetData( input_arg[0]);
		    for(i=0; i<array_length; i++)
		    {
			    if((array_f[i] - value) < 0)
			    {
				    output_arg[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
				    *mxGetPr(output_arg[0]) = (i+1);
				    return;
			    }
		    }
		    break;            
    }

    //create an empty output, to be returned if no such item exists
    output_arg[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
}


int search_array_serial(double* array, double value, int start_idx, int array_length)
{
	int i;
	for(i=start_idx; i<start_idx+array_length; i++)
	{
		if((array[i] - value) <= 0)
		{
			return (i+1);
		}
	}
        return -1;
}

