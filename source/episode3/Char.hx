package episode3;

import flixel.FlxSprite;

class Char extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/ep3/throwingchar.png", true, 192, 238);
		animation.add("stand", [0, 1, 2], 13);
		animation.add("throw", [2, 3, 4, 5, 6], 13, false);
		animation.play("stand");
	}

	public function throwtrash()
	{
		animation.play("throw");
	}
}
