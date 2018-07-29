#pragma once
#include "Cuda_kernel.cuh"


__device__ float anglebetween2vectors(float x, float y, float x2, float y2)
{

	float arc = (x * x + y * y) * (x2 * x2 + y2 * y2);

	arc = sqrtf(arc);
	if (arc > 0.f)
	{
		arc = acosf((x * x2 + y * y2) / arc);
		if ((x * y2 - y * x2) < 0.f)
			arc = -arc;
	}
	return arc;
}


__device__  float Sigmoid(float x)
{
	if (x < -10.0f) return 0.0f;
	else if (x > 10.0f) return 1.0f;
	return (float)(1.0f / (1.0f + expf(-x)));
}

__device__  float Tanh(float x)
{
	if (x < -10.0f) return -1.0f;
	else if (x > 10.0f) return 1.0f;
	return (float)(tanhf(x));
}


__device__  float SoftSignFunction(float xValue)
{
	return xValue / (1.f + fabs(xValue));
}


__device__ void RndGen(float *Gen, int mGl, int nGl, float *out1, int bot, int numberLayers, int layer, int LayerDim)
{
	int rows = mGl; int cols = mGl;

	for (int i = 0; i < rows; ++i)
		for (int j = 0; j < cols; ++j)
			out1[((bot*numberLayers + layer)*LayerDim + i)*LayerDim + j] = 0;


}


__host__ void InitBotList(std::vector<Bot>& BotList, std::vector<float>& Sector, Constant& ct)
{
	std::list <Bot> ::iterator it;
	std::list<Bot> ServerInitBots;

	BotList.clear();
	Sector.clear();

	int botId = 0;

	for (int d = 0; d < ct.Depth; d++)
	{
		for (int i = 0; i < ct.BotPopulationSize; i++)
		{
			int deltastep = 30;

			Bot bot;

			bot.intID = botId;
			bot.TTF = 1;
			bot.Mass = 57;
			bot.Depth = d;
			bot.IntType = 1;
			bot.Xvelocity = 0;
			bot.Yvelocity = 0;
			bot.color = i + 1;

			bot.angle = (rand() % 360) * 3.141592f / 180;
			bot.speed = (float)rand() / ((float)RAND_MAX + 1);
			bot.Radius = (int)(2 * sqrt(bot.Mass));

			bot.X = rand() % (ct.GAME_WIDTH - 2 *  deltastep) + deltastep;
			bot.Y = rand() % (ct.GAME_HEIGHT - 2 * deltastep) + deltastep;
			/*
			while (ServerInitBots.Exists(s = > s.Depth == d&& Math.Abs(s.X - bot.X) < 55 && Math.Abs(s.Y - bot.Y) < 55))
			{
			bot.X = rand() % (0 + deltastep) + (conworld.GAME_WIDTH - deltastep);
			bot.Y = rand() % (0 + deltastep) + (conworld.GAME_HEIGHT - deltastep);
			}
			*/

			//list <Bot> ::iterator it1;
			bool find_element = true;
			int findElementCount = 0;

			while (find_element)
			{

				std::list <Bot> ::iterator it3;
				for (it3 = ServerInitBots.begin(); it3 != ServerInitBots.end(); ++it3)
				{

					if (it3->Depth == d && abs(it3->X - bot.X) < 75 && abs(it3->Y - bot.Y) < 75)
					{
						bot.X = rand() % (ct.GAME_WIDTH - 2 * deltastep) + deltastep;
						bot.Y = rand() % (ct.GAME_HEIGHT - 2 * deltastep) + deltastep;
						++findElementCount;

					}


				}

				if (findElementCount == 0)
				{
					find_element = false;
				}
				else
				{
					findElementCount = 0;
				}

			}

			bot.xPOI = bot.X;
			bot.yPOI = bot.Y;

			ServerInitBots.push_back(bot);
			botId++;


		}

	//	std::cout << "Number of bots " << ct.BotPopulationSize << " generated in Depth " << d << std::endl;

	}

	//std::cout << "Number of all bots " << ServerInitBots.size() << " generated in all Depth " << ct.Depth << std::endl;

	std::list <Bot> ::iterator it1;
	for (it1 = ServerInitBots.begin(); it1 != ServerInitBots.end(); ++it1)
	{
		BotList.push_back(*it1);
	}

	ServerInitBots.clear();

}

__host__ void InitFoodList(std::vector<Food>& FoodList,  Constant & ct)
{
	FoodList.clear();

	std::list<Food> ServerInitFood;
	std::vector<Food> ServerFoodList;
	int FoodId = 0;


	int botId = 0;

	for (int d = 0; d < ct.Depth; d++)
	{
		for (int i = 0; i < ct.FoodPopulationSize; i++)
		{
			int deltastep = 10;

			Food food;

			//bot.ID[3] = "b";
			food.ID = FoodId;
			food.Mass = ct.FOOD_MASS;
			food.Radius = 2.5f;
			food.IntType = 3;
			food.Depth = d;

			food.X = rand() % (ct.GAME_WIDTH - 2 * deltastep) + deltastep;
			food.Y = rand() % (ct.GAME_HEIGHT - 2 * deltastep) + deltastep;

			bool find_element = true;
			int findElementCount = 0;

			ServerInitFood.push_back(food);
			FoodId++;

			Food food1;

			food1.ID = FoodId;
			food1.Mass = ct.FOOD_MASS;
			food1.Radius = 2.5f;
			food1.IntType = 3;
			food1.Depth = d;
			food1.X = ct.GAME_WIDTH - food.X;
			food1.Y = food.Y;

			ServerInitFood.push_back(food1);
			FoodId++;

			Food food2;

			food2.ID = FoodId;
			food2.Mass = ct.FOOD_MASS;
			food2.Radius = 2.5f;
			food2.IntType = 3;
			food2.Depth = d;
			food2.X = food.X;
			food2.Y = ct.GAME_HEIGHT - food.Y;

			ServerInitFood.push_back(food2);
			FoodId++;

			Food food3;

			food3.ID = FoodId;
			food3.Mass = ct.FOOD_MASS;
			food3.Radius = 2.5f;
			food3.IntType = 3;
			food3.Depth = d;
			food3.X = ct.GAME_WIDTH - food.X;
			food3.Y = ct.GAME_HEIGHT - food.Y;

			ServerInitFood.push_back(food3);
			FoodId++;

		}

		//std::cout << "Number of food " << ct.FoodPopulationSize << " generated in Depth " << d << std::endl;

	}

	//std::cout << "Number of all food " << ServerInitFood.size() << " generated in all Depth " <<ct.Depth << std::endl;

	std::list <Food> ::iterator it;
	for (it = ServerInitFood.begin(); it != ServerInitFood.end(); ++it)
	{
		FoodList.push_back(*it);
	}

	ServerInitFood.clear();


}

__host__ void InitAddFoodList( std::vector<Food>& AddFoodList, Constant & ct)
{
	
	AddFoodList.clear();
	
	std::list<Food> ServerAddInitFood;
	
	int FoodId = 0;

	int botId = 0;

	for (int d = 0; d < ct.Depth; d++)
	{
		for (int i = 0; i < ct.FoodAddPopulationSize; i++)
		{
			int deltastep = 10;

			Food food;

			//bot.ID[3] = "b";
			food.ID = FoodId;
			food.Mass =ct.FOOD_MASS;
			food.Radius = 2.5f;
			food.IntType = 3;
			food.Depth = d;

			food.X = rand() % (ct.GAME_WIDTH - 2 * deltastep) + deltastep;
			food.Y = rand() % (ct.GAME_HEIGHT - 2 * deltastep) + deltastep;

			bool find_element = true;
			int findElementCount = 0;
			
			ServerAddInitFood.push_back(food);
			FoodId++;

			Food food1;

			food1.ID = FoodId;
			food1.Mass = ct.FOOD_MASS;
			food1.Radius = 2.5f;
			food1.IntType = 3;
			food1.Depth = d;
			food1.X = ct.GAME_WIDTH - food.X;
			food1.Y = food.Y;

			ServerAddInitFood.push_back(food1);
			FoodId++;

			Food food2;

			food2.ID = FoodId;
			food2.Mass = ct.FOOD_MASS;
			food2.Radius = 2.5f;
			food2.IntType = 3;
			food2.Depth = d;
			food2.X = food.X;
			food2.Y =ct.GAME_HEIGHT - food.Y;

			ServerAddInitFood.push_back(food2);
			FoodId++;

			Food food3;

			food3.ID = FoodId;
			food3.Mass = ct.FOOD_MASS;
			food3.Radius = 2.5f;
			food3.IntType = 3;
			food3.Depth = d;
			food3.X = ct.GAME_WIDTH - food.X;
			food3.Y = ct.GAME_HEIGHT - food.Y;

			ServerAddInitFood.push_back(food3);
			FoodId++;

		}

		//std::cout << "Number of Add food " << ct.FoodAddPopulationSize << " generated in Depth " << d << std::endl;

	}

	//std::cout << "Number of all Add food " << ServerAddInitFood.size() << " generated in all Depth " << ct.Depth << std::endl;

	std::list <Food> ::iterator it;
	for (it = ServerAddInitFood.begin(); it != ServerAddInitFood.end(); ++it)
	{
		AddFoodList.push_back(*it);
	}

	ServerAddInitFood.clear();

}



