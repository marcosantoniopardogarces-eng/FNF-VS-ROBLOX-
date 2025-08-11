import flixel.text.FlxTextFormat;

var dadDood = cpu.characters[1];
var bfDood = player.characters[1];

function postCreate() {
    camDood = new FlxCamera();
    camDood.bgColor = 0;
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(camDood, false);
    FlxG.cameras.add(camHUD, false);

    book = new FlxSprite();
    book.frames = Paths.getFrames("stages/zombaked/daBook");
    book.animation.addByIndices("closed", "open", [0], null, 10, false);
    book.animation.addByPrefix("open", "open", 10, false);
    book.animation.addByPrefix("close", "close", 10, false);
    book.animation.addByPrefix("idle", "idle", 20);
    book.animation.play("closed");
    book.animation.finishCallback = (s)->{
        if (s == "open") {
            book.animation.play("idle");
        }
    }
    book.screenCenter();
    book.x -= 200;
    book.y += 35;
    book.angle = 1;
    book.scale.set(0.9, 0.9);
    book.camera = camDood;
    book.visible = false;
    insert(0, book);

    for (i=>dood in [dadDood, bfDood]) {
        dood.visible = false;
        dood.camera = camDood;
        dood.scrollFactor.set();
        dood.screenCenter(FlxAxes.X);
        // making it easier to edit for future me
        // thank you - future me
        var spacing = 90;
        var height = 80;
        var size = 0.4;
        dood.scale.set(dood.scale.x * size, dood.scale.y * size);
        dood.x += 100 + (i == 0 ? -spacing : spacing);
        dood.y -= 440 + height + (i == 1 ? 10 : 0);
    }

    schlorpy = new FlxSprite();
    schlorpy.frames = Paths.getFrames("characters/horf");
    schlorpy.animation.addByIndices("die", "horf", [11,12,13,14,15,16], "", 20, false);
    schlorpy.animation.play("die");
    schlorpy.screenCenter();
    schlorpy.scale.set(1.1, 1.1);
    schlorpy.visible = false;
    schlorpy.camera = camHUD;
    add(schlorpy);

    textes = new FlxSpriteGroup();
    textes.camera = camHUD;
    textes.visible = false;
    add(textes);

    var dadName = dadDood.xml.get("bookName") ?? dadDood.curCharacter;
    var bfName = bfDood.xml.get("bookName") ?? bfDood.curCharacter;

    var textArrays = [
    //  [TEXT, SIZE, X, Y, ALIGNMENT] (x is relative to screen center and text width)
    //  ["boi", 12, 0, 384, "center"] are the defaults
        [dadName, 48, -210, 130],
        [bfName, 48, 210, 130],
        ["Directions:", 24, -210, 410],
        ["Directions:", 24, 210, 410],
        ["
            1. Marinate in Testing\n
            2. Add Brain Frosting\n
            3. Add Flesh Shavings\n
            4. Enjoy!
        ", 30, -270, 425, "left"],
        ["
            1. Bake at Normal Heat\n
            2. Add Pizza Toppings\n
            3. Add depression\n
            4. Enjoy!
        ", 30, 150, 425, "left"]
    ];

    for (info in textArrays) {
        var boiii = new FlxTextFormat();
        boiii.leading = -10;
        var text = new FlxText().addFormat(boiii);
        text.font = Paths.font("ArialCEItalic.ttf");
        text.color = 0xFF000000;
        text.text = info[0] ?? "boi";
        text.size = info[1] ?? 12;
        text.scale.set(2, 2);
        text.size /= 2;
        text.alignment = info[4] ?? "center";
        text.updateHitbox();
        text.screenCenter(FlxAxes.X);
        text.x += info[2] ?? 0;
        text.y = info[3] ?? 384;
        if (downscroll) text.y = FlxG.height - text.y - text.height;
        textes.add(text);
    }
}

function update() camDood.zoom = camHUD.zoom;

function doodleTime() {
    book.visible = !book.visible;
    if (book.visible) {
        book.y += FlxG.height;
        FlxTween.tween(book, {y: book.y - FlxG.height}, Conductor.crochet / 1000, {ease: FlxEase.quadOut, onComplete: () -> {
            book.animation.play("open");
            FlxTween.tween(book, {x: book.x + 195}, Conductor.crochet / 2000 - 0.1, {ease: FlxEase.circIn, onComplete: () -> {
                FlxTween.num(0, 20, 1, {ease: FlxEase.sineOut}, function(num) {
                    dadDood.visible = bfDood.visible = textes.visible = true;
                    dadDood.alpha = bfDood.alpha = textes.alpha = Math.floor(num)/20;
                });
            }});
        }});
    } else {
        book.visible = true;
        FlxTween.num(20, 0, 1, {ease: FlxEase.sineOut, onComplete: ()-> {
            book.animation.play("close");
            FlxTween.tween(book, {x: book.x - 195}, Conductor.crochet / 1000, {ease: FlxEase.circOut, onComplete: ()->{
                dadDood.visible = bfDood.visible = false;
                FlxTween.tween(book, {y: book.y + FlxG.height}, Conductor.crochet / 1000, {ease: FlxEase.circIn});
            }});
        }}, function(num) {
            dadDood.alpha = bfDood.alpha = textes.alpha = Math.floor(num)/20;
        });
    }
}

function death() {
    schlorpy.visible = true;
    schlorpy.animation.play("die");
    camGame.shake();
    camHUD.shake();
    new FlxTimer().start(1, function() {
        FlxTween.num(20, 0, 2, {ease: FlxEase.sineOut}, function(num) {
            camGame.alpha = Math.floor(num)/20;
        });
        new FlxTimer().start(0.5, function() {
            FlxTween.num(20, 0, 1.5, {ease: FlxEase.sineOut}, function(num) {
                camHUD.alpha = Math.floor(num)/20;
            });
        });
    });
}