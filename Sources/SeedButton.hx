package;

import kha.Color;
import kha.Assets;
import kha.graphics2.Graphics;
import zui.*;

import GlobalState;

class SeedButton implements IUiClass{

    var ui:Zui;
    var loaded:Bool;

    static var typesTheme: zui.Themes.TTheme = {
        NAME: "Default White",
        WINDOW_BG_COL: 0xff292929,
        WINDOW_TINT_COL: 0xffffffff,
        ACCENT_COL: 0xff393939,
        ACCENT_HOVER_COL: 0xff434343,
        ACCENT_SELECT_COL: 0xff505050,
        BUTTON_COL: 0xff383838,
        BUTTON_TEXT_COL: 0xffe8e7e5,
        BUTTON_HOVER_COL: 0xff494949,
        BUTTON_PRESSED_COL: 0xff1b1b1b,
        TEXT_COL: Color.White,
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
		ui = new Zui({font: Assets.fonts.DroidSans, theme: typesTheme});        
        loaded = true;	
	}

    public function draw(g: Graphics): Void{       
        if (!loaded)
            return;      

		ui.begin(g);
        if (ui.window(Id.handle(), 10, 400, 240, 600, true)) {        
           
            if (ui.button("Get random seed")){
                GlobalState.seed = Math.random() * 200.;
            }            
        }
        ui.end();

        
    }

}