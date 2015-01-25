
package ;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxTypedSpriteGroup;

using flixel.util.FlxSpriteUtil;

class Piece extends FlxTypedSpriteGroup<FlxSprite> 
{

    public static inline var WIDTH:Int = 40;
    public static inline var HEIGHT:Int = 40;

    @:isVar public var number(default,null):Int;
    var _color:Int;

    var text:FlxText;
    var bg:FlxSprite;

    override public function new(options:PieceOptions):Void
    {
        super();

        // trace('color: ${options.color}');
        _color = options.color;
        number = options.number;

        drawMe();
    }



    private function drawMe():Void
    {
        text = new FlxText(0,0,WIDTH, Std.string(number), 14);
        text.alignment = 'center';

        bg = new FlxSprite(0,0);
        bg.makeGraphic(WIDTH, HEIGHT, _color, true);

        add(bg);
        add(text);
    }

}

typedef PieceOptions = {
    var number:Int;
    @:optional var color:Int;
}
