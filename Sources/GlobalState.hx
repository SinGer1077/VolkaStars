import kha.math.Vector2;


class GlobalState {
    public static var windowResolution: Vector2;
    
    public static var mouseWheel: Float;
    public static var mousePosition:Vector2;   
    public static var lastMouseOffset :Vector2;
    public static var mouseDown:Bool; 

    public function new(resolution:Vector2){
        windowResolution = resolution;

        mouseWheel = 1.0;
        mousePosition = new Vector2();
    }

    public static function clamp(value:Float, min:Float, max:Float): Float {        
        if (value <= min)
            value = min;        
        if (value >= max)
            value = max;
        return value;
    }

    public static function setMousePosition(x:Float, y:Float, movementX:Float, movementY:Float):Void {       
        var deltaX = x - lastMouseOffset.x;
        var deltaY = y - lastMouseOffset.y;

        var clampCoef = 0.6 * mouseWheel;

        mousePosition.x = clamp(mousePosition.x - deltaX / windowResolution.x, -clampCoef, clampCoef);
        mousePosition.y = clamp(mousePosition.y + deltaY / windowResolution.y, -clampCoef, clampCoef);

        lastMouseOffset = new Vector2(x,y);
    }
}