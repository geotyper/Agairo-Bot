#pragma once
#include <iostream>
#include <cstdio>
#include <vector>
#include <iostream>
#include "Constant.h"
#include "CUDA_kernel.cuh"

void PrintCudaCards()
{
	int  GPU_N;

	printf("Starting MultiGPU\n");
	cudaGetDeviceCount(&GPU_N);

	if (GPU_N > 4)
	{
		GPU_N = 4;
	}

	printf("CUDA-capable device count: %i\n", GPU_N);

}

int  main(void)
{
	srand(time(0));

	PrintCudaCards();


	int icard;
	int num_devices;
	cudaGetDeviceCount(&num_devices);

	if (num_devices>1)
	{

		std::cout << "Please enter an integer value of NVidia card ( 1 or 2) : ";
		std::cin >> icard;

		if (icard == 2)
			cudaSetDevice(1);
		if (icard == 1)
			cudaSetDevice(0);
	}

	/*
	int iload;
	std::cout << "Please enter an integer 1 to load DNA from saved file: ";
	std::cin >> iload;
	bool LoadDNAfromfile = false;
	if (iload == 1)
		LoadDNAfromfile = true;
   */

	int Tick = 0;
	Constant constant;

	//Load Constants of world

	


	printf("Begin exp \n");


	ComputeLSTM(constant);


	int isave;
	std::cout << "End exp ";
	std::cin >> isave;

	return 0;
}