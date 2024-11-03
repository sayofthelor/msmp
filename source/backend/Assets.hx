package backend;

class Assets
{
	public static inline final EXT = ".ogg";

	public static final getText:String->String = #if !web sys.io.File.getContent #else openfl.Assets.getText #end;

	public static function json(name:String, ?diff:String = "normal"):String
	{
		return getText('assets/${name}/${diff}.json');
	}

	public static function hxs(name:String)
	{
		return 'assets/${name}/script.hxs';
	}

	public static function song(name:String):String
	{
		return 'assets/songs/${name}/song${EXT}';
	}

	public static function sound(name:String):String
	{
		return 'assets/sounds/${name}${EXT}';
	}

	public static function font(name:String):String
	{
		return 'assets/fonts/${name}.ttf';
	}

	public static function image(name:String):String
	{
		return 'assets/images/${name}.png';
	}
}