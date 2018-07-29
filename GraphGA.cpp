#include "GraphGA.h"

GraphGA::GraphGA() = default; 

void GraphGA::Init(int vxscreen, int vyscreen, int xscreen, int yscreen, int _depth)
{
	Depth = _depth;
	int x_init_start =xscreen;
	int y_init_start = yscreen;

	x_init = xscreen;
	y_init = yscreen;


	ViewGAWindow.create(sf::VideoMode(x_init_start, y_init_start), "GA view");
	ViewGAWindow.setPosition(sf::Vector2i(750, 350));
	ViewGAWindow.clear(sf::Color(sf::Color(75, 75, 75)));

	GraphView.setSize((float)vxscreen, (float)vyscreen);
	GraphView.setViewport(sf:: FloatRect(0, 0, 1.f, 1.f));
	GraphView.setCenter(sf:: Vector2f(vxscreen / 2, vyscreen / 2));

	ViewGAWindow.setView(GraphView);
	font.loadFromFile("arial.ttf");
	Timecount.setFont(font);

	ViewGAWindow.clear(sf::Color(sf::Color(75, 75, 75)));
	ViewGAWindow.display();
}

void GraphGA::GAtoPictiteAll(std::vector<Bot>& BotList, std::vector<float>& rnnNNWeights, std::vector<float>& rnnMNWeights, float screencoeff,
	int numberOfGens, int BotPopulation,int Generation, int TopologySize, int ArrayDim, 
	std::vector<int>& Topology, std::vector<int>& TopologyRNN )
{
	
	Timecount.setCharacterSize(10);
	Timecount.setFillColor(sf::Color::Cyan);
	Timecount.setPosition(sf::Vector2f(25, 25));

	sf::Vertex GASquare[4];
	int xline = 0;
	int yline = 0;
	int xlinestep = 0;
	int ylinestep = 0;
	int xinit = 75;
	int yinit = 70;

	int xstep = (int)(5 / screencoeff);
	int ystep = (int)(2 / screencoeff);
	int genWidth = (int)(1 / screencoeff);
	int genHeight = (int)(3 / screencoeff);
	int layerDistance = (int)(25 / screencoeff);
	int fontSize = 8;
	int gencnt = 0;

	int smart_Depth = Depth;
	if (Depth>9)
	{
		smart_Depth = 1;
	}

	for (int d = 0; d < smart_Depth; d++)
	{
		
		Timecount.setCharacterSize(12);
		Timecount.setString("Generation    " + std::to_string(Generation) + "    Depth   " + std::to_string(d));
		Timecount.setPosition(sf::Vector2f((float)(25), (float)(15 + yinit + yline * genHeight + genHeight + ylinestep)));
		ViewGAWindow.setView(GraphView);
		ViewGAWindow.draw(Timecount);

		Timecount.setString ("Number of Gens          " + std::to_string(numberOfGens));
		Timecount.setPosition(sf::Vector2f((float)(25), (float)(27 + yinit + yline * genHeight + genHeight + ylinestep)));
		ViewGAWindow.setView(GraphView);
		ViewGAWindow.draw(Timecount);

		Timecount.setString ("Number of Population    " + std::to_string(BotPopulation));
		Timecount.setPosition(sf::Vector2f((float)(25), (float)(39 + yinit + yline * genHeight + genHeight + ylinestep)));
		ViewGAWindow.setView(GraphView);
		ViewGAWindow.draw(Timecount);

		ylinestep += yinit;
		Timecount.setCharacterSize(10);

	
		int pop_show = 0;
		for (auto bot : BotList)
		{
		  if (bot.intID > 150)
		     break;
			std::vector<float> botDNA;
			
			int k = 0;
			for (int layerT = 0; layerT < TopologySize - 1; layerT++)
			{
				for (int it = 0; it < Topology[layerT] + 1; it++)
				{
					for (int jt = 0; jt < Topology[layerT + 1]; jt++)
					{
						botDNA.push_back(rnnNNWeights[((bot.intID*TopologySize + layerT)*ArrayDim + it)*ArrayDim + jt]);
						
					}

				}

			}
			k = 0;
			for (int layerR = 0; layerR < TopologySize - 1; layerR++)
			{
				for (int ir = 0; ir < TopologyRNN[layerR] + 1; ir++)
				{
					for (int jr = 0; jr < TopologyRNN[layerR]; jr++)
					{
						botDNA.push_back(rnnMNWeights[((bot.intID*TopologySize + layerR)*ArrayDim + ir)*ArrayDim + jr]);
						k++;
					}



				}
			}
		

			if (pop_show < 300)
			{
				for (auto& gen : botDNA)
				{
					GASquare[0] = sf::Vertex(sf::Vector2f((float)(xinit + xline * genWidth),
						(float)(yinit + yline * genHeight + ylinestep)));
					GASquare[1] = sf::Vertex(sf::Vector2f((float)(xinit + xline * genWidth + genWidth),
						(float)(yinit + yline * genHeight + ylinestep)));
					GASquare[2] = sf::Vertex(sf::Vector2f((float)(xinit + xline * genWidth + genWidth),
						(float)(yinit + yline * genHeight + genHeight + ylinestep)));
					GASquare[3] = sf::Vertex(sf::Vector2f((float)(xinit + xline * genWidth),
						(float)(yinit + yline * genHeight + genHeight + ylinestep)));

					if (gen < 0)
					{
						GASquare[0].color = sf::Color(fabs(gen * 250), (25), (25));
						GASquare[1].color = sf::Color(fabs(gen * 250), (25), (25));
						GASquare[2].color = sf::Color(fabs(gen * 250), (25), (25));
						GASquare[3].color = sf::Color(fabs(gen * 250), (25), (25));
					}
					else
					{
						GASquare[0].color = sf::Color((25), fabs(gen * 250), (25));
						GASquare[1].color = sf::Color((25), fabs(gen * 250), (25));
						GASquare[2].color = sf::Color((25), fabs(gen * 250), (25));
						GASquare[3].color = sf::Color((25), fabs(gen * 250), (25));
					}
					/*
					if (gen < 0)
					{
					GASquare[0].Color = new Color(Color.Red);
					GASquare[1].Color = new Color(Color.Red);
					GASquare[2].Color = new Color(Color.Red);
					GASquare[3].Color = new Color(Color.Red);
					}
					else
					{
					GASquare[0].Color = new Color(Color.Green);
					GASquare[1].Color = new Color(Color.Green);
					GASquare[2].Color = new Color(Color.Green);
					GASquare[3].Color = new Color(Color.Green);
					}
					*/
					ViewGAWindow.setView(GraphView);
					ViewGAWindow.draw(GASquare, 4, sf::PrimitiveType::Quads);

					xline++;

				}
				gencnt++;
				//  Timecount.DisplayedString = "Gen " + gencnt.ToString();
				//   Timecount.Position = new Vector2f((float)(xinit - 55), (float)(yinit + yline * genHeight+ ylinestep-3));
				//   ClientViewWindow.Draw(Timecount);

				xline = 0;
				yline += 1;
				ylinestep += ystep;
			}
		 pop_show++;
		}
	}


}




void GraphGA::Clear()
{
	ViewGAWindow.clear(sf::Color(sf::Color(75, 75, 75)));
}

void GraphGA::Display()
{
	ViewGAWindow.display();
}

void GraphGA::Close()
{
	ViewGAWindow.close();
}

bool GraphGA::OpenWindow()
{
	return ViewGAWindow.isOpen();
}

