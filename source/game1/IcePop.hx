package game1;

import flixel.FlxG;
import flixel.FlxSprite;

class IcePop extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/first/icepop.png", true, 128, 147);
		animation.add("a", [0, 1, 2], 13);
		kill();
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		alive = true;
		exists = true;
		animation.play("a");
		this.x = FlxG.random.float(0, FlxG.width - this.width);
		this.y = FlxG.random.float(-this.height * 1.5, -this.height);
		velocity.y = IceCreamCone.Vel;
		acceleration.y = IceCreamCone.Acell * 2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (this.y > FlxG.height)
			kill();
	}
}
