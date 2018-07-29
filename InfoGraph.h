#pragma once
#include "SFML\Graphics.hpp"
#include  "Bot.h"

class InfoGraph
{
public:

	InfoGraph();

	int DepthView = 0;
	int ScreenWidth;
	int ScreenHeight;
	float x2Screen;
	float y2Screen;

	sf::RenderWindow InfoWindow;

	void Init();

	sf::Text Timecount;
	sf::Font font;

    void TimetoPictite(int , int timeGPUServer, int timeGPUNN, int timeGPUMEM, int timeGraph,int Tick, float);

	void BotStat(std::vector<Bot>& Botlist, int DepthView, int Tick);

	void Clear();
	void Display();
	void Close();
	bool OpenWindow();

};

