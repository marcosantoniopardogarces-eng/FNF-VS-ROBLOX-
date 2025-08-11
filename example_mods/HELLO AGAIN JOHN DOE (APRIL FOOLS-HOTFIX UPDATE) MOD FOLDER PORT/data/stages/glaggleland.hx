function postCreate() {
    riot = new FlxSprite(-575, 575);
    riot.frames = Paths.getFrames("stages/gigglegabble/riot");
    riot.animation.addByPrefix("riot", "riot instancia 1", 15);
    riot.scale.set(2.6, 2.6);
    riot.animation.play("riot");
    insert(members.indexOf(glaggleland), riot);
}

var darkenTween:FlxTween;
var isItDark = false;

function update() {
    if (FlxG.keys.justPressed.P) bgSwitch();
    if (FlxG.keys.justPressed.L) spawnRiot();
}

function darkenIt() {
    if (darkenTween != null) darkenTween.cancel();
    darkenTween = FlxTween.num(20, 0, isItDark ? 0.25 : 0.375, {ease: FlxEase.circOut}, function(num) {
        glaggleland.color = runway.color = CoolUtil.lerpColor(isItDark ? 0xFF553333 : 0xFFFFFFFF, isItDark ? 0xFFFFFFFF : 0xFF333355, Math.floor(num)/20);
    });
    isItDark = !isItDark;
}

function bgSwitch() {
    runway.alpha = 0;
    FlxTween.num(20, 0, Conductor.crochet / 500, {ease: FlxEase.circIn, onComplete: () -> {
        glaggleland.visible = false;
        FlxTween.num(0, 20, Conductor.crochet / 500, {ease: FlxEase.circOut}, function(num) {
            runway.alpha = Math.floor(num)/20;
        });
    }}, function(num) {
        glaggleland.alpha = Math.floor(num)/20;
    });
}

function stepHit() if (FlxG.random.bool(5) && !glaggleland.visible) spawnRunner();

function spawnRiot() {
    if (riot == null || riot.velocity.x != 0) return;
    riot.velocity.x = 750;
    new FlxTimer().start(4, () -> {remove(riot.destroy());});
}

function spawnRunner() {
    var trippy = FlxG.random.bool(10);
    var id = trippy ? 1 : FlxG.random.int(1, 3);
    var isRight = FlxG.random.bool(50);
    var multiply = FlxG.random.float(0.7, 0.9);
    var runner = new FunkinSprite(isRight ? 2500 : -200, 675);
    runner.flipX = isRight;
    runner.frames = Paths.getFrames("stages/gigglegabble/gigglerRuns");
    runner.scale.set(2.8, 2.8);
    runner.animation.addByPrefix("run", "walk" + id, 40);
    switch(id) {
        case 2:
            runner.addOffset("run", -25, 10);
            runner.scale.set(2.6, 2.6);
        case 3:
            runner.flipX = !runner.flipX;
    }
    runner.scale.x *= multiply;
    runner.scale.y *= multiply;
    runner.playAnim("run");
    insert(members.indexOf(riot), runner);
    if (trippy) {
        runner.animation.addByIndices("trip", "trip", [22,23,24,25,26,27,28,29,30,31,38,39,40,41,42,43,44,45,46,47], "", 20, false);
        runner.addOffset("trip", 0, 80);
        var lerpVal = FlxG.random.float(0.25, 0.75);
        var tripPos = FlxMath.lerp(isRight ? -200 : 2500, isRight ? 2500 : -200, lerpVal);
        var times = FlxMath.lerp(0.5 / Math.pow(multiply, 3), 0, lerpVal);
        FlxTween.tween(runner, {x: tripPos}, times, {onComplete: () -> {
            runner.playAnim("trip");
        }});
        runner.animation.finishCallback = (i) -> {
            if (i == "trip") {
                runner.playAnim("run");
                FlxTween.tween(runner, {x: isRight ? -200 : 2500}, 0.5, {ease: FlxEase.sineIn, onComplete: () -> {
                    remove(runner);
                    runner.destroy();
                }});
            }
        };
    } else FlxTween.tween(runner, {x: isRight ? -200 : 2500}, 0.5 / Math.pow(multiply, 3), {onComplete: () -> {
        remove(runner);
        runner.destroy();
    }});
}