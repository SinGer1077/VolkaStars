package;

import kha.input.Mouse;
import kha.input.KeyCode;

import GlobalState;


class MouseData{

    public function new() {
        kha.input.Mouse.get().notify(onMouseMove, onMouseWheel);
    }

    function onMouseMove(x:Int, y:Int, movementX:Int, movementY:Int) {
    	//mouseDeltaX = x - mouseX;
    	//mouseDeltaY = y - mouseY;

    	//mouseX = x;
    	//mouseY = y;
    }

    function onMouseWheel(delta:Float){
        var mouseWheel = GlobalState.mouseWheel + delta;
        if (mouseWheel <= 1)
            mouseWheel = 1;        
        if (mouseWheel >= 10)
            mouseWheel = 10;
        
        GlobalState.mouseWheel = mouseWheel;
    }   
}