#pragma once
#include<vector>

struct Constant
{
	  float   FOOD_MASS=2.0f;
	  int     GAME_HEIGHT= 1050;
	  int     GAME_TICKS=2500;
	  int     GAME_WIDTH= 1050;
	  float   INERTION_FACTOR= 15.f;
	  int     MAX_FRAGS_CNT=10;
	  float   SPEED_FACTOR=35.f;
	  int     TICKS_TIL_FUSION=250;
	  float   VIRUS_RADIUS=25.f;
	  float   VIRUS_SPLIT_MASS=80.f;
	  float   VISCOSITY= 0.35f;
	  int     RadiusOfView = 4;

	  int SUM_RESP_TIMEOUT=500;       
	  int RESP_TIMEOUT=5;         

	  const int Depth = 55;
	  int CrossMove = 5;

	  const int BotPopulationSize = 35;
	  int VirusPopulationSize = 3;
	  int FoodPopulationSize = 50;
	  int FoodAddPopulationSize = 100;
	  int FoodPAdd = 1;
	  int GlobalTicks = 5000;


	  const int DepthBotPopulation = BotPopulationSize*Depth;
	  const int DepthFoodPopulation = 4*FoodPopulationSize*Depth;
	  const int DepthAddFoodPopulation = 4*FoodAddPopulationSize*Depth;

	  int radius = 7;
	  int KoeffWall = 30;
	  int KoefEnemyDanger = 500;
	  int KoefEnemyEat = 155;
	  int KoefEat = 5;
	  int KoefVirus = 15;//3350
	  int Lkoef = 75;

	  int xSetRight;
	  int xSetLeft;
	  int ySetTop;
	  int ySetDown;

	  int IdeaTick = 75;
	  int IdeaShortTick = 3;

	  int angleStep = 30;
	  int angleStepInit = 0;
	  int numberofSensorsAdd = 6;
	  int numberofSensors=4 * (int)((180 - angleStepInit) / angleStep) + numberofSensorsAdd;
	  int numberofSensorshalf= (int)((180 - angleStepInit) / angleStep);
	  int numberofSensorsAll= 2 * (int)((180 - angleStepInit) / angleStep);

	  std::vector<int> Topology=   { numberofSensors, 32,12,8,6,4 };
	  std::vector<int>TopologyRNN= {            0,    0, 12,8,0,0 };

	  int ArrayDim = 38;

	  float gameLevel = 0.65f;

	  int WorldTick = 3500;
	
	  bool DrawUnits = true;
	  bool SaveDNA = false;
	  bool AutoSaveDNA = false;
	
};
