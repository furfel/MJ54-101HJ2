package outro;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class OutroState extends FlxState
{
	override function create()
	{
		super.create();
		FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
	}
}
