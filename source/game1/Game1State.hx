package game1;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lastgame.Episode2State;

class Game1State extends FlxState
{
	private var sign:FlxSprite;
	private var loiter:Loiter;
	private var bearStampede:BearStampede;
	private var player:Player;
	private var evilIceCreamStand:EvilIceCreamStand;

	private var cones = new FlxTypedGroup<IceCreamCone>(20);
	private var backcones = new FlxTypedGroup<IceCreamCone>(20);
	private var icepops = new FlxTypedGroup<IcePop>(5);

	private var standHealthBar:StandHealthBar;

	private var loiterIndicator:FlxSprite;

	override function create()
	{
		super.create();

		this.bgColor = FlxColor.WHITE;

		add(backcones);
		create_sign();
		add(evilIceCreamStand = new EvilIceCreamStand(FlxG.width - 320, FlxG.height / 2 - 256.0, this));
		create_cones();
		add(bearStampede = new BearStampede());
		add(player = new Player(this));
		add(loiter = new Loiter(this));

		add(standHealthBar = new StandHealthBar());

		add(loiterIndicator = new FlxSprite(32, 32).loadGraphic("assets/images/indicator.png", true, 144, 144));
		loiterIndicator.animation.add("no", [0], 1);
		loiterIndicator.animation.add("yes", [1], 1);

		FlxG.camera.fade(FlxColor.WHITE, 0.6, true, throwFirstCone);
	}

	public function doLoiter(x:Float, y:Float)
	{
		if (!loiter.alive)
			loiter.reset(x, y);
	}

	public function stampede()
	{
		bearStampede.startStampede(player.x);
	}

	private function create_sign()
	{
		sign = new FlxSprite(FlxG.width / 2, FlxG.height / 2 - 100).loadGraphic("assets/images/first/loitersign.png", true, 300, Std.int(498 / 3));
		sign.animation.add("a", [0, 1, 2], 13);
		sign.animation.play("a");
		add(sign);
	}

	private function create_cones()
	{
		for (_ in 0...19)
		{
			backcones.add(new IceCreamCone(-1000, -1000, this, true));
			cones.add(new IceCreamCone(-1000, -1000, this, false));
		}

		for (_ in 0...4)
			icepops.add(new IcePop(-1000, -1000));

		add(cones);
		add(icepops);
	}

	public function getCone():IceCreamCone
		return backcones.getFirstAvailable();

	public function getDownCone():IceCreamCone
		return cones.getFirstAvailable();

	public function getIcePop():IcePop
		return icepops.getFirstAvailable();

	private function throwFirstCone()
	{
		standHealthBar.visible = true;
		new FlxTimer().start(0.8, _ -> evilIceCreamStand.throwCone());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		bearStampede.collideWithIceCreamStand(evilIceCreamStand);
		standHealthBar.setHealth(evilIceCreamStand.health, 100.0);
		if (evilIceCreamStand.health <= 0)
		{
			nextStage();
		}

		var gover = false;
		cones.forEachAlive(c ->
		{
			if (!gover && c.collide(player.getHitbox()))
			{
				gover = true;
				player.kill();
			}
		});

		FlxG.overlap(player, icepops, (p, i) ->
		{
			if ((p is Player) && (i is IcePop) && i.alive)
			{
				cast(i, IcePop).kill();
				cast(p, Player).addLoiter();
				FlxG.sound.play("assets/sounds/icepop.ogg");
			}
		});

		if (player.hasLoiter())
			loiterIndicator.animation.play("yes");
		else
			loiterIndicator.animation.play("no");
	}

	var overSoundPlayed = false;

	public function gameover()
	{
		if (!overSoundPlayed)
		{
			FlxG.sound.play("assets/sounds/over.ogg");
			overSoundPlayed = true;
		}
		FlxG.camera.fade(FlxColor.WHITE, 0.5, false, () -> FlxG.switchState(new Game1State()), true);
	}

	override function destroy()
	{
		super.destroy();

		if (player != null)
		{
			remove(player);
			player = null;
		}

		if (evilIceCreamStand != null)
		{
			remove(evilIceCreamStand);
			evilIceCreamStand = null;
		}

		if (bearStampede != null)
		{
			remove(bearStampede);
			bearStampede = null;
		}

		if (loiter != null)
		{
			remove(loiter);
			loiter = null;
		}
	}

	private function nextStage()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.4, () ->
		{
			FlxG.switchState(new Episode2State());
		});
	}
}
