// ported from hjd hello CodeBG
import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;

public function CodeBG(?x:Float, ?y:Float, ?width:Float, ?height:Float, ?speed:Float, ?color:FlxColor) {
    x ??= 0; y ??= 0; width ??= 1280; height ??= 720; speed ??= 100;

    var codeBG = new FlxSpriteGroup(x, y);

    var backdrops:Array<FlxBackdrop> = [];

    final tSize:Int = 36;
    final tWidth:Int = Std.int(tSize * 0.75);

    for (i in 0...Std.int(width/tWidth)) {


        var t = new FlxText(0,0,0,FlxG.random.bool(50) ? '0' : '1',tSize);
        t.font = Paths.font('vcr.ttf');
        t.color = color ?? FlxColor.LIME;

        for (i in 0...3) {
            t.text += FlxG.random.bool(50) ? '\n0' : '\n1';
        }
        @:privateAccess t.regenGraphic();

        var s = new FlxBackdrop(t.graphic, FlxAxes.Y);
        s.x += t.width * i;
        codeBG.add(s);
        backdrops.push(s);
        if (i % 2 == 0) s.velocity.y = speed;
        else s.velocity.y = -speed;
    }

    var grad = FlxGradient.createGradientFlxSprite(1, Std.int(height), ([0x0,FlxColor.BLACK]));
	grad.scale.x = width;
	grad.updateHitbox();
	codeBG.add(grad);

    return codeBG;
}