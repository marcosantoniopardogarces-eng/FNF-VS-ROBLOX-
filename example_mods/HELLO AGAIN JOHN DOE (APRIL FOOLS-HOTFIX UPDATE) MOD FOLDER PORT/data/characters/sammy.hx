function postCreate() new FlxTimer().start(0.001, () -> {
    var eyes = new FlxSprite(x + 445, y + 375);
    eyes.frames = Paths.getFrames("characters/sammy");
    eyes.animation.addByPrefix("a", "eyes");
    eyes.animation.play("a");
    eyes.scrollFactor.set(scrollFactor.x * 0.95, scrollFactor.y);
    eyes.scale.set(scale.x, scale.y);
    FlxG.state.add(eyes);
});