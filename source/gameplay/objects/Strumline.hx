package gameplay.objects;

import backend.Music;
import backend.Parser.Note;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import lime.app.Application;
import lime.ui.KeyCode;

class Strumline extends FlxTypedSpriteGroup<Strum>
{
	public var robot:Bool;
	public var pressed:Array<Bool> = [false, false];

	public static final keybinds:Array<KeyCode> = [F, J];

	inline static final SPACING:Float = 10;

	private var _noteIndex:Int = 0;

	public var sideNotes:Array<Note> = [];
	public var displayNotes:FlxTypedGroup<NoteSprite> = new FlxTypedGroup();

	public override function set_x(v:Float)
	{
		for (i in 0...2)
		{
			var s = strums[i];
			if (s != null)
			{
				if (i == 0)
					strums[i].x = v - strums[i].width - (SPACING / 2);
				else
					strums[i].x = v + (SPACING / 2);
			}
		}
		return x = super.set_x(v);
	}

	public var strums:Array<Strum> = [];

	public function new(x:Float, ?robot:Bool = false)
	{
		this.robot = robot;
		if (!robot)
		{
			Application.current.window.onKeyDown.add(keyDown);
			Application.current.window.onKeyUp.add(keyUp);
		}
		super(x, 0);
	}

	public function addStrums()
	{
		for (i in 0...2)
		{
			var s = new Strum(this);
			strums.push(s);
			add(s);
		}
		x = x;
		displayNotes.camera = PlayState.current.hud;
		PlayState.current.add(displayNotes);
	}

	private function keyDown(key:KeyCode, _)
	{
		var index:Int = -1;
		for (i in 0...keybinds.length)
		{
			if (keybinds[i] == key)
			{
				index = i;
				break;
			}
		}
		if (index == -1 || pressed[index] || robot)
			return;
		pressed[index] = true;
		strums[index].onPress();
		PlayState.current.player.pressButton(index == 1);

		var canHit = displayNotes.members.filter((n) ->
		{
			n != null
			&& n.id == index
			&& Math.abs(Music.primary.position - n.time) < 165;
		});

		if (canHit.length > 0)
		{
			canHit.sort((a, b) -> Std.int(a.time - b.time));
			var toRemove = canHit.filter((n) -> Math.abs(canHit[0].time - n.time) < 5);
			for (n in toRemove)
			{
				PlayState.current.hitNote(Math.abs(Music.primary.position - n.time));
				n.destroy();
				displayNotes.remove(n);
			}
		}
	}

	private function keyUp(key:KeyCode, _)
	{
		var index:Int = -1;
		for (i in 0...keybinds.length)
		{
			if (keybinds[i] == key)
			{
				index = i;
				break;
			}
		}
		if (index == -1 || !pressed[index] || robot)
			return;
		pressed[index] = false;
		strums[index].onRelease();
		PlayState.current.player.releaseButton(index == 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		while (_noteIndex < sideNotes.length
			&& sideNotes[_noteIndex] != null
			&& sideNotes[_noteIndex].time - Music.primary.position < (1500 / PlayState.current.chart.scrollSpeed))
		{
			var noteData = sideNotes[_noteIndex];
			var note = new NoteSprite(noteData.id, noteData.time, robot);
			displayNotes.add(note);
			_noteIndex++;
		}

		if (robot)
		{
			var canHit = displayNotes.members.filter((n) ->
			{
				n != null
				&& Music.primary.position - n.time >= 0;
			});
			for (n in canHit)
			{
				n.destroy();
				displayNotes.remove(n);
				PlayState.current.opponent.pressButton(n.id == 1);
				strums[n.id].scale.set(0.9, 0.9);
			}
		}
	}

	public function onRobotStep(step:Int)
	{
		for (i in 0...2)
		{
			if (strums[i].scale.x <= 0.95)
			{
				strums[i].scale.set(1, 1);
			}
		}
	}

	override public function destroy()
	{
		while (members.length != 0)
		{
			members.pop().destroy();
		}
		if (!robot)
		{
			Application.current.window.onKeyDown.remove(keyDown);
			Application.current.window.onKeyUp.remove(keyUp);
		}
		super.destroy();
	}
}