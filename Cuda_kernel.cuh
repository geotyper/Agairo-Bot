#pragma once
#include <stdio.h>
#include <cuda_runtime.h>
#include <curand.h>
#include <assert.h>
#include <time.h>
#include <vector>
#include "Constant.h"
#include "Bot.h"
#include "Food.h"
#include <random>
#include <algorithm> 
#include <list>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/sort.h>



#include "InfoGraph.h"
#include "GraphGA.h"
#include "GraphModule.h"



struct ConstantStruct
{

	int   FOOD_MASS;
	int   GAME_HEIGHT;
	int   GAME_TICKS;
	int   GAME_WIDTH;
	int   INERTION_FACTOR;
	int   MAX_FRAGS_CNT;
	int   SPEED_FACTOR;
	int   TICKS_TIL_FUSION;
	int   VIRUS_RADIUS;
	int   VIRUS_SPLIT_MASS;
	float VISCOSITY;
	int   RadiusOfView = 4;

	int SUM_RESP_TIMEOUT;
	int RESP_TIMEOUT;

	int Depth;
	int CrossMove;

	int BotPopulationSize;
	int VirusPopulationSize;
	int FoodPopulationSize;
	int FoodAddPopulationSize;
	int FoodPAdd;
	int GlobalTicks;

	int DepthBotPopulation;
    int DepthFoodPopulation;
	int DepthAddFoodPopulation;

	int radius;
	int KoeffWall;
	int KoefEnemyDanger;
	int KoefEnemyEat;
	int KoefEat;
	int KoefVirus;
	int Lkoef;

	int xSetRight;
	int xSetLeft;
	int ySetTop;
	int ySetDown;

	int IdeaTick;
	int IdeaShortTick;

	int numberofSensors;
	int numberofSensorshalf;
	int numberofSensorsAll;
	int angleStep;
	int angleStepInit;
	int WorldTick;

	int ArrayDim;
	int TopologySize;
	int TopologyRNNSize;

};


struct argumentsRNN
{
	float *outputs;
	float *sums;
	float *sumsContext;
	float *NNweights;
	float *MNweights;
	float *neuronContext;
	
};

__device__  float Sigmoid(float x);

__device__  float Tanh(float x);

__device__  float SoftSignFunction(float xValue);


__host__ void InitBotList(std::vector<Bot>& BotList, std::vector<float>& Sector, Constant& ct);
__host__ void InitFoodList(std::vector<Food>& FoodList,  Constant & ct);
__host__ void InitAddFoodList(std::vector<Food>& AddFoodList, Constant & ct);

void ComputeLSTM(Constant&  constant);
