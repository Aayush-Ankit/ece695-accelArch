#include <iostream>
#include <fstream>
#include <cstring>
#include <cassert>
#include <cstdlib>
#include <sstream>
#include <cmath>
#include <ctime>
using namespace std;


/************************* CPU Serial Implementation *************************/
double jacobi_iterative_cpu (float **A, float*x, float*b, int input_size, int num_iter)
{
    clock_t begin = clock();
    float *sigma = (float*) malloc(input_size*sizeof(float));
    for (int k=0; k<num_iter; k++)
    {
        //cout << "Interation: " << k << ".......\n";
        for (int i=0; i<input_size; i++)
        {
            sigma[i] = 0;
            for (int j=0; j<input_size; j++)
            {
                if (i != j)
                    sigma[i] += A[i][j]*x[j];
            }
        }
        for (int i=0; i<input_size; i++)
            x[i] = (b[i]-sigma[i])/A[i][i];
    }
    clock_t end = clock();
    double elapsed_secs = double(end-begin)/CLOCKS_PER_SEC;
    cout << "elapsed time in seconds: " << elapsed_secs << endl;
}


/************************* Testing Function *************************/
void mvm_check (float **A, float *x, float *b_exp, int input_size)
{
    float *b = (float*) malloc(input_size*sizeof(float));
    for (int i=0; i<input_size; i++)
    {
        b[i] = 0;
        for (int j=0; j<input_size; j++)
            b[i] += A[i][j]*x[j];
        if (abs(b[i]-b_exp[i]) > 1.0)
        {
            cout << "result not converged" << endl;
            break;
        }
    }
    cout << "MVM check passed!" << endl;
    // print the computed results
    for (int i=0; i<input_size; i++)
        cout << b[i] << "\t";
    cout << endl;
}


int main (int argc, char **argv){
    // check if any file specified
    assert (argc > 1 && "input file needs to be specified");

    /********* Parse the input file for size, A, b and number of iterations *********/
    char filename[20] = "inputs/";
    string line;
    int input_size;
    int num_iter;
    float **A;
    float *b;
    float *x;

    strcat(filename, argv[1]);
    cout << "input path: " << filename << endl;

    ifstream infile (filename);

    if (infile.is_open())
    {
        int line_count = 0;
        int soln_found = 0;
        while (! infile.eof())
        {
            getline (infile, line);
            if (line_count == 0)
            {
                input_size = atoi(line.c_str());
                A = (float**) malloc(input_size*sizeof(float *));
                for (int i=0; i<input_size; i++)
                    A[i] = (float*) malloc(input_size*sizeof(float));
                b = (float*) malloc(input_size*sizeof(float));
                x = (float*) malloc(input_size*sizeof(float));
            }
            else if (line_count == 1)
            {
                num_iter = atoi(line.c_str());
            }
            else if (soln_found == 0) //read A matrix
            {
                if (strcmp(line.c_str(), "solution") != 0) // read A matrix
                {
                    stringstream stream(line); //parse the string (line) to extract integers
                    for (int i=0; i<input_size; i++)
                    {
                        int n;
                        stream >> n;
                        assert (stream && "Matrix structure incoherent");
                        A[line_count-2][i] = (float) n;
                    }
                }
                else{
                    soln_found = 1;
                }
            }
            else //read b vector
            {
                if ((line_count-(2+1+input_size)) < input_size)
                    b[line_count-(2+1+input_size)] = (float) atoi(line.c_str());
            }
            line_count ++;
        }
    }
    else std::cout << "File cannot be opened";

    // Initialize x with zeros
    for (int i = 0; i<input_size; i++)
        x[i] = 0.0;

    // Print the values parsed
    cout << "input size: " << input_size << endl;
    cout << "num iter: " << num_iter << endl;
    /*cout << "A matrix: \n";
    for (int i=0; i<input_size; i++)
    {
        for (int j=0; j<input_size; j++)
            cout << A[i][j] << " ";
        cout << endl;
    }
    cout << "b bector: \n";
    for (int i=0; i<input_size; i++)
        cout << b[i] << " ";
    cout << endl;*/

    /************************* CPU run, check and time-log *************************/
    jacobi_iterative_cpu (A, x, b, input_size, num_iter);
    mvm_check (A, x, b, input_size);

    return 0;
}
