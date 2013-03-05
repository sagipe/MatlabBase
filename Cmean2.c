/*
 *  Computes the mean of a matrix
 *
 *  INPUT:
 *  matrix: [double] or [float]
 *  dim   : [int] dimension to calculate mean along (up to 2D matrices)
 *
 *  OUTPUT:
 *  mean    : the mean of the given vector/matrix
 *
 *  Sagi Perel, 02/2012
 */

//#include <string.h> /* needed for memcpy() */
#include "mex.h"

int debug=0;

void matrix_mean(double* matrix, int num_rows, int num_cols, double** mean, int dim)
{
    int i,j;
	double* mean_ptr = (*mean);
    
    if(dim==1)
    {
        //add up the columns
        for(i=0; i<num_cols; i++)
            for(j=0; j<num_rows; j++)
                mean_ptr[i] += matrix[i*num_rows+j];
        //compute the mean
        for(i=0; i<num_cols; i++)
            mean_ptr[i] = mean_ptr[i]/num_rows;
    }else{
        //add up the rows
        for(i=0; i<num_rows; i++)
            for(j=0; j<num_cols; j++)
                mean_ptr[i] += matrix[i+j*num_rows];
        //compute the mean
        for(i=0; i<num_rows; i++)
            mean_ptr[i] = mean_ptr[i]/num_cols;
    }
}

void matrix_mean_f(float* matrix, int num_rows, int num_cols, float** mean, int dim)
{
    int i,j;
	float* mean_ptr = (*mean);
    
    //add up the columns
	for(i=0; i<num_cols; i++)
        for(j=0; j<num_rows; j++)
            mean_ptr[i] += matrix[i*num_rows+j];

    for(i=0; i<num_cols; i++)
        mean_ptr[i] = mean_ptr[i]/num_rows;
}

void
mexFunction(
	int num_output_args,        // Number of left hand side (output) arguments
	mxArray *output_arg[],      // Array of left hand side arguments
	int num_input_args,         // Number of right hand side (input) arguments
	const mxArray *input_arg[]) // Array of right hand side arguments
{
    double *matrix, *mean, *double_ptr;
    float  *matrix_f, *mean_f, *float_ptr;
    int num_rows, num_cols, i;
    int dim, mean_len;
    mxClassID matrix_type;
    size_t bytes_to_copy;

    //sanity check for input arguments
	if( num_input_args < 1 || num_input_args > 2) 
        mexErrMsgTxt( "Cmean2.c: wrong syntax: You should use Cmean2(matrix,[dim])\n");
    matrix_type = mxGetClassID(input_arg[0]);
    if( matrix_type != mxDOUBLE_CLASS && matrix_type != mxSINGLE_CLASS ) 
        mexErrMsgTxt( "Cmean2.c: the matrix must of type double or float\n");
    if(mxGetNumberOfDimensions(input_arg[0]) > 2)
        mexErrMsgTxt( "Cmean2.c: does not support matrices with more than two dimensions\n");

    if(num_input_args==1)
    {
        dim =1;
    }else{
        double_ptr = (double *) mxGetData( input_arg[1]);
        dim = (int)(*double_ptr);
        if(dim != 1 && dim != 2)
            mexErrMsgTxt( "Cmean2.c: dim must be either 1 (default) or 2 \n");
    }    
    
    num_rows = mxGetM(input_arg[0]);
    num_cols = mxGetN(input_arg[0]);    
    
    if(debug)
        printf("input_arg[0] size = [%d,%d]\n",num_rows,num_cols);
    
    //read input arguments:
    //-read the matrix
    switch(matrix_type)
    {
        case mxDOUBLE_CLASS:
            matrix = (double *) mxGetData( input_arg[0]);
            if(dim==1)//calculate mean across the columns
                mean_len = num_cols;
            else //calculate mean across the rows
                mean_len = num_rows;
            
            mean = (double*) mxCalloc(mean_len, sizeof(double));
            matrix_mean(matrix, num_rows, num_cols, &mean, dim);
            //create an output array
            if(dim==1)
                output_arg[0] = mxCreateDoubleMatrix(1, num_cols, mxREAL);
            else
                output_arg[0] = mxCreateDoubleMatrix(num_rows, 1, mxREAL);
            
            double_ptr=mxGetPr(output_arg[0]);//works only for double arrays
            for(i=0; i<mean_len; i++)
                double_ptr[i] = mean[i];
            //free memory
            mxFree((void*)mean);
            break;
            
        case mxSINGLE_CLASS:
            matrix_f = (float *) mxGetData( input_arg[0]);
            if(dim==1)//calculate mean across the columns
                mean_len = num_cols;
            else //calculate mean across the rows
                mean_len = num_rows;
            
            mean_f = (float*) mxCalloc(mean_len, sizeof(float));
            matrix_mean_f(matrix_f, num_rows, num_cols, &mean_f, dim);
            //create an output array
            if(dim==1)
                output_arg[0] = mxCreateNumericMatrix(1, num_cols, mxSINGLE_CLASS, mxREAL);
            else
                output_arg[0] = mxCreateNumericMatrix(num_rows, 1, mxSINGLE_CLASS, mxREAL);
            
            float_ptr = (float*)mxGetData(output_arg[0]);
            for(i=0; i<mean_len; i++)
                float_ptr[i] = mean_f[i];
            //bytes_to_copy = num_cols * mxGetElementSize(output_arg[0]);
            //memcpy(float_ptr,&mean_f,bytes_to_copy);
            
            //free memory
            mxFree((void*)mean_f);
            break;            
    }    
}
