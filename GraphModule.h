#pragma once
#include "SFML\Graphics.hpp"
#include "Bot.h"
#include "Food.h"
#include "Constant.h"
#include<random>


static class GraphModule
{
public:

	GraphModule();

	bool DrawUnits=true;
	bool SaveDNA = false;
	int DepthView=0;
	int MaxDepth = 0;
	int TickW = 2500;

	int ScreenWidth;
	int ScreenHeight;
	float x2Screen;
	float y2Screen;

	const float PI = 3.14159265358979323846f;

	sf::RenderWindow MainWindow;

	void Init(int,int,int,int);

	void DrawDepthAllBot(std::vector<Bot>&, std::vector<float>&, 
		int angleStep, int angleStepInit, int numberofSensorshalf, float);
	void DrawDepthOther(std::vector<Food>&, int);
	void DrawDepthVirus(std::vector<Bot>&, int);

	void DrawFrameInfo(int Tick);

	void DrawGraphStatus(int Status);
	void KeyPressed(sf::Event event);

	sf::Text Timecount;
	sf::Font font;


	void Clear();
	void Display();
	void Close();
	bool OpenWindow();


	std::vector<sf::Vector3f> ColorTable = {

		sf::Vector3f(0.439216,  0.858824, 0.576471),
		sf::Vector3f(0.62352 ,  0.372549, 0.623529),
		sf::Vector3f(0.647059 , 0.164706 , 0.164706),
		sf::Vector3f(0.372549 , 0.623529 , 0.623529),
		sf::Vector3f(1.0 , 0.498039 , 0.0),
		sf::Vector3f(0.258824 , 0.258824 , 0.435294),
		sf::Vector3f(0.184314 , 0.309804 , 0.184314),
		sf::Vector3f(0.309804 , 0.309804 , 0.184314),
		sf::Vector3f(0.6 , 0.196078 , 0.8),
		sf::Vector3f(0.419608 , 0.137255 , 0.556863),
		sf::Vector3f(0.184314 , 0.309804 , 0.309804),
		sf::Vector3f(0.184314 , 0.309804 , 0.309804),
		sf::Vector3f(0.439216 , 0.576471 , 0.858824),
		sf::Vector3f(0.556863 , 0.137255 , 0.137255),
		sf::Vector3f(0.137255 , 0.556863 , 0.137255),
		sf::Vector3f(0.8 , 0.498039 , 0.196078),
		sf::Vector3f(0.858824 , 0.858824 , 0.439216),
		sf::Vector3f(0.576471 , 0.858824 , 0.439216),
		sf::Vector3f(0.309804 , 0.184314 , 0.184314),
		sf::Vector3f(0.623529 , 0.623529 , 0.372549),
		sf::Vector3f(0.74902 , 0.847059 , 0.847059),
		sf::Vector3f(0.560784 , 0.560784 , 0.737255),
		sf::Vector3f(0.196078 , 0.8 , 0.196078),
		sf::Vector3f(0.556863 , 0.137255 , 0.419608),
		sf::Vector3f(0.196078 , 0.8 , 0.6),
		sf::Vector3f(0.196078 , 0.196078 , 0.8),
		sf::Vector3f(0.419608 , 0.556863 , 0.137255),
		sf::Vector3f(0.917647 , 0.917647 , 0.678431),
		sf::Vector3f(0.576471 , 0.439216 , 0.858824),
		sf::Vector3f(0.258824 , 0.435294 , 0.258824),
		sf::Vector3f(0.439216 , 0.858824 , 0.858824),
		sf::Vector3f(0.858824 , 0.439216 , 0.576471),
		sf::Vector3f(0.184314 , 0.184314 , 0.309804),
		sf::Vector3f(0.137255 , 0.137255 , 0.556863),
		sf::Vector3f(0.137255 , 0.137255 , 0.556863),
		sf::Vector3f(0.858824 , 0.439216 , 0.858824),
		sf::Vector3f(0.560784 , 0.737255 , 0.560784),
		sf::Vector3f(0.737255 , 0.560784 , 0.560784),
		sf::Vector3f(0.917647 , 0.678431 , 0.917647),
		sf::Vector3f(0.435294 , 0.258824 , 0.258824),
		sf::Vector3f(0.137255 , 0.556863 , 0.419608),
		sf::Vector3f(0.556863 , 0.419608 , 0.137255),
		sf::Vector3f(0.196078 , 0.6 , 0.8),
		sf::Vector3f(0.137255 , 0.419608 , 0.556863),
		sf::Vector3f(0.858824 , 0.576471 , 0.439216),
		sf::Vector3f(0.847059 , 0.74902 , 0.847059),
		sf::Vector3f(0.678431 , 0.917647 , 0.917647),
		sf::Vector3f(.309804 , 0.184314 , 0.309804),
		sf::Vector3f(0.8 , 0.196078 , 0.6),
		sf::Vector3f(0.847059 , 0.847059 , 0.74902),
		sf::Vector3f(0.6 , 0.8 , 0.196078),
		sf::Vector3f(0.22 , 0.69 , 0.87),
		sf::Vector3f(0.35 , 0.35 , 0.67),
		sf::Vector3f(0.71 , 0.65 , 0.26),
		sf::Vector3f(0.72 , 0.45 , 0.20),
		sf::Vector3f(0.55 , 0.47 , 0.14),
		sf::Vector3f(0.65 , 0.49 , 0.24),
		sf::Vector3f(0.90 , 0.91 , 0.98),
		sf::Vector3f(0.85 , 0.85 , 0.10),
		sf::Vector3f(0.81 , 0.71 , 0.23),
		sf::Vector3f(0.82 , 0.57 , 0.46),
		sf::Vector3f(0.85 , 0.85 , 0.95),
		sf::Vector3f(1.00 , 0.43 , 0.78),
		sf::Vector3f(0.53 , 0.12 , 0.47),
		sf::Vector3f(0.30 , 0.30 , 1.00),
		sf::Vector3f(0.85 , 0.53 , 0.10),
		sf::Vector3f(0.89 , 0.47 , 0.20),
		sf::Vector3f(0.91 , 0.76 , 0.65),
		sf::Vector3f(0.65 , 0.50 , 0.39),
		sf::Vector3f(0.52 , 0.37 , 0.26),
		sf::Vector3f(1.00 , 0.11 , 0.68),
		sf::Vector3f(0.42 , 0.26 , 0.15),
		sf::Vector3f(0.36 , 0.20 , 0.09) };
};