__global__ void cudaGARNN2(Bot *bot, int *fitnessIndex, float *rnnDNA, argumentsRNN *RNN, int *Topology, int *TopologyRNN, int NNslide,
	ConstantStruct *Const, int numElements, int gameTick, int middleFitness, int fitness5, int sumFitness)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;

	int TopologySize = Const->TopologySize;
	int ArrayDim = Const->ArrayDim;


	float crossValueBig = 0.75f;
	float crossValueSmall = 0.35f;


	for (int pos = tid; pos < numElements; pos += threadN)
	{

		if (bot[pos].Fitness<middleFitness)
		{
			if(fabs(rnnDNA[pos*numElements + 175]) < 0.65)
			{ 

					for (int layerT = 0; layerT < Const->TopologySize - 1; layerT++)
					{
						for (int it = 0; it < Topology[layerT] + 1; it++)
						{
							for (int jt = 0; jt < Topology[layerT + 1]; jt++)
							{
								RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt] =
									rnnDNA[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt];

							}

						}

					}

					for (int layerR = 0; layerR < Const->TopologyRNNSize - 1; layerR++)
					{
						for (int ir = 0; ir < TopologyRNN[layerR] + 1; ir++)
						{
							for (int jr = 0; jr < TopologyRNN[layerR]; jr++)
							{
								RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] =
									rnnDNA[NNslide + ((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr];

							}
						}
					}
			}
			else
			{
				int randomBot = fitnessIndex[0];
				for (int layerT = 0; layerT < Const->TopologySize - 1; layerT++)
				{
					for (int it = 0; it < Topology[layerT] + 1; it++)
					{
						for (int jt = 0; jt < Topology[layerT + 1]; jt++)
						{
							RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt] =
								RNN->NNweights[((randomBot*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt];

						}
					}
				}

				for (int layerR = 0; layerR < Const->TopologyRNNSize - 1; layerR++)
				{
					for (int ir = 0; ir < TopologyRNN[layerR] + 1; ir++)
					{
						for (int jr = 0; jr < TopologyRNN[layerR]; jr++)
						{
							RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] =
								RNN->MNweights[((randomBot*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr];

						}
					}
				}

			}

		}
		else
		{

			if (pos != fitnessIndex[0])
			{
				float crossValue = crossValueBig;

				if (bot[pos].Fitness > fitness5)
				{
					crossValue = crossValueSmall;
				}


				float minValue = 0.65f*numElements;
				float maxValue = numElements-1;

				float range = maxValue - minValue;
				int randomBotIndex = (int)((fabs(rnnDNA[pos*numElements +1])* range + minValue));
				int randomBotIndex2 = (int)((fabs(rnnDNA[pos*numElements + 2]) * range + minValue));
				int randomBot = fitnessIndex[randomBotIndex];
				int randomBot2 = fitnessIndex[randomBotIndex2];

				int rndstep = 0;
				for (int layerT = 0; layerT < Const->TopologySize - 1; layerT++)
				{
					for (int it = 0; it < Topology[layerT] + 1; it++)
					{
						for (int jt = 0; jt < Topology[layerT + 1]; jt++)
						{
							RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt] =
								RNN->NNweights[((randomBot*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt];
							if (fabs(rnnDNA[pos*numElements + 3+ rndstep])<crossValue)
								RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt] =
								RNN->NNweights[((randomBot2*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt];
							rndstep++;
						}
					}
				}
				 rndstep = 0;
				for (int layerR = 0; layerR < Const->TopologyRNNSize - 1; layerR++)
				{
					for (int ir = 0; ir < TopologyRNN[layerR] + 1; ir++)
					{
						for (int jr = 0; jr < TopologyRNN[layerR]; jr++)
						{
							RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] =
								RNN->MNweights[((randomBot*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr];
							if (fabs(rnnDNA[pos*numElements + 25 + rndstep])<crossValue)
								RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] =
								RNN->MNweights[((randomBot2*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr];
							rndstep++;

						}
					}
				}

//mutation
			rndstep = 0;
				for (int layerT = 0; layerT < Const->TopologySize - 1; layerT++)
				{
					for (int it = 0; it < Topology[layerT] + 1; it++)
					{
						for (int jt = 0; jt < Topology[layerT + 1]; jt++)
						{
							
							if (fabs(rnnDNA[pos*numElements + 50 + rndstep])< 0.0015)
							{
								if (fabs(rnnDNA[pos*numElements + 75 + rndstep]) < 0.5)
									RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt] =
									-RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt]/30.f;
								else
									RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt] =
									+RNN->NNweights[((pos*Const->TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt]/30.f;
								rndstep++;
							}
						}
					}
				}
				rndstep = 0;
				for (int layerR = 0; layerR < Const->TopologyRNNSize - 1; layerR++)
				{
					for (int ir = 0; ir < TopologyRNN[layerR] + 1; ir++)
					{
						for (int jr = 0; jr < TopologyRNN[layerR]; jr++)
						{
							
							if (fabs(rnnDNA[pos*numElements + 100 + rndstep])< 0.0015)
							{
								if (fabs(rnnDNA[pos*numElements + 125 + rndstep]) < 0.5)
									RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] =
									-RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] / 30.f;
								else
									RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] =
									+RNN->MNweights[((pos*Const->TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr] / 30.f;
								rndstep++;
							}

						}
					}
				}
			}

		}
		
	}
}


__global__ void cudaBeforeNNRNN(Bot *bot, float *gbotSector, float *tgbotSector, argumentsRNN *RNN, ConstantStruct *ct, int numElements, int gameTick)
{
	const int     tid = blockIdx.x * blockDim.x + threadIdx.x;
	const int     threadN = gridDim.x * blockDim.x;

	const int numSensorElem = 2 * ct->numberofSensorshalf;

	for (int pos = tid; pos < numElements; pos += threadN)
	{
		const  int aa = 16 * pos;
		const  int ii = pos;
		const int iiA = ii*ct->ArrayDim;

		if(gameTick!=0)
		{ 
			for (int r = 0; r < numSensorElem; r++)
			{
				RNN->outputs[iiA + r] = gbotSector[numSensorElem*ii + r];
				
			}
			for (int r = 0; r < numSensorElem; r++)
			{
				RNN->outputs[iiA + r+ numSensorElem] = tgbotSector[numSensorElem*ii + r];
				tgbotSector[numSensorElem*ii + r]= gbotSector[numSensorElem*ii + r];
			}
			RNN->outputs[iiA + 2*numSensorElem] = bot[pos].Mass/80.f;
		    RNN->outputs[iiA + 2*numSensorElem+1]= bot[pos].speed/ 35.f;
			RNN->outputs[iiA + 2*numSensorElem + 2] = bot[pos].angle / 3.14f;
			
		}
		else
		{
			for (int r = 0; r < numSensorElem; r++)
			{
				RNN->outputs[iiA + r] = gbotSector[numSensorElem*ii + r];
			}
			for (int r = numSensorElem; r < 2 * numSensorElem; r++)
			{
				RNN->outputs[iiA + r] = 0;
			}
			RNN->outputs[iiA + numSensorElem] = bot[pos].Mass / 80.f;
			RNN->outputs[iiA + numSensorElem + 1] = bot[pos].speed / 35.f;
			RNN->outputs[iiA + numSensorElem + 2] = bot[pos].angle / 3.14f;
			RNN->outputs[iiA + numSensorElem + 3] = (bot[pos].X - ct->GAME_WIDTH / 2) / ct->GAME_WIDTH / 2;
			RNN->outputs[iiA + numSensorElem + 4] = (bot[pos].Y- ct->GAME_HEIGHT / 2) / ct->GAME_HEIGHT / 2;


		}
	}

}




__global__ void cudaServer(Bot *bot, Food *food,float *gbotSector, ConstantStruct *ct, int numElements, int gameTick)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;


	int gWidth = ct->GAME_WIDTH;
	int gHeight = ct->GAME_HEIGHT;

	const int ListSize = ct->DepthBotPopulation;
	//const int VirusListSize = ct->VirusPopulationSize;
	const int FoodListSize = ct->DepthFoodPopulation;

	const int conworldangleStepInit = ct->angleStepInit;
	const int AngleStep = ct->angleStep;
	const int numberofSensorshalf = ct->numberofSensorshalf;
	const int numSensorElem = 2 * numberofSensorshalf;

	const float speedfactor = ct->SPEED_FACTOR;
	const float inertionfactor = ct->INERTION_FACTOR;

	const float RadiusView = ct->RadiusOfView;

	const  int MaxDepth = ct->Depth;

	const float PI = 3.141592653f;

	const float RadtoGrad = (180.f / PI);

	
	for (int i= tid; i < numElements; i += threadN)
	{

		const int ii =i;


		if (bot[i].Mass > 0.f && bot[i].TTF != 0)
		{

			bot[i].Lifetime = bot[i].Lifetime + 1.f;

			bot[i].Radius= 2.f* sqrt(bot[i].Mass);

			if ((bot[i].X - bot[i].Radius) < 0.f)
			{
				bot[i].X = bot[i].Radius;
				bot[i].Xvelocity = 0.f;
			}

			if ((bot[i].X + bot[i].Radius)> gWidth)
			{
				bot[i].X = bot[i].X - bot[i].Radius+ bot[i].X - gWidth;
				bot[i].Xvelocity = 0.f;
			}

			if (bot[i].Y - bot[i].Radius< 0.f)
			{
				bot[i].Y = bot[i].Y + bot[i].Radius- bot[i].Y;
				bot[i].Yvelocity = 0.f;
			}
			if (bot[i].Y + bot[i].Radius> gHeight)
			{
				bot[i].Y = bot[i].Y - bot[i].Radius+ bot[i].Y - gHeight;
				bot[i].Yvelocity = 0.f;
			}

			float speed_x = bot[i].speed * cosf(bot[i].angle);
			float speed_y = bot[i].speed * sinf(bot[i].angle);

			float maxspeed = speedfactor / sqrtf(bot[i].Mass);

			float dx1 = bot[i].xPOI - bot[i].X;
			float dy1 = bot[i].yPOI - bot[i].Y;

			float distpoi = sqrt(dx1 * dx1 + dy1 * dy1);

			float nx = (distpoi > 0.f) ? (dx1 / distpoi) : 0.f;
			float ny = (distpoi > 0.f) ? (dy1 / distpoi) : 0.f;

			speed_x += (nx * maxspeed - speed_x) * inertionfactor / bot[i].Mass;
			speed_y += (ny * maxspeed - speed_y) * inertionfactor / bot[i].Mass;

			bot[i].angle = atan2f(speed_y, speed_x);

			float new_speed = sqrtf(speed_x * speed_x + speed_y * speed_y);

			if (new_speed > maxspeed)
			{
				new_speed = maxspeed;
			}

			bot[i].speed = new_speed;

			float x = bot[i].X;
			float y = bot[i].Y;
			float radius = bot[i].Radius;
			float speed = bot[i].speed;

			float rB = x + radius;
			float lB = x - radius;
			float dB = y + radius;
			float uB = y - radius;

			float dx = speed * cosf(bot[i].angle);
			float dy = speed * sinf(bot[i].angle);

			if ((rB + dx) < gWidth && (lB + dx) > 0.f)
			{
				bot[i].X = bot[i].X + dx;
			}
			else
			{
				// зануляем проекцию скорости по dx
				speed_y = speed * sinf(bot[i].angle);
				bot[i].speed = fabs(speed_y);
				bot[i].angle = (speed_y >= 0.f) ? PI / 2.f : -PI / 2.f;
			}

			if ((dB + dy) < gHeight && (uB + dy) > 0.f)
			{
				bot[i].Y = bot[i].Y + dy;
			}
			else
			{
				// зануляем проекцию скорости по dy
				speed_x = speed * cosf(bot[i].angle);
				bot[i].speed = fabs(speed_x);
				bot[i].angle = (speed_x >= 0.f) ? 0.f : PI;
			}

			bot[i].Xvelocity = bot[i].speed * cosf(bot[i].angle);
			bot[i].Yvelocity = bot[i].speed * sinf(bot[i].angle);

			
			if (bot[i].X < 1.5f * bot[i].Radius)
			{
				bot[i].Mass = bot[i].Mass - 0.25f;
				// bot[i].Fitness = bot[i].Fitness - 0.15; // Fitness
			}
			if (bot[i].X > gWidth - 1.5f* bot[i].Radius)
			{
				bot[i].Mass = bot[i].Mass - 0.25f;
				// bot[i].Fitness = bot[i].Fitness - 0.15; // Fitness
			}
			if (bot[i].Y < 1.5f * bot[i].Radius)
			{
				bot[i].Mass = bot[i].Mass - 0.25f;
				// bot[i].Fitness = bot[i].Fitness - 0.15; // Fitness
			}
			if (bot[i].Y > gHeight - 1.5f* bot[i].Radius)
			{
				bot[i].Mass = bot[i].Mass - 0.25f;
				// bot[i].Fitness = bot[i].Fitness - 0.15; // Fitness
			}

			//Bot

			int ibb = ct->BotPopulationSize *bot[i].Depth;
			for (int bb = ibb; bb < ibb + ct->BotPopulationSize; ++bb)
				//for (int bbc = 0; bbc < ListSize; bbc++)
			{
			
				if (bot[i].Depth == bot[bb].Depth && i != bb
					&& bot[bb].Mass > 0.f && (int)bot[bb].TTF != 0 && fabs(bot[i].X - bot[bb].X) +
					fabs(bot[i].Y - bot[bb].Y)
					<= 2.f *RadiusView* bot[i].Radius)
				{

					float dxa = bot[i].X - bot[bb].X;
					float dya = bot[i].Y - bot[bb].Y;

					float distance = sqrtf(dxa * dxa + dya * dya);

					if (distance < bot[i].Radius- 1.f * bot[bb].Radius / 3.f &&
						bot[i].Mass > 1.2f * bot[bb].Mass )
					{
						bot[i].Mass = bot[i].Mass + bot[bb].Mass/3 ;

						bot[bb].Mass = 0.f;
						bot[bb].TTF = 0.f;

						bot[i].Fitness = bot[i].Fitness + 55.f; // Fitness

					}

				}

			}


			//food

			//for (int ffc = 0; ffc < FoodListSize; ffc++)

			int iff = 4 * ct->FoodPopulationSize *bot[i].Depth;
			for (int ff = iff; ff < iff + 4 * ct->FoodPopulationSize; ff++)
			{
				if (bot[i].Depth == food[ff].Depth &&
					food[ff].Mass > 0.f && fabs(bot[i].X - food[ff].X) +
					fabs(bot[i].Y - food[ff].Y)
					<= 2.f *RadiusView* bot[i].Radius)
				{

					float dxf = bot[i].X - food[ff].X;
					float dyf = bot[i].Y - food[ff].Y;

					float distance = sqrtf(dxf * dxf + dyf * dyf);

					if (distance < bot[i].Radius+ food[ff].Radius)
					{
						bot[i].Mass = bot[i].Mass + food[ff].Mass;
						food[ff].Mass = -1.f;
						bot[i].Fitness = bot[i].Fitness + 3.5f;
					}
				}

			}

			bot[i].Mass = bot[i].Mass - 0.035f;

			if (bot[i].Mass <= 15.f)
			{
				bot[i].Fitness = bot[i].Fitness ;
				bot[i].TTF = 0.f;
			}
		}

		if (bot[i].Mass > 0.f && bot[i].TTF != 0)
		{

			for (int isec = 0; isec < 2 * numberofSensorshalf; isec++)
			{
				gbotSector[numSensorElem*ii + isec] = 0.f;
			}


			float deltaspeedx = bot[i].Xvelocity;
			float deltaspeedy = bot[i].Yvelocity;

			float distspeed = sqrtf(deltaspeedx * deltaspeedx + deltaspeedy * deltaspeedy);

			bot[i].nXvelocity = 0.f;
			bot[i].nYvelocity = 0.f;

			if (distspeed > 0.f)
			{
				bot[i].nXvelocity = bot[i].Xvelocity / distspeed;
				bot[i].nYvelocity = bot[i].Yvelocity / distspeed;
			}


			bool wallflag = false;

			if (fabs(bot[i].Xvelocity) < 0.0001f)
				bot[i].Xvelocity = 0.f;
			if (fabs(bot[i].Yvelocity) < 0.0001f)
				bot[i].Yvelocity = 0.f;

			float DistanceToPOI = 0.f;

			int SensorInputNumber1 = 0;

			for (int tw = conworldangleStepInit; tw < 180; tw = tw + AngleStep)
			{
				float ThetaDegree1 = tw;
				float ThetaRad1 = ThetaDegree1 * PI / 180.f;
				float cs1 = cosf(ThetaRad1);
				float sn1 = sinf(ThetaRad1);

				float NormVectoX = 0.f;
				float NormVEctorY = 1.f;

				if (bot[i].nXvelocity != 0.f && bot[i].nYvelocity != 0.f)
				{
					NormVectoX =  bot[i].nXvelocity;
					NormVEctorY = bot[i].nYvelocity;
				}

				float VEctorXrotate = bot[i].X + RadiusView * bot[i].Radius*
					(cs1 * NormVectoX - sn1 * NormVEctorY);
				float VEctorYrotate = bot[i].Y + RadiusView * bot[i].Radius*
					(sn1 * NormVectoX + cs1 * NormVEctorY);


				float ThetaDegree2 = tw + AngleStep;
				float ThetaRad2 = ThetaDegree2 * PI / 180.f;
				float cs2 = cosf(ThetaRad2);
				float sn2 = sinf(ThetaRad2);


				float VEctorXrotate2 = bot[i].X + RadiusView * bot[i].Radius*
					(cs2 * NormVectoX - sn2 * NormVEctorY);
				float VEctorYrotate2 = bot[i].Y + RadiusView * bot[i].Radius*
					(sn2 * NormVectoX + cs2 * NormVEctorY);


				if ((VEctorXrotate > gWidth || VEctorXrotate < 0.f) && (VEctorXrotate2 > gWidth || VEctorXrotate2 < 0.f)
					|| (VEctorYrotate > gHeight || VEctorYrotate < 0.f) && (VEctorYrotate2 > gHeight || VEctorYrotate2 < 0.f)
					)
				{

					gbotSector[numSensorElem*ii + SensorInputNumber1] = -0.75f;
					wallflag = true;
				}

				VEctorXrotate = bot[i].X + RadiusView * bot[i].Radius*
					(cs1 * NormVectoX + sn1 * NormVEctorY);
				VEctorYrotate = bot[i].Y + RadiusView * bot[i].Radius*
					(-sn1 * NormVectoX + cs1 * NormVEctorY);


				VEctorXrotate2 = bot[i].X + RadiusView * bot[i].Radius*
					(cs2 * NormVectoX + sn2 * NormVEctorY);
				VEctorYrotate2 = bot[i].Y + RadiusView * bot[i].Radius*
					(-sn2 * NormVectoX + cs2 * NormVEctorY);


				if ((VEctorXrotate > gWidth || VEctorXrotate < 0.f) && (VEctorXrotate2 > gWidth || VEctorXrotate2 < 0.f)
					|| (VEctorYrotate > gHeight || VEctorYrotate < 0.f) && (VEctorYrotate2 > gHeight || VEctorYrotate2 < 0.f)
					)
				{

					gbotSector[numSensorElem*ii + SensorInputNumber1 + numberofSensorshalf] = -0.75f;
					wallflag = true;
				}

				SensorInputNumber1++;

			}



			//Food Collisions
			//  if (wallflag == false)

			//for (int ffc = 0; ffc < FoodListSize; ffc++)

			//food
			int iff = 4 *ct->FoodPopulationSize *bot[i].Depth;
			for (int ff = iff; ff < iff + 4 * ct->FoodPopulationSize; ff++)
			{
				if (food[ff].Mass>0.f && bot[i].Depth == food[ff].Depth &&
					fabs(bot[i].X - food[ff].X) +
					fabs(bot[i].Y - food[ff].Y)
					<= 2.f *RadiusView* bot[i].Radius)
				{

					float dxa = food[ff].X - bot[i].X;
					float dya = food[ff].Y - bot[i].Y;

					float distance_to_unita = sqrtf(dxa * dxa + dya * dya);
					float nXalien = 0.f;
					float nYalien = 0.f;

					if (distance_to_unita > 0.)
					{
						nXalien = dxa / distance_to_unita;
						nYalien = dya / distance_to_unita;


						if ((distance_to_unita - (food[ff].Radius + 0.03f)) <= RadiusView * bot[i].Radius)
						{

							int SensorInputNumber = 0;

							for (int t = conworldangleStepInit; t < 180; t = t + AngleStep)
							{

								float angleAttack =
									anglebetween2vectors(bot[i].Xvelocity, bot[i].Yvelocity, nXalien, nYalien) * RadtoGrad;



								if (fabs(angleAttack) > t &&
									fabs(angleAttack) <= t + AngleStep)
								{
									if (angleAttack > 0.f)
									{
										gbotSector[numSensorElem*ii + SensorInputNumber] =
											gbotSector[numSensorElem*ii + SensorInputNumber] +
											(RadiusView * bot[i].Radius- distance_to_unita) / (RadiusView * bot[i].Radius* 2.f);



									}
									else
									{
										gbotSector[numSensorElem*ii + SensorInputNumber + numberofSensorshalf] =
											gbotSector[numSensorElem*ii + SensorInputNumber + numberofSensorshalf] +
											(RadiusView * bot[i].Radius- distance_to_unita) / (RadiusView * bot[i].Radius* 2.f);

									}
								}
								SensorInputNumber++;

							}

						}
					}
				}
			}

			//Alien Collisions
			//  if (wallflag==false)
			//for (int bbc = 0; bbc < ListSize; bbc++)

			int ibb = ct->BotPopulationSize *(int)bot[i].Depth;
			for (int bb = ibb; bb < ibb + ct->BotPopulationSize; ++bb)
			{

				if (bot[i].Depth == bot[bb].Depth && i != bb
					&& bot[bb].Mass > 0.f && (int)bot[bb].TTF != 0 && fabs(bot[i].X - bot[bb].X) +
					fabs(bot[i].Y - bot[bb].Y)
					<= 2.f *RadiusView* bot[i].Radius)
				{

					float dxa = bot[bb].X - bot[i].X;
					float dya = bot[bb].Y - bot[i].Y;

					float distance_to_unita = sqrtf(dxa * dxa + dya * dya);

					float nXalien = 0.f;
					float nYalien = 0.f;

					if (distance_to_unita > 0)
					{
						nXalien = dxa / distance_to_unita;
						nYalien = dya / distance_to_unita;


						if (distance_to_unita - bot[bb].Radius <= RadiusView * bot[i].Radius)
						{

							int SensorInputNumber = 0;

							for (int t = conworldangleStepInit; t < 180; t = t + AngleStep)
							{


								float angleAttack =
									anglebetween2vectors(bot[i].Xvelocity, bot[i].Yvelocity, nXalien, nYalien) * RadtoGrad;


								if (fabs(angleAttack) > t &&
									fabs(angleAttack) <= t + AngleStep)
								{
									if (angleAttack > 0.f)
									{

										if (bot[i].Mass > 1.2f * bot[bb].Mass)
										{
											gbotSector[numSensorElem*ii + SensorInputNumber] =
												gbotSector[numSensorElem*ii + SensorInputNumber] +
												0.95f * (RadiusView * bot[i].Radius- distance_to_unita) / (RadiusView* bot[i].Radius);

										}
										if (bot[i].Mass <= 1.2f * bot[bb].Mass)
										{
											gbotSector[numSensorElem*ii + SensorInputNumber] =
												-0.95f * (RadiusView * bot[i].Radius- distance_to_unita) / (RadiusView* bot[i].Radius);

										}

									}
									else
									{
										if (bot[i].Mass > 1.2f * bot[bb].Mass)
										{
											gbotSector[numSensorElem*ii + SensorInputNumber + numberofSensorshalf] =
												gbotSector[numSensorElem*ii + SensorInputNumber + numberofSensorshalf] +
												0.95f * (RadiusView * bot[i].Radius- distance_to_unita) / (RadiusView * bot[i].Radius);

										}
										if (bot[i].Mass <= 1.2f * bot[bb].Mass)
										{
											gbotSector[numSensorElem*ii + SensorInputNumber + numberofSensorshalf] =
												-0.95f * (RadiusView * bot[i].Radius- distance_to_unita) / (RadiusView * bot[i].Radius);

										}


									}
								}
								SensorInputNumber++;

							}
						}

					}

				}
			}


		}

	}
}

__global__ void cudaAfterNNRNN(Bot *bot, float *gbotSector, argumentsRNN *RNN, ConstantStruct *ct, int numElements, int gameTick,
	int *fitnessIndex, int* fitnessValue)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;

	int numberLayers =ct->TopologySize;
	const float PI = 3.141592653f;
	const float RadtoGrad = (180.f / PI);

	int LayerDim = ct->ArrayDim;

	for (int i = tid; i< numElements; i += threadN)
	{

		fitnessValue[i] = bot[i].Fitness;
		fitnessIndex[i] = bot[i].intID;
		
		if (bot[i].Mass > 0.f && bot[i].TTF != 0)
		{
			const int iiA = i*ct->ArrayDim;

			float rotate1 = RNN->outputs[iiA + 0];
			float rotate2 = RNN->outputs[iiA + 1];
			float speedFoodValue1 = RNN->outputs[iiA + 2];
			float speedFoodValue2 = RNN->outputs[iiA + 3];


			//float rotateAlertValue = layer.Neurons[2].Value;
			// float speedAlertValue =  layer.Neurons[3].Value;

			float angle = bot[i].angle;
			float speed = bot[i].speed;

			float criteria = 0.f;

			if (rotate1 > criteria && rotate2 < criteria)
			{
				angle = angle + 12.f * PI / 180.f;

			}
			if (rotate1 < criteria && rotate2 > criteria)
			{
				angle = angle - 12.f * PI / 180.f;

			}

			if (speedFoodValue1 > criteria && speedFoodValue2 <criteria)
			{
				speed = speed + 2.7f;
			}
			if (speedFoodValue1 < criteria && speedFoodValue2 > criteria)
			{
				speed = speed - 2.7f;
			}


			float dx = speed * cos(angle);
			float dy = speed * sin(angle);

			bot[i].xPOI = (bot[i].X+ dx);
			bot[i].yPOI = (bot[i].Y+ dy);


			for (int i2 = 0; i2 < ct->ArrayDim; i2++)
			{
				RNN->outputs[iiA + i2] = 0.f;
			}


		}



	}
}

__global__ void smallinitNNRNN(Bot *bot, argumentsRNN *RNN, ConstantStruct *Const, int numElements, int gameTick)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;

	

	for (int pos = tid; pos < numElements; pos += threadN)
	{
		const  int ii = pos;
		const int iiA = pos*Const->ArrayDim;
		int LayerDim = Const->ArrayDim;

		for (int i2 = 0; i2 < LayerDim; i2++)
		{
			RNN->outputs[iiA + i2] = 0.f;
		}

	}
}

