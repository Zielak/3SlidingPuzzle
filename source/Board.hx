
package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxSignal;

class Board extends FlxTypedSpriteGroup<FlxSprite>
{

    public var movePiecesSignal:FlxTypedSignal<Int->Void>;

    public var pieces:Array<Piece>;
    public var sizex:Int;
    public var sizey:Int;
    public var piecesNum(get, null):Int;

    var boardCenter:FlxPoint;
    var emptyPiece:Piece;
    var emptySpace(get, null):Int;
    var emptySpaceRow(get, null):Int;
    var emptySpaceCol(get, null):Int;

    var _tweenpiece:Piece;
    var pieceTween:flixel.tweens.misc.VarTween;

    var debugBoard:FlxText;


    override public function new(options:BoardOptions):Void
    {
        super();

        pieces = new Array<Piece>();

        sizex = options.sizex;
        sizey = options.sizey;

        boardCenter = new FlxPoint();
        boardCenter.x = FlxG.width/2 - (Piece.WIDTH*(sizex))/2;
        boardCenter.y = FlxG.height/2 - (Piece.HEIGHT*(sizey))/2;


        var p:Piece;
        for(i in 0...piecesNum-1)
        {
            p = new Piece({
                number: i,
                color: FlxColorUtil.getRandomColor(100,255)
            });

            pieces.push(p);

            add(p);
        }
        emptyPiece = new Piece({
            number: -1,
            color: 0x000000
        });
        pieces.push(emptyPiece);
        updatePiecePosition();


        movePiecesSignal = new FlxTypedSignal<Int->Void>();
        movePiecesSignal.add(movePieces);

        initDebug();
    }

    function initDebug():Void
    {
        debugBoard = new FlxText(-50,-50,200);
        add(debugBoard);

        FlxG.watch.add(this, "emptySpace");
        FlxG.watch.add(this, "emptySpaceRow");
        FlxG.watch.add(this, "emptySpaceCol");
    }

    function movePieces(dir:Int):Void
    {
        // trace('move direction: ${dir}');
        if(move(dir))
        {
            traceAllPieces();
        }
    }

    function traceAllPieces():Void
    {
        var txt:String = "";
        var _x:Int = 0;
        var _y:Int = 0;

        for(i in 0 ...piecesNum)
        {
            txt += pieces[i].number+", ";

            _x ++;
            if(_x >= sizex){
                _y++;
                _x = 0;
                txt += ";\n";
            } 
        }

        txt += ";";
        debugBoard.text = txt;
    }

    function move(dir:Int):Bool
    {
        // trace('move()');
        var pieceToMove:Int;
        var tmpPiece:Piece;
        var targetSpace:Int;

        // trace('canmove? ${canMove(dir)}');

        if(canMove(dir))
        {
            pieceToMove = getPieceToMove(dir);
            tmpPiece = pieces[pieceToMove];

            // Update table positions
            targetSpace = emptySpace;
            pieces[emptySpace] = pieces[pieceToMove];
            pieces[pieceToMove] = emptyPiece;

            updatePiecePosition(pieces[emptySpace], pieceToMove, targetSpace);

            return true;
        }else{
            return false;
        }
    }


    function canMove(dir:Int):Bool
    {
        // trace('canMove()');
        // trace('emptySpaceRow - ${emptySpaceRow}');
        // trace('emptySpaceCol - ${emptySpaceCol}');

        if(dir == FlxObject.DOWN)
        {
            return (emptySpaceRow < sizey-1 );
        }
        else if(dir == FlxObject.UP)
        {
            return (emptySpaceRow > 0);
        }
        else if(dir == FlxObject.RIGHT)
        {
            return (emptySpaceCol < sizex-1);
        }
        else if(dir == FlxObject.LEFT)
        {
            return (emptySpaceCol > 0);
        }
        return false;
    }

    function getPieceToMove(dir:Int):Int
    {
        if(dir == FlxObject.DOWN)
        {
            return emptySpace + sizex;
        }
        else if(dir == FlxObject.UP)
        {
            return emptySpace - sizex;
        }
        else if(dir == FlxObject.RIGHT)
        {
            return emptySpace + 1;
        }
        else if(dir == FlxObject.LEFT)
        {
            return emptySpace - 1;
        }
        return -1;
    }


    function updatePiecePosition(?_piece:Piece = null, ?fromplace = -1, ?targetplace = -1):Void
    {
        trace('from: ${fromplace}, targetplace: ${targetplace}');
        x = boardCenter.x;
        y = boardCenter.y;

        for(i in 0...piecesNum)
        {
            // if(pieces[i] != null && pieces[i] != _piece)
            if(pieces[i] != null && i != targetplace)
            {
                pieces[i].x = Piece.WIDTH * (i % sizex) + boardCenter.x;
                pieces[i].y = Piece.HEIGHT * Math.floor( i/sizey ) + boardCenter.y;
            }
            else
            {
                trace('TWEEN: ${i}, number: ${pieces[i].number}');
                _tweenpiece = pieces[i];

                if(pieceTween!=null)pieceTween.cancel();

                pieceTween = FlxTween.tween(_tweenpiece, {
                    x: Piece.WIDTH * (targetplace % sizex) + boardCenter.x,
                    y: Piece.HEIGHT * Math.floor( targetplace/sizey ) + boardCenter.y
                }, 0.3, { ease: FlxEase.circOut });
            }
        }
    }

    public function get_emptySpace():Int
    {
        for(i in 0...pieces.length)
        {
            if(pieces[i].number == -1)
            {
                return i;
            }
        }
        return -1;
    }
    public function get_emptySpaceRow():Int
    {
        return Math.floor( emptySpace/sizey );
    }
    public function get_emptySpaceCol():Int
    {
        return emptySpace % sizex;
    }


    public function get_piecesNum():Int
    {
        return sizex * sizey;
    }

}

typedef BoardOptions = {
    var sizex:Int;
    var sizey:Int;
}
