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
            GlobalState.setMouseWheel(1);
        };
        else if (key == KeyCode.E) {
            GlobalState.setMouseWheel(-1);
        }

    }    
}