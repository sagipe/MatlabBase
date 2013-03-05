/*
 *  Computes the windowed RMS of a signal
 *
 *  INPUTS:
 *  padded_signal: [double column vector] the padded signal
 *  sig_length   : [int] the original signal length
 *  pad_size     : [int] the padding size used to pad the signal before computing the RMS
 *  window_length: [int] the length of the RMS window to use
 *
 *  Sagi Perel, 05/2008
 */

#include "mex.h"
#include <string.h>
#include <math.h>

double array_mean(double* arr, int arr_size)
{
    int i;
	double mean=arr[0];
	for(i=1; i<arr_size; i++)
		mean += arr[i];

	return  mean/arr_size;
}

void array_pow2(double* arr, int arr_size)
{
    int i;
	for(i=0; i<arr_size; i++)
		arr[i] = pow(arr[i], 2);
}

/*
 *  Assumes that sig_rms is already allocated and has the size of sig_len
 */
void RMS(double* padded_sig, int sig_len, int padded_sig_length, int pad_size, double* sig_rms)
{
    int i;
	double sample_rms_val = 0;
    int window_len = pad_size*2+1; //length of the running window we will use
#ifdef _WIN_CMRS
    //the MS compiler doesn't like it - so let Matlab do allocation for us
    double *tmp;
    mxArray *tmpmxArray;
    tmpmxArray = mxCreateDoubleMatrix(window_len, 1, mxREAL);
    tmp = mxGetPr(tmpmxArray);
#else
    double tmp[window_len];
#endif
    
    //compute the RMS
	for(i=pad_size; i<sig_len+pad_size; i++)
	{
        //to compute an RMS sample- we need to work on a small window
        memcpy(tmp, &padded_sig[i-pad_size], sizeof(double)*window_len);        
        array_pow2(tmp,window_len);
        //compute the sqrt of the mean
		sample_rms_val = sqrt(array_mean(tmp,window_len));
		sig_rms[i-pad_size] = sample_rms_val;
	}
#ifdef _WIN_CMRS
    mxDestroyArray(tmpmxArray);
#endif
}

void
mexFunction(
	int num_output_args,        // Number of left hand side (output) arguments
	mxArray *output_arg[],      // Array of left hand side arguments
	int num_input_args,         // Number of right hand side (input) arguments
	const mxArray *input_arg[]) // Array of right hand side arguments
{
    double *padded_sig, *sig_rms, *tmp;
	int sig_length, padded_sig_length, pad_size, window_length;

    //sanity check for input arguments
	if( num_input_args != 4) mexErrMsgTxt( "RMS.c: wrong syntax: You should use RMS(padded_signal, original_signal_length, pad_size, window_length)\n");
    if( mxGetN(input_arg[0]) != 1) mexErrMsgTxt( "RMS.c: the signal must be a column vector\n");
    
    //read input arguments:
    //-read the signal and its size
    padded_sig = (double *) mxGetData( input_arg[0]);
    padded_sig_length = mxGetM(input_arg[0]);
    
    tmp = (double *) mxGetData( input_arg[1]);
    sig_length = (int)(*tmp);
    
    //-read the pad size
    tmp = (double *) mxGetData( input_arg[2]);
	pad_size = (int) (*tmp);
    
    //-read the window length
    tmp = (double *) mxGetData( input_arg[3]);
	window_length = (int) (*tmp);
    
    //create an output array
    output_arg[0] = mxCreateDoubleMatrix(sig_length, 1, mxREAL);
    sig_rms = mxGetPr(output_arg[0]);
    
    RMS(padded_sig, sig_length, padded_sig_length, pad_size, sig_rms);
}
