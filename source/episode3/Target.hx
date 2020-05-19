package episode3;

import flixel.FlxSprite;

class Target extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		loadGraphic("assets/images/ep3/target.png", true, 240, 153);

		animation.add("a", [0, 1, 2], 13);
		animation.play("a");

		width = 200;
		height = 118;
		offset.set(20, 20);
	}
}
