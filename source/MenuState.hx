package;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{

	var welcomeText:FlxText;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		welcomeText = new FlxText(0, FlxG.height
			/2, FlxG.width);
		welcomeText.alignment = 'center';
		welcomeText.size = 16;
		welcomeText.text = "SlidePuzzle prototype...\n\n\nPress ENTER to start";

		add(welcomeText);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if(FlxG.keys.anyJustPressed(["ENTER"]))
		{
			FlxG.switchState(new PlayState());
		}
	}	
}