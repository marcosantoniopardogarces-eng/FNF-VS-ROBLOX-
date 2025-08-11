function create() {
    shader = new CustomShader("invertGlitch");
    shader.AMT = 0.7;
    shader.SPEED = 8;
    shader.iTime = 0;
    shader.isActive = false;
}

function update(elapsed) {
    shader.iTime += elapsed;
    shader.isActive = StringTools.endsWith(animation.curAnim.name, "-alt");
}