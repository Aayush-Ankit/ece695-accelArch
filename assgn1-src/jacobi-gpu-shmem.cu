#include <iostream>
#include <cassert>
#include "mvm_check.h"
#include "parser.h"

const int TILE_DIM = 64; //blockDim.x = TILE_DIM must be

  __global__
void jacobi_sigma (float *A, float *b, float *x, float *sigma, int input_size)
{
  __shared__ float tile[TILE_DIM][TILE_DIM];

  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < input_size)
  {
    printf("sigma kernel starts...\n");
    //printf ("x_prev=%f\n", x[i]);
    sigma[i] = 0;
    for (int j=0; j<(input_size/TILE_DIM)+1; j++) //divides sigma[i] compute into (input_size/TILE_DIM) chunks for shmem
    {
      // read data from Gmem - a thread reads all values in a column
      // threads concurrently access the same row - coalesced access to Gmem
      for (int k=0; k<TILE_DIM; k++)
        tile[i][k] = A[k*input_size + ((j*TILE_DIM) + i)]; // tile has A's part in tranposed form (to avoid shmem bank conflicts)

      __syncthreads(); //a thread within a block brings data for different threads

      for (int k=0; k<TILE_DIM; k++)
        if (i != k)
          sigma[i] += tile[k][i]*x[k];

      __syncthreads(); //a thread can't fetch new data unless all previous data in shmem for the block gets used
    }
    printf ("sigma_value=%f\n", sigma[i]);
    printf("sigma kernel ends...\n");
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
    //num_iter = 2;
    for (int k=0; k<num_iter; k++)
    {
      cout << "Iteration: " << k << endl;
      jacobi_sigma <<<(input_size+block_width-1)/block_width,block_width>>>
        (d_A, d_b, d_x, d_sigma, input_size);

      jacobi_xnext <<<(input_size+block_width-1)/block_width,block_width>>>
        (d_A, d_b, d_x, d_sigma, input_size);

      cudaDeviceSynchronize(); // stops host execution until kernel finishes
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