__global__ void initNNRNN(Bot *bot, argumentsRNN *RNN, ConstantStruct *Const, int numElements, int gameTick)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;



	for (int pos = tid; pos < numElements; pos += threadN)
	{
		const  int ii = pos;
		const int iiA = pos*Const->ArrayDim;
		int LayerDim = Const->ArrayDim;

		for (int i2 = 0; i2 < LayerDim; i2++)
		{
			RNN->outputs[iiA + i2] = 0.f;
		}

		bot[pos].Fitness = 100000;

	}
}

__global__ void initkernelRNN(float *outputs, float *sums, float *sumsContext, float *NNweights, float *MNweights,
	  float *neuronContext,  argumentsRNN *out)
{
	if (threadIdx.x == 0) {

		out->outputs = outputs;
		out->sums = sums;
		out->sumsContext = sumsContext;
		out->NNweights = NNweights;
		out->MNweights = MNweights;
		out->neuronContext = neuronContext;
	}
}

__global__ void cudaRNN(Bot *bot, argumentsRNN *RNN, ConstantStruct *Const, int *Topology, int *TopologyRNN, int numElements, int gameTick)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;

	int TopologySize = Const->TopologySize;
	

	for (int pos = tid; pos < numElements; pos += threadN)
	{
		const  int ii = pos;
		const int iiA = pos*Const->ArrayDim;
		int ArrayDim = Const->ArrayDim;
		const int iiAT = ii*TopologySize*ArrayDim;

		if (bot[pos].TTF != 0 && bot[pos].Mass>0)
		{
			//RNN->outputs[iiA + Topology[0]] = RNN->NNweights[((ii*TopologySize + layer1)*ArrayDim + i5)*ArrayDim + j4]; //1.f;
			//bias neurons[iiA +  Topology[0]] = 1;

			int neuroncount7 = Topology[0];

			neuroncount7++;

			for (int layer1 = 0; layer1 < TopologySize - 1; layer1++)
			{
				RNN->outputs[iiA + Topology[0]] = RNN->NNweights[((ii*TopologySize + layer1)*ArrayDim + ArrayDim-1)*ArrayDim + ArrayDim-1]; //1.f;
				for (int j4 = 0; j4 < Topology[layer1 + 1]; j4++)
				{
					for (int i5 = 0; i5 < Topology[layer1] + 1; i5++)
					{
						RNN->sums[iiA + j4] = RNN->sums[iiA + j4] + RNN->outputs[iiA + i5] *
							RNN->NNweights[((ii*TopologySize + layer1)*ArrayDim + i5)*ArrayDim + j4];
					}
				}

				if (TopologyRNN[layer1] > 0)
				{

					for (int j14 = 0; j14 < Topology[layer1]; j14++)
					{
						for (int i15 = 0; i15 < Topology[layer1]; i15++)
						{


							RNN->sumsContext[iiA + j14] = RNN->sumsContext[iiA + j14] +
								RNN->neuronContext[iiAT + ArrayDim * layer1 + i15] *
								RNN->MNweights[((ii*TopologySize + layer1)*ArrayDim + i15)*ArrayDim + j14];

						}
						RNN->sumsContext[iiA + j14] = RNN->sumsContext[iiA + j14] + RNN->MNweights[((ii*TopologySize + layer1)*ArrayDim + ArrayDim - 1)*ArrayDim + ArrayDim - 1]*//1.0f*
							RNN->MNweights[((ii*TopologySize + layer1)*ArrayDim + Topology[layer1])*ArrayDim + j14]; //bias=1
					}

					for (int t = 0; t < Topology[layer1 + 1]; t++)
					{

						RNN->outputs[iiA + t] = Tanh(RNN->sums[iiA + t] + RNN->sumsContext[iiA + t]);
						RNN->neuronContext[iiAT + ArrayDim * layer1 + t] = RNN->outputs[iiA + t];

						//neurons[iiA + neuroncount7] = outputs[iiA + t];
						neuroncount7++;
					}
					//SoftMax
/*
					double sum = 0.0;
					for (int k = 0; k <ArrayDim; ++k)
						sum += exp(RNN->outputs[iiA + k]);

					for (int k = 0; k < ArrayDim; ++k)
						RNN->outputs[iiA + k] = exp(RNN->outputs[iiA + k]) / sum;
*/

				}
				else
				{
					for (int t= 0; t < Topology[layer1 + 1]; t++)
					{

						RNN->outputs[iiA + t] = Tanh(RNN->sums[iiA + t]); //sigma

																			 //neurons[iiA + neuroncount7] = outputs[iiA + i1];
						neuroncount7++;
					}

				}


				if (layer1 + 1 != TopologySize - 1)
				{
					RNN->outputs[iiA + Topology[layer1 + 1]] = RNN->NNweights[((ii*TopologySize + layer1+1)*ArrayDim + ArrayDim - 1)*ArrayDim + ArrayDim - 1];// 1.f;
					//neurons[iiA + neuroncount7] = 1;
					neuroncount7++;
				}


				for (int i2 = 0; i2 < ArrayDim; i2++)
				{
					RNN->sums[iiA + i2] = 0.f;
					RNN->sumsContext[iiA + i2] = 0.f;

				}

			}

			
		}

	}
}


