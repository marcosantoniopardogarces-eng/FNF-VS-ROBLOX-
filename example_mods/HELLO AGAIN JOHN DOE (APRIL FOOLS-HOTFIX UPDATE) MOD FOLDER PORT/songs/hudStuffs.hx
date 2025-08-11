import flixel.input.keyboard.FlxKey;
import StringTools;
import flixel.math.FlxRect;
import funkin.backend.utils.DiscordUtil;
import Date;

// game over time
GameOverSubstate.script = "data/states/HJDGameOver";
// pause time
// not if ur charting cus some extra options
if (!PlayState.instance.chartingMode) PauseSubState.script = "data/states/HJDPauseMenu";
allowGitaroo = false; // stop dat

// no countdown fuck you bruh
introLength = 1;
function onCountdown(event) event.cancel();

//
// NOTE CAMERA MOVEMENT
//

public var camNoteOffset:Float;
public var camNoteMove:Bool;
public var isSnappy = false;

function create() {
    camNoteOffset = 20;
    camNoteMove = true;
}

function onCameraMove(e) {
    if (!camNoteMove || (isSnappy != null && isSnappy)) return;
    var char = e.strumLine.characters[0];
    if (char.animation.curAnim != null)
		{
			switch (char.animation.curAnim.name.substring(4)) {
				case 'UP' | 'UP-alt':
					e.position.y -= camNoteOffset;
				case 'DOWN' | 'DOWN-alt':
					e.position.y += camNoteOffset;
				case 'LEFT' | 'LEFT-alt':
					e.position.x -= camNoteOffset;
				case 'RIGHT' | 'RIGHT-alt':
					e.position.x += camNoteOffset;
			}
		}
}

// 
// ALL OF THE NOTE SHIT HERE
//

var keyLabelLines:Map<Int, FlxText> = [];

function onPostNoteCreation(e) {
    if (e.note.isSustainNote) e.note.alpha /= 0.6;
    e.note.antialiasing = false;
    e.note.gapFix = 10;
    if (FlxG.save.data.pezTabletNotes) e.note.color = switch(e.strumID) {
        case 0: 0xFFC24B99;
        case 1: 0xFF00FFFF;
        case 2: 0xFF12FA05;
        case 3: 0xFFF9393F;
    }
}

function onStrumCreation(e) e.cancelAnimation();

function onPostStrumCreation(e) {
    e.strum.antialiasing = false;

    e.strum.x += 10;
    if (e.strumID > 0) {
        e.strum.x -= 4.7 * e.strumID;
    }
    e.strum.alpha = 0.8;

    // key names

    if (e.strum.cpu || !strumLines.members[e.player].visible) return;
    var keyName = CoolUtil.keyToString(switch(e.strumID) {
        case 0: Options.P1_NOTE_LEFT[0];
        case 1: Options.P1_NOTE_DOWN[0];
        case 2: Options.P1_NOTE_UP[0];
        case 3: Options.P1_NOTE_RIGHT[0];
    });

    keyName = StringTools.replace(keyName, "#", "");
    if (keyName.length > 1) keyName = "";

    if (e.strumID == 0) {
        var keyLabels = new FlxGroup();
        keyLabels.camera = camHUD;
        add(keyLabels);
        keyLabelLines[e.player] = keyLabels;
    }

    var keyLabel = new FlxText();
    keyLabel.color = 0xFFD1D1D1;
    keyLabel.text = keyName;
    keyLabel.font = Paths.font("ARIAL.TTF");
    keyLabel.size = 20;
    keyLabelLines[e.player].add(keyLabel);
}

function postUpdate() {
    for (id in keyLabelLines.keys()) {
        for (n=>keyLabel in keyLabelLines.get(id).members) {
            var strum = strumLines.members[id].members[n];
            keyLabel.setPosition(strum.x, strum.y + (downscroll ? -5 : strum.height - keyLabel.height + 5));
            keyLabel.angle = strum.angle;
        }
    }
    if (isThereCutscene) csBlackBox.alpha = csSkipText.alpha;
}

// 
// ROBLOXHUD SHIT HERE
// 

