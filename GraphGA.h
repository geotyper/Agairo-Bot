#pragma once
#include "SFML\Graphics.hpp"
#include "Bot.h"
#include <vector>

class GraphGA
{

public:

	int x_init;
	int y_init;

	int Depth;

	int xgrid;
	int ygrid;

	int xSetRight;
	int xSetLeft;
	int ySetTop;
	int ySetDown;

	GraphGA();
	
	sf::RenderWindow ViewGAWindow;
	sf::View GraphView;
	sf::Text Timecount;
	sf::Font font;

	bool GraphOn = true;

	void Init(int , int , int , int ,int);
	
	//void GAtoPictite(const GeneticAlgorithm&, float );

	void GAtoPictiteAll(std::vector<Bot>& BotList, std::vector<float>& , std::vector<float>& , float, int numberOfGens,
		int BotPopulation, int Generation, int TopologySize, int ArrayDim,
		std::vector<int>& Topology, std::vector<int>& TopologyRNN);

	
	void Clear();
	void Display();
	void Close();
	bool OpenWindow();

};
