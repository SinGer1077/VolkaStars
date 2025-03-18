import kha.math.Vector4;
import kha.math.Vector2;


class GlobalState {
    public static var windowResolution: Vector2;
    
    public static var mouseWheel: Float;
    public static var mousePosition:Vector2;   
    public static var lastMouseOffset :Vector2;
    public static var mouseDown:Bool; 

    public static var starsTypes:Vector4;

    public static var starsResolution:Float;
    public static var starsShouldntDraw:Float;
    public static var initStarCount:Float;
    public static var starsCount:Float;

    public function new(resolution:Vector2){
        windowResolution = resolution;

        mouseWheel = 1.0;
        mousePosition = new Vector2();

        starsTypes = new Vector4();

        starsResolution = 1000.;
        starsShouldntDraw = 0.0;
        starsCount = calculateStarsNumber();
        initStarCount = starsCount;
    }

    public static function clamp(value:Float, min:Float, max:Float): Float {        
        if (value <= min)
            value = min;        
        if (value >= max)
            value = max;
        return value;
    }

    public static function calculateStarsNumber():Float {
        var count = Math.pow(starsResolution * 0.1/mouseWheel, 2.) * 8;
        return count;
    }

    public static function setMousePosition(x:Float, y:Float, movementX:Float, movementY:Float):Void {       
        var deltaX = x - lastMouseOffset.x;
        var deltaY = y - lastMouseOffset.y;

        var clampCoef = 0.6 * mouseWheel;

        mousePosition.x = clamp(mousePosition.x - deltaX / windowResolution.x, -clampCoef, clampCoef);
        mousePosition.y = clamp(mousePosition.y + deltaY / windowResolution.y, -clampCoef, clampCoef);

        lastMouseOffset = new Vector2(x,y);
    }

    public static function setStarsCount(value:Float) {
        value *= 1000;
        starsCount = clamp(starsCount + value, 0., 80000.);

        var deletedNumber = initStarCount - starsCount;
        //starsShouldntDraw = Math.ceil(initStarCount / (deletedNumber + 1));
        starsShouldntDraw = deletedNumber / initStarCount;
    }
}