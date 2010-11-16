#include "sys/alt_timestamp.h"
#include "alt_types.h"
#include "system.h"

#include <stdio.h>

typedef union {
	unsigned char comp[4];
	unsigned int vect;
} vectorType;

typedef vectorType VectorArray[4];

// Prototypes
void setInputMatrices(VectorArray A, VectorArray B);
void displayMatrix(VectorArray input);
void multiMatrixSoft(VectorArray A, VectorArray B, VectorArray P);
void multiMatrixC2H(VectorArray A, VectorArray B, VectorArray P);
void multiMatrixHard(VectorArray A, VectorArray B, VectorArray P);

void setInputMatrices(VectorArray A, VectorArray B)
{
	A[0].comp[0] = 1;
	A[0].comp[1] = 2;
	A[0].comp[2] = 3;
	A[0].comp[3] = 4;
	A[1].comp[0] = 5;
	A[1].comp[1] = 6;
	A[1].comp[2] = 7;
	A[1].comp[3] = 8;
	A[2].comp[0] = 9;
	A[2].comp[1] = 10;
	A[2].comp[2] = 11;
	A[2].comp[3] = 12;
	A[3].comp[0] = 13;
	A[3].comp[1] = 14;
	A[3].comp[2] = 15;
	A[3].comp[3] = 16;

	B[0].comp[0] = 1;
	B[0].comp[1] = 1;
	B[0].comp[2] = 1;
	B[0].comp[3] = 1;
	B[1].comp[0] = 2;
	B[1].comp[1] = 2;
	B[1].comp[2] = 2;
	B[1].comp[3] = 2;
	B[2].comp[0] = 3;
	B[2].comp[1] = 3;
	B[2].comp[2] = 3;
	B[2].comp[3] = 3;
	B[3].comp[0] = 4;
	B[3].comp[1] = 4;
	B[3].comp[2] = 4;
	B[3].comp[3] = 4;
}

void displayMatrix(VectorArray input)
{
	printf("|%d %d %d %d|\n", input[0].comp[0], input[0].comp[1], input[0].comp[2], input[0].comp[3]);
	printf("|%d %d %d %d|\n", input[1].comp[0], input[1].comp[1], input[1].comp[2], input[1].comp[3]);
	printf("|%d %d %d %d|\n", input[2].comp[0], input[2].comp[1], input[2].comp[2], input[2].comp[3]);
	printf("|%d %d %d %d|\n", input[3].comp[0], input[3].comp[1], input[3].comp[2], input[3].comp[3]);
}

int dotProduct(VectorArray A, VectorArray B, int row, int column)
{
	int res = 0;
	int j;
	for( j = 0; j < 4; ++j)
	{
	   res += A[row].comp[j] * B[column].comp[j];
	}
	return res;
}

void multiMatrixSoft(VectorArray A, VectorArray B, VectorArray P)
{
   int i = 0;
   int j = 0;
   for( i = 0; i < 4; ++i)
   {
	   for( j = 0; j < 4; ++j)
	   {
		   P[i].comp[j] = dotProduct(A, B, i, j);
	   }
   }
}

void multiMatrixHard(VectorArray A, VectorArray B, VectorArray P)
{
   int i = 0;
   int j = 0;
   for( i = 0; i < 4; ++i)
   {
	   for( j = 0; j < 4; ++j)
	   {
		   P[i].comp[j] = ALT_CI_MULTIPLIERADD_INST(A[i].vect, B[j].vect);
	   }
   }
}


// Global variables, therefore not static (file scope)
VectorArray aInst;
VectorArray bInst;

int main()
{
  int ts;
  VectorArray pInst;
  printf("Setting AInst and BInst\n");
  setInputMatrices(aInst, bInst);
  printf("AInst=\n");
  displayMatrix(aInst);
  printf("BInst=\n");
  displayMatrix(bInst);

  ts = alt_timestamp_start();
  multiMatrixSoft(aInst, bInst, pInst);
  ts = alt_timestamp() - ts;
  printf("PInst=\n");
  displayMatrix(pInst);
  printf("Calculation 4x4 Soft took: %d ticks\n", ts);

  ts = alt_timestamp_start();
  multiMatrixHard(aInst, bInst, pInst);
  ts = alt_timestamp() - ts;
  printf("PInst=\n");
  displayMatrix(pInst);
  printf("Calculation 4x4 Hard took: %d ticks\n", ts);

  return 0;
}
