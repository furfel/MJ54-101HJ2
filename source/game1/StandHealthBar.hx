package game1;

import flixel.FlxG;
import flixel.FlxSprite;

class StandHealthBar extends FlxSprite
{
	public function new()
	{
		super(300, 42);
		loadGraphic("assets/images/first/healthbar.png", true, 500, 52);

		/*label.x = FlxG.width / 2 - (label.width + this.width + 24) / 2;
			this.x = label.x + label.width + 24;
			this.y = label.y + label.height / 2 - this.height / 2; */

		screenCenter(X);

		animation.add("wobble", [0, 1, 2], 13);
		animation.play("wobble");

		scale.set(1, 1);
		origin.x = 0;
		visible = false;
	}

	public function setHealth(current:Float, max:Float)
	{
		scale.set(current / max, 1);
	}
}
