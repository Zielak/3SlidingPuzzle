package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSignal;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{


	var board:Board;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		board = new Board({
			sizex: 4,
			sizey: 4
		});

		add(board);
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

		if(FlxG.keys.anyJustPressed(["R"]))
		{
			FlxG.resetState();
		}

		if(FlxG.keys.justPressed.UP){
			board.movePiecesSignal.dispatch(FlxObject.UP);
		} else if(FlxG.keys.justPressed.DOWN){
			board.movePiecesSignal.dispatch(FlxObject.DOWN);
		} else if(FlxG.keys.justPressed.LEFT){
			board.movePiecesSignal.dispatch(FlxObject.LEFT);
		} else if(FlxG.keys.justPressed.RIGHT){
			board.movePiecesSignal.dispatch(FlxObject.RIGHT);
		}
	}
}
