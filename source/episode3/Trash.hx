package episode3;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Trash extends FlxSprite
{
	private var parent:Episode3State;

	public function new(X:Float, Y:Float, parent:Episode3State)
	{
		super(X, Y);

		loadGraphic("assets/images/first/trash.png", true, 48, 48);
		animation.add("a", [0, 1, 2, 3, 4], 13);
		animation.play("a");

		this.parent = parent;

		width = 32;
		height = 32;
		offset.set(8, 8);
	}

	public function throwme(aim:Aim)
	{
		var end = aim.getEndPoint();
		var diff = end.x - this.x;
		var diffy = end.y - this.y;
		new FlxTimer().start(0.85, _ ->
		{
			FlxG.sound.play("assets/sounds/trash.ogg");
		});
		FlxTween.cubicMotion(this, this.x, this.y, this.x + diff * 0.25, this.y + diffy - 100, this.x + diff * 0.75, this.y + diffy - 50, end.x, end.y, 1.0, {
			ease: FlxEase.bounceOut,
			type: ONESHOT,
			onComplete: _ -> {}
		});
	}
}
