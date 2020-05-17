package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Dust extends FlxSprite
{
	public function new()
	{
		super(-1000, -1000);
		loadGraphic("assets/images/first/dust.png", true, 64, 64);

		animation.add("a1", [4, 5, 4, 3, 2, 3, 1, 0, 1, 2, 3, 2, 5, 4, 5], 15, false);
		animation.add("a2", [5, 4, 5, 2, 3, 2, 0, 1, 0, 3, 2, 3, 4, 5, 4], 15, false);
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		lifeLength = 0;
		animation.play("a" + FlxG.random.int(1, 2));
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
