package backend;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxSignal.FlxTypedSignal;

class Music extends FlxBasic
{
	public static var offset(default, set):Float = -120.0;

	public static function set_offset(v:Float)
	{
		FlxG.save.data.offset = v;
		FlxG.save.flush();
		return offset = v;
	}

	public var bpm(default, set):Float;
	public var beatTime(default, null):Float;
	public var stepTime(default, null):Float;

	public function set_bpm(v:Float):Float
	{
		beatTime = (60 / v) * 1000;
		stepTime = beatTime / 4;
		return bpm = v;
	}

	public var position:Float;

	public static var primary:Music;
	public static var hasPrimary:Bool = false;

	public var step:Int;
	public var stepDec:Float;
	public var beat:Int;
	public var beatDec:Float;

	public var music:FlxSound;

	public function new(musicAsset:FlxSoundAsset, ?volume:Float = 1.0, ?onEnd:Void->Void)
	{
		offset = FlxG.save.data.offset;
		if (!hasPrimary)
		{
			hasPrimary = true;
			primary = this;
		}
		super();
		trace("Loading music...");
		music = FlxG.sound.load(musicAsset, volume, false, FlxG.sound.defaultMusicGroup);
		if (onEnd != null)
			music.onComplete = onEnd;
	}

	public function play()
	{
		music?.play();
	}

	public function pause()
	{
		music?.pause();
	}

	public function resume()
	{
		music?.resume();
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		position = music.time + offset;
		var oldStep:Int = step;
		stepDec = position / stepTime;
		beatDec = stepDec / 4;
		step = Math.floor(stepDec);
		beat = Math.floor(beatDec);
		if (step != oldStep)
			stepHit();
	}

	public var onStep:FlxTypedSignal<Int->Void> = new FlxTypedSignal();
	public var onBeat:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	public function stepHit()
	{
		onStep.dispatch(step);
		if (step % 4 == 0)
			onBeat.dispatch(beat);
	}

	override function destroy()
	{
		hasPrimary = false;
		primary = null;
		super.destroy();
	}
}