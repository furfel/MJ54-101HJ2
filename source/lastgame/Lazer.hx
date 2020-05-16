package lastgame;

import flixel.FlxG;
import flixel.FlxSprite;

class Lazer extends FlxSprite
{
	public static final SPEED = 1500.0;

	public function new()
	{
		super(-100, -100);

		loadGraphic("assets/images/last/bullet.png", true, 140, 38);
		animation.add("fly", [0, 1, 2], 13);
		animation.play("fly");

		alive = false;
		exists = false;
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		alive = true;
		exists = true;
		velocity.set(SPEED, 0);
		animation.play("fly");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (x > FlxG.width)
		{
			alive = false;
			exists = false;
		}
	}
}
