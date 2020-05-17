package game1;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.*;
import flixel.util.FlxColor;

class Loiter extends FlxSprite
{
	public static final FALLDOWN = 240.0;
	public static final THROW = 100.0;

	private var parent:Game1State = null;

	public function new(parent:Game1State)
	{
		super(-1000, -1000);

		loadGraphic("assets/images/first/trash.png", true, 48, 48);
		animation.add("a", [0, 1, 2, 3, 4], 13);

		alive = false;
		exists = false;
		this.parent = parent;
	}

	override function reset(X:Float, Y:Float)
	{
		if (tween != null && !tween.finished)
			return;

		super.reset(X, Y);
		alive = true;
		exists = true;

		animation.play("a");
		FlxG.sound.play("assets/sounds/trash.ogg");

		tween = FlxTween.linearMotion(this, this.x, this.y, this.x, this.y + FALLDOWN, 1.0, {
			ease: FlxEase.bounceOut,
			type: ONESHOT,
			onComplete: _ ->
			{
				parent.stampede();
				tween = FlxTween.linearMotion(this, this.x, this.y, this.x, FlxG.height + this.height, 0.8, true, {
					ease: FlxEase.circOut,
					type: ONESHOT,
					onComplete: _ ->
					{
						tween = null;
						kill();
					}
				});
			}
		});
	}

	private var tween:Motion = null;
}
