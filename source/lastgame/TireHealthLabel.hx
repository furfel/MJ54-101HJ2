package lastgame;

import flixel.FlxSprite;

class TireHealthLabel extends FlxSprite
{
	public function new()
	{
		super(100, 12);

		loadGraphic("assets/images/last/evilspacetire.png", true, 300, 54);
		animation.add("wobble", [0, 1, 2], 13);
		animation.play("wobble");

		visible = false;
	}
}
