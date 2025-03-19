package;

import kha.Scheduler;
import kha.Color;
import kha.Assets;
import kha.graphics2.Graphics;
import zui.*;

import Math;


class FPSCounter{
    var ui:Zui;
    var loaded:Bool;
    var deltaTime:Float = 1.0 / 60.0;
    var lastTime: Float;
    static var fpsTheme: zui.Themes.TTheme = {
        NAME: "Default Green",
        WINDOW_BG_COL: 0xff292929,
        WINDOW_TINT_COL: 0xffffffff,
        ACCENT_COL: 0xff393939,
        ACCENT_HOVER_COL: 0xff434343,
        ACCENT_SELECT_COL: 0xff505050,
        BUTTON_COL: 0xff383838,
        BUTTON_TEXT_COL: 0xffe8e7e5,
        BUTTON_HOVER_COL: 0xff494949,
        BUTTON_PRESSED_COL: 0xff1b1b1b,
        TEXT_COL: Color.Green,
        LABEL_COL: 0xffc8c8c8,
        SEPARATOR_COL: 0xff202020,
        HIGHLIGHT_COL: 0xff205d9c,
        CONTEXT_COL: 0xff222222,
        PANEL_BG_COL: 0xff3b3b3b,
        FONT_SIZE: 24,
        ELEMENT_W: 100,
        ELEMENT_H: 24,
        ELEMENT_OFFSET: 4,
        ARROW_SIZE: 5,
        BUTTON_H: 22,
        CHECK_SIZE: 15,
        CHECK_SELECT_SIZE: 8,
        SCROLL_W: 9,
        TEXT_OFFSET: 8,
        TAB_W: 6,
        FILL_WINDOW_BG: false,
        FILL_BUTTON_BG: true,
        FILL_ACCENT_BG: false,
        LINK_STYLE: Line,
        FULL_TABS: false
    };

    public function new() {
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {        
		ui = new Zui({font: Assets.fonts.DroidSans, theme: fpsTheme});
        Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
        loaded = true;	
	}

    public function update():Void{
        var currentTime = Scheduler.time();
        var frameTime = currentTime - lastTime;
        lastTime = currentTime;
        deltaTime += (frameTime - deltaTime) * 0.1; 
    }

    public function draw(g: Graphics): Void{       
        if (!loaded)
            return;
        
        var fps:Float = 1.0 / deltaTime;
        
		ui.begin(g);
        if (ui.window(Id.handle(), 10, 10, 240, 600, true)) {        
            ui.text("FPS: "+Math.ceil(fps), 0);
        }
        ui.end();

        
    }
}