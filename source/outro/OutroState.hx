package outro;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class OutroState extends FlxState
{
	override function create()
	{
		super.create();

		bgColor = FlxColor.BLACK;

		var gz = new FlxSprite(FlxG.width / 2 - 541 / 2, FlxG.height / 2 - 98 / 2).loadGraphic("assets/images/congratz.png", true, 541, 98);
		gz.animation.add("a", [0, 1, 2], 13);
		gz.animation.play("a");
		add(gz);

		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
	}
}
