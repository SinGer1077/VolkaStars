package;

import kha.math.Vector2;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

import GlobalState;
import MouseData;
import KeyboardData;
import Stars;
import FPSCount;
import StarsTypes;
import StarsCountButtons;
import SeedButton;
import StarsNames;

import IUiClass;
import IRenderClass;

class Main {
	static var stars:Stars;
	static var uiObjects:Array<IUiClass>;
	static var renderObjects:Array<IRenderClass>;

	static function update(): Void {
	}	

	static function render(frames: Array<Framebuffer>): Void {
		final fb = frames[0];
		final g2 = fb.g2;
		final g4 = fb.g4;

		g4.begin();
		g4.clear(Color.Green, Math.POSITIVE_INFINITY);   

		for (render in renderObjects){
			render.draw(g4);
		}	
		g4.end();

		g2.begin(false);	
		g2.end();

		for (ui in uiObjects){
			ui.draw(g2);
		}	
	}

	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (_) {

			Assets.loadEverything(function () {						

				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames);});

				var globalState = new GlobalState(new Vector2(1024., 768));
				var MouseData = new MouseData();
				var KeyboardData = new KeyboardData();		
				
				renderObjects = [
					new Stars(1.5, new Vector2(0., 0.,))
				];

				uiObjects = [
					new SeedButton(), 
					new StarsTypes(), 
					new StarsCountButtons(),
					new StarsNames(),
					new FPSCounter()
				];
			});
		});
	}
}
