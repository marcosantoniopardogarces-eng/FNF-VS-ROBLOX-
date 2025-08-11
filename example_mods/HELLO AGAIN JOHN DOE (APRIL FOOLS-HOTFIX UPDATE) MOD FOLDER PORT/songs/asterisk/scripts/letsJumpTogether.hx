// wouldve rather had this as character script but character scripts suck in cne

var isJumping = false;
var canJump = true;
function onNoteHit(e) if (e.character.curCharacter == "ritz" && isJumping) e.animCancelled = true;
function onPlayerMiss(e) if (e.character.curCharacter == "ritz" && isJumping) e.animCancelled = true;

function create() {
    jumpSound = FlxG.sound.load(Paths.sound("jump"));
    jumpSound.volume = 0.6;
}

function update() {
    if (FlxG.keys.justPressed.SPACE && !isJumping && canJump) {
        isJumping = true;
        jumpSound.play(true);
        boyfriend.animation.play("jump", true);
        boyfriend.animation.curAnim.frameRate = 75;
        FlxTween.tween(boyfriend.animation.curAnim, {frameRate: 20}, 0.5, {ease: FlxEase.circOut});
        FlxTween.tween(boyfriend, {y: boyfriend.y - 200}, 0.25, {ease: FlxEase.sineOut, onComplete: (_) -> {
            FlxTween.tween(boyfriend, {y: boyfriend.y + 200}, 0.25, {ease: FlxEase.sineIn, onComplete: (_) -> {
                isJumping = false;
                boyfriend.animation.play("idle");
            }});
        }});
    }
    if (isJumping) boyfriend.debugMode = true; else boyfriend.debugMode = false;
}

function toggleJump() canJump = !canJump;

function jumpOffABuilding() {
    isJumping = true;
    jumpSound.play();
    boyfriend.animation.play("jump", true);
    boyfriend.animation.curAnim.frameRate = 75;
    FlxTween.tween(boyfriend, {"animation.curAnim.frameRate": 20, x: boyfriend.x + 100}, 0.75, {ease: FlxEase.circOut});
    FlxTween.tween(boyfriend, {y: boyfriend.y - 200}, 0.25, {ease: FlxEase.sineOut, onComplete: (_) -> {
        FlxTween.tween(boyfriend, {y: boyfriend.y + 500, "cameraOffset.y": boyfriend.cameraOffset.y - 200}, 0.5, {ease: FlxEase.sineIn, onComplete: (_) -> {
            isJumping = false;
            boyfriend.animation.play("idle");
        }});
    }});
}

// dont look at it bro just dont
function finalJump() {
    isJumping = true;
    jumpSound.play();
    boyfriend.animation.play("jump", true);
    boyfriend.animation.curAnim.frameRate = 75;
    FlxTween.tween(boyfriend, {"animation.curAnim.frameRate": 20}, Conductor.crochet / 500, {ease: FlxEase.circOut});
    FlxTween.tween(boyfriend, {y: boyfriend.y - 200, x: boyfriend.x + 100}, Conductor.crochet / 1000 - 0.05, {ease: FlxEase.sineOut, onComplete: (_) -> {
        boyfriend.x -= 500;
        boyfriend.scale.x *= 2;
        boyfriend.scale.y *= 0.5;
        new FlxTimer().start(0.05, (_) -> {
            boyfriend.scale.x /= 2;
            boyfriend.scale.y /= 0.5;
            boyfriend.x -= 750;
            FlxTween.tween(boyfriend, {x: boyfriend.x + 1100}, 0.5, {ease: FlxEase.quartOut});
            FlxTween.tween(boyfriend, {y: boyfriend.y - 100}, 0.25, {ease: FlxEase.sineOut, onComplete: (_) -> {
                FlxTween.tween(boyfriend, {y: boyfriend.y + 300}, 0.25, {ease: FlxEase.sineIn, onComplete: (_) -> {
                    isJumping = false;
                    boyfriend.animation.play("idle");
                }});
            }});
        });
    }});
}

function imaCrash() FlxTween.tween(boyfriend.cameraOffset, {x: boyfriend.cameraOffset.x + 100, y: boyfriend.cameraOffset.y + 50}, Conductor.crochet / 500, {ease: FlxEase.quadOut});