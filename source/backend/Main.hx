package backend;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.system.FlxSplash;
import haxe.macro.Expr.Metadata;
import lime.app.Application;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxSplash.muted = true;
		addChild(new FlxGame(0, 0, ui.TitleScreen, 120, 120));
		FlxG.save.bind("jam24");
		if (FlxG.save.data.offset == null) {
			Music.offset = 0;
		}
		if (FlxG.save.data.highscoreTutorial == null)
			FlxG.save.data.highscoreTutorial = 0;
		if (FlxG.save.data.highscoreRadioactive == null)
			FlxG.save.data.highscoreRadioactive = 0;
		Application.current.window.onClose.add(onClose);
	}

	private function onClose()
	{
		FlxG.save.close();
	}
}
