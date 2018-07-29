#pragma once

struct Bot 
	{
	
		int intID;
		int fragmentId = 0;
		float X;
		float Y;

		float Xvelocity=0;
		float Yvelocity=0;

		float nXvelocity=0;
		float nYvelocity=0;

		float xPOI=0;
		float yPOI=0;

		float Radius;
		float Mass;

		float Fitness=1000;

		int TTF;

		bool Split;
		bool Eject;

		int IntType;
		int Tick=0;

		int Depth;

		int Lifetime=0;

		float angle;
		float speed;

		bool is_fast;
		int fuse_timer=0;
		
		int color;
		
		int numberofsensors;
		bool Random;
	
};
