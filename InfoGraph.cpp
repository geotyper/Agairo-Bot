#include "InfoGraph.h"

InfoGraph::InfoGraph() = default;

void InfoGraph::Init()
{
	int x_init_start = 1550;
	int y_init_start = 1050;

	InfoWindow.create(sf::VideoMode(x_init_start, y_init_start), "Info");

	InfoWindow.setPosition(sf::Vector2i(50, 100));
    InfoWindow.clear(sf::Color(sf::Color(75, 75, 75)));

	font.loadFromFile("arial.ttf");
	Timecount.setFont(font);


}

void InfoGraph::TimetoPictite( int TickW, int timeGPUServer, int timeGPUNN, int timeGPUMEM, int timeGraph, int Tick, float gamelevel)
{

	int gencnt = 0;
	Timecount.setFillColor(sf::Color::Cyan);

	Timecount.setCharacterSize(12);
	Timecount.setString("Tick per Generation : " + std::to_string(TickW)+ "    Tick :" + std::to_string(Tick));
	Timecount.setPosition(sf::Vector2f(15, 15));
	InfoWindow.draw(Timecount);

	Timecount.setString("Time GPU Server : " + std::to_string(timeGPUServer));
	Timecount.setPosition(sf::Vector2f(15, 30));
	InfoWindow.draw(Timecount);

	Timecount.setString("Time GPU NN       : " + std::to_string(timeGPUNN));
	Timecount.setPosition(sf::Vector2f(15, 45));
	InfoWindow.draw(Timecount);

	Timecount.setString("Time GPU Mem    : " + std::to_string(timeGPUMEM));
	Timecount.setPosition(sf::Vector2f(15, 60));
	InfoWindow.draw(Timecount);


	Timecount.setString("Time Graph            : " + std::to_string(timeGraph) );
	Timecount.setPosition(sf::Vector2f(15, 75));
	InfoWindow.draw(Timecount);

	Timecount.setString("GameLevel            : " + std::to_string(gamelevel));
	Timecount.setPosition(sf::Vector2f(15, 90));
	InfoWindow.draw(Timecount);

}

void InfoGraph::BotStat(std::vector<Bot>& Botlist, int DepthView, int Tick)
{
	int BotListIndex = 0;
	int BotListX = 0;
	for (Bot bot : Botlist)
	{
		if (bot.Fitness > Botlist[0].Fitness)
		{
			Timecount.setString("Bot  : " + std::to_string(bot.intID)+ " Fitness  : " + std::to_string(bot.Fitness));
			Timecount.setPosition(sf::Vector2f(15+ BotListX, 115+BotListIndex*15));
			InfoWindow.draw(Timecount);
			BotListIndex++;

		}
		if (BotListIndex == 55|| BotListIndex == 110)
		{
			BotListIndex = 0;
			BotListX +=170;
		}

	}

	


}

void InfoGraph::Clear()
{
	InfoWindow.clear(sf::Color(sf::Color(75, 75, 75)));
}

void InfoGraph::Display()
{
	InfoWindow.display();
}

void InfoGraph::Close()
{
	InfoWindow.close();

}

bool InfoGraph::OpenWindow()
{
	return InfoWindow.isOpen();
}



