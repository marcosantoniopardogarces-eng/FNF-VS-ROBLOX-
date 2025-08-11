import funkin.editors.charter.Charter;
import flixel.tweens.FlxTweenType;
import openfl.display.BlendMode;
import flixel.text.FlxText.FlxTextBorderStyle;

var bg = stage.stageSprites.get("house");

function postCreate() {
    blackOne = new FunkinSprite().makeGraphic(1, 1, 0xFF000000);
    blackOne.scale.set(FlxG.width, FlxG.height);
    blackOne.screenCenter();
    blackOne.scrollFactor.set();
    blackOne.zoomFactor = 0;
    blackOne.visible = false;
    add(blackOne);

    giveMeIt = new FlxGroup();
    giveMeIt.camera = camHUD;
    insert(0, giveMeIt);
    for (i in 0...4) {
        var text = new FlxText();
        text.font = Paths.font("Montserrat.ttf");
        text.size = 30;
        text.scale.set(3.5, 3.5);
        switch(i) {
            case 0:
                text.text = "GIVE";
                text.screenCenter();
                text.x -= 250;
                text.y -= 200;
            case 1:
                text.text = "ME";
                text.screenCenter();
                text.y -= 200;
            case 2:
                text.text = "THE";
                text.screenCenter();
                text.x += 250;
                text.y -= 200;
            case 3:
                text.text = "CHEESE.";
                text.scale.x *= 1.5;
                text.screenCenter();
                text.y += 300;
        }
        text.alpha = 0;
        giveMeIt.add(text);
    }

    glow = new FlxSprite().loadGraphic(Paths.image("stages/asterisk/yellowLight"));
    glow.blend = BlendMode.ADD;
    glow.screenCenter();
    glow.visible = false;
    glow.camera = camHUD;
    insert(members.indexOf(giveMeIt), glow);

    cheses = new FlxGroup();
    cheses.camera = camHUD;
    insert(members.indexOf(glow), cheses);
    for (i in 0...4) {
        var chese = new FlxSprite();
        chese.frames = Paths.getFrames("stages/asterisk/chese");
        chese.scale.set(1.5, 1.5);
        chese.animation.addByPrefix("chese", "cheeese", 5);
        chese.animation.play("chese");
        chese.screenCenter();
        switch (i) {
            case 1:
                chese.y += 250;
                chese.x += 300;
            case 2:
                chese.y -= 250;
                //chese.x += 300;
            case 3:
                chese.y += 250;
                chese.x -= 300;
        }
        chese.alpha = 0;
        cheses.add(chese);
    }

    // FUCKING DOWNSCROLL FIX I HATE DOWNSCROLL FUUUK.
    if (downscroll) for (textes in [glow].concat(giveMeIt.members.concat(cheses.members))) textes.y = FlxG.height - textes.y - textes.height;

    errorTextes = new FlxGroup();
    errorTextes.camera = camHUD;
    insert(members.indexOf(blackOne), errorTextes);
    for (i in 0...5) {
        text = new FlxText();
        text.color = 0xFFFF0000;
        text.size = 25;
        text.bold = true;
        text.alpha = 0;
        errorTextes.add(text);
    }

    theFucking = new FlxText();
    theFucking.font = Paths.font("Montserrat.ttf");
    theFucking.size = 25;
    theFucking.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1, 0.5);
    theFucking.alignment = "center";
    theFucking.camera = camHUD;
    theFucking.visible = false;
    theFucking.alpha = 0.75;
    add(theFucking);

    deathSound = FlxG.sound.load(Paths.sound("death"));
    hitSound = FlxG.sound.load(Paths.sound("punch"));
    hitSound.volume = 0.6;

    if (PlayState.instance.chartingMode && Charter.startHere) return;
    camGame.zoom = 0.4;
    bg.alpha = dad.alpha = boyfriend.alpha = 0;
}

function postUpdate() {
    if (blackOne.visible) blackOne.angle = -camGame.angle;
}

function onSongStart() {
    if (PlayState.instance.chartingMode && Charter.startHere) return;
    var beat = Conductor.crochet / 1000;
    FlxTween.num(0, 20, 12 * beat, {ease: FlxEase.sineOut}, function(num) {
        bg.alpha = Math.floor(num)/20;
    });
    FlxTween.num(0, 20, 16 * beat, {ease: FlxEase.sineOut}, function(num) {
        dad.alpha = Math.floor(num)/20;
    });
    FlxTween.num(0, 20, 8 * beat, {ease: FlxEase.sineOut}, function(num) {
        boyfriend.alpha = Math.floor(num)/20;
    });
}

var cinema:FlxTween;

