import flixel.effects.FlxFlicker;

function postCreate() {
    camGame.followLerp *= 1.5;
    flickerCooldown = new FlxTimer();
    flickerSprite = new FunkinSprite().makeGraphic(1, 1, 0xFF000010);
    flickerSprite.scrollFactor.set();
    flickerSprite.zoomFactor = 0;
    flickerSprite.scale.set(FlxG.width, FlxG.height);
    flickerSprite.screenCenter();
    flickerSprite.alpha = 0.75;
    insert(members.indexOf(testing) + 1, flickerSprite);
    flickerSound = FlxG.sound.load(Paths.sound("lightblink"), 0.3);
    for (s in strumLines.members) for (c in s.characters) c.color = 0xFF7777AA;
}

function update() flickerSprite.angle = -camGame.angle;

function onEvent(e) if (e.event.name == 'logo') {
    FlxG.sound.play(Paths.sound("lighton"), 0.3);
    remove(flickerSprite);
    insert(999, flickerSprite);
    if (!Options.flashingMenu) flickerSprite.visible = false;
    else flickerLight();
    for (s in strumLines.members) for (c in s.characters) c.color = 0xFFFFFFFF;
}

var shouldFlicker = true;
function toggleFlicker() shouldFlicker = !shouldFlicker;

function flickerLight() {
    if (!Options.flashingMenu) return;
    FlxFlicker.flicker(flickerSprite, 0.25, 0.03, true, true);
    flickerSound.play(true);
    flickerSprite.alpha = 0.25;
    FlxTween.tween(flickerSprite, {alpha: 0}, 0.25, {ease: FlxEase.sineIn, onComplete: function() {
        flickerSprite.visible = false;
    }});
    flickerCooldown.start(5);
}

function stepHit() {
    //trace("u " + (shouldFlicker && !flickerCooldown.active && !flickerSprite.visible ? "can" : "cant") + " flicker");
    if (FlxG.random.bool(5) && shouldFlicker && !flickerCooldown.active && !flickerSprite.visible) flickerLight();
}