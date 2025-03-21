package;

import kha.graphics4.Graphics;
import kha.math.Vector2;
import kha.graphics5_.PipelineState;
import kha.Scheduler;
import kha.Shaders;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import Math;

class Stars implements IRenderClass{

    static var vBuffer: VertexBuffer;
    static var iBuffer: IndexBuffer;
    static var vertexData: kha.arrays.Float32Array;
    static var pipeline: PipelineState;
    static var structure: VertexStructure;

    static var vertices:Array<Float>;
    static var indices:Array<Int>;

    var size:Float;
    var position:Vector2;

    public function new(size:Float, position:Vector2) {
        Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
        structure = new VertexStructure();
        structure.add("pos", VertexData.Float32_2X);    
        structure.add("uvData", VertexData.Float32_3X);   
        structure.add("starsTypes", VertexData.Float32_4X);         
        structure.add("starsDeletedCount", VertexData.Float32_1X);
        structure.add("starsResolution", VertexData.Float32_1X);
        structure.add("timer", VertexData.Float32_1X);
        structure.add("newSeed", VertexData.Float32_1X);
        fillBuffers(32, size, position, structure);
        this.size = size;
        this.position = position;
    }

    public function update(){
        fillBuffers(32, size, position, structure);
    }

    function fillBuffers(segments:Int, size:Float, position:Vector2, structure: VertexStructure) {
        var angleStep = (2 * Math.PI) / segments;
        
        var vertexCount = segments + 1; 
        var indicesCount = segments * 3;  

        vBuffer = new VertexBuffer(vertexCount, structure, Usage.StaticUsage);
        vertexData = vBuffer.lock();

        iBuffer = new IndexBuffer(indicesCount, Usage.StaticUsage);
        var indexData = iBuffer.lock();

        vertexData[0] = position.x; 
        vertexData[1] = position.y; 

        vertexData[2] = GlobalState.mousePosition.x;
        vertexData[3] = GlobalState.mousePosition.y;
        vertexData[4] = GlobalState.mouseWheel;

        vertexData[5] = GlobalState.starsTypes.x;
        vertexData[6] = GlobalState.starsTypes.y;
        vertexData[7] = GlobalState.starsTypes.z;
        vertexData[8] = GlobalState.starsTypes.w;

        vertexData[9] = GlobalState.starsShouldntDraw;
        vertexData[10] = GlobalState.starsResolution;

        vertexData[11] = Scheduler.time();

        vertexData[12] = GlobalState.seed;

        for (i in 0...segments) {
            var angle = i * angleStep;
            
            var x = Math.cos(angle) * size + position.x;
            var y = Math.sin(angle) * size + position.y;

            var index = (i + 1) * 13;
            vertexData[index] = x;
            vertexData[index + 1] = y;
            
            vertexData[index + 2] = GlobalState.mousePosition.x;
            vertexData[index + 3] = GlobalState.mousePosition.y;
            vertexData[index + 4] = GlobalState.mouseWheel;

            vertexData[index + 5] = GlobalState.starsTypes.x;
            vertexData[index + 6] = GlobalState.starsTypes.y;
            vertexData[index + 7] = GlobalState.starsTypes.z;
            vertexData[index + 8] = GlobalState.starsTypes.w;

            vertexData[index + 9] = GlobalState.starsShouldntDraw;
            vertexData[index + 10] = GlobalState.starsResolution;

            vertexData[index + 11] = Scheduler.time();

            vertexData[index + 12] = GlobalState.seed;

            indexData[i * 3] = 0;
            indexData[i * 3 + 1] = i + 1;
            indexData[i * 3 + 2] = if (i + 2 > segments) 1 else i + 2;
        }

        vBuffer.unlock();
        iBuffer.unlock();

        pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
        pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.full_galaxy_frag;	
		pipeline.colorAttachmentCount = 1;
		pipeline.colorAttachments[0] = kha.graphics4.TextureFormat.RGBA32;
		pipeline.depthStencilAttachment = kha.graphics4.DepthStencilFormat.Depth16;
		pipeline.compile();
    }



    public function draw(g4: Graphics): Void {
		g4.setPipeline(pipeline);

        g4.setVertexBuffer(vBuffer);
		g4.setIndexBuffer(iBuffer);

        g4.drawIndexedVertices();
	}   
}