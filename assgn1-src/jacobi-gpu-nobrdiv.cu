#include <iostream>
#include <cassert>
#include "mvm_check.h"
#include "parser.h"

  __global__
void jacobi_sigma (float *A, float *b, float *x, float *sigma, int input_size)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < input_size)
  {
    //printf ("x_prev=%f\n", x[i]);
    sigma[i] = 0;
    for (int j=0; j<input_size; j++)
    {
      //if (i != j)
      sigma[i] += A[i*input_size+ j]*x[j];
    }
  //printf ("sigma_value=%f\n", sigma[i]);
  }
}

__global__
void jacobi_xnext (float *A, float *b, float*x, float *sigma, int input_size)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < input_size)
  {
    x[i] = (b[i]-sigma[i]+A[i*input_size+ i]*x[i])/A[i*input_size+ i];
    //printf ("x_next=%f\n", x[i]);
  }
}

int main (int argc, char **argv){
    // check if any file specified
    if (argc < 2)
    {
      cout << "Usage: " << "Input file name required" << endl;
      return 1;
    }

    char filename[20] = "inputs/";
    int N, M;
    float *A, *b, *x;

    strcat(filename, argv[1]);
    parser (filename, &N, &M, &A, &b);

    // allocate and initalize x with zeros
    int input_size = N;
    int num_iter = M;
    x = (float*) malloc(input_size*sizeof(float));
    for (int i = 0; i<input_size; i++)
        x[i] = 0.0;

    // Print the values parsed
    cout << "input size: " << input_size << endl;
    cout << "num iter: " << num_iter << endl;
    /*cout << "A matrix: \n";
    for (int i=0; i<input_size; i++)
    {
        for (int j=0; j<input_size; j++)
            cout << A[i*input_size + j] << " ";
        cout << endl;
    }
    cout << "b bector: \n";
    for (int i=0; i<input_size; i++)
        cout << b[i] << " ";
    cout << endl;*/

    // allocate device memory
    float *d_A, *d_b, *d_x, *d_sigma;
    cudaMalloc((void**) &d_A, input_size*input_size*sizeof(float)); //cudaMalloc has to be 1d array
    cudaMalloc((void**) &d_b, input_size*sizeof(float));
    cudaMalloc((void**) &d_x, input_size*sizeof(float));
    cudaMalloc((void**) &d_sigma, input_size*sizeof(float));

    // move data from host to device memory
    cudaMemcpy(d_A, A, (input_size*input_size)*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, input_size*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, x, input_size*sizeof(float), cudaMemcpyHostToDevice);

    //launch cuda kernel
    int block_width;
    if(argc > 2)  block_width = atoi(argv[2]);
    else  block_width = 1<<6; // defalut is 64

    cout << "block size: " << block_width << endl;
    for (int k=0; k<num_iter; k++)
    {
      jacobi_sigma <<<(input_size+block_width-1)/block_width,block_width>>>
        (d_A, d_b, d_x, d_sigma, input_size);

      jacobi_xnext <<<(input_size+block_width-1)/block_width,block_width>>>
        (d_A, d_b, d_x, d_sigma, input_size);
    }

    // move data from device to host memory
    cudaMemcpy(x, d_x, input_size*sizeof(float), cudaMemcpyDeviceToHost);

    // test results
    mvm_check (A, x, b, input_size);

    // deallocate device and host memory
    cudaFree(d_A); cudaFree(d_b); cudaFree(d_x);
    free(A); free(b); free(x);

    return 0;
}
