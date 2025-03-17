package;

import kha.input.Keyboard;
import kha.input.KeyCode;

import GlobalState;


class KeyboardData{

    public function new() {
        Keyboard.get().notify(onKeyDown);
    }

    function onKeyDown(key:Int) {
        if (key == KeyCode.Q) {
            GlobalState.mouseWheel = clamp(GlobalState.mouseWheel + 1., 1., 10.);
        };
        else if (key == KeyCode.E) {
            GlobalState.mouseWheel = clamp(GlobalState.mouseWheel - 1., 1., 10.);
        }

    }

    function clamp(value:Float, min:Float, max:Float): Float {        
        if (value <= min)
            value = min;        
        if (value >= max)
            value = max;
        return value;
    }
}