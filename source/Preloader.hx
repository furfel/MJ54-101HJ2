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

	var bmpFrame:Int = 0;
	var bitmaps:Array<Bitmap> = new Array<Bitmap>();
	var bitmapClasses:Array<Class<BitmapData>> = [PreloaderBitmap2, PreloaderBitmap3, PreloaderBitmap4];
	var warning:Bitmap = null;
	var current:Bitmap = null;

	private var startTime:Float = 0.0;
	private var startTime0:Float = 0;
	private var endTime:Float = 1.0;
	private var elapsed:Float = 0.0;

	public static final MIN_TIME = 8;

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

		for (b in bitmapClasses)
		{
			var _bitmap = createBitmap(b, (bbitmap) ->
			{
				var aspect = bbitmap.width / bbitmap.height;
				bbitmap.width = Lib.current.stage.stageWidth;
				bbitmap.height = bbitmap.width / aspect;
				bbitmap.x = 0;
				bbitmap.y = Lib.current.stage.stageHeight / 2 - bbitmap.height / 2;
			});
			_bitmap.smoothing = true;
			_bitmap.alpha = 0;
			bitmaps.push(_bitmap);
		}

		startTime0 = Date.now().getTime();
		startTime = Date.now().getTime() + 2000;
		endTime = MIN_TIME * 1000;
		current = bitmaps[0];
		_buffer.addChild(warning);

		super.create();
	}

	override function destroy()
	{
		if (current != null)
			_buffer.removeChild(current);
		for (b in bitmaps)
		{
			_buffer.removeChild(b);
			removeChild(b);
			bitmaps.remove(b);
		}
		bitmaps = null;
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

		if (Date.now().getTime() < startTime)
		{
			elapsed = Date.now().getTime() - startTime0;
			var p = (Date.now().getTime() - startTime) / (startTime - startTime0);
			if (p > 0.9)
			{
				warning.alpha = Math.max(0, 1.0 - (p - 0.9) * 10);
			}
			else if (p <= 0.1)
			{
				warning.alpha = Math.min(1, p * 10);
			}
			return;
		}

		elapsed = Date.now().getTime() - startTime;
		if (bitmaps == null)
			return;
		bmpFrame = Std.int(elapsed / 150) % bitmaps.length;

		var percentTime = calculatePercentOfTime();

		_buffer.removeChild(current);
		if (bitmaps == null)
			return;
		current = bitmaps[bmpFrame];
		if (percentTime > 0.9 && current != null)
		{
			setAllAlpha(Math.max(0, 1.0 - (percentTime - 0.9) * 10));
		}
		else if (percentTime <= 0.1 && current != null)
		{
			setAllAlpha(Math.min(1, percentTime * 10));
		}
		_buffer.addChild(current);
	}

	public inline function setAllAlpha(a:Float)
		for (b in bitmaps)
			b.alpha = a;

	override function update(Percent:Float)
	{
		super.update(Percent);
	}
}
