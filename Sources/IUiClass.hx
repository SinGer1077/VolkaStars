import kha.graphics2.Graphics;
import zui.*;

interface IUiClass {
    private var ui:Zui;
    private var loaded:Bool;

    public function draw(g: Graphics):Void;
}