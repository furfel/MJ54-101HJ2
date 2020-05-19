package;

import flash.events.Event;
import flixel.system.FlxBasePreloader;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

@:keep @:bitmap("assets/preloader2.jpg")
private class PreloaderBitmap2 extends BitmapData {}

@:keep @:bitmap("assets/preloader3.jpg")
private class PreloaderBitmap3 extends BitmapData {}

@:keep @:bitmap("assets/preloader4.jpg")
private class PreloaderBitmap4 extends BitmapData {}

@:keep @:bitmap("assets/preloader1.jpg")
private class PreloaderWarning extends BitmapData {}

class Preloader extends FlxBasePreloader
{
	public function new()
	{
		super(MIN_TIME);
	}

	var _buffer:Sprite;

	var warning:Bitmap = null;

	private var startTime:Float = 0.0;
	private var startTime0:Float = 0;
	private var endTime:Float = 1.0;
	private var elapsed:Float = 0.0;

	public static final MIN_TIME = 12;

	override function create()
	{
		_buffer = new Sprite();
		addChild(_buffer);
		_buffer.addChild(new Bitmap(new BitmapData(1280, 720, 0x000000)));

		warning = createBitmap(PreloaderWarning, (b) ->
		{
			var aspect = b.width / b.height;
			b.width = Std.int(0.75 * Lib.current.stage.stageWidth);
			b.height = b.width / aspect;
			b.x = Lib.current.stage.stageWidth / 2 - b.width / 2;
			b.y = Lib.current.stage.stageHeight - b.height - 100;
		});
		warning.smoothing = true;
		warning.alpha = 0;

		startTime = Date.now().getTime();
		endTime = MIN_TIME * 1000;
		_buffer.addChild(warning);

		super.create();
	}

	override function destroy()
	{
		if (warning != null)
			_buffer.removeChild(warning);
		warning = null;
		if (_buffer != null)
			removeChild(_buffer);
		_buffer = null;
		super.destroy();
	}

	private inline function calculatePercentOfTime():Float
	{
		return (Date.now().getTime() - startTime) / endTime;
	}

	override function onEnterFrame(E:Event)
	{
		super.onEnterFrame(E);

		var percentTime = calculatePercentOfTime();

		if (warning == null)
			return;

		if (percentTime > 0.9 && warning != null)
		{
			warning.alpha = Math.max(0, 1.0 - (percentTime - 0.9) * 10);
		}
		else if (percentTime <= 0.1 && warning != null)
		{
			warning.alpha = Math.min(1, percentTime * 10);
		}
	}

	override function update(Percent:Float)
	{
		super.update(Percent);
	}
}
