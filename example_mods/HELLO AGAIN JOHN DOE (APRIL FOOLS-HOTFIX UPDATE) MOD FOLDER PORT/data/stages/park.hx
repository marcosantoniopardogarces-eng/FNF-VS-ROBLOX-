import flixel.util.FlxGradient;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var darkenTween:FlxTween;
var isItDark = false;

function darkenIt() {
    if (darkenTween != null) darkenTween.cancel();
    darkenTween = FlxTween.num(20, 0, isItDark ? 0.5 : 0.75, {ease: FlxEase.circOut}, function(num) {
        park.color = parkBoilayer.color = strumLines.members[2].characters[1].color = CoolUtil.lerpColor(isItDark ? 0xFF333355 : 0xFFFFFFFF, isItDark ? 0xFFFFFFFF : 0xFF333355, Math.floor(num)/20);
    });
    isItDark = !isItDark;
}

function postCreate() {
    beautiful = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0x77FFB2B2, 0x77FF72B2, 0x00FFFFFF], 10);
    beautiful.blend = BlendMode.ADD;
    beautiful.camera = camHUD;
    beautiful.alpha = 0;
    insert(0, beautiful);

    floweres = new FlxGroup();
    //add(floweres);

    for (i in 0...2) {
        flowers = new FlxBackdrop(Paths.image(i == 0 ? "stages/plan-b/flowers1" : "stages/plan-b/flowers2"));
        flowers.scale.set(1.75, 1.75);
        flowers.updateHitbox();
        flowers.velocity.set(-100, 100);
        flowers.alpha = 0;
        flowers.scrollFactor.set(1.25, 1.25);
        floweres.add(flowers);
        add(flowers);
    }
    floweres.members[1].visible = false;
    floweres.members[1].setPosition(-10, 10);

    moment = new FlxGroup();
    add(moment);

    for (i in 0...2) {
        var momento = new FlxText();
        momento.text = i == 0 ? "Beautiful moment." : "~タマを引っ掻いてる~";
        momento.color = 0xFF77FFFF;
        momento.blend = BlendMode.ADD;
        momento.font = Paths.font(i == 0 ? "DroidSerif-Italic.ttf" : "NotoSansJP.ttf");
        momento.size = i == 0 ? 30 : 15;
        momento.scale.set(3, 3);
        momento.screenCenter();
        if (i == 1) momento.y += downscroll ? -75 : 75;
        momento.camera = camHUD;
        momento.alpha = 0;
        moment.add(momento);
    }
}

function beatHit() {
    for (flowers in floweres.members) {
        flowers.visible = !flowers.visible;
    }
}

function beautifulMoment() {
    FlxTween.num(0, 20, 3, {ease: FlxEase.circOut}, function(num) {
        beautiful.alpha = Math.floor(num)/20;
    });
    FlxTween.num(0, 10, 4, {}, function(num) {
        for (flowers in floweres.members) flowers.alpha = Math.floor(num)/20;
    });
    new FlxTimer().start(2, {
        FlxTween.num(0, 20, 3, {ease: FlxEase.circOut, onComplete: function() {
            FlxTween.num(20, 0, 2, {}, function(num) {
                moment.members[0].alpha = moment.members[1].alpha = Math.floor(num)/20;
            });
        }}, function(num) {
            moment.members[0].alpha = moment.members[1].alpha = Math.floor(num)/20;
        });
    });
}

function crashout() {
    beautiful.visible = flowers.visible = moment.visible = false;
}