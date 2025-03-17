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

class Main {
	static var logo = ["1 1 1 1 111", "11  111 111", "1 1 1 1 1 1"];
	static var starsTypes:StarsTypes;
	static var fps:FPSCounter;
	static var star:Star;

	static function update(): Void {
	}

	static function render1(frames: Array<Framebuffer>): Void {
		// As we are using only 1 window, grab the first framebuffer
		final fb = frames[0];
		// Now get the `g2` graphics object so we can draw
		final g2 = fb.g2;
		// Start drawing, and clear the framebuffer to `petrol`
		g2.begin(true, Color.fromBytes(0, 95, 106));
		// Offset all following drawing operations from the top-left a bit
		g2.pushTranslation(64, 64);
		// Fill the following rects with red
		g2.color = Color.Red;

		// Loop over the logo (Array<String>) and draw a rect for each "1"
		for (rowIndex in 0...logo.length) {
		  final row = logo[rowIndex];

		  for (colIndex in 0...row.length) {
		    switch row.charAt(colIndex) {
		      case "1": g2.fillRect(colIndex * 16, rowIndex * 16, 16, 16);
		      case _:
		    }
		  }
		}		
		
		// Pop the pushed translation so it will not accumulate over multiple frames
		g2.popTransformation();
		// Finish the drawing operations
		g2.end();
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
	}

	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				
				//var empty = new Empty();
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames);});
				//for (i in 0...100){
				var globalState = new GlobalState(new Vector2(1024., 768));
				var MouseData = new MouseData();
				var KeyboardData = new KeyboardData();
				fps = new FPSCounter();
				star = new Star(1.5, new Vector2(0., 0.,));
				starsTypes = new StarsTypes();
					//System.notifyOnFrames(star.render);
				//}
				
				//System.notifyOnFrames(fps.render);
				//System.notifyOnFrames(function (frames) { star.render;});
			});
		});
	}
}
