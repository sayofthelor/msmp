package gameplay;

import backend.Assets;
import backend.Music;
import backend.Parser;
import backend.Script;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;
import gameplay.objects.PlayerSprites;
import gameplay.objects.Strumline;
import ui.TitleScreen;

class PlayState extends FlxState
{
	public static var current(default, null):PlayState;
	public var chart:Chart;
	public var playerSide:Strumline;
	public var opponentSide:Strumline;
	public var script:Script;
	public var score:Int = 0;
	public var scoreText:FlxText;
	public var scoreAddText:FlxText;
	public var timeText:FlxText;
	public var hud:FlxCamera;
	public var timeBar:FlxBar;

	private var songToLoad:String;

	override public function new(song:String) {
		super();
		songToLoad = song;
	}
	public var player:PlayerSprites;
	public var opponent:PlayerSprites;
	override public function create()
	{
		super.create();
		FlxG.camera.bgColor = 0xffef89b8;
		current = this;
		hud = new FlxCamera();
		hud.bgColor = 0;
		FlxG.cameras.add(hud, true);
		opponentSide = new Strumline((FlxG.width * 1 / 3) + 25, true);
		playerSide = new Strumline((FlxG.width * 2 / 3) - 25);
		opponentSide.camera = hud;
		playerSide.camera = hud;
		opponentSide.alpha = playerSide.alpha = 0.8;
		opponent = new PlayerSprites(true);
		add(opponent);
		player = new PlayerSprites();
		add(player);
		add(opponentSide);
		add(playerSide);
		opponentSide.addStrums();
		playerSide.addStrums();
		chart = Parser.parseChart(songToLoad, "normal");
		add(new Music(Assets.song(songToLoad), 1, () -> FlxG.switchState(ui.TitleScreen.new)));
		script = new Script('songs/$songToLoad');
		script.call("onCreate");
		Music.primary.bpm = chart.bpm;
		Music.primary.onBeat.add(onBeat);
		Music.primary.onStep.add(onStep);
		Music.primary.onStep.add(player.onStep);
		Music.primary.onStep.add(opponent.onStep);
		Music.primary.onStep.add(opponentSide.onRobotStep);
		for (note in chart.notes) {
			if (note.mustPress) {
				playerSide.sideNotes.push(Reflect.copy(note));
			} else {
				opponentSide.sideNotes.push(Reflect.copy(note));
			}
		}

		for (line in [playerSide, opponentSide]) {
			line.sideNotes.sort((a, b) -> Std.int(a.time - b.time));
		}
		scoreAddText = new FlxText(0, 0, 0, "").setFormat(Assets.font("Daydream"), 24, CENTER);
		add(scoreAddText);
		timeText = new FlxText(0, 16, FlxG.width, '0:00 / ${FlxStringUtil.formatTime(Music.primary.music.length / 1000)}').setFormat(Assets.font("Daydream"), 32, CENTER);
		timeText.camera = hud;
		add(timeText);
		timeBar = new FlxBar(0, 0, 1000, 16, Music.primary, "position", 0, Music.primary.music.length);
		timeBar.createFilledBar(0xffAA336A, 0xffeeeeee, true, 0xffeeeeee);
		timeBar.screenCenter(X);
		timeBar.numDivisions = 1000;
		timeBar.y = timeText.y + timeText.height + 16;
		timeBar.camera = hud;
		add(timeBar);
		scoreText = new FlxText(0, 0, FlxG.width, "score: 0").setFormat(Assets.font("Daydream"), 24, CENTER);
		scoreText.y = timeBar.y + timeBar.height + 16;
		scoreText.camera = hud;
		add(scoreText);
		Music.primary.play();
		add({
			var t = new FlxText(16, 16, 0, "esc to exit").setFormat(Assets.font("Daydream"), 16, 0xffeeeeee);
			FlxTween.tween(t, {alpha: 0}, Music.primary.beatTime / 500, {startDelay: Music.primary.beatTime / 500, onComplete: (_) -> {
				remove(t).destroy();
			}});
			t;
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		script.call("onUpdate", [elapsed]);
		timeText.text = '${FlxStringUtil.formatTime(Music.primary.position / 1000)} / ${FlxStringUtil.formatTime(Music.primary.music.length / 1000)}';
		if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(TitleScreen.new);
	}


	var scoreTween:FlxTween;
	var scoreTween2:FlxTween;
	public function hitNote(zone:Float) {
		if (scoreTween != null) {
			scoreTween.cancel();
			scoreTween = null;
		}
		if (scoreTween2 != null) {
			scoreTween2.cancel();
			scoreTween2 = null;
		}
		var name:String;
		var s:Int;
		if (zone <= 45) {
			score += (s = 50);
			name = "yay";
		} else if (zone <= 90) {
			score += (s = 35);
			name = "good";
		} else if (zone <= 120) {
			score += (s = 20);
			name = "okay";
		} else {
			score += (s = 5);
			name = "bad";
		}
		scoreText.text = 'score: $score';
		scoreAddText.text = '$name +$s';
		scoreAddText.scale.set(1.1,1.1);
		scoreAddText.alpha = 1;
		scoreAddText.x = (FlxG.width * 2 / 3) - 25 - (scoreAddText.width / 2);
		scoreAddText.y = (playerSide.members[0].y + playerSide.members[0].height + 8);
		scoreTween2 = FlxTween.tween(scoreAddText, {"scale.x":1,"scale.y":1}, 0.25, {ease:FlxEase.quintOut, onComplete: (_) -> {
			scoreTween2 = null;
		}});
		scoreTween = FlxTween.tween(scoreAddText, {alpha: 0, "scale.x": 0.8, "scale.y": 0.8}, .5, {ease: FlxEase.quintOut, startDelay: 0.5, onComplete: (_) -> {
			scoreTween = null;
		}});
	}

	public function onStep(step:Int) {
		script.call("onStep", [step]);
	}

	public function onBeat(beat:Int) {
		script.call("onBeat", [beat]);
	}

	override function destroy() {
		playerSide.destroy();
		opponentSide.destroy();
		script = null;
		scoreText.destroy();
		scoreAddText.destroy();
		timeText.destroy();
		Music.primary.destroy();
		super.destroy();
	}
}
