package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearMotion;
import flixel.util.FlxColor;
import haxe.display.Display.Package;

class Player extends FlxSprite
{
	private var parent:Game1State = null;

	public function new(parent:Game1State)
	{
		super(72, 100);
		makeGraphic(128, 128, FlxColor.BLUE);
		screenCenter(Y);
		this.parent = parent;
	}

	/**
		Jumping stuff

	**/
	private var jumpTween:LinearMotion = null;

	public static final JUMPHEIGHT = 300.0;

	private function jump()
	{
		if (jumpTween != null && !jumpTween.finished)
			return;
		jumpTween = FlxTween.linearMotion(this, this.x, this.y, this.x, this.y - JUMPHEIGHT, 1.0, true, {
			ease: FlxEase.cubeIn,
			type: ONESHOT,
			onComplete: _ ->
			{
				jumpTween = FlxTween.linearMotion(this, this.x, this.y, this.x, this.y + JUMPHEIGHT, 1.0, true, {
					ease: FlxEase.cubeOut,
					type: ONESHOT,
					onComplete: _ ->
					{
						jumpTween = null;
					}
				});
			}
		});
	}

	/**

		Combat stuff

	**/
	public static final LOITER_X = 60;

	public static final LOITER_Y = 60;

	private var loiterAmnt = 7;

	private function loiter()
	{
		if (loiterAmnt > 0)
		{
			parent.doLoiter(this.x + LOITER_X, this.y + LOITER_Y);
			loiterAmnt--;
		}
	}

	private function move() {}

	private function checkKeys()
	{
		if (FlxG.keys.anyJustPressed([SPACE]))
			loiter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		checkKeys();
	}
}
