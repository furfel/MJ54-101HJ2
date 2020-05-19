package episode3;

import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Aim extends FlxSprite
{
	public static final WIDTH = 700;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		loadGraphic("assets/images/ep3/aim.png", true, WIDTH, 32);
		animation.add("a", [0, 1, 2], 13);
		animation.play("a");

		origin.x = 0;
		alpha = 0.8;
	}

	public function getEndPoint():FlxPoint
	{
		return new FlxPoint(this.x + FlxMath.fastCos(FlxAngle.asRadians(angle)) * WIDTH, this.y + FlxMath.fastSin(FlxAngle.asRadians(angle)) * WIDTH);
	}

	private var backwards = false;
	private var move = true;

	public function stop()
	{
		move = false;
		FlxTween.tween(this, {alpha: 0}, 0.3);
	}

	public function isMoving():Bool
		return move;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!move)
			return;

		if (backwards)
		{
			if (angle > -30)
				angle -= elapsed * 240;
			else
				backwards = false;
		}
		else
		{
			if (angle < 30)
				angle += elapsed * 240;
			else
				backwards = true;
		}
	}
}