__global__ void cudaRnd(float *RndDNA, int numElements)
{
	int  tid = blockIdx.x * blockDim.x + threadIdx.x;
	int  threadN = gridDim.x * blockDim.x;

	//float w = sqrt(3.0f / 2.f);

	for (int pos = tid; pos < numElements; pos += threadN)
	{
		
		RndDNA[pos] = 1.9999f * RndDNA[pos] - 0.9999f;
		//RndDNA[pos] = 2.0f *w* RndDNA[pos] - 1.0f*w;
	}
}

__host__ void CalculateSizeRNN(std::vector<int>& Topology, std::vector<int>& TopologyRNN, int& neuroncount,
	int& dendritecount)
{
	
	for (int i : Topology)
		neuroncount += i;
	for (int i : TopologyRNN)
		neuroncount += i;

	for (int layer1 = 0; layer1 <Topology.size() - 1; layer1++)
	{
		for (int i = 0; i < Topology[layer1] + 1; i++)
			for (int j = 0; j < Topology[layer1 + 1]; j++)
				dendritecount++;
	}


	for (int layer2 = 0; layer2 < TopologyRNN.size() - 1; layer2++)
	{
		for (int i7 = 0; i7 <TopologyRNN[layer2] + 1; i7++)
			for (int j7 = 0; j7 < TopologyRNN[layer2]; j7++)
				dendritecount++;
	}

}


