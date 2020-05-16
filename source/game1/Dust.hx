package game1;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Dust extends FlxSprite
{
	public function new()
	{
		super(-1000, -1000);
		makeGraphic(48, 48, FlxColor.GRAY);
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		lifeLength = 0;
	}

	private var lifeLength = 0.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (lifeLength > 1.0)
			kill();

		lifeLength += elapsed;
	}
}
