#pragma once

#include "Graphmodule.h"

GraphModule::GraphModule() = default;

void GraphModule::Init(int _ScreenWidth, int _ScreenHeight, int maxDepth, int _gameTick)
	{

	    MaxDepth = maxDepth;
		x2Screen = 0;
	    y2Screen = (float)_ScreenHeight;

		TickW = _gameTick;

		ScreenWidth = _ScreenWidth;
		ScreenHeight = _ScreenHeight;
		MainWindow.create(sf::VideoMode(ScreenWidth,ScreenHeight), "SFML start");
		MainWindow.setPosition(sf::Vector2i(150, 100));
		MainWindow.clear(sf::Color(sf::Color(75, 75, 75)));

		font.loadFromFile("arial.ttf");
		Timecount.setFont(font);

		

	}

void GraphModule::DrawDepthAllBot(std::vector<Bot>& BotList, std::vector<float>& Sector,  int angleStep, 
	int angleStepInit, int numberofSensorshalf, float radiusView)
{
	sf::CircleShape drawunit;
	sf::CircleShape drawunit1;
	sf::Vertex SpeedLine[3];
	sf::Vertex POILine[2];
	sf::Vertex nPOILine[2];
	sf::Vertex nPOI90[2];
	sf::Vertex nPOI270[2];
	sf::Vertex VirusLine[2];

	drawunit.setFillColor(sf::Color::Transparent);
	drawunit.setFillColor(sf::Color(sf::Color(45, 45, 45)));
	drawunit.setOutlineColor(sf::Color::Yellow);
	drawunit.setOutlineThickness(1.f);

	drawunit1.setFillColor(sf::Color::Transparent);
	drawunit1.setOutlineColor(sf::Color::Green);
	drawunit1.setOutlineThickness(1.f);
	int Drawindex = 0;
	int botindex = 0;
	for (Bot& bot: BotList)
	{
		if (bot.Depth == DepthView && bot.TTF > 0)
		{
			drawunit.setFillColor(sf::Color(ColorTable[bot.color ].x*210,
											ColorTable[bot.color ].y*210,
											ColorTable[bot.color ].z*210));

			Timecount.setCharacterSize(11);
			Timecount.setString("BotID: " + std::to_string(bot.intID) + "Mass: " + std::to_string(bot.Mass)
				+ "TTF: " + std::to_string(bot.TTF));
			Timecount.setPosition(sf::Vector2f(25, 25 + 25 * Drawindex));
			Drawindex++;
			//Unitcount.DisplayedString = "Idea Count:  " + BotsList.BotList.Count.ToString();

			MainWindow.draw(Timecount);

			drawunit.setRadius((float)bot.Radius);

			drawunit1.setRadius(radiusView * (float)bot.Radius);

			drawunit.setPosition(
				sf::Vector2f((float)(bot.X - drawunit.getRadius()), y2Screen - (float)(bot.Y + drawunit.getRadius())));


			drawunit1.setPosition(
				sf::Vector2f((float)(bot.X - drawunit1.getRadius()),
					y2Screen - (float)(bot.Y + drawunit1.getRadius())));


			int SensorInputNumber = 0;

			for (int t = angleStepInit; t < 180; t = t + angleStep)
			{
				auto ThetaDegree1 = t;
				auto ThetaRad1 = ThetaDegree1 * PI / 180;
				auto cs1 = cos(ThetaRad1);
				auto sn1 = sin(ThetaRad1);

				float NormVectoX = 0;
				float NormVEctorY = 1;

				if (bot.nXvelocity != 0 && bot.nYvelocity != 0)
				{
					NormVectoX = bot.nXvelocity;
					NormVEctorY = bot.nYvelocity;
				}

				float VEctorXrotate = bot.X + radiusView * bot.Radius *
					(cs1 * NormVectoX - sn1 * NormVEctorY);
				float VEctorYrotate = bot.Y + radiusView * bot.Radius *
					(sn1 * NormVectoX + cs1 * NormVEctorY);


				auto ThetaDegree2 = t + angleStep;
				auto ThetaRad2 = ThetaDegree2 * PI / 180;
				auto cs2 = cos(ThetaRad2);
				auto sn2 = sin(ThetaRad2);



				float VEctorXrotate2 = bot.X + radiusView * bot.Radius *
					(cs2 * NormVectoX - sn2 * NormVEctorY);
				float VEctorYrotate2 = bot.Y + radiusView * bot.Radius *
					(sn2 * NormVectoX + cs2 * NormVEctorY);

				SpeedLine[0] = sf::Vertex(sf::Vector2f((float)bot.X, y2Screen - (float)bot.Y));
				SpeedLine[1] = sf::Vertex(sf::Vector2f((float)(VEctorXrotate), y2Screen - (float)(VEctorYrotate)));
				SpeedLine[2] = sf::Vertex(sf::Vector2f((float)(VEctorXrotate2), y2Screen - (float)(VEctorYrotate2)));



				if (Sector[botindex*2*numberofSensorshalf+SensorInputNumber] != 0)
				{

					if (Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber] > 0)
					{
						SpeedLine[0].color = sf::Color::Transparent;
						SpeedLine[1].color = sf::Color(0, (190 * Sector[botindex*2*numberofSensorshalf+SensorInputNumber]), 0);
						SpeedLine[2].color = sf::Color(0, (190 * Sector[botindex*2*numberofSensorshalf+SensorInputNumber]), 0);
					}
					else
					{
						SpeedLine[0].color = sf::Color::Transparent;
						SpeedLine[1].color = sf::Color((190 * abs(Sector[botindex*2*numberofSensorshalf+SensorInputNumber])), 0, 0);
						SpeedLine[2].color = sf::Color((190 * abs(Sector[botindex*2*numberofSensorshalf+SensorInputNumber])), 0, 0);

					}
				}
				else
				{
					SpeedLine[0].color = sf::Color(95, 95, 95);
					SpeedLine[1].color = sf::Color::Transparent;
					SpeedLine[2].color = sf::Color::Transparent;
				}

				MainWindow.draw(SpeedLine, 3, sf::PrimitiveType::Triangles);

				if (Sector[botindex*2*numberofSensorshalf+SensorInputNumber] != 0)
				{
					Timecount.setString(std::to_string(Sector[botindex*2*numberofSensorshalf+SensorInputNumber]));
					Timecount.setPosition(sf::Vector2f((float)VEctorXrotate, y2Screen - (float)VEctorYrotate));
					MainWindow.draw(Timecount);
				}

				VEctorXrotate = bot.X + radiusView * bot.Radius *
					(cs1 * NormVectoX + sn1 * NormVEctorY);
				VEctorYrotate = bot.Y + radiusView * bot.Radius *
					(-sn1 * NormVectoX + cs1 * NormVEctorY);

				VEctorXrotate2 = bot.X + radiusView* bot.Radius *
					(cs2 * NormVectoX + sn2 * NormVEctorY);
				VEctorYrotate2 = bot.Y + radiusView* bot.Radius *
					(-sn2 * NormVectoX + cs2 * NormVEctorY);

				SpeedLine[0] = sf::Vertex(sf::Vector2f((float)bot.X, y2Screen - (float)bot.Y));
				SpeedLine[1] = sf::Vertex(sf::Vector2f((float)(VEctorXrotate), y2Screen - (float)(VEctorYrotate)));
				SpeedLine[2] = sf::Vertex(sf::Vector2f((float)(VEctorXrotate2), y2Screen - (float)(VEctorYrotate2)));



				if (Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf] != 0)
				{

					if (Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf] > 0)
					{
						SpeedLine[0].color = sf::Color::Transparent;
						SpeedLine[1].color = sf::Color(0, (190 * Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf]), 0);
						SpeedLine[2].color = sf::Color(0, (190 * Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf]), 0);
					}
					else
					{
						SpeedLine[0].color = sf::Color::Transparent;
						SpeedLine[1].color = sf::Color((190 * abs(Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf])), 0, 0);
						SpeedLine[2].color = sf::Color((190 * abs(Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf])), 0, 0);

					}
				}
				else
				{
					SpeedLine[0].color = sf::Color(95, 95, 95);
					SpeedLine[1].color = sf::Color::Transparent;
					SpeedLine[2].color = sf::Color::Transparent;
				}

				MainWindow.draw(SpeedLine, 3, sf::PrimitiveType::Triangles);

				if (Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf] != 0)
				{
					Timecount.setString(std::to_string(Sector[botindex * 2 * numberofSensorshalf + SensorInputNumber + numberofSensorshalf]));
					Timecount.setPosition(sf::Vector2f((float)VEctorXrotate, y2Screen - (float)VEctorYrotate));
					MainWindow.draw(Timecount);
				}

				SensorInputNumber++;

			}

			MainWindow.draw(drawunit1);
			MainWindow.draw(drawunit);


			float vectorzoom = 25.f;
			float vectorzoom2 = 0.5f;

			POILine[0] = sf::Vertex(sf::Vector2f((float)bot.X, y2Screen - (float)bot.Y));
			POILine[1] = sf::Vertex(sf::Vector2f((float)(bot.X + vectorzoom * bot.nXvelocity),
				y2Screen - (float)(bot.Y + vectorzoom * bot.nYvelocity)));

			POILine[0].color = (sf::Color::Green);
			POILine[1].color = (sf::Color::Green);

			//MainWindow.draw(POILine, 2, sf::PrimitiveType::Lines);

			nPOILine[0] = sf::Vertex(sf::Vector2f((float)bot.X, y2Screen - (float)bot.Y));
			nPOILine[1] = sf::Vertex(sf::Vector2f((float)(bot.xPOI), y2Screen - (float)(bot.yPOI)));

			nPOILine[0].color = (sf::Color::Yellow);
			nPOILine[1].color = (sf::Color::Yellow);

			MainWindow.draw(nPOILine, 2, sf::PrimitiveType::Lines);
		}
		botindex++;
	}

}

