package;

import zui.Zui.Align;
import kha.Color;
import kha.Font;
import kha.Framebuffer;
import kha.Assets;
import zui.*;

class FPSCounter{
    var ui:Zui;

    public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {        
		ui = new Zui({font: Assets.fonts.DroidSans});
        kha.System.notifyOnFrames(render);	
	}

    public function render(framebuffers: Array<Framebuffer>): Void{
        var g = framebuffers[0].g2;
		g.begin();
        g.end();
        
		ui.begin(g);
        if (ui.window(Id.handle(), 10, 10, 240, 600, true)) {
            ui.text("Text", 0);
        }
        ui.end();

        
    }
}