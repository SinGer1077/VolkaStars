package;

import haxe.ds.Vector;
import js.lib.webassembly.Global;
import kha.math.Vector2;
import kha.input.Mouse;
import kha.input.KeyCode;

import GlobalState;


class MouseData{

    public function new() {
        kha.input.Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
    }

    function onMouseDown(button:Int, x:Int, y:Int) {
        GlobalState.mouseDown = true;
        GlobalState.lastMouseOffset = new Vector2(x, y);
    }

    function onMouseUp(button:Int, x:Int, y:Int) {
        GlobalState.mouseDown = false;
    }

    function onMouseMove(x:Int, y:Int, movementX:Int, movementY:Int) {
        if (GlobalState.mouseDown)
            GlobalState.setMousePosition(x, y, movementX, movementY);
    }

    function onMouseWheel(delta:Float){
        GlobalState.setMouseWheel(delta);
    }   
}