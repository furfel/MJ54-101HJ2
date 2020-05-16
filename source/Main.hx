package;

import flixel.FlxGame;
import intro.IntroState;
import lastgame.LastState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, IntroState, true));
	}
}