void GraphModule::DrawDepthOther(std::vector<Food>& FoodList, int)
{
	sf::CircleShape drawunitf;
	sf::Vertex VirusLine[2];

	drawunitf.setFillColor(sf::Color::Transparent);
	drawunitf.setFillColor(sf::Color(175, 175, 0));
	drawunitf.setOutlineColor(sf::Color::Yellow);
	drawunitf.setOutlineThickness(1);
	drawunitf.setRadius(2.5f);

	
	for (Food& food: FoodList)
	{
		if (food.Depth == DepthView && food.Mass>0)
		{
			drawunitf.setPosition(sf::Vector2f((float)(food.X - food.Radius),
				y2Screen - (float)(food.Y + food.Radius)));


			MainWindow.draw(drawunitf);
		}

	}
}

void GraphModule::DrawDepthVirus(std::vector<Bot>& VirusList, int)
{
	sf::Vertex VirusLine[2];
	for (Bot& bot : VirusList)
	{
		for (double angle = 0; angle < PI; angle += PI / 12)
		{
			double dx = cos(angle) * bot.Radius;
			double dy = sin(angle) * bot.Radius;

			VirusLine[0] = sf:: Vertex(sf::Vector2f((float)(bot.X - dx), y2Screen - (float)(bot.Y - dy)));
			VirusLine[1] = sf:: Vertex(sf:: Vector2f((float)(bot.X + dx), y2Screen - (float)(bot.Y + dy)));

			VirusLine[0].color =sf::Color::Black;
			VirusLine[1].color = sf::Color::Black;

			MainWindow.draw(VirusLine,2, sf::PrimitiveType::Lines);

		}
	}

}

