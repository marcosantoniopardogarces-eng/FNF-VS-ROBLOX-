importScript("data/scripts/CodeBG");
import funkin.editors.charter.Charter;

var bgs:Map<String, FlxBasic> = [];
var bgIgnore:Map<String, Array> = [];
var curBg:String;
var curSwitchy:Int;

function postCreate() {
    // lets group em up yeah?
    for (i in stage.stageSprites.iterator()) remove(i);
    
    // BASEPLATE
    bgs["baseplate"] = new FlxGroup();
    for (i in [sky, skySet, skyRed, baseplate]) bgs["baseplate"].add(i);
    bgIgnore["baseplate"] = [skySet, skyRed];

    // CROSSROADS
    bgs["crossroads"] = crossroads;
    
    // SWITCHAROO
    bgs["switcharoo"] = new FlxGroup();
    for (i in [bg0, bg1, bg2, bg3]) bgs["switcharoo"].add(i);
    bgIgnore["switcharoo"] = [];

    bgs["home"] = bg1;

    glitchy = new CustomShader("invertGlitch");
    glitchy.AMT = 0.7;
    glitchy.SPEED = 8;
    glitchy.iTime = 0;
    glitchy.isActive = false;
    for (i in bgs["switcharoo"].members) i.shader = glitchy;

    for (i in bgs.iterator()) {
        if (Std.isOfType(i, FlxGroup)) for (s in i.members) s.alpha = 0;
        else i.alpha = 0;
        add(i);
    }

    // code bg
    codeBG = CodeBG(0, 0, FlxG.width * 3, FlxG.height * 2.4, 100, FlxColor.RED);
    centerOnSprite(codeBG, gf);
    codeBG.x += 250;
    add(codeBG);
    codeBG.alpha = 0;
    
    codeBGjohn = CodeBG(0, 0, FlxG.width * 3, FlxG.height * 2.4);
    centerOnSprite(codeBGjohn, gf);
    codeBGjohn.x += 250;
    add(codeBGjohn);
    codeBGjohn.alpha = 0;

    darkenableSprites = [sky, skySet, skyRed, crossroads, bg0, bg1, bg2, bg3];

    if (SONG.meta.customValues?.startingBg != null) {
        if (SONG.meta.customValues.startingBg != "none") switchBgMode(SONG.meta.customValues.startingBg, "0.001");
    } else switchBgMode("baseplate", "0.001");
}

function update(elapsed) {
    glitchy.iTime += elapsed;
    if (codeBGjohn.alpha == 0 && StringTools.endsWith(playerStrums.characters[1].animation.curAnim.name, "-alt"))
        FlxTween.tween(codeBGjohn, {alpha: 0.5}, 1);
}

var darkenTween:FlxTween;
var isItDark = false;
function darkenIt(instant) {
    if (darkenTween != null) darkenTween.cancel();
    if (instant == "instant") for (i in darkenableSprites) i.color = isItDark ? 0xFFFFFFFF : 0xFF333355;
    else darkenTween = FlxTween.num(20, 0, isItDark ? 0.5 : 0.75, {ease: FlxEase.circOut}, function(num) {
        for (i in darkenableSprites) i.color = CoolUtil.lerpColor(isItDark ? 0xFF333355 : 0xFFFFFFFF, isItDark ? 0xFFFFFFFF : 0xFF333355, Math.floor(num)/20);
    });
    isItDark = !isItDark;
}

function outtahere() FlxTween.tween(codeBGjohn, {alpha: 0}, 1);

function switcharooShuffle(?noShader) {
    noShader ??= false;
    if (curBg != "switcharoo") return;
    var lol = [];
    for (i in 0...bgs["switcharoo"].members.length) lol.push(i);
    lol.remove(curSwitchy);
    curSwitchy = FlxG.random.getObject(lol);
    if (noShader) for (n=>i in bgs["switcharoo"].members) i.visible = n == curSwitchy;
    else {
        glitchy.isActive = true;
        new FlxTimer().start(0.25, () -> {
            glitchy.isActive = false;
            for (n=>i in bgs["switcharoo"].members) i.visible = n == curSwitchy;
        });
    }
}

function beatHit() {
    if (PlayState.instance.chartingMode && Charter.startHere) {
        var beatsSkipped = Math.floor(Charter.startTime / Conductor.crochet);
        if (curBeat < beatsSkipped) return;
    }
    if (curBg == "switcharoo" && FlxG.random.bool(25)) switcharooShuffle();
}

function switchBgMode(bg, ?alength) {
    var lengthy = Conductor.crochet / 250;
    if (alength != null) lengthy = (Conductor.crochet / 1000) * Std.parseFloat(alength);
    if (curBg != null && curBg != "none") {
        if (Std.isOfType(bgs[curBg], FlxGroup)) for (i in bgs[curBg]) FlxTween.tween(i, {alpha: 0}, lengthy, {ease: FlxEase.sineIn});
        else FlxTween.tween(bgs[curBg], {alpha: 0}, lengthy, {ease: FlxEase.sineIn});
    }
    curBg = bg;
    if (bg == "switcharoo") {
        switcharooShuffle(true);
        FlxTween.cancelTweensOf(codeBG);
        FlxTween.tween(codeBG, {alpha: 0.25}, 0.5);
    } else {
        FlxTween.cancelTweensOf(codeBG);
        FlxTween.tween(codeBG, {alpha: 0}, 0.5);
    }
    // this shit gon give me a head ache
    if (bg == "home") {
        for (i in bgs["switcharoo"]) i.visible = i == bg1;  
    }
    if (bg != "none")
        if (Std.isOfType(bgs[bg], FlxGroup)) {
            for (i in bgs[bg]) {
                if (!bgIgnore[bg].contains(i)) {
                    FlxTween.tween(i, {alpha: 1}, lengthy, {ease: FlxEase.sineIn});
                }
            }
        }
        else FlxTween.tween(bgs[bg], {alpha: 1}, lengthy, {ease: FlxEase.sineIn});
}

var beat = Conductor.crochet / 1000;
var setTween:FlxTween;
function stageStuffs(dod) switch(dod) {
    case "sunset":
        setTween = FlxTween.num(0, 20, 12 * beat, {ease: FlxEase.sineOut}, function(num) {
            skySet.alpha = Math.floor(num)/20;
        });
    case "redsky":
        skyRed.alpha = 1;
        baseplate.color = dad.color = gf.color = boyfriend.color = 0xFFFFBBBB;
    case "wash the red":
        if (setTween != null) setTween.cancel();
        FlxTween.num(0, 20, 10, {ease: FlxEase.circOut}, function(num) {
            for (i in [baseplate, dad, gf, boyfriend]) i.color = CoolUtil.lerpColor(0xFFFFBBBB, 0xFFFFFFFF, Math.floor(num)/20);
        });
}