public var timeTxt:FlxText;
public var hpText:FlxText;
public var hpBar_under:FlxSprite;
public var hpBar_over:FlxSprite;
public var timeName:String;
public var topBar:FunkinSprite;
public var csBlackBox:FlxSprite;

public var scaryMode = false;
function postCreate() {
    // funny
    if (Date.now().getHours() == 3) {
        inst.pitch = vocals.pitch = 0.8;
        for (strumLine in strumLines.members) strumLine.vocals.pitch = 0.8;
        var scary = new FlxSprite().makeGraphic(1, 1, 0xFFFF1111);
        scary.scale.set(FlxG.height*1.5, FlxG.width*1.5);
        scary.screenCenter();
        scary.camera = camHUD;
        scary.blend = 2;
        insert(0, scary);
        scaryMode = true;
    }

    camHUD.width = camGame.width = 1024;
    camHUD.height = camGame.height = 768;

    // die bro DIE
    for(c in [iconP1, iconP2, healthBar, healthBarBG, scoreTxt, accuracyTxt, missesTxt, comboGroup])
        c.visible = false;

    topBar = new FunkinSprite().makeGraphic(FlxG.width*2,40,FlxColor.BLACK);
    topBar.origin.y = 0;
    topBar.screenCenter(FlxAxes.X);

    timeName = 'time: ';
    timeTxt = new FlxText(0,10,FlxG.width,timeName,30);
    timeTxt.font = Paths.font('ARIAL.TTF');
    timeTxt.alignment = "center";
    retroText(timeTxt);

    hpBar_under = new FlxSprite().makeGraphic(20,250,FlxColor.RED);
    hpBar_under.screenCenter();
    hpBar_under.x = FlxG.width - hpBar_under.width - 50;
    
    hpBar_over = new FlxSprite().makeGraphic(20,250,0xFF96FF00);
    hpBar_over.screenCenter();
    hpBar_over.x = FlxG.width - hpBar_over.width - 50;
    
    hpClipRect = new FlxRect(0,0,20,125);

    hpText = new FlxText(0,0,0,'health',30);
    hpText.italic = true;
    hpText.color = FlxColor.BLUE;
    hpText.font = Paths.font('ArialCEItalic.ttf');
    hpText.x = hpBar_under.x + hpBar_under.width/2 - hpText.width/2;
    hpText.y = hpBar_under.y + hpBar_under.height + 10;

    for (thigns in [topBar, timeTxt, hpBar_under, hpBar_over, hpText]) {
        if (downscroll) thigns.y = FlxG.height - thigns.y - thigns.height; // cne downscroll is lovely yes
        thigns.camera = camHUD;
        add(thigns);
    }

    isThereCutscene = false;
    for (event in events) if (event.name == 'Cutscene Trigger') isThereCutscene = true;
    if (isThereCutscene) {
        csSkipText.font = Paths.font("ARIAL.TTF");
        csSkipText.size = 15;
        csSkipText.scale.set(2, 2);
        csSkipText.text = csSkipText.text.toLowerCase();
        csSkipText.borderColor = 0;
        csSkipText.updateHitbox();
        csBlackBox = new FlxSprite(csSkipText.x, csSkipText.y).makeGraphic(csSkipText.width, csSkipText.height, FlxColor.BLACK);
        csBlackBox.camera = camHUD;
        csBlackBox.alpha = 0;
        insert(members.indexOf(csSkipText), csBlackBox);
    }
}

var healthOld = 0;
function update() {
    topBar.angle = -camHUD.angle;
    if (FlxG.sound.music != null) {
        var currentTime = Conductor.songPosition > FlxG.sound.music.length ? 0 : Conductor.songPosition; // replicating the bugs yes?
        timeTxt.text = timeName + Math.round((FlxG.sound.music.length - currentTime)/1000);
    }
    
    if (health != healthOld && hpClipRect != null) {
        hpClipRect.height = FlxMath.remapToRange(health,0,2,0,250);
        hpClipRect.y = hpBar_over.height - hpClipRect.height;
        hpBar_over.clipRect = hpClipRect;
    }
}


function retroText(f:FlxText) {
    f.size = Std.int(f.size/2);
    f.scale.set(2,2);
}

function destroy() lastSongPlayed = curSong;