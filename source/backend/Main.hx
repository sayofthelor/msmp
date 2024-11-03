package backend;

import flixel.FlxG;
import flixel.FlxGame;
import haxe.macro.Expr.Metadata;
import lime.app.Application;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, ui.TitleScreen, 120, 120));
		addChild(new FPS(3,3, 0xffffff));
		FlxG.save.bind("jam24");
		if (FlxG.save.data.offset == null) {
			Music.offset = 0;
		}
		if (FlxG.save.data.highscores == null) {
			FlxG.save.data.highscores = ["" => 0];
		}
		Application.current.window.onClose.add(onClose);
	}

	private function onClose()
	{
		FlxG.save.close();
	}
}