void GraphModule::DrawFrameInfo(int Tick)
	{
		Timecount.setCharacterSize(10);
		Timecount.setFillColor(sf::Color::Cyan);
		Timecount.setString (" TickOnRound:  "+ std::to_string(Tick) + " Depth: "+ std::to_string(DepthView));
		Timecount.setPosition(sf::Vector2f(15, 7));
		MainWindow.draw(Timecount);
	}

void GraphModule::DrawGraphStatus(int Status)
{
	Timecount.setCharacterSize(25);
	Timecount.setFillColor(sf::Color::Cyan);
	Timecount.setString("Graphics is set off/ to start press G button");

    sf::Vector2f textPosition;

	std::random_device rd;  //Will be used to obtain a seed for the random number engine
	std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
	std::uniform_real_distribution<> dis(300.0, (float)ScreenWidth-300);

	textPosition.y =(ScreenHeight - 300) * ((((float)rand()) / (float)RAND_MAX)) + 300;
	textPosition.x = dis(gen);
	//textPosition.y = dis(gen);
	
	Timecount.setPosition(textPosition);
	MainWindow.draw(Timecount);
}

void GraphModule::KeyPressed(sf::Event event)
{
	if (event.key.code == sf::Keyboard::G)
	{
		if (DrawUnits == true)
			DrawUnits = false;
		else
			DrawUnits = true;
	}

	if (event.key.code == sf::Keyboard::P)
	{
		TickW = TickW + 500;
	}

	if (event.key.code == sf::Keyboard::M)
	{
		TickW = TickW - 500;
	}

	if (event.key.code == sf::Keyboard::E)
	{
		DepthView++;
		if (DepthView >MaxDepth - 1)
			DepthView = MaxDepth - 1;
	}

	if (event.key.code == sf::Keyboard::D)
	{
		DepthView--;
		if (DepthView < 0)
			DepthView = 0;
	}

	if (event.key.code == sf::Keyboard::S)
	{
		SaveDNA = true;
	}


}

void GraphModule::Clear()
{
	MainWindow.clear(sf::Color(sf::Color(75, 75, 75)));
}

void GraphModule::Display()
{
	MainWindow.display();
}

void GraphModule::Close()
{
	MainWindow.close();
}

bool GraphModule::OpenWindow()
{
	return MainWindow.isOpen();
}
