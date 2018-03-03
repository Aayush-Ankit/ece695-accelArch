#include <iostream>
#include <cassert>
#include "mvm_check.h"
#include "parser.h"
#include <cuda.h>
#include <cuda_runtime_api.h>

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
      if (i != j)
      {
        sigma[i] += A[i*input_size+ j]*x[j];
        //if (j == 0) //see uncoalesced access
        //  printf ("A addr %u\n", &A[i*input_size+j]);
      }
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
    x[i] = (b[i]-sigma[i])/A[i*input_size+ i];
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

    // allocate unified memory
    float *A_u, *b_u, *x_u, *sigma_u;
    cudaMallocManaged(&A_u, input_size*input_size*sizeof(float));
    cudaMallocManaged(&b_u, input_size*sizeof(float));
    cudaMallocManaged(&x_u, input_size*sizeof(float));
    cudaMallocManaged(&sigma_u, input_size*sizeof(float));

    // initialize allocated memories based on parsed values
    for (int i=0; i<input_size; i++)
    {
      b_u[i] = b[i];
      x_u[i] = x[i];
    }
    for (int i=0; i<input_size*input_size; i++)
      A_u[i] = A[i];

    // deallocate memory associated with parsed variables
    free (A); free (b); free (x);

    //launch cuda kernel
    int block_width;
    if(argc > 2)  block_width = atoi(argv[2]);
    else  block_width = 1<<6; // defalut is 64

    cout << "block size: " << block_width << endl;
    //num_iter = 1;
    for (int k=0; k<num_iter; k++)
    {
      //cout << "Iteration " << k << endl;
      jacobi_sigma <<<(input_size+block_width-1)/block_width,block_width>>>
        (A_u, b_u, x_u, sigma_u, input_size);

      jacobi_xnext <<<(input_size+block_width-1)/block_width,block_width>>>
        (A_u, b_u, x_u, sigma_u, input_size);

      //cudaDeviceSynchronize(); // stops host execution until kernel finishes
    }

    // test results - in host
    cudaDeviceSynchronize(); // stops host execution until kernel finishes
    mvm_check (A_u, x_u, b_u, input_size);

    // deallocate device and host memory
    cudaFree(A_u); cudaFree(b_u); cudaFree(x_u);
    //cudaProfilerStop();

    return 0;
}
