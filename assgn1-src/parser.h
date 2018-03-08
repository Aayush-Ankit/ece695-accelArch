#include <fstream>
#include <cstring>
#include <sstream>
#include <cstdlib>
using namespace std;

void parser (char *filename, int *N, int *M, float **A, float **b)
{
    int input_size, num_iter;
    string line;
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
                *N = input_size;
                *A = (float*) malloc(input_size*input_size*sizeof(float));
                *b = (float*) malloc(input_size*sizeof(float));
            }
            else if (line_count == 1)
            {
                num_iter = atoi(line.c_str());
                *M = num_iter;
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
                        if (stream && "Matrix structure incoherent")
                            (*A)[(line_count-2)*input_size + i] = (float) n;
                        else
                        {
                            cout << "Matrix structure in file is incorrect" << endl;
                            exit (0);
                        }
                    }
                }
                else{
                    soln_found = 1;
                }
            }
            else //read b vector
            {
                if ((line_count-(2+1+input_size)) < input_size)
                    (*b)[line_count-(2+1+input_size)] = (float) atoi(line.c_str());
            }
            line_count ++;
        }
    }
    else std::cout << "File cannot be opened";
}
