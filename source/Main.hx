package;

import flixel.FlxGame;
import game1.Game1State;
import intro.IntroState;
import lastgame.LastState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, Game1State, true));
	}
}
