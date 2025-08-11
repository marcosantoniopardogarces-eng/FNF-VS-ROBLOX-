function postCreate() {
    camGame.visible = false;

    cutsceneBg = new FunkinSprite().loadGraphic(Paths.image("stages/plan-b/park-cutscene"));
    cutsceneBg.scale.set(FlxG.height/cutsceneBg.height, FlxG.height/cutsceneBg.height);
    cutsceneBg.screenCenter();
    cutsceneBg.x -= 160;
    cutsceneBg.scrollFactor.set();
    cutsceneBg.zoomFactor = 0;
    cutsceneBg.visible = false;
    add(cutsceneBg);

    theLine = new FlxGroup();
    theLine.visible = false;
    add(theLine);

    theGuys = new FunkinSprite();
    theGuys.zoomFactor = 0;
    theGuys.scrollFactor.set();
    theGuys.frames = Paths.getFrames("stages/plan-b/jd666");
    theGuys.animation.addByPrefix("walk", "walk", 4);
    theGuys.animation.play("walk");
    theGuys.scale.set(0.35, 0.35);
    theGuys.flipX = true;
    theGuys.screenCenter();
    theGuys.x += 125;
    theGuys.y -= 15;
    theLine.add(theGuys);

    for (i in 0...4) {
        var theDuck = new FunkinSprite();
        theDuck.zoomFactor = 0;
        theDuck.scrollFactor.set();
        theDuck.frames = Paths.getFrames("stages/plan-b/dick");
        theDuck.animation.addByPrefix("walk", "walk", 4);
        theDuck.animation.play("walk");
        theDuck.scale.set(0.35, 0.35);
        theDuck.x = theGuys.x + 50*(i+5);
        theDuck.y = theGuys.y + 85;
        theLine.add(theDuck);
    }

    fatassfuck = new FunkinSprite(150, 425);
    fatassfuck.frames = Paths.getFrames("stages/plan-b/boyflendfatass");
    fatassfuck.animation.addByPrefix("chew", "chew", 18);
    fatassfuck.animation.addByPrefix("walk", "walk", 18);
    fatassfuck.animation.play("chew");
    fatassfuck.scrollFactor.set();
    fatassfuck.zoomFactor = 0;
    fatassfuck.scale.set(2, 2);
    fatassfuck.visible = false;
    add(fatassfuck);

    fuckassdog = new FunkinSprite(650, 525).loadGraphic(Paths.image("stages/plan-b/shockeddog"));
    fuckassdog.scrollFactor.set();
    fuckassdog.zoomFactor = 0;
    fuckassdog.scale.set(2, 2);
    fuckassdog.visible = false;
    add(fuckassdog);

    theFetus = new FunkinSprite(0, 585);
    theFetus.screenCenter(FlxAxes.X);
    theFetus.x -= 300;
    theFetus.frames = Paths.getFrames("stages/plan-b/babys");
    theFetus.animation.addByPrefix("fetus", "baby", 18);
    theFetus.scrollFactor.set();
    theFetus.zoomFactor = 0;
    theFetus.scale.set(2, 2);
    theFetus.visible = false;
    add(theFetus);

    new FlxTimer().start(0.001, function() {
        myHeadCam = new FlxCamera();
        myHeadCam.bgColor = 0;
        FlxG.cameras.add(myHeadCam, false);
        csSkipText.camera = csBlackBox.camera = myHeadCam;
    });
}

// bandaid hotfix so gf doesnt break the camera
function onCameraMove(e) if (curCameraTarget == 2) {
    e.preventDefault();
    camFollow.x = e.strumLine.characters[0].getCameraPosition().x;
    camFollow.y = e.strumLine.characters[0].getCameraPosition().y;
}

function toggleView() camGame.visible = !camGame.visible;

function camSlidez() {
    camNoteMove = false;
    FlxTween.tween(boyfriend.cameraOffset, {x: boyfriend.cameraOffset.x + 200}, Conductor.crochet / 250, {ease: FlxEase.backIn});
    dad.cameraOffset.x -= 300;
}

function beautifulMoment() {
    boyfriend.cameraOffset.x -= 200;
    dad.cameraOffset.x += 300;
    camNoteMove = true;
}

var letsMoveIt = false;
var cutsceneTimer:FlxTimer;
public function myFuckFucking() {
    cutsceneBg.visible = fatassfuck.visible = fuckassdog.visible = theLine.visible = true;
    camHUD.visible = false;
    letsMoveIt = true;
    cutsceneTimer = new FlxTimer().start(3, function() {
        fatassfuck.animation.play("walk");
        FlxTween.tween(fatassfuck, {x: -400}, 3, {ease: FlxEase.backIn, onComplete: function() {
            fatassfuck.x = FlxG.width;
            FlxTween.tween(fatassfuck, {x: FlxG.width - 100}, 0.05, {onComplete: function() {remove(fatassfuck.destroy());}});
        }});
    }, 1);
}

function update(elapsed) if (letsMoveIt) for (i=>thing in theLine.members) thing.x -= (50 + 5 * i) * elapsed;

function onCutsceneTrigger(id, isEnd, skipped) if (id == "kill the fetus") {
    if (isEnd) {
        if (cutsceneTimer != null && skipped) cutsceneTimer.cancel();
        if (fatassfuck != null) remove(fatassfuck.destroy());
        theFetus.visible = true;
        theFetus.animation.play("fetus");
    }
}