function superCinema(bub) {
    if (bub == "no") {
        camGame.angle = 0;
        if (cinema != null) cinema.cancel();
    } else {
        camGame.angle = 3;
        if (cinema != null) cinema.cancel();
        cinema = FlxTween.tween(camGame, {angle: -3}, 3, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
    }
}

function boiCam(yep) {
    if (yep == "l") camGame.angle = -5;
    else if (yep == "r") camGame.angle = 5;
    else if (yep == "boi") FlxTween.tween(camGame, {angle: 0}, Conductor.crochet / 250, {ease: FlxEase.backIn});
    else camGame.angle = 0;
}


function dude() {
    FlxTween.tween(camGame, {alpha: 0}, (Conductor.crochet / 1000) * 3, {ease: FlxEase.sineIn, onComplete: (_) -> {
        camGame.alpha = 1;
        blackOne.visible = true;
    }});
}

var doodoo:FlxTimer;
var daTextes = [
    "HYG5:[",
    "%&9gP6",
    ".:`/7+",
    "m&04·6",
    "!.#.;m",
    "Mk.$d=",
    "g%#$mA",
    "su^+`s",
    "lKiU6&",
    "mmM%$o"
];
// artificial rarity
var daFakeOnes = [
    "HE IS\nHERE",
    "GIVE ME\nTHE CHEESE",
    "RUN",
    "BEHIND YOU"
];
var daRealOnes = ["PRESS SPACE"];
for (i in daFakeOnes) {
    daRealOnes.push(i);
    daRealOnes.push(i);
    daRealOnes.push(i);
}

function errorTextDuds(?boi) {
    if (!Options.flashingMenu) return;
    if (doodoo != null) doodoo.cancel();
    errorTextes.visible = true;
    if (!boi) theFucking.visible = true;
    doodoo = new FlxTimer().start(0.1, (_) -> {
        errorTextes.visible = theFucking.visible = false;
    });
    theFucking.text = daRealOnes[FlxG.random.int(0, daRealOnes.length-1)];
    theFucking.screenCenter();
    theFucking.x += FlxG.random.float(-50, 50);
    theFucking.y += FlxG.random.float(-50, 50);
    var biiScale = FlxG.random.float(2.5, 3.5);
    theFucking.scale.set(biiScale, biiScale);
    theFucking.angle = FlxG.random.float(-5, 5);
    for (text in errorTextes.members) {
        text.text = daTextes[FlxG.random.int(0, daTextes.length-1)];
        text.screenCenter();
        text.x += FlxG.random.float(-300, 300);
        text.y += FlxG.random.float(-300, 300);
        var boiScale = FlxG.random.float(2, 4);
        text.scale.set(boiScale, boiScale);
        text.font = Paths.font(FlxG.random.bool() ? "Merriweather.ttf" : "Roboto Mono.ttf");
        text.angle = FlxG.random.float(0, 360);
    }
}

function onNoteHit(e) if (e.noteType == "Your parents call you a cheese lard.") errorTextDuds();

var cheeseCount = 0;
var shakeItUp = false;

function daChees() {
    if (cheeseCount == 0) for (i in 0...32)
        new FlxTimer().start(0.05*i, (_) -> {
            if (errorTextes.members[Math.floor(i/2)] != null) errorTextes.members[Math.floor(i/2)].alpha = 0.75;
            errorTextDuds(true);
        });
    giveMeIt.members[cheeseCount].alpha = 1;
    cheeseCount += 1;
    if (cheeseCount == 1) {
        glow.visible = true;
        glow.scale.set(0.001, 0.001);
        FlxTween.tween(glow, {"scale.x": 3, "scale.y": 3}, 0.5, {ease: FlxEase.sineOut, onComplete: (_) -> {shakeItUp = true;}});
    }
    for (i=>chese in cheses.members) if (i == cheeseCount) {
        FlxTween.num(0, 20, 1, {ease: FlxEase.circOut}, function(num) {
            chese.alpha = Math.floor(num)/20;
        });
        FlxTween.tween(chese, {x: glow.x + glow.width/2 - chese.width/2}, 1, {ease: FlxEase.circIn});
        FlxTween.tween(chese, {y: glow.y + glow.height/2 - chese.height/2}, 1, {ease: FlxEase.quadIn});
        FlxTween.tween(chese, {"scale.x": 0.2, "scale.y": 0.2, angle: 360*2}, 1, {ease: FlxEase.sineIn, onComplete: (_) -> {
            FlxTween.cancelTweensOf(chese);
            remove(chese.destroy());
        }});
    }
}

function update() if (shakeItUp) {
    var buddy = FlxG.random.float(2.8, 3.2);
    glow.scale.set(buddy, buddy);
}

function itsTime() {
    shakeItUp = false;
    remove(glow.destroy());
    giveMeIt.visible = blackOne.visible = false;
    camGame.angle = 6;
    if (cinema != null) cinema.cancel();
    cinema = FlxTween.tween(camGame, {angle: -6}, 3, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
    dad.angle = 6;
    FlxTween.tween(dad, {angle: -6}, 3, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
}

function ohHesGone() {
    superCinema("no");
    FlxTween.cancelTweensOf(dad);
    FlxTween.tween(dad, {angle: 360*3, x: dad.x - 5000}, 1, {ease: FlxEase.sineInOut});
    FlxTween.tween(dad, {y: dad.y - 500}, 0.5, {ease: FlxEase.sineInOut, type: FlxTweenType.PINGPONG});
    hitSound.play();
    new FlxTimer().start(0.5, function() {
        deathSound.play();
        camGame.shake();
    }, 1);
};