#include <cmath>
using namespace std;

void mvm_check (float *A, float *x, float *b_exp, int input_size)
{
    int error = 0;
    float *b = (float*) malloc(input_size*sizeof(float));
    for (int i=0; i<input_size; i++)
    {
        b[i] = 0;
        for (int j=0; j<input_size; j++)
          b[i] += A[i*input_size +j]*x[j];
        //cout << b[i] << "  " << endl;
        if (abs(b[i]-b_exp[i]) > 1.0)
        {
          cout << "result not converged" << endl;
          error ++;
          break;
        }
    }
    if (error == 0)
        cout << "MVM check passed!" << endl;
}
