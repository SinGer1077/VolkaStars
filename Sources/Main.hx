package;

import kha.math.Random;
import kha.math.Vector2;
import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

import GlobalState;
import MouseData;
import KeyboardData;
import Star;
import FPSCount;
import StarsTypes;
import StarsCountButtons;
import SeedButton;
import StarsNames;

class Main {
	static var starsTypes:StarsTypes;
	static var fps:FPSCounter;
	static var starsCount:StarsCountButtons;
	static var seedBtn:SeedButton;
	static var star:Star;
	static var starsNames:StarsNames;

	static function update(): Void {
	}	

	static function render(frames: Array<Framebuffer>): Void {
		final fb = frames[0];
		final g2 = fb.g2;
		final g4 = fb.g4;

		g4.begin();
		g4.clear(Color.Green, Math.POSITIVE_INFINITY);   

		star.draw(g4);

		g4.end();

		g2.begin(false);	
		g2.end();

		fps.draw(g2);	
		starsTypes.draw(g2);
		starsCount.draw(g2);
		seedBtn.draw(g2);
		starsNames.draw(g2);
	}

	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (_) {

			Assets.loadEverything(function () {						

				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames);});

				var globalState = new GlobalState(new Vector2(1024., 768));
				var MouseData = new MouseData();
				var KeyboardData = new KeyboardData();
				fps = new FPSCounter();
				star = new Star(1.5, new Vector2(0., 0.,));
				starsTypes = new StarsTypes();
				starsCount = new StarsCountButtons();
				seedBtn = new SeedButton();
				starsNames = new StarsNames();
			});
		});
	}
}
