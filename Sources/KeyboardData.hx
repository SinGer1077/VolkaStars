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
            GlobalState.mouseWheel = GlobalState.clamp(GlobalState.mouseWheel + 1., 1., 10.);
        };
        else if (key == KeyCode.E) {
            GlobalState.mouseWheel = GlobalState.clamp(GlobalState.mouseWheel - 1., 1., 10.);
        }

    }    
}