void ComputeLSTM(Constant&  constant)
{

	size_t sizeTopology = constant.Topology.size() * sizeof(int);
	size_t sizeTopologyRNN = constant.TopologyRNN.size() * sizeof(int);
	int    *h_Topology = (int *)malloc(sizeTopology);
	int    *h_TopologyRNN = (int *)malloc(sizeTopologyRNN);
	for (int i = 0; i < constant.Topology.size(); ++i)
	{
		h_Topology[i] = constant.Topology[i];
		h_TopologyRNN[i] = constant.TopologyRNN[i];
	}
	int *d_Topology = NULL;
	cudaMalloc((void **)&d_Topology, sizeTopology);
	int *d_TopologyRNN = NULL;
	cudaMalloc((void **)&d_TopologyRNN, sizeTopologyRNN);
	cudaMemcpy(d_Topology, h_Topology, sizeTopology, cudaMemcpyHostToDevice);
	cudaMemcpy(d_TopologyRNN, h_TopologyRNN, sizeTopologyRNN, cudaMemcpyHostToDevice);


	int neuroncount = 0;
	int dendritecount = 0;

	int DepthBotPopulation = constant.DepthBotPopulation;

	CalculateSizeRNN(constant.Topology, constant.TopologyRNN, neuroncount, dendritecount);

	int RnnDNAsize = 2*DepthBotPopulation*constant.Topology.size()* constant.ArrayDim*constant.ArrayDim;
	int numberOfGensRNN = DepthBotPopulation*dendritecount;

	float *hrnnDNA;
	float *drnnDNA;
	size_t rnnDNASize = RnnDNAsize * sizeof(float);
	hrnnDNA = (float *)malloc(rnnDNASize);
	cudaMalloc((void**)&drnnDNA, rnnDNASize);

	curandGenerator_t gen3r;
	//Set the generator options
	curandCreateGenerator(&gen3r, CURAND_RNG_PSEUDO_DEFAULT);
	//Generate random numbers
	curandSetPseudoRandomGeneratorSeed(gen3r, 1234ULL);
	curandGenerateUniform(gen3r, drnnDNA, RnnDNAsize);
	//curandDestroyGenerator(gen3r);

	cudaRnd <<< int(1 + RnnDNAsize / 32), 64 >> > (drnnDNA, RnnDNAsize);
	cudaThreadSynchronize();

	cudaMemcpy(hrnnDNA, drnnDNA, rnnDNASize, cudaMemcpyDeviceToHost);
	std::vector<float> rnnDNA(hrnnDNA, hrnnDNA + RnnDNAsize);


	//RNN coeff

	float *outputs, *sums, *sumsContext, *NNweights, *MNweights, *neuronContext;
	float *_outputs, *_sums, *_sumsContext, *_NNweights, *_MNweights, *_neuronContext;

	argumentsRNN *_argsRNN;
	
	int preSizeOutputs = DepthBotPopulation * constant.ArrayDim;
	
	int preSizeNweight = DepthBotPopulation*constant.Topology.size()  * constant.ArrayDim * constant.ArrayDim;
	int preSizeMweight = DepthBotPopulation*constant.TopologyRNN.size()  * constant.ArrayDim * constant.ArrayDim;
	int preSizeNeuronContext = DepthBotPopulation*constant.TopologyRNN.size()  * constant.ArrayDim * constant.ArrayDim;

	size_t sizeOutputs = preSizeOutputs * sizeof(float);
	size_t sizeNweight = preSizeNweight * sizeof(float);
	size_t sizeMweight = preSizeMweight * sizeof(float);
	size_t SizeNeuronContext = preSizeNeuronContext * sizeof(float);

	outputs = (float *)malloc(sizeOutputs);
	sums = (float *)malloc(sizeOutputs);
	sumsContext = (float *)malloc(sizeOutputs);

	NNweights = (float *)malloc(sizeNweight);
	MNweights = (float *)malloc(sizeMweight);
	neuronContext = (float *)malloc(SizeNeuronContext);

	cudaMalloc((void**)&_outputs, sizeOutputs);
	cudaMalloc((void**)&_sums, sizeOutputs);
	cudaMalloc((void**)&_sumsContext, sizeOutputs);

	cudaMalloc((void**)&_NNweights, sizeNweight);
	cudaMalloc((void**)&_MNweights, sizeMweight);
	cudaMalloc((void**)&_neuronContext, SizeNeuronContext);

	cudaMalloc((void**)&_argsRNN, sizeof(argumentsRNN));


	ConstantStruct cudaConst;
	ConstantStruct *d_cudaConst;

	//h_cudaConst = (ConstantStruct *)malloc(sizeof(ConstantStruct));
	cudaMalloc((void**)&d_cudaConst, sizeof(ConstantStruct));

	cudaConst.FOOD_MASS=constant.FOOD_MASS;
	cudaConst.GAME_HEIGHT=constant.GAME_HEIGHT;
	cudaConst.GAME_TICKS=constant.GAME_TICKS;
	cudaConst.GAME_WIDTH=constant.GAME_WIDTH;
	cudaConst.INERTION_FACTOR=constant.INERTION_FACTOR;
	cudaConst.MAX_FRAGS_CNT=constant.MAX_FRAGS_CNT;
	cudaConst.SPEED_FACTOR=constant.SPEED_FACTOR;
	cudaConst.TICKS_TIL_FUSION=constant.TICKS_TIL_FUSION;
	cudaConst.VIRUS_RADIUS=constant.VIRUS_RADIUS;
	cudaConst.VIRUS_SPLIT_MASS=constant.VIRUS_SPLIT_MASS;
	cudaConst.VISCOSITY = constant.VISCOSITY;
	cudaConst.RadiusOfView=constant.RadiusOfView;

	cudaConst.SUM_RESP_TIMEOUT=constant.SUM_RESP_TIMEOUT;      
	cudaConst.RESP_TIMEOUT=constant.RESP_TIMEOUT ;        

	cudaConst.Depth=constant.Depth;
	cudaConst.CrossMove=constant.CrossMove;

	cudaConst.BotPopulationSize=constant.BotPopulationSize;
	cudaConst.VirusPopulationSize=constant.VirusPopulationSize;
	cudaConst.FoodPopulationSize=constant.FoodPopulationSize ;
	cudaConst.FoodAddPopulationSize=constant.FoodAddPopulationSize;
	cudaConst.FoodPAdd=constant.FoodPAdd;
	cudaConst.GlobalTicks=constant.GlobalTicks;

	cudaConst.DepthBotPopulation=constant.DepthBotPopulation;
	cudaConst.DepthFoodPopulation = constant.DepthFoodPopulation;
	cudaConst.DepthAddFoodPopulation = constant.DepthAddFoodPopulation;

	cudaConst.radius=constant.radius;
	cudaConst.KoeffWall=constant.KoeffWall;
	cudaConst.KoefEnemyDanger=constant.KoefEnemyDanger;
	cudaConst.KoefEnemyEat=constant.KoefEnemyEat;
	cudaConst.KoefEat=constant.KoefEat;
	cudaConst.KoefVirus=constant.KoefVirus;
	cudaConst.Lkoef=constant.Lkoef;

	cudaConst.xSetRight=constant.xSetRight;
	cudaConst.xSetLeft=constant.xSetLeft;
	cudaConst.ySetTop=constant.ySetTop;
	cudaConst.ySetDown=constant.ySetDown;

	cudaConst.IdeaTick=constant.IdeaTick;
	cudaConst.IdeaShortTick=constant.IdeaShortTick;

	cudaConst.numberofSensors=constant.numberofSensors;
	cudaConst.numberofSensorshalf=constant.numberofSensorshalf;
	cudaConst.numberofSensorsAll=constant.numberofSensorsAll;
	cudaConst.angleStep=constant.angleStep;
	cudaConst.angleStepInit=constant.angleStepInit;
	cudaConst.WorldTick=constant.WorldTick;
	cudaConst.ArrayDim=constant.ArrayDim;
	cudaConst.TopologySize = constant.Topology.size();
	cudaConst.TopologyRNNSize = constant.TopologyRNN.size();

    cudaMemcpy(d_cudaConst, &cudaConst, sizeof(ConstantStruct), cudaMemcpyHostToDevice);

	//initialization of Bot

	int numElements = constant.DepthBotPopulation;;

	//thrust::host_vector<Bot> thBotList;
	//thrust::device_vector<Bot> tdBotList;

	std:: vector<Bot> BotList(numElements);
	Bot *hBotList;
	Bot *dBotList;
	size_t BotSize = numElements * sizeof(Bot);
	hBotList = (Bot *)malloc(BotSize);
	cudaMalloc((void**)&dBotList, BotSize);

	std::vector<Bot> BotListSort(numElements);
	Bot *hBotListSort;
	Bot *dBotListSort;
	hBotListSort = (Bot *)malloc(BotSize);
	cudaMalloc((void**)&dBotListSort, BotSize);


	std::vector<Food> FoodList(constant.DepthFoodPopulation);
	Food *hFoodList;
	Food *dFoodList;
	size_t FoodSize = FoodList.size() * sizeof(Food);
	hFoodList = (Food *)malloc(FoodSize);
	cudaMalloc((void**)&dFoodList, FoodSize);

	std::vector<Food> AddFoodList(constant.DepthAddFoodPopulation);
	Food *hAddFoodList;
	Food *dAddFoodList;
	size_t AddFoodSize = AddFoodList.size() * sizeof(Food);
	hAddFoodList = (Food *)malloc(AddFoodSize);
	cudaMalloc((void**)&dAddFoodList, AddFoodSize);

	
	int numSensorElem = 2 * (int)constant.numberofSensorshalf;
	int numSensorElements = (int)BotList.size()*numSensorElem;
	std::vector<float> Sector(numSensorElements);
	std::fill(Sector.begin(), Sector.begin() + numSensorElements, 0);
	size_t sizeSensorElem = numSensorElements * sizeof(float);



	float *h_gbotSector = (float *)malloc(sizeSensorElem);
	float *d_gbotSector = NULL;
	cudaMalloc((void **)&d_gbotSector, sizeSensorElem);

	float *h_tgbotSector = (float *)malloc(sizeSensorElem);
	float *d_tgbotSector = NULL;
	cudaMalloc((void **)&d_tgbotSector, sizeSensorElem);

	for (int i = 0; i <preSizeOutputs; i++)
	{
		outputs[i] = 0;
		sums[i] = 0;
		sumsContext[i] = 0;
	}

	InitBotList(BotList, Sector, constant);

	for (Bot botIndex : BotList)
	{
		for (int layerT = 0; layerT < constant.Topology.size() - 1; layerT++)
		{
			for (int it = 0; it < constant.Topology[layerT] + 1; it++)
			{
				for (int jt = 0; jt < constant.Topology[layerT + 1]; jt++)
				{
					NNweights[((botIndex.intID*constant.Topology.size() + layerT)*constant.ArrayDim + it)*constant.ArrayDim + jt] =
						rnnDNA[((botIndex.intID*constant.Topology.size() + layerT)*constant.ArrayDim + it)*constant.ArrayDim + jt];
				}
			}
		}

		for (int layerR = 0; layerR < constant.TopologyRNN.size() - 1; layerR++)
		{
			for (int ir = 0; ir < constant.TopologyRNN[layerR] + 1; ir++)
			{
				for (int jr = 0; jr < constant.TopologyRNN[layerR]; jr++)
				{
					MNweights[((botIndex.intID*constant.Topology.size() + layerR)*constant.ArrayDim + ir)*constant.ArrayDim + jr]
						= rnnDNA[preSizeMweight+((botIndex.intID*constant.Topology.size() + layerR)*constant.ArrayDim + ir)*constant.ArrayDim + jr];
				}
			}
		}
	}


	for (int i = 0; i <preSizeNeuronContext; i++)
	{
		neuronContext[i] = 0;
	}

	cudaMemcpy(_outputs, outputs, sizeOutputs, cudaMemcpyHostToDevice);
	cudaMemcpy(_sums, sums, sizeOutputs, cudaMemcpyHostToDevice);
	cudaMemcpy(_sumsContext, sumsContext, sizeOutputs, cudaMemcpyHostToDevice);

	cudaMemcpy(_NNweights, NNweights, sizeNweight, cudaMemcpyHostToDevice);
	cudaMemcpy(_MNweights, MNweights, sizeNweight, cudaMemcpyHostToDevice);
	cudaMemcpy(_neuronContext, neuronContext, SizeNeuronContext, cudaMemcpyHostToDevice);

	initkernelRNN <<< 1, 1 >> > (_outputs, _sums, _sumsContext, _NNweights, _MNweights, _neuronContext, _argsRNN);
	cudaThreadSynchronize();


	std::vector<int> fitnessIndex;
	fitnessIndex.resize(DepthBotPopulation);
	std::vector<int> fitnessValue;
	fitnessValue.resize(DepthBotPopulation);

	int numFitnessElem = (int)DepthBotPopulation;
	size_t sizeFitness = numFitnessElem * sizeof(int);

	int *h_fitnessIndex = (int*)malloc(sizeFitness);
	int *h_fitnessValue = (int*)malloc(sizeFitness);

	int *d_fitnessIndex = NULL;
	cudaMalloc((void **)&d_fitnessIndex, sizeFitness);
	int *d_fitnessValue = NULL;
	cudaMalloc((void **)&d_fitnessValue, sizeFitness);

	cudaMemcpy(d_fitnessIndex, h_fitnessIndex, sizeFitness, cudaMemcpyHostToDevice);
	cudaMemcpy(d_fitnessValue, h_fitnessValue, sizeFitness, cudaMemcpyHostToDevice);



	//Init game loop

	GraphModule graphModule;
	graphModule.Init(constant.GAME_WIDTH, constant.GAME_HEIGHT, constant.Depth, constant.GAME_TICKS);

	InfoGraph infoGraph;
	infoGraph.Init();

	std::vector<float> rnnNNweights1(NNweights, NNweights + preSizeNweight);
	std::vector<float> rnnMNweights1(MNweights, MNweights + preSizeMweight);

	GraphGA graphGA;
	graphGA.Init(1700, 1250, 1700, 1250, constant.Depth);
	graphGA.Clear();
	graphGA.GAtoPictiteAll(BotList, rnnNNweights1, rnnMNweights1, 1.f, dendritecount, DepthBotPopulation, 0,
		constant.TopologyRNN.size(), constant.ArrayDim, constant.Topology, constant.TopologyRNN);
	graphGA.Display();


	for (int WGTick = 0; WGTick < constant.GlobalTicks; ++WGTick)
	{

		clock_t start2 = clock();
		
		InitBotList(BotList, Sector, constant);
		::memcpy(hBotList, BotList.data(), BotSize);
		cudaMemcpy(dBotList, hBotList, BotSize, cudaMemcpyHostToDevice);

		InitFoodList(FoodList, constant);
		::memcpy(hFoodList, FoodList.data(), FoodSize);
		cudaMemcpy(dFoodList, hFoodList, FoodSize, cudaMemcpyHostToDevice);

		InitAddFoodList(AddFoodList, constant);
		::memcpy(hAddFoodList, AddFoodList.data(), AddFoodSize);
		cudaMemcpy(dAddFoodList, hAddFoodList, AddFoodSize, cudaMemcpyHostToDevice);

		::memcpy(h_gbotSector, Sector.data(), sizeSensorElem);
		cudaMemcpy(d_gbotSector, h_gbotSector, sizeSensorElem, cudaMemcpyHostToDevice);
		::memcpy(h_tgbotSector, Sector.data(), sizeSensorElem);
		cudaMemcpy(d_tgbotSector, h_tgbotSector, sizeSensorElem, cudaMemcpyHostToDevice);
		float gameLevel = constant.gameLevel;

		
		clock_t finish2 = clock();

		for (int WTick = 0; WTick < constant.GAME_TICKS; ++WTick)
		{

			sf::Event event;
			if (graphModule.MainWindow.pollEvent(event))
			{
				if (event.type == sf::Event::Closed)
					graphModule.Close();

				if (event.type == sf::Event::KeyPressed)
					graphModule.KeyPressed(event);
			}


			//RNN Section

			clock_t ServerStart = clock();

		    cudaServer <<< int(1 + numElements / 32), 64 >> > (dBotList, dFoodList, d_gbotSector, d_cudaConst, numElements, WGTick);
			cudaThreadSynchronize();

			clock_t ServerFinish = clock();

            clock_t NNStart = clock();

			cudaBeforeNNRNN<<< int(1 + numElements / 32), 64 >>> (dBotList, d_gbotSector, d_tgbotSector, _argsRNN, d_cudaConst, numElements, WTick);
			cudaThreadSynchronize();

			cudaRNN <<< int(1 + numElements / 32), 64 >>> (dBotList, _argsRNN, d_cudaConst, d_Topology, d_TopologyRNN, numElements, WTick);
			cudaThreadSynchronize();

			cudaAfterNNRNN <<< int(1 + numElements / 32), 64 >>> (dBotList,d_gbotSector, _argsRNN, d_cudaConst, numElements, 
				WTick, d_fitnessIndex, d_fitnessValue);
			cudaThreadSynchronize();

            clock_t NNFinish = clock();
		
            clock_t start3 = clock();

			if (graphModule.DrawUnits)
			{
				

				// Copy the device result vector in device memory to the host result vector in host memory.
				//printf("Copy output data from the CUDA device to the host memory\n");

				cudaMemcpy(hBotList, dBotList, BotSize, cudaMemcpyDeviceToHost);
				cudaMemcpy(hFoodList, dFoodList, FoodSize, cudaMemcpyDeviceToHost);
				cudaMemcpy(h_gbotSector,d_gbotSector, sizeSensorElem, cudaMemcpyDeviceToHost);

				std::vector<Bot> VisualDepthBot(hBotList+ constant.BotPopulationSize*graphModule.DepthView, 
					 hBotList +constant.BotPopulationSize*graphModule.DepthView+ constant.BotPopulationSize);
				std::vector<Food> VisualDepthFood(hFoodList+ 4 * constant.FoodPopulationSize*graphModule.DepthView,
					hFoodList + 4 * constant.FoodPopulationSize*graphModule.DepthView+ 4 * constant.FoodPopulationSize);
				std::vector<float> VisualSector(h_gbotSector + 2*constant.numberofSensorshalf*constant.BotPopulationSize*graphModule.DepthView,
					h_gbotSector +2*constant.numberofSensorshalf*
					constant.BotPopulationSize*graphModule.DepthView + 2*constant.numberofSensorshalf* constant.BotPopulationSize);



			    std::memcpy(BotList.data(), hBotList, BotSize);
			
				
             


			   graphModule.Clear();
			   graphModule.DrawFrameInfo(WTick);
			   graphModule.DrawDepthAllBot(VisualDepthBot, VisualSector,constant.angleStep,
				   constant.angleStepInit, constant.numberofSensorshalf, constant.RadiusOfView);
			   graphModule.DrawDepthOther(VisualDepthFood, WTick);
			   graphModule.Display();

				constant.GAME_TICKS= graphModule.TickW;
				//constant.gamelevel = graphModule.gameLevel;

			}


			if (WTick % 50 == 0 && WTick > 15)
			{
				if (graphModule.DrawUnits == false)
					cudaMemcpy(hFoodList, dFoodList, FoodSize, cudaMemcpyDeviceToHost);

				for (int d = 0; d < constant.Depth; d++)
				{
					int FoodAddCount = 0;
					for (int i = 0; i < 4 * constant.FoodPopulationSize; i++)
					{
						int indexFoodDepth = i + d * 4 * constant.FoodPopulationSize;
						if (hFoodList[indexFoodDepth].Mass < 0)
						{
							int min = d * 4 * constant.FoodAddPopulationSize + 1;
							int max = d * 4 * constant.FoodAddPopulationSize + 4 * constant.FoodAddPopulationSize - 10;
							int output = min + (rand() % static_cast<int>(max - min));
							hFoodList[indexFoodDepth].Mass = AddFoodList[output].Mass;
							hFoodList[indexFoodDepth].X = AddFoodList[output].X;
							hFoodList[indexFoodDepth].Y = AddFoodList[output].Y;
							FoodAddCount++;
							if (FoodAddCount > 4 * AddFoodSize)
								break;
						}

					}
					
				}

				cudaMemcpy(dFoodList, hFoodList, FoodSize, cudaMemcpyHostToDevice);
			}
	
			clock_t finish3 = clock();

			infoGraph.Clear();
			infoGraph.TimetoPictite(constant.GAME_TICKS,
				(int)ceil(float(((ServerFinish - ServerStart) * 1000 / (CLOCKS_PER_SEC)))),
				(int)ceil(float(((NNFinish - NNStart) * 1000 / (CLOCKS_PER_SEC)))),
				(int)ceil(float(((finish2 - start2) * 1000 / (CLOCKS_PER_SEC)))),
				(int)ceil(float(((finish3 - start3) * 1000 / (CLOCKS_PER_SEC)))), WGTick, gameLevel);

			if (graphModule.DrawUnits)
			{
			//	infoGraph.BotStat(BotList, graphModule.DepthView, WGTick);
			}

			infoGraph.Display();


		}

			cudaMemcpy(hBotList, dBotList, BotSize, cudaMemcpyDeviceToHost);
			std::memcpy(BotList.data(), hBotList, BotSize);

			thrust::device_ptr<int> t_fitnessValue(d_fitnessValue);  // add this line before the sort line
			thrust::device_ptr<int> t_fitnessIndex(d_fitnessIndex);  // add this line before the sort line
																	 //thrust::sort(t_fitnessValue, t_fitnessValue + BotListSize);
																	 //srand(15);
			thrust::sort_by_key(t_fitnessValue, t_fitnessValue + DepthBotPopulation, t_fitnessIndex, thrust::greater<int>());

			cudaMemcpy(h_fitnessValue, d_fitnessValue, sizeFitness, cudaMemcpyDeviceToHost);
			cudaMemcpy(h_fitnessIndex, d_fitnessIndex, sizeFitness, cudaMemcpyDeviceToHost);
			std::vector<int> fitnessValue2(h_fitnessValue, h_fitnessValue + DepthBotPopulation);
			std::vector<int> fitnessIndex2(h_fitnessIndex, h_fitnessIndex + DepthBotPopulation);

			int sumFitness = thrust::reduce(t_fitnessValue, t_fitnessValue + DepthBotPopulation);


			int maxFitness = fitnessValue2[0];
			int minFitness = fitnessValue2[constant.DepthBotPopulation - 1];
			int bestBotindex = fitnessIndex2[0];
			int MiddleFitness = (int)((maxFitness + minFitness)/2);
			int MiddleFitness2 = (int)((fitnessValue2[25] + minFitness) / 2);
			int Fitness5 =(int)( maxFitness - (maxFitness - minFitness) /5);

			printf(" Sum fitness %u ", sumFitness);
			printf(" Best f0 %u ", fitnessValue2[0]);
			printf(" f1 %u ", fitnessValue2[1]);
			printf(" Mf %u ", MiddleFitness);
			printf(" Mf2 %u ", MiddleFitness2);
			printf(" F5 %u ", MiddleFitness2);
			printf(" lowest f %u ", fitnessValue2[constant.DepthBotPopulation - 1]);
			printf("\n");


		//	std::copy(BotListCopy.begin(), BotListCopy.end(), hBotListSort);
		//	std::memcpy(hBotListSort, BotListCopy.data(), BotSize);
		//	cudaMemcpy(dBotListSort, hBotListSort, BotSize, cudaMemcpyHostToDevice));

			//bestBotIndex = bestBotindex;

			//curandGenerator_t gen3r;
			//Set the generator options
			//curandCreateGenerator(&gen3r, CURAND_RNG_PSEUDO_DEFAULT);
			//Generate random numbers
			//curandSetPseudoRandomGeneratorSeed(gen3r, 1234ULL* WGTick);
			curandGenerateUniform(gen3r, drnnDNA, RnnDNAsize);
			//curandDestroyGenerator(gen3r);


			cudaRnd << < int(1 + RnnDNAsize / 32), 64 >> > (drnnDNA, RnnDNAsize);
			cudaThreadSynchronize();

			cudaMemcpy(hrnnDNA, drnnDNA, rnnDNASize, cudaMemcpyDeviceToHost);
			std::vector<float> rnnDNA2(hrnnDNA, hrnnDNA + RnnDNAsize);


			
/*
			cudaGARNN << < int(1 + numElements / 32), 64 >> > (dBotList, dBotListSort, drnnDNA, _argsRNN , d_Topology, d_TopologyRNN, preSizeMweight,
				d_cudaCardConst, numElements, WGTick, MiddleFitness, Fitness5, bestBotindex);
			cudaThreadSynchronize());
*/

			cudaGARNN2 << < int(1 + numElements / 32), 64 >> > (dBotList, d_fitnessIndex, drnnDNA, _argsRNN, d_Topology, d_TopologyRNN, preSizeMweight,
				d_cudaConst, numElements, WGTick, MiddleFitness2, Fitness5, sumFitness);
			cudaThreadSynchronize();

			initNNRNN << < int(1 + numElements / 32), 64 >> > (dBotList, _argsRNN, d_cudaConst, numElements, WGTick);
			cudaThreadSynchronize();

			//cudaMemcpy(hBotList, dBotList, BotSize, cudaMemcpyDeviceToHost));
			//std::memcpy(BotList.data(), hBotList, BotSize);



			if (graphModule.DrawUnits)
			{
				

				cudaMemcpy(NNweights, _NNweights, sizeNweight, cudaMemcpyDeviceToHost);
				std::vector<float> rnnNNweights(NNweights, NNweights + preSizeNweight);

				cudaMemcpy(MNweights, _MNweights, sizeNweight, cudaMemcpyDeviceToHost);
				std::vector<float> rnnMNweights(MNweights, MNweights + preSizeMweight);

				graphGA.Clear();
				graphGA.GAtoPictiteAll(BotList, rnnNNweights, rnnMNweights, 1.f, dendritecount, DepthBotPopulation, WGTick,
					constant.TopologyRNN.size(),constant.ArrayDim, constant.Topology, constant.TopologyRNN);
				graphGA.Display();
			}


		//RNN Block

		smallinitNNRNN << < int(1 + numElements / 32), 64 >> > (dBotList, _argsRNN, d_cudaConst, numElements, WGTick);
		cudaThreadSynchronize();

		cudaMemcpy(hBotList, dBotList, BotSize, cudaMemcpyDeviceToHost);
		std::memcpy(BotList.data(), hBotList, BotSize);

	}



	//resultOutput = MatCopy2d(ht2d, 3, 1);
	//resultCellState = MatCopy2d(ct2d, 3, 1);
	//return resultCudaOutput;



	cudaFree(dBotList);
	cudaFree(dFoodList);
	cudaFree(dAddFoodList);

	cudaFree(_outputs);
	cudaFree(_sums);
	cudaFree(_sumsContext);
	cudaFree(_NNweights);
	cudaFree(_MNweights);
	cudaFree(_neuronContext);


	free(hBotList);
	free(hFoodList);
	free(hAddFoodList);

	free(outputs);
	free(sums);
	free(sumsContext);
	free(NNweights);
	free(MNweights);
	free(neuronContext);

}
